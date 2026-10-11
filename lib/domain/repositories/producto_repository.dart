import '../entities/producto.dart';

/// Contrato del repositorio. La capa de presentación depende de esta
/// abstracción, no de SQLite (se puede cambiar el almacenamiento sin tocar la UI).
abstract class ProductoRepository {
  Future<List<Producto>> obtenerTodos();
  Future<int> insertar(Producto producto);
}
