# Anti-AI Look & Premium Component System Rules

Strict guidelines to avoid the generic "AI-generated look" and enforce premium, handcrafted interface standards.

---

## 1. Eliminate the "AI Look" (Banned Patterns)

### ❌ BANNED: The Cliché "AI Gradient"
- **NEVER** use generic purple-to-cyan or neon magenta gradients (`#8B5CF6` -> `#06B6D4` / `#EC4899`).
- **NEVER** add glowing border highlights or iridescent radial backgrounds to cards.
- **INSTEAD**: Use purposeful, domain-grounded palettes. For agricultural and environmental tech, use **Organic Biophilic**:
  - Primary: Deep Emerald (`#15803D`)
  - Secondary / Accent: Growth Green (`#22C55E`), Harvest Ochre (`#A16207`)
  - Surface / Background: Crisp White (`#FFFFFF`) on Warm Tinted Canvas (`#F0FDF4` / `#F7F9F6`)
  - Foreground / Text: Deep Slate Pine (`#14532D` / `#0F172A`)
  - Border: Soft Mint Tint (`#BBF7D0` or `1px solid rgba(0,0,0,0.08)`)

### ❌ BANNED: Emojis as UI Icons
- **NEVER** use emojis (`🤖`, `🌾`, `👨‍🌾`, `💡`, `💰`, `📊`, `⚡`) as button icons, tab icons, or status badges. Emojis look amateurish and render inconsistently across Android, iOS, and Web.
- **INSTEAD**: Use crisp vector icons with consistent stroke weight:
  - Flutter: `flutter_lucide` or `material_symbols_icons` (Rounded style).
  - Consistent size: 18px (inline), 20-22px (buttons/lists), 24px (app bars/nav).

### ❌ BANNED: "Chatbot Everywhere" Syndrome
- **NEVER** default to a blank chat prompt with sparkles for complex tasks.
- **INSTEAD**: Build dedicated, high-efficiency task flows:
  - AI Crop Doctor: Dedicated camera viewfinder, sample photo guides, thumbnail preview with retake option, structured diagnosis summary card.
  - Mandi Prices: Filterable datatable / cards with state/district pills, sortable min/max/modal prices, price trend charts.
  - Sowing Advisor: Step-by-step interactive selector (crop, soil, season) with immediate recommendations.

### ❌ BANNED: Muddy Shadows & Unanchored Cards
- **NEVER** use exaggerated, blurry black drop shadows (`box-shadow: 0 20px 25px rgba(0,0,0,0.25)`).
- **INSTEAD**: Use 1px subtle borders combined with gentle multi-step ambient elevation (`0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.03)`).

---

## 2. Premium Typography & Indian Language Support (Hindi-First)

### Typography Hierarchy
- **Latin / Numbers**: `Poppins` or `Plus Jakarta Sans` for headers; `Fira Sans` / `Inter` for body; `Fira Code` or tabular numbers for mandi price values and metrics.
- **Hindi / Devanagari**: `Noto Sans Devanagari` or `Hind`.
- **CRITICAL**: For Devanagari script, always provide adequate `lineHeight` (`1.4` to `1.5` minimum) so upper and lower vowel marks (मात्राएँ जैसे ि, ी, ु, ू, ृ, े, ै) are never clipped by widget boundaries.

### Touch Targets & Accessibility
- Minimum touch target size: **48x48 logical pixels** (farmers often use devices outdoors, with one hand or with working hands).
- Text contrast: Maintain minimum **4.5:1** contrast ratio against all card and canvas surfaces.
- Sunlight readability: High-contrast text `#0F172A` / `#14532D` against crisp `#FFFFFF` cards.

---

## 3. Premium Component Libraries (Flutter Mobile Stack)

When implementing the mobile UI in Flutter:

1. **Icons**: `flutter_lucide` (`LucideIcons.sprout`, `LucideIcons.camera`, `LucideIcons.trendingUp`, `LucideIcons.cloudRain`, `LucideIcons.shieldCheck`)
2. **Typography**: `google_fonts` (`GoogleFonts.poppins`, `GoogleFonts.notoSansDevanagari`)
3. **Animations**: `flutter_animate` for smooth, non-intrusive micro-interactions (e.g. `.fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0)`).
4. **Loading States**: `skeletonizer` for realistic skeleton shimmer placeholders rather than jarring `CircularProgressIndicator`.
5. **Charts**: `fl_chart` for clean commodity price timelines and weather forecasts with smoothed Bezier curves.
6. **Tactile Feedback**: Call `HapticFeedback.lightImpact()` on key interactive moments (photo captured, tab switched, filter applied).
