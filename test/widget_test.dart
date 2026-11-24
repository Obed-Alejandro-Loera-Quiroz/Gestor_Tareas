import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/data/app_database.dart';
import 'package:gestor_tareas_local/main.dart';

void main() {
  testWidgets('La app abre y muestra la pantalla de tareas', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());

    await tester.pumpWidget(GestorTareasApp(database: db));
    await tester.pump();

    expect(find.text('Gestor de tareas'), findsOneWidget);
    expect(find.text('Agregar tarea'), findsOneWidget);

    // Se retira la pantalla para cancelar la suscripción y se cierra la base.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(db.close);
  });
}