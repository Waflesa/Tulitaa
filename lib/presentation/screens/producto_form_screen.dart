import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/formato.dart';
import '../viewmodels/inventario_viewmodel.dart';
import '../../domain/entities/producto.dart';

/// Formulario para registrar un producto nuevo.
/// Muestra en vivo el precio de venta mientras se escribe el costo.
class ProductoFormScreen extends StatefulWidget {
  final Producto? producto; // null = producto nuevo

  const ProductoFormScreen({super.key, this.producto});
  

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _costoCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  String? _categoria;
  bool _guardando = false;

    bool get _editando => widget.producto != null;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    if (p != null) {
      _nombreCtrl.text = p.nombre;
      _costoCtrl.text = p.costo.toString();
      _stockCtrl.text = p.stock.toString();
      if (AppConstants.categorias.contains(p.categoria)) {
        _categoria = p.categoria;
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _costoCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  /// Acepta "12,50" o "12.50".
  double? _leerCosto(String texto) =>
      double.tryParse(texto.trim().replaceAll(',', '.'));

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<InventarioViewModel>();
    setState(() => _guardando = true);

        final costo = _leerCosto(_costoCtrl.text)!;
    final stock = int.parse(_stockCtrl.text.trim());
    final ok = _editando
        ? await vm.actualizarProducto(
            widget.producto!,
            nombre: _nombreCtrl.text,
            costo: costo,
            categoria: _categoria!,
            stock: stock,
          )
        : await vm.agregarProducto(
            nombre: _nombreCtrl.text,
            costo: costo,
            categoria: _categoria!,
            stock: stock,
          );

    if (!mounted) return;
    setState(() => _guardando = false);

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error ?? 'Ocurrió un error.',
              style: const TextStyle(fontSize: 20)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pricing = context.read<InventarioViewModel>().pricing;
    final tema = Theme.of(context);

    return Scaffold(
            appBar: AppBar(
          title: Text(_editando ? 'Editar producto' : 'Nuevo producto')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreCtrl,
                  style: const TextStyle(fontSize: 24),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                    hintText: 'Ej: Arroz 1 libra',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Escriba el nombre del producto'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _costoCtrl,
                  style: const TextStyle(fontSize: 24),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Costo de compra (C\$)',
                    hintText: 'Ej: 18.50',
                  ),
                  validator: (v) {
                    final costo = _leerCosto(v ?? '');
                    if (costo == null) return 'Escriba el costo con números';
                    if (costo <= 0) return 'El costo debe ser mayor que cero';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _categoria,
                  isExpanded: true,
                  style: tema.textTheme.bodyLarge
                      ?.copyWith(color: Colors.black87),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: AppConstants.categorias
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoria = v),
                  validator: (v) =>
                      v == null ? 'Escoja una categoría' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _stockCtrl,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad en stock',
                    hintText: 'Ej: 24',
                  ),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null) return 'Escriba la cantidad con números';
                    if (n < 0) return 'La cantidad no puede ser negativa';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Vista previa en vivo del precio de venta (regla del 20 %).
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _costoCtrl,
                  builder: (_, valor, __) {
                    final costo = _leerCosto(valor.text);
                    final texto = (costo != null && costo > 0)
                        ? Formato.moneda(pricing.precioVenta(costo))
                        : '—';
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: tema.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Precio de venta (+${pricing.margenTexto})',
                            style: tema.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(texto, style: tema.textTheme.titleLarge),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),

                FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: const Icon(Icons.save, size: 30),
                  label: Text(_guardando ? 'GUARDANDO...' : 'GUARDAR'),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed:
                      _guardando ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                  child: const Text('CANCELAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
