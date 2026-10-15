import 'package:flutter_test/flutter_test.dart';
import 'package:kobimat_mobile/main.dart';

void main() {
  testWidgets('giriş ekranı açılır', (tester) async {
    await tester.pumpWidget(const KobimatApp());
    expect(find.text('Tekrar hoş geldin'), findsOneWidget);
  });
}
