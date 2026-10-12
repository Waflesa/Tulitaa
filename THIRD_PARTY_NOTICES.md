# Componentes de terceros

Este proyecto usa software de código abierto. Cada componente conserva su
propia licencia y sus derechos de autor. Este listado se basa en las
dependencias declaradas en `pubspec.yaml`; **antes de entregar, verifique la
licencia de cada paquete en su página de pub.dev (pestaña "License")**, ya que
las licencias pueden cambiar entre versiones.

## Dependencias directas

| Componente | Versión declarada | Uso en el proyecto | Licencia (a verificar en pub.dev) | Enlace |
|---|---|---|---|---|
| Flutter SDK | 3.47.7 (usada por el equipo) | Framework de la interfaz | BSD 3-Clause | https://github.com/flutter/flutter |
| sqflite | ^2.3.3 | Base de datos SQLite local | BSD 2-Clause | https://pub.dev/packages/sqflite |
| path | ^1.9.0 | Construcción de la ruta de la base de datos | BSD 3-Clause | https://pub.dev/packages/path |
| provider | ^6.1.2 | Gestión de estado (ChangeNotifier) | MIT | https://pub.dev/packages/provider |
| intl | ^0.19.0 | Formato de moneda (C$) | BSD 3-Clause | https://pub.dev/packages/intl |

## Dependencias de desarrollo

| Componente | Versión declarada | Uso | Licencia (a verificar) | Enlace |
|---|---|---|---|---|
| flutter_lints | ^4.0.0 | Reglas de análisis de código | BSD 3-Clause | https://pub.dev/packages/flutter_lints |
| flutter_test | (SDK de Flutter) | Pruebas | BSD 3-Clause | https://github.com/flutter/flutter |

## Recursos incluidos con Flutter

- **Material Icons** (íconos como lápiz, papelera, búsqueda y advertencia):
  incluidos con Flutter con `uses-material-design: true`. Licencia Apache 2.0.
- **Roboto** (tipografía por defecto en Android): Apache 2.0.

## Dependencias indirectas

Las dependencias transitivas (por ejemplo, de `sqflite`) quedan registradas con
su versión exacta en `pubspec.lock`. Para listarlas:

```powershell
flutter pub deps
```

Cada una tiene su propia licencia, consultable en pub.dev.

## Herramientas de apoyo

El equipo utilizó un asistente de IA (Claude, de Anthropic) como apoyo para
explicar conceptos y revisar o redactar fragmentos de código y documentación.
Los integrantes revisaron y probaron el resultado, y son responsables del
contenido final. Si la universidad pide declarar el uso de IA de otra forma,
ajuste esta sección.

## Textos de licencia

- BSD 2-Clause y BSD 3-Clause: https://opensource.org/licenses/BSD-3-Clause
- MIT: https://opensource.org/licenses/MIT
- Apache 2.0: https://www.apache.org/licenses/LICENSE-2.0
