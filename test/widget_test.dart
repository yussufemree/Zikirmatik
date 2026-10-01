import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zikirmatik/main.dart';
import 'package:zikirmatik/services/storage_service.dart';

void main() {
  testWidgets('Zikirmatik app launches successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storageService = StorageService();
    await storageService.init();

    await tester.pumpWidget(ZikirmatikApp(storageService: storageService));
    await tester.pumpAndSettle();

    // Verify counter screen displays "Sayaç"
    expect(find.text('Sayaç'), findsWidgets);
    expect(find.text('BAS'), findsOneWidget);
  });
}
