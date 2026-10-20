# SPEC.md — AI Krishi Saathi (एआई कृषि साथी)

> **Status**: `FINALIZED`
>
> ⚠️ **Planning Lock**: Requirements and scope verified from `AI_Krishi_Saathi_Project_Proposal.pdf`.

## Vision
AI Krishi Saathi (एआई कृषि साथी) is an AI-powered smart farming assistant mobile application designed for Indian farmers. It brings together AI-assisted crop-image analysis, location- and season-based sowing guidance, weather forecasts, and government-sourced mandi prices into a unified, Hindi-first, highly accessible mobile interface. It serves as actionable decision support tailored for farmers with varying levels of digital literacy, while avoiding generic "AI aesthetics" in favor of an organic, grounded, human-crafted design system.

## Project Details
- **Student / Author**: Kamlesh Yadav
- **Programme / Branch**: B.Tech — Computer Science and Engineering
- **Institution**: Birla Institute of Technology (BIT), Mesra — Patna Campus

## Core Goals & Scope
1. **AI Crop Doctor (फसल डॉक्टर)**:
   - Allow farmers to capture or upload a leaf/crop photo.
   - Vision-capable AI model identifies possible diseases/pest issues, symptoms, confidence score, and cautious next-step guidance.
   - Clear limitation and safety messaging (no unsupported chemical dosage instructions; referral to verified local agricultural advisories).
2. **Smart Sowing Advisor (बुवाई सलाहकार)**:
   - Location, season, soil, and irrigation-aware sowing guidance backed by verified agricultural sources (ICAR/KVK).
3. **Mandi Price Comparison (मंडी भाव)**:
   - Live/recent mandi commodity pricing filtered by State, District, and Market via Government Open Data (data.gov.in / Agmarknet).
   - Display min, max, and modal prices with source attribution and reported dates (not tick-by-tick real-time stock trading look).
4. **Weather-Based Advisory (मौसम पूर्वानुमान)**:
   - IMD (India Meteorological Department) or verified weather provider integration showing forecasts, rainfall warnings, and precautions.
5. **Crop Calendar & Farm Expense Tracker (फसल कैलेंडर व लागत-लाभ कैलकुलेटर)**:
   - Timeline of crop stages and critical farming operations.
   - Simple ledger for recording seed, fertilizer, and labor expenses with yield/price return estimates.
6. **Farmer Profile & Crop Records**:
   - Save farm size, soil type, primary crops, and past diagnosis history.
7. **Hindi-First & Rural-Friendly UX**:
   - Simple, high-contrast UI (Organic Biophilic theme) with Hindi as primary language, clear icons (Lucide / Material Symbols Rounded, strictly NO emoji icons), and 48px+ touch targets for outdoor ease of use.

## Non-Goals (Out of Scope)
- No unverified prescription or dosage calculations for restricted agrochemicals/pesticides.
- No claim of 100% diagnostic accuracy; ambiguous or low-confidence images prompt expert consultation.
- No real-time stock-ticker price speculation for commodities.
- No forced chatbot interfaces where structured visual cards and workflows are faster and clearer.

## Technical Stack & Constraints
- **Client App**: Flutter / Dart (Cross-platform Android target).
- **Backend & Database**: Supabase (PostgreSQL, Authentication, Row-Level Security, Storage bucket for leaf images).
- **AI Vision Analysis**: Google Gemini Multimodal Vision API (`google-genai` / REST) with structured output.
- **External Data Sources**: data.gov.in (Agmarknet Mandi API), IMD Mausam API.
- **Component & Design Ecosystem**:
  - `flutter_lucide` (crisp, modern stroke icons)
  - `google_fonts` (`Noto Sans Devanagari` + `Poppins`)
  - `flutter_animate` (natural, physics-based micro-interactions)
  - `skeletonizer` (smooth skeleton loading states)
  - `fl_chart` (mandi price trends & weather rainfall charts)
  - `haptic_feedback` (tactile responses for physical certainty)

## Success Criteria
- [ ] Functional Android prototype running smoothly on mobile devices.
- [ ] Working image capture & Gemini vision diagnosis pipeline with disclaimers.
- [ ] State/district-wise Mandi price search and display with date attribution.
- [ ] Weather forecast module with actionable advisory cards.
- [ ] Seamless Hindi & English toggle with zero vowel clipping.
- [ ] Premium, non-generic AI UI adhering to `design-system/ai-krishi-saathi/MASTER.md`.
