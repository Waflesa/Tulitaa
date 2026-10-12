# Pulpería Tulita

App móvil Android **offline-first** para el control de inventario y precios de
una pulpería de El Viejo, Chinandega (Nicaragua). Hecha con **Flutter** y
**SQLite**; todos los datos se guardan en el teléfono y la app funciona sin
conexión a Internet.

Proyecto académico de la Universidad Tecnológica La Salle (ULSA), León.
Asignaturas: Formulación y Evaluación de Proyecto / Tecnología de la
Información (Unidad 1). Periodo de ejecución: septiembre – diciembre de 2026.



## Qué hace la app

| Función | Descripción |
|---|---|
| Inventario | Lista de productos con nombre, categoría, stock, costo, ganancia y precio de venta. |
| Agregar producto | Formulario con validaciones y vista previa en vivo del precio de venta. |
| Buscar | Filtro por nombre o categoría (ignora mayúsculas y tildes). |
| Editar | Modifica nombre, costo, categoría y cantidad en stock. |
| Eliminar | Con ventana de confirmación para evitar borrados accidentales. |
| Alerta de stock bajo | Tarjeta resaltada cuando el stock es menor o igual a 5 unidades; "AGOTADO" cuando es 0. |

**Reglas de negocio**

- Precio de venta sugerido = costo × 1.20 (margen del 20 %), calculado por `PricingService`.
- Costo mayor que cero y stock mayor o igual a cero (validado en el formulario y en la tabla SQLite con `CHECK`).
- Umbral de alerta: constante `AppConstants.stockBajo` (valor actual: 5).

**Diseño pensado para una usuaria de la tercera edad:** letra grande, botones
de más de 48 dp, un flujo de pantallas corto y confirmación antes de eliminar.

## Requisitos

| Herramienta | Versión con la que se probó |
|---|---|
| Flutter | 3.47.7 (canal stable) |
| Dart | 3.13.5 (el proyecto exige `>=3.3.0 <4.0.0`) |
| Android Studio con Android SDK | Cualquier versión reciente |
| Android NDK (Side by side) | 28.2.13676358 |
| Emulador o teléfono Android | Probado en el emulador `Medium_Phone_API_37.0` |
| Git | Cualquier versión reciente |

Sistema operativo usado por el equipo: Windows 11 con PowerShell.

Si Gradle falla con *"Android sdkmanager did not install NDK ..."*, instale la
versión que indica el mensaje desde **Android Studio → SDK Manager → SDK Tools →
Show Package Details → NDK (Side by side)**.

## Instalación

```powershell
git clone https://github.com/Waflesa/Tulitaa.git
cd Tulitaa
flutter pub get
```

Si la carpeta `android/` no existe en su copia del repositorio, genérela **desde
la raíz del proyecto** (no desde `lib/`):

```powershell
flutter create --platforms=android --project-name=pulperia_tulita .
flutter pub get
```

Sin la opción `--overwrite`, Flutter conserva los archivos existentes y solo
crea los que faltan.

## Configuración

La app **no necesita** claves, tokens, cuentas ni variables de entorno. La base
de datos se crea sola en el primer arranque (archivo SQLite dentro del
almacenamiento privado de la app). Los valores configurables están en
`lib/core/constants/app_constants.dart`:

- `appName`: nombre que se muestra en la barra superior.
- `categorias`: categorías disponibles en el formulario.
- `stockBajo`: umbral de la alerta de stock bajo.
- `dbName` y `dbVersion`: archivo y versión de la base de datos.

No se debe subir al repositorio ninguna clave, contraseña ni token.

## Ejecución

1. Encienda un emulador (Android Studio → Device Manager) o conecte un
   teléfono con depuración USB.
2. Compruebe que Flutter lo detecta:

   ```powershell
   flutter devices
   ```

3. Ejecute la app (la primera compilación puede tardar varios minutos):

   ```powershell
   flutter run -d emulator-5554
   ```

   Cambie `emulator-5554` por el identificador que muestre `flutter devices`.

Para generar un APK de prueba: `flutter build apk --debug`.

**Reiniciar con datos limpios:** desinstale la app del emulador o use
*Configuración → Aplicaciones → Pulpería Tulita → Almacenamiento → Borrar datos*.

## Datos de prueba

La app arranca con el inventario vacío. Los productos de ejemplo, con casos que
activan la alerta de stock bajo y el estado "agotado", están en
[`docs/datos_de_prueba.md`](docs/datos_de_prueba.md). Todos son ficticios; el
proyecto no usa datos personales reales.

## Cómo ejecutar la demostración

El guion paso a paso esta en:
[`docs/guion_demostracion.md`](docs/guion_demostracion.md). Resumen:
cargar los productos de prueba, buscar, editar, provocar la alerta de stock
bajo, eliminar con confirmación y comprobar que los datos persisten al cerrar y
volver a abrir la app.

## Arquitectura

MVVM con capas separadas, usando `provider` para el estado.

```
lib/
├── core/            # Constantes, tema y utilidades compartidas
│   ├── constants/app_constants.dart
│   ├── theme/app_theme.dart
│   └── utils/formato.dart
├── data/            # Acceso a SQLite
│   ├── database/database_helper.dart
│   ├── models/producto_model.dart
│   └── repositories/producto_repository_impl.dart
├── domain/          # Reglas del negocio (sin Flutter ni SQLite)
│   ├── entities/producto.dart
│   ├── repositories/producto_repository.dart
│   └── services/pricing_service.dart
├── presentation/    # Interfaz y lógica de pantalla
│   ├── screens/     # inventario_screen, producto_form_screen
│   ├── viewmodels/  # inventario_viewmodel
│   └── widgets/     # producto_card
└── main.dart
```

Flujo de datos: **pantalla → ViewModel → repositorio (interfaz) → SQLite**.
La interfaz del repositorio vive en `domain`, por lo que la lógica de negocio
no depende de la base de datos.

## Estado actual y limitaciones

Esta es una versión de prototipo (MVP), todavía no una solución de producción.

- No hay inicio de sesión ni roles de usuario.
- No se registra quién hizo cada operación (trazabilidad pendiente).
- No hay módulos de ventas ni de pagos a proveedores; solo inventario y precios.
- No hay comandos de voz.
- La alerta de stock usa un umbral único para todos los productos y no
  considera la velocidad de venta.
- No hay respaldo de datos en la nube: si se desinstala la app, se pierde el
  inventario.
- Las pruebas automatizadas están pendientes (`test/widget_test.dart` es la
  plantilla de Flutter y no corresponde a esta app).
- Solo se generó la plataforma Android.

## Equipo

| Integrante | Usuario de GitHub | Aporte principal |
|---|---|---|
| Fernando Marcelo Arauz Blanco| MorongaExplosiva | Fronted  |
| Winston Vidal Reyes Narvaez  | Waflesa          |Backend   |
| Ramon Antonio Mendoza cano   |SopladoDeHollin   | Documento|



Para ver la participación de cada integrante:

```powershell
git shortlog -sn --all
git log --format="%h | %an | %ad | %s" --date=short
```

Cada integrante debe configurar su identidad antes de hacer commits, con el
mismo correo de su cuenta de GitHub:

```powershell
git config user.name "Su Nombre"
git config user.email "su-correo@ejemplo.com"
```

## Licencia y atribuciones

Código del proyecto bajo licencia MIT (ver [`LICENSE`](LICENSE)).
Los componentes de terceros y sus licencias están listados en
[`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md).

  **APK de prueba:** descárguelo desde
  [Releases](https://github.com/Waflesa/Tulitaa/releases/tag/v0.1.0).
