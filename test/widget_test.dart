import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ai_krishi_saathi/core/localization/language_provider.dart';
import 'package:ai_krishi_saathi/core/location/location_provider.dart';
import 'package:ai_krishi_saathi/main.dart';

void main() {
  testWidgets('AiKrishiSaathiApp with AppTheme pumps without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
        ],
        child: const AiKrishiSaathiApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(MainNavigationShell), findsOneWidget);
  });
}
