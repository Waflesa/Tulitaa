/// Constantes globales de la aplicación.
class AppConstants {
  AppConstants._();

  static const String appName = 'Pulpería Tulita';

  // --- Base de datos ---
  static const String dbName = 'pulperia_tulita.db';
  static const int dbVersion = 1;
  static const String tablaProductos = 'productos';

  // --- Regla de negocio ---
  /// Ganancia fija sobre el costo (20 %). Precio venta = costo * (1 + margen).
  static const double margenGanancia = 0.20;

  /// Cuando el stock es menor o igual a este número, se muestra la alerta.
  static const int stockBajo = 5;

  /// Categorías predefinidas: evitan escribir y reducen errores de digitación.
  static const List<String> categorias = [
    'Abarrotes',
    'Granos básicos',
    'Bebidas',
    'Lácteos y huevos',
    'Dulces y snacks',
    'Limpieza e higiene',
    'Otros',
  ];
}
