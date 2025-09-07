# Countries Flutter App

A Flutter project built as a **practical exercise** to explore how to consume a **GraphQL API** and organize a mobile app with professional practices.  
The focus was on **learning**, but decisions were made with **real-world standards** in mind.

---

## Overview

The application connects to a **public GraphQL endpoint** and allows the user to:

-   Browse **continents**.
-   See the list of **countries** by continent.
-   View **details of a country** such as capital, ISO code, currency, phone code, and languages.

The scope is intentionally simple, but the project demonstrates how to set up a maintainable Flutter app with proper structure, navigation, environment configuration, and custom setup.

---

## Tech Stack

-   [Flutter](https://flutter.dev) (stable)
-   [Dart](https://dart.dev)
-   [graphql_flutter](https://pub.dev/packages/graphql_flutter) – GraphQL client
-   [flutter_hooks](https://pub.dev/packages/flutter_hooks) – state utilities
-   [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) – state management
-   [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) – app icon
-   [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) – splash screen

---

## Architecture & Structure

The project follows a **feature-based structure**, inspired by clean architecture principles but simplified for this scope.

```
lib/
 ├── core/              # Shared core (network client, utils)
 ├── features/
 │    ├── common/       # Shared widgets (footer, etc.)
 │    ├── continents/   # Continents screen
 │    ├── countries/    # Countries list screen
 │    └── country/      # Country detail screen
 ├── app.dart           # MaterialApp with routes
 └── main.dart          # Entrypoint
```

### Why this structure?

-   **Separation by feature** makes the project easier to scale (each feature holds its own UI, logic, and potentially data/domain in a bigger app).
-   A `core/` module centralizes cross-cutting concerns (network, utils).
-   Even if some `data/` or `domain/` folders are not fully used here, the structure reflects how a production Flutter app is often organized.

---

## Key Technical Decisions

-   **GraphQL over REST** → requirement for the exercise and useful to demonstrate queries.
-   **Navigator with named routes** → simple, reliable for a small app (instead of go_router).
-   **Environment variables** (`.env`) → keep configuration (GraphQL endpoint) outside code.
-   **Custom scripts** (`tools/dev.sh`) → automate setup, formatting, and analysis.
-   **Linting and formatting** → enforce code consistency with `dart format` and `flutter_lints`.
-   **Custom branding (icon + splash)** → practice setting up app assets.

---

## Environment Variables

The GraphQL endpoint is set in a `.env` file at the project root:

```env
GRAPHQL_ENDPOINT=https://countries.trevorblades.com/
```

A `.env.example` file is included for reference.

---

## Running the App

### Common Steps

1. Clone the repository
    ```bash
    git clone https://github.com/
    cd countries_flutter_app
    ```
2. Install dependencies
    ```bash
    flutter pub get
    ```

### Run on Android

```bash
flutter run -d emulator-5554    # or any Android emulator/device ID
```

### Run on iOS (macOS required)

```bash
flutter run -d ios
```

### Run on macOS desktop

```bash
flutter run -d macos
```

---

## Development Setup

A helper script is provided for consistency:

```bash
./tools/dev.sh
```

It runs:

-   `flutter pub get`
-   `dart format .`
-   `dart analyze`

This ensures dependencies are installed, code is formatted, and issues are detected.

---

## Notes

This project was created mainly as a **learning exercise** in Flutter.  
It is **not a production-ready app**, but it applies conventions and good practices (clear structure, env vars, CI-ready config, formatting, etc.) that are commonly expected in professional projects.

---

## License

This project is licensed under the MIT License.  
See the [LICENSE](LICENSE) file for details.
