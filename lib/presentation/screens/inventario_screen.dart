import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/producto.dart';
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
  final _busquedaCtrl = TextEditingController();
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    // Carga inicial al abrir la app.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<InventarioViewModel>().cargarProductos(),
    );
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  /// Minúsculas y sin tildes, para que "aceite" encuentre "Aceíte".
  String _normalizar(String texto) {
    const con = 'áéíóúüñ';
    const sin = 'aeiouun';
    var r = texto.toLowerCase().trim();
    for (var i = 0; i < con.length; i++) {
      r = r.replaceAll(con[i], sin[i]);
    }
    return r;
  }

  List<Producto> _filtrar(List<Producto> productos) {
    final q = _normalizar(_filtro);
    if (q.isEmpty) return productos;
    return productos
        .where((p) =>
            _normalizar(p.nombre).contains(q) ||
            _normalizar(p.categoria).contains(q))
        .toList();
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
    Future<void> _editar(Producto producto) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProductoFormScreen(producto: producto),
      ),
    );
    if (guardado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cambios guardados!', style: TextStyle(fontSize: 22)),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _confirmarEliminar(Producto producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar ${producto.nombre}?',
            style: const TextStyle(fontSize: 24)),
        content: const Text('Esta acción no se puede deshacer.',
            style: TextStyle(fontSize: 20)),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(130, 56)),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCELAR', style: TextStyle(fontSize: 20)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(130, 56),
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('ELIMINAR', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;

    final vm = context.read<InventarioViewModel>();
    final ok = await vm.eliminarProducto(producto);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            ok ? 'Producto eliminado' : (vm.error ?? 'Ocurrió un error.'),
            style: const TextStyle(fontSize: 22)),
      ),
    );
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

  Widget _buscador() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        controller: _busquedaCtrl,
        style: const TextStyle(fontSize: 24),
        textInputAction: TextInputAction.search,
        onChanged: (v) => setState(() => _filtro = v),
        decoration: InputDecoration(
          hintText: 'Buscar producto',
          prefixIcon: const Icon(Icons.search, size: 32),
          suffixIcon: _filtro.isEmpty
              ? null
              : IconButton(
                  iconSize: 32,
                  tooltip: 'Borrar búsqueda',
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _busquedaCtrl.clear();
                    setState(() => _filtro = '');
                  },
                ),
        ),
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

    final visibles = _filtrar(vm.productos);

    return Column(
      children: [
        _buscador(),
        Expanded(
          child: visibles.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No se encontró ningún producto con ese nombre.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, height: 1.4),
                    ),
                  ),
                )
              : ListView.builder(
                  // Espacio abajo para que el botón flotante no tape la última tarjeta.
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                  itemCount: visibles.length,
                                    itemBuilder: (_, i) => ProductoCard(
                    producto: visibles[i],
                    pricing: vm.pricing,
                    onEditar: () => _editar(visibles[i]),
                    onEliminar: () => _confirmarEliminar(visibles[i]),
                  ),
                ),
        ),
      ],
    );
  }
}