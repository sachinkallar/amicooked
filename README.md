# 🔥 AM I COOKED?

> **Apple-level polish × Awwwards interaction design × internet meme culture.**  
> A premium, hilarious, viral web application that calculates how "cooked" someone is based on money, career, sleep, spending, screen time, habits, and questionable 2 AM life decisions.

---

## ⚡ Architecture & Tech Stack

- **Framework**: Flutter 3.44+ (Web, Windows Desktop, Android, iOS)
- **Language**: Dart 3.12+ (Strict Mode)
- **Routing**: `go_router` (Browser URL bar synchronization, deep linking, query parameter handling, forward/back history)
- **State Management**: `provider` + Clean Feature Architecture
- **Design & Typography**: Pitch obsidian theme (`#09090C`), frosted glassmorphism, dynamic ember particle canvas, Google Fonts (`Outfit`, `Plus Jakarta Sans`, `JetBrains Mono`)
- **Persistence**: `shared_preferences` with safe fallbacks and bounded history
- **Calculators**: Extensible schema engine with INR formatting and real-time validation
- **AI / LLM Reasoning**: Decoupled AI reasoning layer supporting:
  - **Offline Meme Engine (Default)**: 100% offline, deterministic, zero-latency savage roasts.
  - **Hugging Face Serverless Inference API**: Pluggable free LLM models (e.g. `Qwen/Qwen2.5-72B-Instruct`, `meta-llama/Llama-3.2-3B-Instruct`, or any HF model) with automatic instant fallback to local templates if API limits or timeouts occur.

---

## 🗺️ Routes & Pages

| Route | Page | Description |
|---|---|---|
| `/` | **Home** | Massive hero header, live ticker, 3-step "How It Works", Cooked Spectrum breakdown, mini calculators preview |
| `/check` | **Assessment** | 15 data-driven meme questions with animated option cards, keyboard controls (1–4, ←), auto-advance, and session persistence |
| `/calculating` | **Calculating** | Suspenseful scanner sequence ("Analyzing mistakes", "Mostly vibes") leading to "SHOW ME THE DAMAGE" |
| `/result` | **Results** | Animated 0–100 radial gauge, 5 category breakdown cards, savage personalized roast, 5-point emergency plan, share & challenge buttons, confetti |
| `/calculators` | **Calculators Hub** | Filterable catalog of all 10 viral mini calculators with live search |
| `/calculators/:type` | **Single Calculator** | Dynamic runner with currency inputs, sliders, dropdowns, input validation, and verdict cards |
| `/leaderboard` | **Leaderboard** | "The Hall of Flame" featuring Top 3 podium, category tabs, and anonymous confession submissions |
| `/challenge` | **Friend Challenge** | Query-param driven comparison (`/challenge?score=87&tier=absolutely-cooked`) challenging visitors to beat their friend |
| `/about` | **About & Methodology** | Humorous breakdown of the algorithm's 5 pillars, AI architecture notes, and mandatory legal disclaimers |

---

## 🧮 10 Mini Calculators Included

1. 💰 **Can I Afford This?** — Item price vs bank balance vs days until salary.
2. 🍔 **Can I Afford Food Delivery?** — Base price vs delivery markup tax.
3. 💻 **Am I Actually a Senior Developer?** — Production incidents vs open Chrome tabs vs imposter syndrome.
4. 😴 **Sleep Cooked Score** — Sleep debt, 2 AM phone scrolling, and caffeine consumption.
5. 🛒 **Do I Actually Need This?** — Reality check filter for midnight retail therapy.
6. 💸 **Salary-to-Poverty Speedrun** — Daily burn rate and runway collapse date.
7. 🧠 **Career Delusion Meter** — Job hatred level vs resumes actually sent (0).
8. 💳 **Should I Buy This on EMI?** — "No-Cost EMI" psychological trap exposure.
9. 📱 **Screen-Time Damage Report** — Percentage of conscious waking existence donated to glass.
10. ❤️ **Are They Ghosting Me?** — Activity status vs hours elapsed without response.

---

## 🧪 Testing

The codebase includes full unit tests and an end-to-end integration test:

```bash
# Run test suite
flutter test
```

### Test Coverage:
- `ScoringEngine`: deterministic outputs, 0–100 boundary constraints, tier mappings, category score isolation.
- `MiniCalculators`: formula correctness, edge cases (overdrawn account, extreme sleep deficit), all 10 calculators executed against default schemas.
- `E2E Flow`: Home → Assessment → Question selection → Calculating → Result generation → Retake navigation.

---

## 🚀 Running Locally

```bash
# Run locally in Chrome
flutter run -d chrome

# Run as Windows desktop application
flutter run -d windows
```

## 📦 Building for Production

```bash
# Build production web bundle (output located at build/web)
flutter build web --release
```

### Deploying to Netlify

The root `netlify.toml` configures Netlify to run `scripts/netlify-build.sh`
and publish `build/web`, rather than the Flutter source files. The script
uses an installed Flutter SDK when available, or downloads the official stable
Linux SDK archive for the build machine's architecture into a temporary directory.
It verifies the archive's SHA-256 checksum before extracting it, installing
dependencies, and compiling the app. SDK installation does not require `git clone`.

For the downloaded SDK, the script validates the bundled version metadata against
the release manifest and runs the prebuilt Flutter tool with its bundled Dart
runtime. This preserves the release's SDK version in environments that block
Flutter's Git-based bootstrap and version detection. Automatic version checks
are disabled for this temporary SDK.

A fallback rewrite serves `index.html` for client-side routes such as `/check`
and `/calculators`, so opening or refreshing those URLs does not return a
Netlify page-not-found error. Existing files are served normally.

Redeploy the site after applying this configuration. Verify that `/` loads
the application and that opening `/check` directly also loads the application.
