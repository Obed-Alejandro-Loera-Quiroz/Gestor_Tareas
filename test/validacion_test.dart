import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_tareas_local/utils/validacion.dart';

void main() {
  group('validarTitulo', () {
    test('rechaza nulo, vacío y solo espacios', () {
      expect(validarTitulo(null), isNotNull);
      expect(validarTitulo(''), isNotNull);
      expect(validarTitulo('   '), isNotNull);
    });

    test('acepta un título normal', () {
      expect(validarTitulo('Comprar leche'), isNull);
    });

    test('rechaza títulos de más de 200 caracteres', () {
      expect(validarTitulo('a' * 201), isNotNull);
    });
  });
}