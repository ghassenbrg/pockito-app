# Pockito mobile prototype

This folder contains Pockito’s high-fidelity Flutter prototype. It is intentionally isolated inside the monorepo’s `pockito-mobile` package.

The app is a complete local experience for validating product design, navigation, financial modelling, responsive behaviour, and interaction flows before production services are introduced. It does not call a backend, authenticate real users, connect bank accounts, invoke MCP, or upload receipt images.

## Run

From `pockito-mobile`:

```sh
flutter pub get
flutter run
```

For a browser build:

```sh
flutter run -d chrome
```

## Verify

```sh
flutter analyze
flutter test
flutter build web
```

The tests cover fixture arithmetic, currency minor units, the two-lens spending model, settlement invariants, local mutations, primary navigation and the fast add launcher, shared-expense editing, receipt scanning, packaged app-icon masks, mascot semantics, all routed surfaces, and compact phone widths.

## Component previews

The component catalogue uses Flutter’s built-in widget preview annotations:

```sh
flutter widget-preview start
```

Preview definitions live in `lib/ui/previews/pockito_previews.dart`. They include light and dark account cards, balance directions, budget thresholds, skeletons, and empty states. In the running app, **More → State catalogue** switches Home between ready, loading, empty, error, and offline treatments.

## Architecture

```text
lib/
├── app/                 # App-level view state
├── data/repositories/   # Coherent in-memory fixture implementation
├── domain/models/       # Immutable Freezed financial models
├── domain/repositories/ # Replaceable repository contract
└── ui/
    ├── core/            # Design tokens, theme, navigation, components
    ├── features/        # Product screens and flows
    └── previews/        # Component/state catalogue
```

Screens depend on `PockitoRepository`, while `MockPockitoRepository` owns the local fixture and mutations. A future API repository can implement the same contract without redesigning the UI.

Generated Freezed code can be refreshed with:

```sh
dart run build_runner build
```

## Prototype rules

- Keep all prototype code and platform folders inside `pockito-mobile`.
- Preserve the spending-versus-cash-flow distinction and currency minor-unit scales.
- Use centralized tokens and reusable components before adding screen-local styling.
- Keep every visible action interactive with local state; do not add placeholder destinations.
- Do not introduce real service integrations during the prototype phase.
