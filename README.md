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
```

## Notes

If you encounter database schema conflicts during development, uninstall the app from the emulator or device to reset the local database.
