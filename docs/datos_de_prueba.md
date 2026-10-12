# Datos de prueba

Todos los datos son **ficticios**. La app arranca con el inventario vacío:
ingrese estos productos desde el botón **AGREGAR PRODUCTO**.

Regla aplicada: precio de venta = costo × 1.20. Umbral de alerta:
stock ≤ 5 (`AppConstants.stockBajo`).

## Productos de ejemplo

| # | Nombre | Categoría | Costo (C$) | Stock | Precio de venta esperado (C$) | Alerta esperada |
|---|---|---|---|---|---|---|
| 1 | Arroz 1lb | Granos básicos | 18.50 | 25 | 22.20 | Ninguna |
| 2 | Aceite 500ml | Abarrotes | 50.00 | 10 | 60.00 | Ninguna |
| 3 | Jabon para lavar platos | Limpieza e higiene | 15.00 | 50 | 18.00 | Ninguna |
| 4 | Frijoles rojos 1lb | Granos básicos | 24.00 | 4 | 28.80 | POCO STOCK |
| 5 | Azúcar 1lb | Abarrotes | 16.00 | 0 | 19.20 | AGOTADO |
| 6 | Detergente en polvo 500g | Limpieza e higiene | 32.50 | 5 | 39.00 | POCO STOCK (límite exacto) |
| 7 | Sal 1lb | Abarrotes | 8.00 | 6 | 9.60 | Ninguna (justo sobre el umbral) |
| 8 | Pasta dental 100g | Limpieza e higiene | 28.00 | 18 | 33.60 | Ninguna |

Los productos 4, 5 y 6 sirven para comprobar la alerta; el 7 comprueba que no
se activa con 6 unidades.

> Las categorías deben existir en `AppConstants.categorias`. Si alguna no
> aparece en el menú desplegable, use una de las que sí aparezcan o agréguela
> en ese archivo.

## Casos de entrada inválida

| Campo | Valor | Resultado esperado |
|---|---|---|
| Nombre | (vacío) | "Escriba el nombre del producto" |
| Costo | (vacío) o letras | "Escriba el costo con números" (el teclado solo admite dígitos, punto y coma) |
| Costo | 0 | "El costo debe ser mayor que cero" |
| Categoría | sin elegir | "Escoja una categoría" |
| Cantidad | (vacía) | "Escriba la cantidad con números" |
| Costo | 12,50 (con coma) | Se acepta y se interpreta como 12.50 |

## Cambios para probar edición y eliminación

| Acción | Dato | Resultado esperado |
|---|---|---|
| Editar costo | Aceite 500ml: 50 → 55 | Precio de venta pasa de 60.00 a 66.00 |
| Editar stock | Arroz 1lb: 25 → 3 | Aparece la alerta "POCO STOCK" |
| Editar stock | Frijoles rojos 1lb: 4 → 20 | Desaparece la alerta |
| Eliminar | Cualquier producto, botón CANCELAR | No se borra |
| Eliminar | Cualquier producto, botón ELIMINAR | Desaparece y se muestra "Producto eliminado" |
| Persistencia | Cerrar y reabrir la app | Los datos siguen ahí |
