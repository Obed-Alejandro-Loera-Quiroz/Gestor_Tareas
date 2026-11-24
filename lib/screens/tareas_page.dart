import 'dart:async';

import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../models/tarea.dart';
import '../utils/validacion.dart';

class TareasPage extends StatefulWidget {
  const TareasPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  List<Tarea> _tareas = [];
  StreamSubscription<List<TareaRegistro>>? _suscripcion;

  @override
  void initState() {
    super.initState();
    // La base avisa cada vez que cambia la tabla: no se consulta en build().
    _suscripcion = widget.database.observarTareas().listen(
      (registros) {
        setState(() {
          _tareas = registros
              .map((r) => Tarea(
                    id: r.id,
                    titulo: r.titulo,
                    completada: r.completada,
                  ))
              .toList();
        });
      },
      onError: (Object error) {
        _mostrarMensaje('No se pudieron cargar las tareas: $error');
      },
    );
  }

  Future<void> _agregarTarea() async {
    final error = validarTitulo(_tituloController.text);
    if (error != null) {
      _mostrarMensaje(error);
      return;
    }
    try {
      await widget.database.insertarTarea(_tituloController.text.trim());
      _tituloController.clear();
    } catch (error) {
      _mostrarMensaje('No se pudo guardar la tarea: $error');
    }
  }

  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    try {
      await widget.database.cambiarEstado(tarea.id, completada);
    } catch (error) {
      _mostrarMensaje('No se pudo actualizar la tarea: $error');
    }
  }

  Future<void> _editarTarea(Tarea tarea) async {
    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (_) => _DialogoEditarTarea(tituloInicial: tarea.titulo),
    );
    if (nuevoTitulo == null) return; // canceló
    final error = validarTitulo(nuevoTitulo);
    if (error != null) {
      _mostrarMensaje(error);
      return;
    }
    try {
      await widget.database.actualizarTitulo(tarea.id, nuevoTitulo.trim());
    } catch (error) {
      _mostrarMensaje('No se pudo editar la tarea: $error');
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    try {
      await widget.database.eliminarTarea(tarea.id);
    } catch (error) {
      _mostrarMensaje('No se pudo eliminar la tarea: $error');
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    _tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: _tareas.isEmpty
                  ? const Center(child: Text('Todavía no hay tareas guardadas'))
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = _tareas[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tarea.completada,
                              onChanged: (valor) {
                                if (valor != null) {
                                  _alternarCompletada(tarea, valor);
                                }
                              },
                            ),
                            title: Text(tarea.titulo),
                            subtitle: Text('ID: ${tarea.id}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarTarea(tarea),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _eliminarTarea(tarea),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogoEditarTarea extends StatefulWidget {
  const _DialogoEditarTarea({required this.tituloInicial});

  final String tituloInicial;

  @override
  State<_DialogoEditarTarea> createState() => _DialogoEditarTareaState();
}

class _DialogoEditarTareaState extends State<_DialogoEditarTarea> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.tituloInicial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar tarea'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Título'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}