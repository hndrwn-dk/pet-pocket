APP Name: Pet Pocket
Description: Raise and care for your virtual pet through simple daily interactions

Package name: com.tursinalabs.pet.pocket

You are a senior Flutter engineer. Create a full working Flutter app named **tamagotchi_flutter_drift** using:
- Flutter + Material 3
- `flutter_riverpod` for state
- `drift` + `sqlite3_flutter_libs` + `path_provider` + `path` for SQLite
- `flutter_local_notifications` for local notifications

Goal: A tamagotchi MVP that is “production-ish”:
- Auto-decay based on `lastUpdatedAtUtcMs` (even when app closed)
- Apply decay on app start + on resume
- Multiple pets + active pet selector
- Inventory + shop purchase (coins) + use items
- Skins/evolution: suggest skin based on level; equip if owned; also skin items can be bought/equipped
- Notifications: when hunger < 25 or clean < 25 show notification on open/resume
- Optional simple periodic reminder (keep simple; okay if interval limited by plugin)

## HARD REQUIREMENTS
1. Output must be a complete project code, file-by-file, matching the folder structure below.
2. Code must compile and run on Android emulator.
3. Use UTC timestamps in ms everywhere for `lastUpdatedAtUtcMs`.
4. Drift must generate successfully with build_runner.
5. Avoid over-engineering; keep code clean and readable.
6. No emojis in logs.

## PROJECT STRUCTURE (must match)
Create these files exactly:

lib/
  main.dart
  app.dart
  core/constants.dart
  core/time.dart
  core/logger.dart
  core/notifs.dart

  features/pet/
    data/app_db.dart
    data/daos.dart
    logic/pet_engine.dart
    model/models.dart
    ui/pet_screen.dart
    ui/widgets/stat_bar.dart
    ui/widgets/action_button.dart
    ui/widgets/pet_avatar.dart
    ui/widgets/section_card.dart

## STEP-BY-STEP TASKS
### A) Create Flutter project
- If project not exists:
  - `flutter create tamagotchi_flutter_drift`
  - Ensure Android app runs in emulator.

### B) Update pubspec.yaml
Add dependencies versions:
- flutter_riverpod: ^2.5.1
- drift: ^2.21.0
- sqlite3_flutter_libs: ^0.5.24
- path_provider: ^2.1.4
- path: ^1.9.0
- flutter_local_notifications: ^17.2.2
Dev:
- drift_dev: ^2.21.0
- build_runner: ^2.4.12

Then run:
- `flutter pub get`

### C) Implement code (copy into files)
Implement exactly the logic described:
- Drift database with tables:
  - SettingsTable (activePetId)
  - PetsTable (stats + skinKey + lastUpdatedAtUtcMs)
  - ItemsTable (catalog)
  - PetInventoryTable (petId, itemId, qty)
- DAOs:
  - SettingsDao ensureSettings() + setActivePet()
  - PetsDao CRUD + watchAll + watchById
  - ItemsDao seedCatalogIfEmpty + watchItems
  - InventoryDao watchInventory + addQty + getItem
- Engine:
  - applyDecay(PetsTableData, nowUtc) using rates:
    - hungerPerMin=0.10, energyPerMin=0.0833, cleanPerMin=0.0666
    - happy baseline 0.03/min, plus 0.05/min if low needs (hunger<25 or clean<25 or energy<20)
  - applyAction(feed/clean/play/sleep)
  - applyUseItem(food/soap/toy/equipSkin)
  - level up loop using xpForLevel = 20 + level*10
- UI:
  - PetScreen with:
    - apply decay on start (post frame) and on resume (WidgetsBindingObserver)
    - show notification if hunger<25 or clean<25
    - dropdown to choose active pet
    - button to add new pet (dialog)
    - actions row: feed/clean/play/sleep
    - inventory list with “Use”
    - shop list with “Buy”
    - evolution suggestion: skinForLevel level>=12 gold, level>=7 ninja else classic; show “Equip” which equips only if owned
    - Notification section: enable/disable periodic reminder (simple)
- Widgets: stat bar, action button, avatar, section card.

### D) Ensure drift generation works
Run:
- `flutter pub run build_runner build --delete-conflicting-outputs`

Fix any generation errors by adjusting imports/part directives.

### E) Android notification permission
- Ensure `Notifs.init()` requests notification permission (Android 13+).
- Use minimal Android initialization settings.
- Avoid requiring additional manifest edits unless compilation demands it.
- If manifest needs changes, apply them and explain.

### F) Provide a final run checklist
At end, print:
- commands to run
- common fixes if drift generation fails
- note: if old DB conflicts, uninstall app to reset DB.

## OUTPUT FORMAT
- Produce the full contents of each file in code blocks labeled with the path.
- Do NOT omit any file.
- Keep explanations minimal; prioritize code.

Start now.
