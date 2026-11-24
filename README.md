## Pruebas automatizadas

`flutter test` ejecuta:
- `validacion_test.dart`: rechaza títulos nulos, vacíos o de solo espacios, acepta uno normal y rechaza los de más de 200 caracteres.
- `app_database_test.dart`: con una base en memoria, inserta y consulta, cambia el estado, edita el título y elimina por id.
- `widget_test.dart`: la app abre y muestra la pantalla de tareas.

## Plataformas

- **Probadas:** Linux (escritorio) y web (Chrome).
- **Previstas, no probadas:** Android, iOS, Windows y macOS. El mismo código usa `drift_flutter`, que las soporta, pero no se ejecutó en ellas.

## Resultados de las pruebas manuales

| ID | Resultado |
|----|-----------|
| P1 | Pasó en Linux: las 3 tareas siguieron al cerrar y abrir |
| P2 | Pasó: el estado completado se conservó |
| P3 | Pasó: apareció el título nuevo |
| P4 | Pasó: la tarea eliminada no reapareció |
| P5 | Pasó: el título vacío no se registra y sale un aviso |
| P6 | Pasó en Chrome: los datos permanecieron al recargar y al cerrar/abrir la pestaña en `localhost:5000` |

## Notas de web

Se necesitan `web/sqlite3.wasm` y `web/drift_worker.js`, que ya están en el repositorio. Sin ellos la app muestra un error de tipo MIME de WebAssembly. Se ejecuta siempre en el mismo puerto (`--web-port 5000`) porque el navegador guarda los datos por origen.