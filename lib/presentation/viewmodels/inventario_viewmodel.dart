import 'package:flutter/foundation.dart';

import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../../domain/services/pricing_service.dart';

/// ViewModel (MVVM): conecta la UI con el repositorio y el servicio de precios.
class InventarioViewModel extends ChangeNotifier {
  final ProductoRepository _repositorio;
  final PricingService pricing;

  InventarioViewModel(this._repositorio, this.pricing);

  List<Producto> _productos = [];
  bool _cargando = false;
  String? _error;

  List<Producto> get productos => List.unmodifiable(_productos);
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarProductos() async {
    _cargando = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await _repositorio.obtenerTodos();
    } catch (_) {
      _error = 'No se pudo cargar el inventario.';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Devuelve true si se guardó bien.
  Future<bool> agregarProducto({
    required String nombre,
    required double costo,
    required String categoria,
    required int stock,
  }) async {
    try {
      await _repositorio.insertar(Producto(
        nombre: nombre.trim(),
        costo: costo,
        categoria: categoria,
        stock: stock,
        creadoEn: DateTime.now(),
      ));
      await cargarProductos();
      return true;
    } catch (_) {
      _error = 'No se pudo guardar el producto. Intente de nuevo.';
      notifyListeners();
      return false;
    }
  }

  /// Devuelve true si se actualizó bien.
  Future<bool> actualizarProducto(
    Producto original, {
    required String nombre,
    required double costo,
    required String categoria,
    required int stock,
  }) async {
    try {
      await _repositorio.actualizar(original.copyWith(
        nombre: nombre.trim(),
        costo: costo,
        categoria: categoria,
        stock: stock,
      ));
      await cargarProductos();
      return true;
    } catch (_) {
      _error = 'No se pudo actualizar el producto. Intente de nuevo.';
      notifyListeners();
      return false;
    }
  }

  /// Devuelve true si se eliminó bien.
  Future<bool> eliminarProducto(Producto producto) async {
    if (producto.id == null) return false;
    try {
      await _repositorio.eliminar(producto.id!);
      await cargarProductos();
      return true;
    } catch (_) {
      _error = 'No se pudo eliminar el producto. Intente de nuevo.';
      notifyListeners();
      return false;
    }
  }
}
