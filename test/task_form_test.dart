import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/local_task_repository.dart';
import 'package:taskflow/features/tasks/data/task_repository.dart';
import 'package:taskflow/features/tasks/presentation/task_form_screen.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

Future<void> _openForm(WidgetTester tester) async {
  // appRouter es compartido por las pruebas: se reinicia antes de cada una.
  appRouter.go('/');
  final TaskRepository repository = LocalTaskRepository();
  await tester.pumpWidget(
    ChangeNotifierProvider<TasksViewModel>(
      create: (_) => TasksViewModel(repository),
      child: const TaskFlowApp(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Nueva tarea'));
  await tester.pumpAndSettle();
  expect(find.text('Nueva tarea'), findsOneWidget);
}

Future<void> _choosePriority(WidgetTester tester, String priority) async {
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(priority).last);
  await tester.pumpAndSettle();
}

Future<void> _save(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Guardar'));
  await tester.pump();
  await tester.tap(find.text('Guardar'));
  // No pumpAndSettle: deja que el SnackBar siga visible al verificarlo.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  test('El borrador permite crear una tarea sin fecha', () {
    const TaskDraft draft = TaskDraft('Título', 'Descripción', 'Media');
    expect(draft.title, 'Título');
    expect(draft.description, 'Descripción');
    expect(draft.priority, 'Media');
    expect(draft.dueDate, isNull);
  });

  testWidgets('Muestra los tres errores cuando el formulario está vacío', (
    WidgetTester tester,
  ) async {
    await _openForm(tester);
    await _save(tester);

    expect(find.text('El título no puede estar vacío.'), findsOneWidget);
    expect(find.text('La descripción no puede estar vacía.'), findsOneWidget);
    expect(find.text('Selecciona una prioridad.'), findsOneWidget);
  });

  testWidgets('Rechaza un título de dos caracteres', (
    WidgetTester tester,
  ) async {
    await _openForm(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'AB');
    await _save(tester);

    expect(
      find.text('Escribe al menos 3 caracteres en el título.'),
      findsOneWidget,
    );
  });

  testWidgets('Devuelve un borrador sin exigir la fecha', (
    WidgetTester tester,
  ) async {
    await _openForm(tester);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Entregar informe de móviles',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Revisar validaciones y subir el codelab',
    );
    await _choosePriority(tester, 'Alta');
    await _save(tester);

    expect(
      find.text('Formulario válido: Entregar informe de móviles'),
      findsOneWidget,
    );
  });

  testWidgets('Cancelar regresa sin mensaje de retorno', (
    WidgetTester tester,
  ) async {
    await _openForm(tester);
    await tester.enterText(find.byType(TextFormField).at(0), 'Tarea cancelada');

    await tester.ensureVisible(find.text('Cancelar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.textContaining('Formulario válido:'), findsNothing);
  });
}
