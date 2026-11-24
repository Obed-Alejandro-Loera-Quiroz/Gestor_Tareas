import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('inserta y consulta una tarea', () async {
    await db.insertarTarea('Comprar leche');
    final tareas = await db.obtenerTareas();
    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Comprar leche');
    expect(tareas.first.completada, isFalse);
  });

  test('cambia el estado de una tarea', () async {
    final id = await db.insertarTarea('Estudiar');
    await db.cambiarEstado(id, true);
    final tareas = await db.obtenerTareas();
    expect(tareas.first.completada, isTrue);
  });

  test('edita el título de una tarea', () async {
    final id = await db.insertarTarea('Titulo viejo');
    await db.actualizarTitulo(id, 'Titulo nuevo');
    final tareas = await db.obtenerTareas();
    expect(tareas.first.titulo, 'Titulo nuevo');
  });

  test('elimina una tarea por su id', () async {
    final id1 = await db.insertarTarea('Una');
    await db.insertarTarea('Dos');
    await db.eliminarTarea(id1);
    final tareas = await db.obtenerTareas();
    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Dos');
  });
}