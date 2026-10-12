/// Entidad de dominio: un producto del inventario.
/// No conoce SQLite ni Flutter; solo describe el negocio.
class Producto {
  final int? id; // null mientras no se haya guardado
  final String nombre;
  final double costo; // costo de adquisición (precio de compra)
  final String categoria;
  final int stock;
  final DateTime creadoEn;

  const Producto({
    this.id,
    required this.nombre,
    required this.costo,
    required this.categoria,
    required this.stock,
    required this.creadoEn,
  });

  Producto copyWith({
    String? nombre,
    double? costo,
    String? categoria,
    int? stock,
  }) {
    return Producto(
      id: id,
      nombre: nombre ?? this.nombre,
      costo: costo ?? this.costo,
      categoria: categoria ?? this.categoria,
      stock: stock ?? this.stock,
      creadoEn: creadoEn,
    );
  }
}