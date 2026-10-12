import '../../core/constants/app_constants.dart';
import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../database/database_helper.dart';
import '../models/producto_model.dart';

/// Implementación del repositorio usando SQLite (sqflite).
class ProductoRepositoryImpl implements ProductoRepository {
  final DatabaseHelper _dbHelper;

  ProductoRepositoryImpl(this._dbHelper);

  @override
  Future<List<Producto>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final filas = await db.query(
      AppConstants.tablaProductos,
      orderBy: 'nombre COLLATE NOCASE ASC',
    );
    return filas.map(ProductoModel.fromMap).toList();
  }

  @override
  Future<int> insertar(Producto producto) async {
    final db = await _dbHelper.database;
    return db.insert(
      AppConstants.tablaProductos,
      ProductoModel.fromEntity(producto).toMap(),
    );
  }

  @override
  Future<int> actualizar(Producto producto) async {
    final db = await _dbHelper.database;
    final datos = ProductoModel.fromEntity(producto).toMap()..remove('id');
    return db.update(
      AppConstants.tablaProductos,
      datos,
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  @override
  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      AppConstants.tablaProductos,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
