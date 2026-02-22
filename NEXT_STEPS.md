# Pet Pocket — Next Steps (Branding, Icon, Repo Readiness)

This document is a single execution guide after the app successfully runs.

---

## STEP 1 — Product Identity (FINAL)

APP NAME  
Pet Pocket

SHORT DESCRIPTION  
Raise and care for your virtual pet through simple daily interactions

TAGLINE  
Care. Play. Grow.

PACKAGE NAME  
com.tursinalabs.pet.pocket

TONE  
- Calm
- Premium
- Minimal
- Not childish

---

## STEP 2 — App Icon Direction (Premium, Non-Childish)

### Chosen Concept (RECOMMENDED)
**Pocket + Paw**

Reason:
- Clean and brandable
- Feels like a product, not a kids game
- Scales well for Android, iOS, monochrome icons

### Visual Rules
- Flat vector
- Minimal shapes
- No gradients
- No cartoon faces
- Strong negative space

### Color Direction
Primary:
- Black (#000000)
- White (#FFFFFF)

Optional accent (very subtle):
- Emerald (#0F766E)

---

## STEP 3 — Icon Assets Required

### Android
1. ic_launcher_foreground.png  
   - 432x432
   - Transparent background
   - Icon centered in safe zone (288x288)

2. ic_launcher_background.png  
   - Solid color (black or white)

3. ic_launcher_monochrome.png  
   - Black/white only
   - Transparent
   - Same safe zone as foreground

### iOS
4. app_icon_1024.png  
   - 1024x1024
   - No transparency
   - Centered, balanced

---

## STEP 4 — Image Generation Prompt (Icon)

Use this prompt in image generation tool:

PROMPT:
"A premium minimalist app icon for a virtual pet app called Pet Pocket. 
A simple pocket outline combined with a small paw symbol, using negative space. 
Flat vector design, geometric, clean lines, no gradients, no text, no cartoon style.
Modern, calm, and professional aesthetic suitable for a mobile app.
Black and white color scheme, high contrast, centered composition."

STYLE NOTES:
- Flat vector
- SVG-like clarity
- No shadows
- No 3D
- No playful expressions

---

## STEP 5 — GitHub README.md (FINAL)

Create `README.md` in repo root:

```md
# Pet Pocket

Raise and care for your virtual pet through simple daily interactions.

Pet Pocket is an offline-first, time-based virtual pet app where your pet continues to grow even when the app is closed.

## Features
- Time-based stat decay (hunger, energy, cleanliness, happiness)
- Multiple pets with active pet selection
- Simple actions: feed, clean, play, sleep
- Inventory and shop system with coins and items
- Level progression and skin evolution
- Local notifications for low pet needs

## Tech Stack
- Flutter (Material 3)
- Riverpod
- Drift (SQLite)
- flutter_local_notifications

## Run
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run

Notes

If you encounter database schema conflicts during development, uninstall the app from the emulator or device to reset the local database.


---

## STEP 6 — Repo Hygiene

### Commit Order (RECOMMENDED)
1. Initial Flutter project
2. Core app + Drift + Riverpod
3. Pet logic & UI
4. Notifications
5. Branding + README

### Files to Commit
- All Dart source files
- Drift generated `.g.dart` files (recommended for easier cloning)
- README.md
- CHANGELOG.md (optional)

---

## STEP 7 — Android Verification Checklist

Check these files:

### android/app/src/main/AndroidManifest.xml
```xml
android:label="Pet Pocket"

## STEP STEP 8 — Done Criteria

You are DONE when:

App launches without error

Pet stats decay after app resume

Notifications appear when hunger or clean < 25

README renders correctly on GitHub

App icon looks clean in launcher
