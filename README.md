# Gestor de tareas con SQLite (Flutter)

Práctica de Programación de Dispositivos Móviles (UAA). Aplicación Flutter que
administra tareas con una base de datos SQLite local, sin servidor ni conexión a
internet. Los datos se conservan entre ejecuciones.

## Tecnología de persistencia

Se eligió **Drift** con **drift_flutter** (sobre SQLite).

Motivos:
- Una sola configuración sirve para Android, iOS, Windows, Linux, macOS y web.
- Las tablas se definen en Dart y las consultas son tipadas, lo que evita errores
  de SQL escrito como texto.
- Permite consultas reactivas con `Stream`, por lo que la lista se actualiza sola
  después de cada escritura.
- En web usa SQLite compilado a WebAssembly (`sqlite3.wasm`) y un worker
  (`drift_worker.js`).

## Diseño de la tabla `tareas`

| Columna      | Tipo SQLite | Descripción                                      |
|--------------|-------------|--------------------------------------------------|
| `id`         | INTEGER PK  | Identificador único, autoincremental             |
| `titulo`     | TEXT        | Título de la tarea (no vacío)                    |
| `completada` | INTEGER     | Booleano guardado como 0 (pendiente) o 1 (hecha) |

Cada registro se identifica por su `id`, que se usa para editar, cambiar el
estado y eliminar.

## Estructura

- `lib/main.dart`: arranque de la aplicación.
- `lib/screens/tareas_page.dart`: pantalla de tareas.
- `lib/models/tarea.dart`: modelo de tarea.
- `lib/data/`: capa de persistencia (tabla y base de datos Drift).
- `test/`: pruebas automatizadas.

## Cómo ejecutarlo

Requisitos: Flutter instalado (`flutter doctor -v` sin errores).

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome --web-port 5000   # web
flutter run -d linux                    # escritorio Linux
```

Para web se necesitan `web/sqlite3.wasm` y `web/drift_worker.js` (incluidos en
el repositorio). Se usa siempre el mismo puerto porque el navegador guarda los
datos por origen.

## Pruebas

```bash
flutter analyze
flutter test
```

*(completar: qué casos cubren las pruebas automatizadas)*

## Plataformas probadas

*(completar al terminar: indicar cuáles probaste y cuáles son solo previstas)*

## Resultados de las pruebas P1–P6

*(completar con lo que realmente observaste)*