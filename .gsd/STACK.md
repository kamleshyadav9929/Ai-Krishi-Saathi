# Technology Stack: AI Krishi Saathi

> Verified from Project Proposal PDF & Design Intelligence

## Runtime & Platforms

| Platform | Technology | Version | Purpose |
|----------|------------|---------|---------|
| Mobile | Flutter / Dart | Stable 3.x | Cross-platform Android application |
| Backend | Supabase / PostgreSQL | Latest | Auth, PostgreSQL database, Image Storage |
| AI / Vision | Google Gemini Multimodal API | Gemini 2.5 / 1.5 Flash | Leaf disease detection & contextual advice |
| Open Data | data.gov.in / Agmarknet | REST API | Mandi commodity prices & market data |
| Weather | IMD / Open-Meteo | REST API | Weather forecasts and rainfall alerts |

## Premium UI & Component Libraries (Anti-AI Stack)

| Library | Package | Purpose |
|---------|---------|---------|
| Design Tokens | `design-system/ai-krishi-saathi/MASTER.md` | Organic Biophilic palette & typography |
| Icons | `flutter_lucide` | Geometric vector stroke icons (No emojis!) |
| Typography | `google_fonts` | `Noto Sans Devanagari` + `Poppins` |
| Micro-animations | `flutter_animate` | Non-intrusive physics micro-interactions |
| Skeletons | `skeletonizer` | Content-accurate shimmer loading |
| Charts | `fl_chart` | Mandi price trends and weather data visualizations |
| Feedback | `services` / `HapticFeedback` | Tactile touch confirmation |

## Core Integrations

| Feature | Service / Provider | Purpose |
|---------|-------------------|---------|
| AI Crop Doctor | Gemini Vision API | Leaf pathology analysis & structured advisory |
| Mandi Prices | Government Open Data Platform | Commodity market pricing across India |
| Weather Advisory | IMD / Meteorological Provider | Agricultural weather alerts and sowing safety |
| Storage | Supabase Storage (`crop-images`) | Uploaded leaf photos storage |
| Database | Supabase PostgreSQL | Profiles, historical scans, expense records |
