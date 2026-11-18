import 'package:flutter_test/flutter_test.dart';

import 'package:taskflow/main.dart';

void main() {
  testWidgets('Muestra el listado y navega al detalle', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TaskFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('Mis tareas'), findsOneWidget);
    expect(find.text('Personalizar la bienvenida de TaskFlow'), findsOneWidget);

    await tester.tap(find.text('Personalizar la bienvenida de TaskFlow'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle de tarea'), findsOneWidget);
    expect(find.text('Usuario: 1'), findsOneWidget);
  });
}
