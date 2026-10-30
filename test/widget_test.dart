import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('Muestra la pantalla de bienvenida de TaskFlow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());

    expect(find.text('TaskFlow'), findsWidgets);
    expect(find.text('Aplicaciones Móviles'), findsOneWidget);
    expect(find.text('Hola, Franklin Molina'), findsOneWidget);
    expect(
      find.text(
        'Bienvenido a TaskFlow. Organiza tus pendientes y avanza el reto final conectado a una API.',
      ),
      findsOneWidget,
    );
    expect(find.text('Tareas pendientes'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });
}
