# Copilot Instructions for flutter_application_1

## Project Overview
- This is a cross-platform Flutter application (mobile, web, desktop) with the main code in `lib/`.
- The entry point is `lib/main.dart`. UI components and features are organized under `lib/app/`.
- Custom themes and shared data are in `lib/app/data/` and `lib/app/theme_data.dart`.
- The app uses custom assets (images, fonts) from the `assets/` directory, referenced in `pubspec.yaml`.

## Key Patterns & Structure
- **Stateful Widgets**: Most UI logic is in `StatefulWidget`/`State` pairs (see `ClockView` in `lib/app/views/clockview.dart`).
- **CustomPainter**: For custom UI (e.g., clock face), see `ClockPainter` in `clockview.dart`.
- **Timer/Animation**: Uses `Timer.periodic` for real-time updates (e.g., clock refresh).
- **Theme & Colors**: Centralized in `lib/app/data/theme_data.dart` as `CustomColors`.

## Developer Workflows
- **Build**: Use `flutter run` for development, `flutter build <platform>` for release builds.
- **Test**: Place tests in `test/` (e.g., `test/widget_test.dart`). Run with `flutter test`.
- **Assets**: Add new images/fonts to `assets/`, then update `pubspec.yaml`.
- **Hot Reload**: Use `r` in the terminal or VS Code's hot reload button during development.

## Project Conventions
- **File Naming**: Use `snake_case` for Dart files and directories.
- **Widget Organization**: UI widgets go in `lib/app/views/`, helpers in `lib/app/` or subfolders.
- **No Business Logic in UI**: Keep business/data logic out of widgets when possible.
- **Always Dispose Resources**: Override `dispose()` in `State` classes to clean up timers/controllers.

## Integration & Dependencies
- **Flutter SDK**: Version managed by `pubspec.yaml`.
- **No custom platform code**: Native code in `android/`, `ios/`, etc. is default unless otherwise noted.
- **External packages**: Add to `pubspec.yaml` and run `flutter pub get`.

## Examples
- See `lib/app/views/clockview.dart` for a custom clock widget using `CustomPainter` and periodic state updates.
- See `test/widget_test.dart` for widget test structure.

---
If you are unsure about a pattern or workflow, check for examples in `lib/app/views/` or ask for clarification.
