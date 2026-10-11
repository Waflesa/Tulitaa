import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/app_constants.dart';

/// Configuración de SQLite (singleton). Todo se guarda en el teléfono,
/// por lo que la app funciona 100 % sin conexión a Internet.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async => _db ??= await _abrir();

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), AppConstants.dbName);
    return openDatabase(
      ruta,
      version: AppConstants.dbVersion,
      onCreate: _crearTablas,
      // Para futuras versiones: onUpgrade: (db, viejo, nuevo) { ... }
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tablaProductos} (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre      TEXT    NOT NULL,
        costo       REAL    NOT NULL CHECK (costo > 0),
        categoria   TEXT    NOT NULL,
        stock       INTEGER NOT NULL CHECK (stock >= 0),
        creado_en   TEXT    NOT NULL
      )
    ''');
  }

  Future<void> cerrar() async {
    await _db?.close();
    _db = null;
  }
}
