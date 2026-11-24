/// Devuelve un mensaje de error si el título no es válido, o null si lo es.
String? validarTitulo(String? titulo) {
  if (titulo == null || titulo.trim().isEmpty) {
    return 'Escribe un título para la tarea.';
  }
  if (titulo.trim().length > 200) {
    return 'El título no puede pasar de 200 caracteres.';
  }
  return null;
}