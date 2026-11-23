// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:jazzcash_flutter_example/main.dart';

void main() {
  testWidgets('Shows the sandbox payment example', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Product name: Product 1'), findsOneWidget);
    expect(find.text('Product price: PKR 100.00'), findsOneWidget);
    expect(find.text('Ready for a sandbox payment'), findsOneWidget);
    expect(find.text('Purchase now'), findsOneWidget);
  });
}
