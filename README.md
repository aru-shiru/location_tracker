# location_tracker

A Flutter app that records device location in the foreground, background, and
even after the user removes it from recents. Built as a hiring assignment.

## Stack

| Concern | Choice |
| --- | --- |
| Location tracking | [`flutter_background_geolocation`](https://pub.dev/packages/flutter_background_geolocation) — native foreground/background/terminated tracking, persistent notification, offline queue. |
| Map tiles | [`flutter_map`](https://pub.dev/packages/flutter_map) + OpenStreetMap (no API key, no Google Play Services). |
| State management | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) |
| Local persistence | [`drift`](https://pub.dev/packages/drift) — planned; in-memory only today |
| Date/number formatting | [`intl`](https://pub.dev/packages/intl) |

## Project layout

The codebase follows an [Nx](https://nx.dev)-style **feature-folder** convention.
Each top-level folder under `lib/` is one *domain* (a vertical slice of the
product). Inside each domain, files are bucketed by *library type*:

```
lib/
├── main.dart                             entry + MaterialApp + ProviderScope
│
├── location_access_request/              domain: ask the user for permissions
│   ├── location_access_request.dart        ← public barrel
│   ├── data_access/
│   │   ├── models/
│   │   │   └── permission_item.dart        view model for a checklist row
│   │   └── providers/
│   │       └── next_permission_label.dart  derived CTA copy
│   ├── feature/
│   │   └── location_permission_screen.dart smart screen (consumes provider)
│   └── ui/
│       ├── location_illustration.dart      stateless illustration
│       └── permission_checklist.dart       stateless row list
│
├── map_view/                             domain: show the map + status sheet
│   ├── map_view.dart                       ← public barrel
│   ├── data_access/
│   │   ├── models/
│   │   │   └── location_sample.dart        domain model for one fix
│   │   ├── location_samples.dart           live List<LocationSample> via onLocation
│   │   └── tracking.dart                   starts/stops the foreground service
│   ├── feature/
│   │   ├── map_screen.dart                 smart screen (consumes providers)
│   │   └── map_view.dart                   FlutterMap + MapController, ConsumerStatefulWidget
│   └── ui/
│       └── status_sheet.dart               stateless draggable bottom sheet
│
└── shared/                               cross-feature building blocks
    ├── shared.dart                         ← public barrel
    ├── data_access/
    │   └── permissions.dart                Permissions model + notifier + provider
    ├── feature/
    │   └── root_shell.dart                 gates map_view behind permissions
    └── ui/                                 (empty placeholder)
```

### Bucket meanings

| Bucket | Holds | Example |
| --- | --- | --- |
| `data_access/` | State (Riverpod providers / notifiers), repositories, domain models. May depend on data sources. Should not import Flutter UI types. | `permissions.dart`, `location_samples.dart` |
| `feature/` | Smart / stateful widgets that wire `data_access` to `ui`. Owns side effects. | `map_screen.dart`, `map_view.dart`, `root_shell.dart` |
| `ui/` | Dumb / stateless presentational widgets. No state, no providers, no I/O — only props in, widgets out. | `status_sheet.dart`, `location_illustration.dart`, `permission_checklist.dart` |

### Barrels

Each domain ships a `<domain>/<domain>.dart` barrel that re-exports the public
surface (screens, providers, models). Consumers always import the barrel:

```dart
import 'package:location_tracker/map_view/map_view.dart';
```

Internal files inside a domain are not re-exported unless another feature
genuinely needs them — keep the public surface small.

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

- **Freezed for immutable state classes.** We now have two value classes
  consumed by Riverpod providers (`Permissions` and `LocationSample`) with
  hand-written `copyWith` and equality. A third or fourth would tip the cost
  curve toward [`freezed`](https://pub.dev/packages/freezed): code-generated
  equality, `copyWith`, and exhaustive sealed unions, paired naturally with
  Riverpod's `==`-based rebuild semantics.
- **Cold-start permission state shows as denied for a frame or two.**
  `PermissionsNotifier` keeps a synchronous `Notifier<Permissions>` and seeds
  with `const Permissions()` (all `false`) until
  `flutter_background_geolocation.ready()` resolves. On a fresh install the
  empty state is the right screen anyway, so the flicker is invisible. On a
  relaunch with everything already granted, the empty state shows for a beat
  before `RootShell` flips to the map. Switch to an `AsyncNotifier<Permissions>`
  plus a small splash if this ever feels janky.
- **License key for production builds.** `flutter_background_geolocation` is
  free in debug, but release builds need a per-app token from the Transistor
  dashboard wired through `bg.Config.transistorAuthorizationToken`. Right now
  the debug log prints `LICENSE VALIDATION FAILURE` and continues — expected.
