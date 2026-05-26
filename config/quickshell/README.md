# Structure

Where things go:

- `config/` — singletons of static settings/theme (just values).
- `services/` — singletons that expose live system data and hold state.
- `modules/` — top-level surfaces (windows/overlays). A surface gets its own subdir
  once it has private sub-components; the surface file and those components live together.
  Single-file surfaces sit at the root until they grow.
- `widgets/` — generic components reusable by any module.

A component specific to one surface stays inside that surface's folder.
When a second consumer needs it the same component, it can be moved to `widgets/` for reuse.

## Imports & qmldir

- Cross-folder: `import qs.<path>` (relative to `shell.qml`). Same-dir PascalCase files
  import implicitly. Singletons use `pragma Singleton` + `Singleton` root.
