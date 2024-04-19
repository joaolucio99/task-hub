import 'package:flutter_test/flutter_test.dart';
import 'package:task_hub/app/app.dart';
import 'package:task_hub/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
