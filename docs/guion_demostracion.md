# Guion de demostración 

## Preparación (antes de empezar)

1. Emulador encendido y app instalada con la base de datos **limpia** (ver
   "Reiniciar con datos limpios" en el README).
2. Tener abierto `docs/datos_de_prueba.md` para copiar los valores.
3. Ejecutar `flutter run -d emulator-5554` y comprobar que abre la lista vacía.
4. Si hay conexión, probar también con el modo avión activado para mostrar que
   la app funciona sin Internet.

## Recorrido

| Min | Qué se muestra | Qué se dice |
|---|---|---|
| 0:00 – 1:00 | Contexto | Negocio de más de 20 años que lleva el inventario en papel y de memoria; la dueña es una persona adulta mayor con poca experiencia digital. Problema: desabastecimiento imprevisto y precios sin cálculo claro. |
| 1:00 – 2:00 | Pantalla vacía | Interfaz grande y simple. Mensaje guía: "Toque el botón verde para agregar el primero". |
| 2:00 – 4:00 | Agregar 3 productos (n.º 1, 2 y 4 de la tabla de datos) | **Dato** → costo y cantidad. La vista previa muestra el **precio de venta** al escribir (regla costo × 1.20). Mostrar un error de validación (costo 0). |
| 4:00 – 5:00 | Lista con tarjetas | **Información**: costo, ganancia y precio de venta ya calculados. |
| 5:00 – 6:00 | Alerta de stock bajo | **Decisión**: el producto con 4 unidades aparece resaltado con "¡POCO STOCK! Quedan 4". Explicar el umbral (5) y su límite: no considera cuánto se vende por día. |
| 6:00 – 7:00 | Buscador | Escribir "ace" y "limpieza"; mostrar que ignora tildes y mayúsculas y que hay mensaje cuando no hay resultados. |
| 7:00 – 8:00 | Editar | **Acción**: subir el stock del producto en alerta de 4 a 20; la alerta desaparece (**retroalimentación**). Cambiar un costo y ver el nuevo precio. |
| 8:00 – 9:00 | Eliminar | Tocar la papelera, mostrar la confirmación, probar CANCELAR y luego ELIMINAR. |
| 9:00 – 10:00 | Persistencia y cierre | Cerrar la app por completo y reabrir: los datos siguen. Resumir qué cambió: de papel y memoria a un registro con precios calculados y alertas. |

## Preguntas probables (preparar respuestas)

- **¿Por qué móvil y Flutter?** Funciona sin Internet, un solo código para
  futuras plataformas, control total del tamaño de botones y texto.
- **¿Dónde se guardan los datos?** En SQLite dentro del teléfono.
- **¿Qué falta para producción?** Roles, trazabilidad, respaldo de datos,
  ventas y proveedores, pruebas automatizadas (ver "Estado actual y
  limitaciones" del README).
- **¿Cuándo puede equivocarse la alerta?** Con productos de mucha rotación,
  5 unidades pueden no alcanzar; con productos lentos, pueden ser demasiadas.
- **¿Se midieron mejoras?** Solo presentar indicadores que se hayan medido de
  verdad (tiempos, registros incompletos, etc.); no afirmar mejoras sin datos.

## Si algo falla durante la demo

- La app no abre: `flutter run -d emulator-5554` otra vez; si Gradle falla por
  el NDK, revisar el apartado de requisitos.
- Cambios que no se ven: detener con `q` y volver a ejecutar (el hot reload no
  siempre toma todo).
- Llevar un video corto de respaldo del recorrido completo.
