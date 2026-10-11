import '../../domain/entities/producto.dart';

/// Modelo de datos: traduce entre la entidad y las filas de SQLite.
class ProductoModel extends Producto {
  const ProductoModel({
    super.id,
    required super.nombre,
    required super.costo,
    required super.categoria,
    required super.stock,
    required super.creadoEn,
  });

  factory ProductoModel.fromEntity(Producto p) => ProductoModel(
        id: p.id,
        nombre: p.nombre,
        costo: p.costo,
        categoria: p.categoria,
        stock: p.stock,
        creadoEn: p.creadoEn,
      );

  factory ProductoModel.fromMap(Map<String, Object?> map) => ProductoModel(
        id: map['id'] as int?,
        nombre: map['nombre'] as String,
        costo: (map['costo'] as num).toDouble(),
        categoria: map['categoria'] as String,
        stock: map['stock'] as int,
        creadoEn: DateTime.parse(map['creado_en'] as String),
      );

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'costo': costo,
        'categoria': categoria,
        'stock': stock,
        'creado_en': creadoEn.toIso8601String(),
      };
}
