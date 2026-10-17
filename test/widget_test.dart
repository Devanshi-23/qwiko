import 'package:flutter_test/flutter_test.dart';
import 'package:qwiko/main.dart';

void main() {
  testWidgets('Qwiko app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QwikoApp());
    await tester.pump();
    expect(find.text('Qwiko'), findsOneWidget);
  });
}
