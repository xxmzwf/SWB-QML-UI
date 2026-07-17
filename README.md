# SWB-QML-UI（Shadcn Base UI for QML）

English | [简体中文](docs/README-Chinese.md)

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/platform-macOS-000000?style=flat&logo=apple&logoColor=white">
  <img alt="Windows" src="https://img.shields.io/badge/platform-Windows-0078D4?style=flat&logo=windows11&logoColor=white">
</p>

**SWB-QML-UI is a shadcn Base UI style GUI control library for QML.** It restyles the full set of `QtQuick.Controls.Basic` visual controls — 51 in total — into the clean, black-and-white shadcn Base UI look, with light/dark theming driven by a single singleton.

Out of respect for the original work: part of the controls in this library are implemented following the design parameters of [shadcn](https://ui.shadcn.com/)'s Base UI components, and the rest are written from scratch for this library.

- **51 restyled controls** — buttons, inputs, menus, popups, navigation, calendar, table helpers… see the [component reference](docs/CONTROLS.md)
- **One-line theming** — every control follows the `SwbTheme` singleton; toggle `SwbTheme.darkMode` and the whole UI switches
- **Zero image assets** — all icons are drawn at runtime with `Canvas`, so they stay crisp at any scale and recolor with the theme
- **Plain Qt** — pure QML on top of `QtQuick.Controls.Basic`, no private APIs

## Screenshots

*Home*

![Home](assets/1.png)

*Component gallery*

![Component gallery](assets/2.png)

*Dashboard (light)*

![Dashboard light](assets/3.png)

*Dashboard (dark)*

![Dashboard dark](assets/4.png)

## Requirements

- Qt **6.10 or later** (developed and tested with Qt 6.11)
- CMake **3.21+** and a C++17 compiler
- Ninja (recommended; any CMake generator works)

## Building

```bash
git clone https://github.com/xxmzwf/SWB-QML-UI.git
cd SWB-QML-UI
cmake -S . -B build -G Ninja -DQT_PATH=/path/to/Qt/6.11.1/<platform>
cmake --build build
# Optional — only needed for find_package integration (Options 2/3 below):
cmake --install build --prefix /path/to/installed
```

`QT_PATH` points at your Qt installation prefix (the directory containing `bin`, `lib`, `qml`). Defaults you get without extra flags:

| Option | Default | Meaning |
|---|---|---|
| `CMAKE_BUILD_TYPE` | `Release` | Optimized build |
| `BUILD_SHARED_LIBS` | `ON` | Build SwbControls as a **shared** library (set `OFF` for static) |
| `SWB_BUILD_EXAMPLES` | `ON` when top-level | Build the example gallery app (auto-`OFF` when embedded via `add_subdirectory`) |

Run the example (it needs `Qt6::Multimedia` for the home-page video):

```bash
# macOS
./build/examples/SwbExample.app/Contents/MacOS/SwbExample
# Windows / Linux
./build/examples/SwbExample
```

## Using it in your project

However you integrate the library, usage in QML is the same:

```qml
import QtQuick
import SwbControls

Window {
    visible: true

    SwbButton {
        anchors.centerIn: parent
        text: "Get started"
        variant: "outline"
    }
}
```

`SwbTheme` is a **module singleton** — it is registered automatically with the module, so after `import SwbControls` you can customize its light/dark palettes and metrics or switch modes (`SwbTheme.darkMode = true`) anywhere; dark mode follows the system color scheme by default. Every visual control also exposes a local `theme: SwbStyle` object for per-instance overrides. See the [component reference](docs/CONTROLS.md) for the full API.

> The CMake snippets below name the executable target `appMyApp`. If you prefer another name, keep it **different from your QML module URI** (or make the target a macOS bundle) — otherwise the QML output directory and the executable fight over the same path.

**Option 1 is the recommended route** — a single `add_subdirectory`, no install step, no paths to manage, and IDE tooling picks the module up from your build directory automatically. Reach for Option 2/3 only when several projects should share one prebuilt copy of the library.

### Option 1 — Source import (`add_subdirectory`) — recommended

Copy the repository (or add it as a git submodule) into your project, then:

```cmake
add_subdirectory(SWB-QML-UI)

target_link_libraries(appMyApp PRIVATE Qt6::Quick SwbControls)
# Only needed if you set BUILD_SHARED_LIBS=OFF to build it statically:
if(NOT BUILD_SHARED_LIBS)
    target_link_libraries(appMyApp PRIVATE SwbControlsplugin)
endif()
```

That's it — no import path setup. The QML files are compiled into the library, its resources register themselves when the library loads, and `import SwbControls` resolves through the engine's built-in `qrc:/qt/qml` path. The example app is skipped automatically in this mode.

### Option 2 — Installed shared library (`find_package`)

Build with the defaults, then install:

```bash
cmake --install build --prefix /your/prefix
```

Installed layout:

```
lib/libSwbControls.<so|dylib|dll>     # backing library (compiled QML inside)
lib/cmake/SwbControls/                # CMake package files for find_package
share/qml/SwbControls/                # on-disk QML module: qmldir + qmltypes + QML sources + plugin
```

Consume it:

```cmake
list(APPEND CMAKE_PREFIX_PATH "/your/prefix")
find_package(SwbControls REQUIRED)
target_link_libraries(appMyApp PRIVATE Qt6::Quick Swb::SwbControls)
```

No import path and no extra code: the compiled QML resources travel inside `libSwbControls` and register themselves when the library loads, so the engine resolves `import SwbControls` through its built-in `qrc:/qt/qml` path. When you ship the app, distribute `libSwbControls` alongside it. The on-disk `share/qml/SwbControls/` directory serves the tooling — qmllint/qmlls and your IDE read the plain `.qml` sources from there (see [IDE & qmlls support](#ide--qml-language-server-qmlls-support)).

### Option 3 — Installed static library (`find_package`)

Build and install a static variant:

```bash
cmake -S . -B build-static -G Ninja -DBUILD_SHARED_LIBS=OFF -DQT_PATH=...
cmake --build build-static
cmake --install build-static --prefix /your/prefix
```

Consume it:

```cmake
list(APPEND CMAKE_PREFIX_PATH "/your/prefix")
find_package(SwbControls REQUIRED)
target_link_libraries(appMyApp PRIVATE Qt6::Quick Swb::SwbControls)
```

The consuming code is identical to Option 2. The difference is the deliverable: the QML plugin, its type registrations, and all compiled QML resources are linked straight into your executable (the CMake package attaches them to `Swb::SwbControls` automatically), so everything ends up inside a single self-contained binary — nothing to ship next to it.

## IDE & QML language server (qmlls) support

The installed module ships its plain `.qml` sources next to the `qmldir`, so `qmllint` and `qmlls` — and any editor powered by them — can resolve every Swb type, its inheritance chain, and code completion.

For a consuming project (Options 2/3), let CMake generate the `.qmlls.ini` that points qmlls at the library:

```cmake
set(QT_QML_GENERATE_QMLLS_INI ON CACHE BOOL "" FORCE)
set_target_properties(appMyApp PROPERTIES
    QT_QML_IMPORT_PATH "${SwbControls_QML_IMPORT_PATH}")
```

`.qmlls.ini` is (re)written into your project root at build time — add it to your `.gitignore`. With Option 1 the module already lives in your build directory, which the generated `buildDir` entry covers, so the first line alone is enough.

## Components

All 51 visual controls of `QtQuick.Controls.Basic` are covered — buttons, value inputs, text editing (with a themed right-click menu), menus, popups & overlays, navigation, containers, calendar, and table helpers.

**[→ Component reference & usage](docs/CONTROLS.md)**

## License

[MIT](LICENSE)

## Acknowledgements

- [shadcn/ui](https://ui.shadcn.com/) — this library follows the design parameters of its Base UI components; thank you for the beautiful design system.
- [byralpha/AntDesign](https://github.com/byralpha/AntDesign) — some asset files in the example gallery come from this project's example; thank you for the excellent reference.
