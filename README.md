# AI Krishi Saathi (एआई कृषि साथी) 🌾
**An AI-Powered Smart Farming Assistant for Indian Farmers**

> **Academic Project Proposal Implementation**  
> **Student:** Kamlesh Yadav (B.Tech — Computer Science & Engineering)  
> **Institution:** Birla Institute of Technology (BIT), Mesra — Patna Campus  

---

## 🌟 Key Features

1. **AI Crop Doctor (फसल डॉक्टर)**:
   - Leaf and crop photograph upload / camera capture.
   - Disease identification powered by Google Gemini Multimodal Vision API.
   - Structured symptoms, confidence level, organic/safe treatments, and safety disclaimers against hazardous pesticide overdosing.
2. **Live Mandi Price Comparison (मंडी भाव)**:
   - Live & recent commodity prices from Government Open Data (Agmarknet / data.gov.in).
   - Filter by State (Bihar, UP, MP, Rajasthan, etc.), District, and Commodity.
   - Displays minimum, maximum, and modal prices with 7-day price movement trend chart (`fl_chart`).
3. **Smart Sowing Advisor (बुवाई सलाहकार)**:
   - Sowing window recommendations based on season (Rabi, Kharif, Zaid), soil type, and irrigation availability.
   - Curated agricultural best practices verified by ICAR and Krishi Vigyan Kendras (KVK).
4. **Weather-Based Agricultural Advisory (मौसम पूर्वानुमान)**:
   - Location-specific weather forecasts (IMD Mausam integration).
   - Real-time temperature, humidity, rain probability, and actionable farming precautions.
5. **Farm Ledger & Profit Estimator (खेत खाता व मुनाफा)**:
   - Simple expense tracking for seeds, fertilizers, tractor diesel, and labor.
   - Yield and market price projection to calculate estimated net returns.
6. **Bilingual Hindi-First Support (हिंदी व English)**:
   - Instant one-tap language switcher (`EN` / `हिंदी`) in the app bar.
   - Generous line-height (`1.4`–`1.5`) ensuring Devanagari vowel signs (मात्राएँ) are never clipped.
7. **Anti-AI Design System**:
   - Designed using **Organic Biophilic** visual language (`#15803D`, `#22C55E`, `#A16207`, `#F0FDF4`).
   - Clean vector icons (`flutter_lucide`), no emojis as UI buttons, 48px+ touch targets for outdoor sunlight usability.

---

## 🏗️ Project Architecture

```
lib/
├── main.dart                      # App entry point, MultiProvider & MaterialApp shell
├── core/
│   ├── theme/
│   │   ├── app_colors.dart        # Organic Biophilic green & harvest gold palette
│   │   ├── app_typography.dart    # Noto Sans Devanagari + Poppins with safe line-heights
│   │   └── app_theme.dart         # Material 3 light theme & accessible card borders
│   ├── localization/
│   │   ├── app_translations.dart  # Complete English and Hindi bilingual dictionary
│   │   └── language_provider.dart # Persistent language toggle state management
│   ├── constants/
│   │   └── app_constants.dart     # Academic metadata & configuration keys
│   └── utils/
│       └── haptic_helper.dart     # Physical tactile tap feedback
├── data/
│   ├── models/                    # Crop disease, Mandi price, Weather & Farm record models
│   └── services/
│       ├── gemini_vision_service.dart # Gemini Vision multimodal leaf pathology analysis
│       ├── mandi_service.dart         # Agmarknet mandi commodity search & trend analysis
│       ├── weather_service.dart       # IMD weather forecasts & agro alerts
│       ├── sowing_service.dart        # ICAR verified crop sowing guide
│       └── supabase_service.dart      # Supabase cloud database & image storage
└── presentation/
    ├── screens/
    │   ├── home/                  # Unified dashboard with weather & quick services
    │   ├── crop_doctor/           # Camera viewfinder guide & structured diagnosis report
    │   ├── mandi/                 # Commodity rate comparison & price trend chart
    │   ├── sowing/                # Seasonal sowing window selector
    │   ├── weather/               # 7-day weather forecast & rainfall precautions
    │   ├── farm_manager/          # Input expense ledger & profit calculator
    │   └── settings/              # Language toggle & BIT Mesra academic disclaimer
    └── widgets/
        ├── custom_app_bar.dart    # Header with instant language switch pill
        ├── biophilic_card.dart    # Modern 1px mint border, non-muddy shadow card
        ├── action_button.dart     # 48px+ touch target button with haptic feedback
        └── stat_tile.dart         # Tabular numerical metric widget
```

---

## 🚀 How to Run the App

### Prerequisites
- Install Flutter SDK (version 3.x+).
- Connect an Android device with USB debugging enabled or launch an Android emulator.

### Running Commands
```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run the application
flutter run
```

---

## 🔑 Configuration & API Keys

To enable live Gemini AI Vision and cloud Supabase storage:
1. Open `lib/core/constants/app_constants.dart`.
2. Add your Google Gemini API key:
   ```dart
   static const String geminiApiKeyPlaceholder = 'YOUR_ACTUAL_GEMINI_KEY';
   ```
3. Add your Supabase credentials:
   ```dart
   static const String supabaseUrlPlaceholder = 'https://YOUR_PROJECT.supabase.co';
   static const String supabaseAnonKeyPlaceholder = 'YOUR_SUPABASE_ANON_KEY';
   ```
*(Note: If API keys are omitted, the app automatically runs in curated offline prototype mode with sample data for demonstration).*
