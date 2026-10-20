// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ai_krishi_saathi/main.dart';
import 'package:ai_krishi_saathi/core/localization/language_provider.dart';
import 'package:ai_krishi_saathi/core/location/location_provider.dart';

void main() {
  testWidgets('AI Krishi Saathi app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => LocationProvider()),
        ],
        child: const AiKrishiSaathiApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AiKrishiSaathiApp), findsOneWidget);
  });
}
