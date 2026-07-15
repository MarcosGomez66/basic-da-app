# basic_da_app

Offline-first Flutter app for small business data analysis. Portfolio project — keep it simple.

## Commands

```bash
flutter analyze        # lint (flutter_lints)
flutter test           # unit tests (no integration tests yet)
flutter pub get        # after pubspec changes
dart run build_runner build --delete-conflicting-outputs  # regenerate Hive adapters
```

No CI workflows exist. No opencode.json or other agent config files exist.

## Architecture

```
lib/
  main.dart            # Hive init, adapter registration, box opening, Provider setup
  app/
    app.dart           # MaterialApp, theme, routes
    routes.dart        # named route map (initialRoute: '/')
    main_layout.dart   # IndexedStack with BottomAppBar nav (4 tabs + FAB for sale)
    helpers.dart       # CostType enum, totalPrice/totalCost/totalSold, validators, formatDate
  models/              # Hive models with @HiveType + generated .g.dart adapters
  providers/           # ChangeNotifier providers (act as service layer)
  screens/             # Full-screen views
  widgets/             # Reusable form widgets
```

Entry: `main.dart` → initializes Hive, registers all adapters, opens all boxes, wraps `MyApp` in `MultiProvider`.

## Key domain rules

- One open workday per business at a time.
- Each product belongs to a business and a lot. Lots can be deactivated (cascades to products).
- IDs: `DateTime.now().microsecondsSinceEpoch.toString()` — never use random/UUID.
- CostType enum: `purchase` (per-unit cost) vs `budget` (fixed total cost).
- Stock can reach 0; product is auto-deactivated when stock ≤ 0.
- Locale: Spanish (`es`), dates formatted as `dd/MMM/yyyy HH:mm`.

## Hive adapter gotchas

- Every model uses `part '*.g.dart'` with `@HiveType`/`@HiveField` annotations.
- Adapters are registered manually in `main.dart` — **do not change typeId values** or field indices on existing adapters.
- `CostTypeAdapter` (typeId 5) is in `helpers.dart` (the `CostType` enum lives there).
- If adding a new model: add `@HiveType`, run `build_runner`, register the adapter in `main.dart`, open the box, and add to `MultiProvider` if needed.
- If modifying an existing model's fields: use the **next available** `@HiveField` index. Never reuse or reorder indices.

## UI conventions

- Forms are shown via `showDialog` / `AlertDialog`.
- Autocomplete for name/group fields uses `RawAutocomplete<String>` with existing products as options.
- Navigation: named routes for non-tab screens; `IndexedStack` for the 4 main tabs.
- Material Design 3, `Colors.deepPurple` as seed color.

## Test notes

- Tests use `flutter_test` + `flutter_test`-based Hive initialization.
- `movements_provider_test.dart` initializes Hive with a temp directory — this is the pattern to follow for tests needing Hive.
- `models_test.dart` tests pure helper functions without Hive.
