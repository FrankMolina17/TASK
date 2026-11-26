import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:taskflow/app/taskflow_app.dart';
import 'package:taskflow/features/tasks/data/local_task_repository.dart';
import 'package:taskflow/features/tasks/data/task_repository.dart';
import 'package:taskflow/features/tasks/presentation/tasks_view_model.dart';

void main() {
  testWidgets('Muestra el listado y navega al detalle', (
    WidgetTester tester,
  ) async {
    final TaskRepository repository = LocalTaskRepository();
    final viewModel = TasksViewModel(repository);
    await tester.pumpWidget(
      ChangeNotifierProvider<TasksViewModel>.value(
        value: viewModel,
        child: const TaskFlowApp(),
      ),
    );
    await viewModel.loadTasks();
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.text('Personalizar la bienvenida de TaskFlow'), findsOneWidget);

    await tester.tap(find.text('Personalizar la bienvenida de TaskFlow'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle de tarea'), findsOneWidget);
    expect(find.text('Usuario: 1'), findsOneWidget);
  });
}
