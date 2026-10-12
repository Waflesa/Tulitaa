import 'package:flutter/material.dart';

import '../../core/utils/formato.dart';
import '../../domain/entities/producto.dart';
import '../../domain/services/pricing_service.dart';

/// Tarjeta grande con nombre, costo, margen y precio de venta ya calculado.
class ProductoCard extends StatelessWidget {
  final Producto producto;
  final PricingService pricing;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.pricing,
    this.onEditar,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final precio = pricing.precioVenta(producto.costo);
    final ganancia = pricing.ganancia(producto.costo);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        Row(
              children: [
                Expanded(
                  child: Text(producto.nombre,
                      style: tema.textTheme.titleMedium),
                ),
                IconButton(
                  tooltip: 'Editar',
                  iconSize: 32,
                  constraints:
                      const BoxConstraints(minWidth: 56, minHeight: 56),
                  icon: const Icon(Icons.edit),
                  onPressed: onEditar,
                ),
                IconButton(
                  tooltip: 'Eliminar',
                  iconSize: 32,
                  constraints:
                      const BoxConstraints(minWidth: 56, minHeight: 56),
                  color: Colors.red.shade700,
                  icon: const Icon(Icons.delete),
                  onPressed: onEliminar,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${producto.categoria}  •  En stock: ${producto.stock}',
              style: tema.textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey.shade800),
            ),
            const Divider(height: 28, thickness: 1.5),
            _Fila(etiqueta: 'Costo', valor: Formato.moneda(producto.costo)),
            _Fila(
              etiqueta: 'Ganancia (${pricing.margenTexto})',
              valor: Formato.moneda(ganancia),
            ),
            const SizedBox(height: 10),
                        Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: tema.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text('PRECIO DE VENTA', style: tema.textTheme.labelLarge),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        Formato.moneda(precio),
                        style: tema.textTheme.titleLarge?.copyWith(
                          color: tema.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fila extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _Fila({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: estilo),
          Text(valor, style: estilo?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
