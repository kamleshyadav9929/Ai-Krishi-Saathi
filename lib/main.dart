import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:provider/provider.dart';

import 'core/localization/language_provider.dart';
import 'core/location/location_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/haptic_helper.dart';
import 'data/services/supabase_service.dart';
import 'presentation/screens/crop_doctor/crop_doctor_screen.dart';
import 'presentation/screens/farm_manager/farm_manager_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/mandi/mandi_screen.dart';
import 'presentation/screens/schemes/govt_schemes_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/sowing/sowing_advisor_screen.dart';
import 'presentation/widgets/kiwi_bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()..init()),
      ],
      child: const AiKrishiSaathiApp(),
    ),
  );
}

class AiKrishiSaathiApp extends StatelessWidget {
  const AiKrishiSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'AI Krishi Saathi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(isHindi: languageProvider.isHindi),
      locale: Locale(languageProvider.currentLocale),
      supportedLocales: const [
        Locale('hi', 'IN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    HapticHelper.lightTap();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    final screens = [
      HomeScreen(onNavigateTab: _navigateToTab),
      const CropDoctorScreen(),
      const MandiScreen(),
      const GovtSchemesScreen(),
      const FarmManagerScreen(),
      const SowingAdvisorScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: GoogleBottomNav(
        currentIndex: (_currentIndex >= 0 && _currentIndex < 5) ? _currentIndex : -1,
        onTap: (index) => _navigateToTab(index),
        items: [
          GoogleNavItem(
            icon: LucideIcons.house,
            activeIcon: LucideIcons.house,
            label: lang.tr('navHome'),
          ),
          GoogleNavItem(
            icon: LucideIcons.scan_line,
            activeIcon: LucideIcons.scan_line,
            label: lang.tr('navCropDoctor'),
          ),
          GoogleNavItem(
            icon: LucideIcons.trending_up,
            activeIcon: LucideIcons.trending_up,
            label: lang.tr('navMandi'),
          ),
          GoogleNavItem(
            icon: LucideIcons.landmark,
            activeIcon: LucideIcons.landmark,
            label: lang.tr('navSchemes'),
          ),
          GoogleNavItem(
            icon: LucideIcons.wallet,
            activeIcon: LucideIcons.wallet,
            label: lang.tr('navFarmRecords'),
          ),
        ],
      ),
    );
  }
}
