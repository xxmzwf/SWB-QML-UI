# SWB-QML-UI（Shadcn Base UI for QML）

English | [简体中文](docx/README-Chinese.md)

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/platform-macOS-000000?style=flat&logo=apple&logoColor=white">
  <img alt="Windows" src="https://img.shields.io/badge/platform-Windows-0078D4?style=flat&logo=windows11&logoColor=white">
</p>

**SWB-QML-UI is a shadcn Base UI style GUI control library for QML.** It restyles the full set of `QtQuick.Controls.Basic` visual controls — 51 in total — into the clean, black-and-white shadcn Base UI look, with light/dark theming driven by a single singleton.

Out of respect for the original work: part of the controls in this library are implemented following the design parameters of [shadcn](https://ui.shadcn.com/)'s Base UI components, and the rest are written from scratch for this library.

- **51 restyled controls** — buttons, inputs, menus, popups, navigation, calendar, table helpers… see the [component reference](docx/CONTROLS.md)
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

`SwbTheme` is a **module singleton** — it is registered automatically with the module, so after `import SwbControls` you can customize its light/dark palettes and metrics or switch modes (`SwbTheme.darkMode = true`) anywhere; dark mode follows the system color scheme by default. Every visual control also exposes a local `theme: SwbStyle` object for per-instance overrides. See the [component reference](docx/CONTROLS.md) for the full API.

> The CMake snippets below name the executable target `appMyApp`. If you prefer another name, keep it **different from your QML module URI** (or make the target a macOS bundle) — otherwise the QML output directory and the executable fight over the same path.

### Option 1 — Source import (`add_subdirectory`)

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
lib/libSwbControls.<so|dylib|dll>     # backing library
lib/cmake/SwbControls/                # CMake package files for find_package
share/qml/SwbControls/                # QML module: plugin + qmldir + qmltypes
```

Consume it:

```cmake
list(APPEND CMAKE_PREFIX_PATH "/your/prefix")
find_package(SwbControls REQUIRED)

target_link_libraries(appMyApp PRIVATE Qt6::Quick Swb::SwbControls)
# The package exports the installed QML directory; hand it to your app:
target_compile_definitions(appMyApp PRIVATE
    SWB_QML_DIR="${SwbControls_QML_IMPORT_PATH}")
```

```cpp
QQmlApplicationEngine engine;
engine.addImportPath(QStringLiteral(SWB_QML_DIR));  // before loading QML
```

**Why the import path?** With a shared build, the QML engine loads the plugin from disk at runtime, so it must be able to find `share/qml/SwbControls/`. Setting the `QML_IMPORT_PATH` environment variable to that directory works too. When you ship the app, distribute `libSwbControls` and the `share/qml/SwbControls/` directory alongside it.

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

This is where static differs from shared: **no import path and no extra code needed.** The QML plugin, its type registrations, and all compiled QML resources are linked straight into your executable (the CMake package attaches them to `Swb::SwbControls` automatically), and the engine finds the module through the built-in `qrc:/qt/qml` path. Everything ends up inside a single binary.

If you support both build flavors with one CMakeLists.txt, gate the import-path define on the library type:

```cmake
get_target_property(_swb_type Swb::SwbControls TYPE)
if(_swb_type STREQUAL "SHARED_LIBRARY")
    target_compile_definitions(appMyApp PRIVATE
        SWB_QML_DIR="${SwbControls_QML_IMPORT_PATH}")
endif()
```

## Components

All 51 visual controls of `QtQuick.Controls.Basic` are covered — buttons, value inputs, text editing (with a themed right-click menu), menus, popups & overlays, navigation, containers, calendar, and table helpers.

**[→ Component reference & usage](docx/CONTROLS.md)**

## License

[MIT](LICENSE)

## Acknowledgements

- [shadcn/ui](https://ui.shadcn.com/) — this library follows the design parameters of its Base UI components; thank you for the beautiful design system.
- [byralpha/AntDesign](https://github.com/byralpha/AntDesign) — some asset files in the example gallery come from this project's example; thank you for the excellent reference.
