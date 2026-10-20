---
milestone: v1.0-prototype
version: 1.0.0
updated: 2026-10-15T17:30:00Z
---

# Roadmap: AI Krishi Saathi (एआई कृषि साथी)

> **Current Phase:** Phase 1 - Planning and Design
> **Status:** executing

## Must-Haves (from SPEC & Proposal)

- [ ] Farmer profile & basic farm records setup
- [ ] AI Crop Doctor (Leaf photograph upload & Gemini Vision diagnosis)
- [ ] Smart Sowing Advisor (Crop options based on location, season, soil)
- [ ] Mandi Price Comparison (Commodity price cards with date & source)
- [ ] Weather-Based Advisory (Forecast & precaution cards)
- [ ] Hindi-first user interface with Organic Biophilic design system

---

## Phases

### Phase 1: Planning and Design
**Status:** 🔄 In Progress
**Objective:** Confirm requirements from PDF proposal, establish Organic Biophilic design system, configure GSD workflow, UI/UX Pro Max, and Anti-AI guidelines.
- [x] Plan 1.1: Analyze PDF proposal and extract comprehensive specifications
- [x] Plan 1.2: Install Get Shit Done (GSD) & UI/UX Pro Max plugins and skills
- [x] Plan 1.3: Generate Master Design System (`MASTER.md`) & Anti-AI design rules
- [ ] Plan 1.4: Scaffold Flutter project with premium component libraries and folder structure

---

### Phase 2: Core Prototype (Profile, Image Upload & AI Crop Doctor)
**Status:** ⬜ Not Started
**Objective:** Build farmer profile, image capture/upload flow, Gemini Vision API analysis pipeline, and safety disclaimers.
**Depends on:** Phase 1
- [ ] Plan 2.1: Supabase client & schema initialization (Farmers, Diagnoses, Crops)
- [ ] Plan 2.2: Leaf photo capture with camera/gallery preview & upload to Supabase Storage
- [ ] Plan 2.3: Gemini Vision API integration for structured disease classification & remedy guidelines
- [ ] Plan 2.4: Crop Doctor UI with confidence indicators, precaution alerts, and Hindi labels

---

### Phase 3: External Data Integration (Mandi & Weather)
**Status:** ⬜ Not Started
**Objective:** Integrate government mandi-price data (data.gov.in / Agmarknet) and weather advisory (IMD / Open-Meteo).
**Depends on:** Phase 2
- [ ] Plan 3.1: Mandi price service with State, District, and Commodity filtering
- [ ] Plan 3.2: Mandi price UI with price trends, date badges, and modal price comparisons
- [ ] Plan 3.3: Weather service integration for location-based 7-day forecast & rain alerts
- [ ] Plan 3.4: Sowing Advisor module matching season, soil, and irrigation data

---

### Phase 4: Farm Manager, Testing & Refinement
**Status:** ⬜ Not Started
**Objective:** Build Crop Calendar & Expense Estimator; test usability, API error fallbacks, and accessibility.
**Depends on:** Phase 3
- [ ] Plan 4.1: Crop stage calendar timeline and farming activity reminders
- [ ] Plan 4.2: Farm cost and profit calculator
- [ ] Plan 4.3: Usability and edge-case testing (low connectivity, ambiguous leaf images, API fallbacks)
- [ ] Plan 4.4: Hindi language audit (vowel clipping check, vernacular terminology)

---

### Phase 5: Demonstration & Final Report
**Status:** ⬜ Not Started
**Objective:** Prepare live demonstration scenarios, document limitations, and produce final academic report for BIT Mesra.
**Depends on:** Phase 4
- [ ] Plan 5.1: Create demo scenarios and test dataset
- [ ] Plan 5.2: Final report and documentation compilation
