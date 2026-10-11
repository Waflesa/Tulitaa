import '../../core/constants/app_constants.dart';

/// Servicio con la regla de negocio de precios.
///
/// Regla: Precio de venta = Costo * (1 + 0.20)
///
/// El precio NO se guarda en la base de datos: se calcula siempre a partir
/// del costo. Así, si el margen cambia en el futuro, todos los precios
/// quedan consistentes sin migrar datos.
class PricingService {
  final double margen;

  const PricingService({this.margen = AppConstants.margenGanancia});

  /// Precio de venta sugerido, redondeado a 2 decimales (centavos).
  double precioVenta(double costo) => _redondear(costo * (1 + margen));

  /// Ganancia en córdobas por unidad vendida.
  double ganancia(double costo) => _redondear(precioVenta(costo) - costo);

  /// Margen expresado como texto, p. ej. "20%".
  String get margenTexto => '${(margen * 100).toStringAsFixed(0)}%';

  double _redondear(double valor) => (valor * 100).roundToDouble() / 100;
}
