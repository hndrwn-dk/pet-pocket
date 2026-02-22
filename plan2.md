APP NAME: **Pet Pocket**  
SHORT DESCRIPTION: **Raise and care for your virtual pet through simple daily interactions**  
PACKAGE NAME (Android): **com.tursinalabs.pet.pocket**  

Tech stack:
- Flutter + Material 3
- flutter_riverpod for state management
- drift (SQLite) with sqlite3_flutter_libs
- flutter_local_notifications for local notifications

Goal:
Build a calm, minimalist virtual pet (tamagotchi-style) app that is production-ready and cleanly structured.

---

## HARD REQUIREMENTS
1. Output must be a complete Flutter project, file-by-file.
2. Android package name must be **com.tursinalabs.pet.pocket**.
3. App title shown in UI must be **Pet Pocket**.
4. Code must compile and run on Android emulator.
5. Use UTC timestamps in milliseconds (`lastUpdatedAtUtcMs`) for all time-based logic.
6. Drift code must generate successfully using build_runner.
7. Apply stat decay on:
   - app start (post-frame)
   - app resume (lifecycle observer)
8. No emojis in logs or system messages.

---

## PROJECT STRUCTURE (MUST MATCH EXACTLY)
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

---

## FUNCTIONAL REQUIREMENTS

### Pet Core
- Stats: hunger, energy, clean, happy (0–100)
- Decay system (per minute):
  - hunger: −0.10
  - energy: −0.0833
  - clean: −0.0666
  - happy: −0.03 baseline
  - extra happy decay −0.05 if hunger <25 OR clean <25 OR energy <20
- Decay based on `nowUtc - lastUpdatedAtUtcMs`
- Clamp all stats to 0–100

### Actions
- Feed: +hunger, −clean, +xp, +coins
- Clean: +clean, +xp, +coins
- Play: +happy, −energy, −hunger, +xp, +coins
- Sleep: +energy, −hunger, +xp

### Progression
- XP → Level
- XP required: `20 + (level * 10)`
- Level up grants:
  - +5 happy
  - +5 coins

### Evolution / Skin
- Suggested skin by level:
  - <7 → classic
  - ≥7 → ninja
  - ≥12 → gold
- Skin can only be equipped if owned in inventory
- Skins are items purchasable from shop

---

## DATABASE REQUIREMENTS (DRIFT)

### Tables
1. **SettingsTable**
   - id (PK)
   - activePetId

2. **PetsTable**
   - id (PK)
   - name
   - level, xp, coins
   - hunger, energy, clean, happy
   - skinKey
   - lastUpdatedAtUtcMs

3. **ItemsTable**
   - id (PK) e.g. food_basic, skin_gold
   - type (food / soap / toy / skin)
   - name
   - priceCoins

4. **PetInventoryTable**
   - petId + itemId (composite PK)
   - qty

### DAOs
- SettingsDao: ensureSettings(), watch, setActivePet()
- PetsDao: createPet(), watchAll(), watchById(), upsertPet()
- ItemsDao: seedCatalogIfEmpty(), watchItems()
- InventoryDao: watchInventory(), addQty(), getItem()

---

## NOTIFICATIONS
- Initialize notifications on app start.
- Request Android 13+ notification permission.
- On app start/resume:
  - If hunger <25 → notify “Pet is hungry”
  - If clean <25 → notify “Pet is dirty”
- Optional:
  - Simple periodic reminder (acceptable plugin limitations).

---

## UI REQUIREMENTS
- Single main screen (PetScreen)
- Sections:
  - Active Pet (dropdown selector)
  - Pet status (avatar, mood, stats)
  - Actions (Feed / Clean / Play / Sleep)
  - Inventory (Use item)
  - Shop (Buy item)
  - Notifications (Enable / Disable reminder)
- Add new pet via dialog
- Use Material 3 components
- Clean, calm, non-childish UI

---

## IMPLEMENTATION STEPS

### 2. Update pubspec.yaml

Add dependencies:

flutter_riverpod ^2.5.1
drift ^2.21.0
sqlite3_flutter_libs ^0.5.24
path_provider ^2.1.4
path ^1.9.0
flutter_local_notifications ^17.2.2

Dev:
drift_dev ^2.21.0
build_runner ^2.4.12

Run:
flutter pub get

### 3. Implement all Dart files

Create each file listed above.
Include part 'app_db.g.dart'; in app_db.dart.
Ensure imports are correct and consistent.

### 4. Generate Drift
flutter pub run build_runner build --delete-conflicting-outputs

###  5. Run app
flutter run