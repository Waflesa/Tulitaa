import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/database/database_helper.dart';
import 'data/repositories/producto_repository_impl.dart';
import 'domain/services/pricing_service.dart';
import 'presentation/screens/inventario_screen.dart';
import 'presentation/viewmodels/inventario_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyección de dependencias manual (suficiente para un MVP).
  final repositorio = ProductoRepositoryImpl(DatabaseHelper.instance);
  const pricing = PricingService(); // margen del 20 %

  runApp(
    ChangeNotifierProvider(
      create: (_) => InventarioViewModel(repositorio, pricing),
      child: const PulperiaTulitaApp(),
    ),
  );
}

class PulperiaTulitaApp extends StatelessWidget {
  const PulperiaTulitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const InventarioScreen(),
    );
  }
}
