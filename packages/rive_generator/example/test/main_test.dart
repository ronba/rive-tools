import 'package:example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Loads widget.', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(startKey));
    await tester.tap(find.byKey(addProgressKey));
    await tester.tap(find.byKey(addProgressKey));
    await tester.tap(find.byKey(addProgressKey));
    await tester.tap(find.byKey(addProgressKey));
    await tester.tap(find.byKey(addProgressKey));
    await tester.tap(find.byKey(addProgressKey));
  });
}
