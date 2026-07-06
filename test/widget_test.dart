import 'package:flutter_test/flutter_test.dart';

import 'package:edubot/main.dart';

void main() {
  testWidgets('Login page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(initialRoute: '/loginx'));

    // Verify that our login page is loaded.
    expect(find.text('SICA-ESTUDIANTE'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsWidgets);
  });
}
