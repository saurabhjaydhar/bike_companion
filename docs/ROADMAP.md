# Garajo — Product Roadmap

> Working name of this repo: `bike_companion`. Product name from Phase 3 onward: **Garajo**.
> Last updated: 2026-10-03

## 1. Product direction

**Garajo** is a global app for managing personal vehicles — bikes, scooters and cars — in one place: fuel and mileage, service history, spending and budgets, documents and expiry reminders, and RC card scanning.

### Name and store listing

| Field | Limit | Text |
|---|---|---|
| Play title / App Store name | 30 | `Garajo: Bike & Car Manager` |
| App Store subtitle | 30 | `Fuel, Service & PUC Reminders` |
| Play short description | 80 | `Track fuel, mileage & expenses. Get service, insurance & PUC reminders. Scan RC.` |
| App Store keywords | 100 | `mileage,log,vehicle,expense,two wheeler,scooter,rc,insurance,odometer,maintenance,budget,petrol` |

**Before launch, confirm the name is free:**

- [ ] Trademark search: WIPO Global Brand Database, IP India, USPTO, EUIPO (classes 9 and 42)
- [ ] Reserve the app name in App Store Connect (names are unique across the App Store)
- [ ] Register a domain, e.g. `garajo.app`

**Names checked and rejected:** WheelMate (Coloplast app), Kilomo (too close to Kilvo), Garagely, Odomate, Drivolo (Drivio/Drivvo), Motiq (VehIQ), Gearbook (Gearboxe/GRBX), WheelMitra (too India-specific for a global launch).

### App identifiers

Identifiers are permanent once published, so they change before the first release:

| Platform | Today | Target |
|---|---|---|
| iOS bundle ID | `com.example.bikeCompanion` (rejected by Apple) | `app.garajo` |
| Android application ID | `com.app.bike_companion` | `app.garajo` |

Both need new Firebase app registrations and new `google-services.json` / `GoogleService-Info.plist`.

## 2. Ground rules

- Phases run in order; each ships on its own branch and ends in a working, tested build.
- Every database change is a versioned migration with an upgrade test.
- Data the user entered is never lost or silently changed by an upgrade.
- All user-facing text goes through l10n in all 8 languages (en, hi, es, fr, de, it, pt, ar).

### UX principles (apply to every feature)

Every feature must be quick to use, obvious without explanation, and look polished. A feature isn't done until it meets these:

| Principle | What it means in practice |
|---|---|
| **3 taps or fewer** | Any common action (log fuel, add expense, check a reminder) takes at most 3 taps from the dashboard. |
| **Smart defaults** | Prefill whatever we can: today's date, last odometer + typical distance, last fuel price, the vehicle in focus. Typing is the last resort. |
| **One primary action per screen** | One clear, highlighted button. Secondary actions are visually quieter. |
| **Show, don't list** | Numbers become visuals: rings, progress bars, countdown chips, trend arrows. Plain tables only in detail views. |
| **Helpful empty states** | Every empty screen shows an illustration, one line explaining the benefit, and a button that starts the action. |
| **Instant feedback** | Haptic tap, a short animation, and a confirmation snackbar with **Undo** for destructive actions. |
| **Consistent look** | Use the existing "Night Ride" design system (HudPanel, PrimaryButton, AppColors, AppSpacing). No one-off styles. |
| **Works for everyone** | Light and dark themes, Arabic right-to-left, large text sizes, 48 dp touch targets, readable contrast. |
| **Never a dead end** | Errors say what happened and what to do next, with a button to do it. |

Each phase below lists its own UX requirements. A design review against this table is part of every phase's **Done when**.

## 3. Phases

Effort: **S** ≈ days, **M** ≈ 1 week, **L** ≈ 2+ weeks.

### Phase 0 — Foundation (S)

| # | Task | Why |
|---|---|---|
| 0.1 | Commit the pending RC-scan work | Clean starting point |
| 0.2 | Cloud restore copies only known columns | Restore inserts raw Firestore rows into SQLite; any new column breaks restore across versions |
| 0.3 | Migration test harness (create v2 DB → upgrade → verify) | Every later phase adds a case |
| 0.4 | Stable notification IDs (fixed hash instead of `String.hashCode`) | IDs must stay the same across app versions to cancel/reschedule |

**Done when:** tests green; restore of an older backup into the current schema works.

### Phase 1 — Reminders (M)

Today only documents in the Documents tab get reminders, and only after that tab is opened. Insurance and PUC dates entered on the bike get none.

| # | Task |
|---|---|
| 1.1 | Insurance and PUC reminders from the bike's own dates — 30, 7 and 1 day before; reschedule on save/edit, cancel on delete |
| 1.2 | Reschedule all reminders (every vehicle, every document) on app start |
| 1.3 | Fire at 09:00 local time instead of midnight |
| 1.4 | One reminder per date when the same expiry exists as a bike field and a document |
| 1.5 | Service-due reminders from km since last service (health-score intervals), checked on odometer update |
| 1.6 | Capture "Regn. Validity" from the RC scan; RC renewal reminder |
| 1.7 | In-app banner when notification permission is off |

**UX:**
- **"Coming up" card on the dashboard**: the next 3 expiries or services as colour-coded countdown chips (green > 30 days, amber ≤ 30, red ≤ 7 or overdue). Tap a chip to renew or update the date.
- **Reminders are on by default**: no setup screen. One "Reminders" switch per vehicle in settings, with a preview of the next reminder.
- **Notifications do something**: tapping one opens the exact place to fix it, e.g. the insurance date picker, prefilled.
- **Permission asked at the right moment**: after the user saves their first expiry date, with one sentence explaining why, not on first launch.

**DB v3:** `bikes.reg_validity`

**Done when:** unit tests for dates, dedupe and cancel; manual QA on Android 13/14 and iOS — permission granted, denied, and reminders surviving a reboot; tapping a notification lands on the right screen; UX review passed.

### Phase 2 — Spending, budgets and analytics (L)

Today fuel logs and service costs are stored separately and **are not counted** in expense totals, charts or exports.

| # | Task |
|---|---|
| 2.1 | Unified ledger: expenses + fuel logs + service costs, combined at query time (no data copied, no double counting). Fuel and service entries appear in the Expenses list, tagged with their source |
| 2.2 | Budgets per vehicle — monthly and yearly; progress bars on Expenses and Dashboard; alerts at 80 % and 100 % (once per threshold per period) |
| 2.3 | Yearly analytics — Month/Year toggle, 12-month chart, category split, average monthly spend |
| 2.4 | Cost per km and fuel cost per km from odometer readings |
| 2.5 | CSV export for a year as well as a month |
| 2.6 | Garage summary — total spend this month/year across vehicles, per-vehicle comparison |

**UX:**
- **Quick add**: one floating "+" on Dashboard and Expenses opens a sheet with big category chips (Fuel, Service, Parts, Insurance…). Amount gets focus immediately with a number pad; date and vehicle are prefilled. Saving takes 2 taps after typing the amount.
- **Budget ring**: a progress ring on the dashboard ("₹4,200 of ₹6,000 this month"), changing colour as it fills (green → amber at 80 % → red at 100 %).
- **Setting a budget**: suggest an amount from the last 3 months' average; the user just accepts or adjusts with a slider.
- **Analytics you can read in 2 seconds**: headline number first (this month, ↑/↓ % vs last month), then the chart. Swipe left/right to change month or year. Tap a chart bar to see that month's breakdown.
- **Cost per km** shown as a single big stat card with a short explanation line.

**DB v4:** `bikes.monthly_budget`, `bikes.yearly_budget`

**Done when:** totals match hand-calculated fixtures; budget alerts fire exactly once per threshold per period; quick add works in 2 taps after the amount; UX review passed.

### Phase 3 — Car support and rebrand to Garajo (L)

Done together because both rewrite the same "bike" wording.

| # | Task |
|---|---|
| 3.1 | `vehicle_type` (bike / scooter / car), existing rows default to bike |
| 3.2 | Auto-detect type from the RC scan's vehicle class (`MCWG`, `M-CYCLE` → bike; `LMV`, `MOTOR CAR` → car), user confirms |
| 3.3 | Per-type service types (no chain items for cars; add wheel alignment, AC service, wipers) |
| 3.4 | Per-type health-score intervals (e.g. car oil ≈ 10,000 km) |
| 3.5 | Car brand list alongside two-wheeler brands |
| 3.6 | Wording: "vehicle" on shared screens, type-specific elsewhere; icons by type; all 8 languages |
| 3.7 | Rebrand: app name, icon, splash, store text |
| 3.8 | New identifiers (`app.garajo`) + new Firebase apps and config files |

The internal `Bike` class and `bikes` table keep their names — renaming them is risk without user benefit.

**UX:**
- **Vehicle type picker**: large illustrated cards (Bike · Scooter · Car) as the first step of adding a vehicle — or skipped entirely when the RC scan already detected the type ("Looks like a car — correct?").
- **Garage as a visual shelf**: each vehicle as a card with its colour, type icon, plate badge and next due item; switch vehicles with a swipe or a tap on the avatar.
- **Type-aware screens**: car users never see chain items; wording and icons always match the vehicle.
- **New look for Garajo**: refreshed icon and splash; the welcome screen explains the app in 3 swipeable cards (track · remind · scan), with "Add your first vehicle" as the only button.

**DB v5:** `bikes.vehicle_type`

**Done when:** a car can be added by scan and manually with car services and health score; existing bikes are unchanged after upgrade; no "bike" wording left on shared screens; sign-in, sync and scan work on the new identifiers; UX review passed.

### Phase 4 — Release (M)

| # | Task |
|---|---|
| 4.1 | Firebase App Check (Play Integrity / App Attest) |
| 4.2 | Privacy policy covering RC photos and Gemini processing; Play data-safety form; App Store privacy labels |
| 4.3 | Review Gemini data terms (free tier vs. Vertex AI) for RC photos |
| 4.4 | Store assets: screenshots (English + one more language), listing text above |
| 4.5 | Play: internal test → closed test (12+ testers, 14 days) → production 20 % → 50 % → 100 % |
| 4.6 | iOS: TestFlight → App Store review |
| 4.7 | Crashlytics + key events: scan success rate, reminders scheduled, budgets set |
| 4.8 | UX review: walk every main flow (add vehicle, log fuel, add expense, set budget, renew insurance) against the UX principles; fix anything over 3 taps or with a dead end |
| 4.9 | Usability test with 5 people who haven't seen the app; fix the top 3 points of confusion before production |

## 4. Risks

| Risk | Mitigation |
|---|---|
| Migration corrupts user data | Upgrade test per version; one-time DB backup before each migration |
| Restore breaks across app versions | Column whitelist in restore (0.2) |
| Notifications blocked or delayed by the OS | Permission check + in-app banner (1.7); inexact scheduling at 09:00 |
| Identifier change breaks Firebase | Register new apps first; verify sign-in, sync and scan before switching |
| Name unavailable | Finish trademark and store checks before Phase 3 starts |
| Gemini cost or data terms | App Check, per-user rate limits in Firebase, on-device OCR fallback |

## 5. Current status

- [x] RC scan: front/back capture, upright rotation, position-based OCR parsing, Gemini with on-device gap-fill
- [x] Name decided: **Garajo**
- [x] Phase 0 — Foundation
- [ ] Phase 1 — Reminders
- [ ] Phase 2 — Spending, budgets and analytics
- [ ] Phase 3 — Car support and rebrand
- [ ] Phase 4 — Release
