import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../viewmodels/inventario_viewmodel.dart';
import '../widgets/producto_card.dart';
import 'producto_form_screen.dart';

/// Pantalla principal: lista de inventario con precios de venta calculados.
class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  @override
  void initState() {
    super.initState();
    // Carga inicial al abrir la app.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<InventarioViewModel>().cargarProductos(),
    );
  }

  Future<void> _abrirFormulario() async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ProductoFormScreen()),
    );
    if (guardado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Producto guardado!', style: TextStyle(fontSize: 22)),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InventarioViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: SafeArea(child: _cuerpo(vm)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.add, size: 32),
        label: const Text('AGREGAR PRODUCTO'),
      ),
    );
  }

  Widget _cuerpo(InventarioViewModel vm) {
    if (vm.cargando && vm.productos.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 6));
    }
    if (vm.error != null && vm.productos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(vm.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22)),
        ),
      );
    }
    if (vm.productos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Todavía no hay productos.\nToque el botón verde para agregar el primero.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, height: 1.4),
          ),
        ),
      );
    }
    return ListView.builder(
      // Espacio abajo para que el botón flotante no tape la última tarjeta.
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      itemCount: vm.productos.length,
      itemBuilder: (_, i) =>
          ProductoCard(producto: vm.productos[i], pricing: vm.pricing),
    );
  }
}
