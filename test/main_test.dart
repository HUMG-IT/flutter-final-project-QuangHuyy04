import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/main.dart';

void main() {
  testWidgets('MainApp displays Hello World', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that our app displays "Hello World!".
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
