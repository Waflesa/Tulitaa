import 'package:intl/intl.dart';

/// Utilidades de formato para mostrar dinero en córdobas.
class Formato {
  Formato._();

  static final NumberFormat _moneda =
      NumberFormat.currency(locale: 'es_NI', symbol: 'C\$ ', decimalDigits: 2);

  static String moneda(double valor) => _moneda.format(valor);
}
