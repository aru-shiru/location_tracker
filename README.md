# location_tracker

A Flutter app that records device location in the foreground, background, and
even after the user removes it from recents. Built as a hiring assignment.

## Stack

| Concern | Choice |
| --- | --- |
| Location tracking | [`flutter_background_geolocation`](https://pub.dev/packages/flutter_background_geolocation) — native foreground/background/terminated tracking, persistent notification, offline queue. |
| Map tiles | [`flutter_map`](https://pub.dev/packages/flutter_map) + OpenStreetMap (no API key, no Google Play Services). |
| State management | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) (planned — currently `setState`). |
| Local persistence | [`drift`](https://pub.dev/packages/drift) (planned — currently dummy data). |
| Date/number formatting | [`intl`](https://pub.dev/packages/intl) |

## Project layout

The codebase follows an [Nx](https://nx.dev)-style **feature-folder** convention.
Each top-level folder under `lib/` is one *domain* (a vertical slice of the
product). Inside each domain, files are bucketed by *library type*:

```
lib/
├── main.dart                             entry point + MaterialApp
│
├── location_access_request/              domain: ask the user for permissions
│   ├── location_access_request.dart        ← public barrel
│   ├── data_access/                        models, providers, repositories
│   │   └── models/permission_item.dart
│   ├── feature/                            stateful (smart) components
│   └── ui/                                 stateless (presentational) components
│       └── location_permission_screen.dart
│
├── map_view/                             domain: show the map + status sheet
│   ├── map_view.dart                       ← public barrel
│   ├── data_access/
│   ├── feature/
│   │   └── map_screen.dart
│   └── ui/
│       ├── map_view.dart                   FlutterMap composition
│       └── status_sheet.dart               draggable bottom sheet
│
└── shared/                               cross-feature building blocks
    ├── shared.dart                         ← public barrel
    ├── data_access/
    ├── feature/
    │   └── root_shell.dart                 gates map_view behind permissions
    └── ui/
```

### Bucket meanings

| Bucket | Holds | Example |
| --- | --- | --- |
| `data_access/` | State (Riverpod providers/notifiers), repositories, domain models. May depend on data sources. Should not import Flutter UI types. | `permission_item.dart` (currently a view model — see *Things to consider*) |
| `feature/` | Smart/stateful widgets that wire `data_access` to `ui`. Owns side effects. | `map_screen.dart`, `root_shell.dart` |
| `ui/` | Dumb/stateless presentational widgets. No state, no providers, no I/O — only props in, widgets out. | `location_permission_screen.dart`, `map_view.dart`, `status_sheet.dart` |

### Barrels

Each domain ships a `<domain>/<domain>.dart` barrel that re-exports the public
surface (screens, providers, models). Consumers always import the barrel:

```dart
import 'package:location_tracker/map_view/map_view.dart';
```

Internal files inside a domain (e.g. `ui/map_view.dart`) are not re-exported
unless another feature genuinely needs them — keep the public surface small.

## Run locally

```bash
flutter pub get
flutter run -d <device-id>      # use `flutter devices` to list
```

In the attached run:

- `r` — hot reload
- `R` — hot restart
- `q` — quit

> **macOS toolchain note:** Flutter's JDK is set by `flutter config --jdk-dir`,
> not `JAVA_HOME`. If a Gradle build fails with
> `JAVA_HOME is set to an invalid directory`, run
> `flutter config --machine | grep jdk` and point it at a real JDK 17 install
> (`flutter config --jdk-dir=/path/to/jdk-17`).

## Things to consider

- **Freezed for immutable state classes once Riverpod lands.** The state objects
  consumed by Riverpod providers (e.g. `PermissionState`, future
  `LocationSample`, `TrackerStatus`) want to be deeply immutable with value
  equality, `copyWith`, and exhaustive sealed unions for async / result types.
  Hand-writing all of that is noisy and easy to get wrong.
  [`freezed`](https://pub.dev/packages/freezed) generates it from a small class
  declaration and pairs naturally with Riverpod's `==`-based rebuild semantics.
  Defer adding it until we actually have ≥ 2 such classes — there is no point
  paying the build_runner cost for the single boolean-triple we have today.
- **License key for production builds.** `flutter_background_geolocation` is
  free in debug, but release builds need a per-app token from the Transistor
  dashboard wired through `bg.Config.transistorAuthorizationToken`. Right now
  the debug log prints `LICENSE VALIDATION FAILURE` and continues — expected.
