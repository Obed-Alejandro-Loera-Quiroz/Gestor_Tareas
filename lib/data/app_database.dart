import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tareas_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tareas])
class AppDatabase extends _$AppDatabase {
  // El parámetro opcional permite usar una base en memoria en las pruebas.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _abrirConexion());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _abrirConexion() => driftDatabase(
        name: 'gestor_tareas',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );

  Future<int> insertarTarea(String titulo) =>
      into(tareas).insert(TareasCompanion.insert(titulo: titulo));

  Future<List<TareaRegistro>> obtenerTareas() =>
      (select(tareas)..orderBy([(t) => OrderingTerm.desc(t.id)])).get();

  // Alternativa reactiva (pregunta I5 del PDF).
  Stream<List<TareaRegistro>> observarTareas() =>
      (select(tareas)..orderBy([(t) => OrderingTerm.desc(t.id)])).watch();

  Future<bool> actualizarTitulo(int id, String titulo) async {
    final filas = await (update(tareas)..where((t) => t.id.equals(id)))
        .write(TareasCompanion(titulo: Value(titulo)));
    return filas > 0;
  }

  Future<bool> cambiarEstado(int id, bool completada) async {
    final filas = await (update(tareas)..where((t) => t.id.equals(id)))
        .write(TareasCompanion(completada: Value(completada)));
    return filas > 0;
  }

  Future<int> eliminarTarea(int id) =>
      (delete(tareas)..where((t) => t.id.equals(id))).go();
}