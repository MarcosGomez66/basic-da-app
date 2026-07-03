# Basic DataAnalysis app

## Propósito del proyecto

Aplicación móvil desarrollada en Fluter para la gestión de pequeños negocios, que ofrece una forma
simple de visualización de datos.

## Características principales

- Crear uno o varios negocios para registrar los datos de forma independiente entre sí.
- Registrar productos agrupados en lotes desde un borrador.
- Iniciar y finalizar jornadas de ventas.
- Resistrar ventas de uno o varios productos, solo si existe una jornada abierta.
- Pantalla de resumen o inicio que muestra tres bloques; Estado de la jornada, total vendido de la
  jornada actual o última jornada en caso de no tener una abierta, y alertas de bajo stock de
  productos según su cantidad mínima registrada.

## Otras características

- Modificar nombre, grupo y stock minimo de un producto.
- Mermar productos.
- En formularios de registro, seleccionar productos o grupos ya registrados con un autocompletado.
- Visualizar lista de jornadas.
- Visualizar lista de lotes y filtrar entre activo o no.
- Visualizar lista de movimientos y filtrar entre ingreso(lote), venta o merma.

## Visualización de datos

- De cada jornada, un gráfico de líneas que muestre las horas en X y la cantidad de unidades
  vendidas en Y de cada producto vendido, un gráfico circular que muestre la cantidad de dinero
  ingresado de cada producto o grupo según el total, un gráfico de barras que muestre la cantidad de
  dinero ingresado con la diferencia de ganancia en el eje X y el producto o grupo en el eje Y.
- En la pantalla Dashboard, un gráfico de líneas que muestre las horas, días de la semana o mes
  según selección en el eje X y la cantidad de unidades vendidas de cada producto en el eje Y, un
  gráfico circular de los 10 productos o grupos más rentables del negocio, es decir, generaron más
  ganancia, un gráfico de barras con la cantidad de dinero ingresado con la diferencia de ganancia
  en el eje X y el producto o grupo en el eje Y, agrupados en semanas o meses según selección.
- De cada lote, mostrar un gráfico de progresión con el avance que registran las ganancias de los
  productos ya vendidos según el estimado total del lote, un gráfico que muestre la ganancia
  estimada con la diferencia que lleva vendiendo en el eje X y el producto en el eje Y.

## Tecnologías

- Flutter
- Dart
- Hive
- Provider
- Material Design 3
- fl_chart

## Detalles del proyecto

- Es un proyecto de portafolio, mantener siempre simple y fácil de entender.
- Diseño pensado para funcionar completamente offline.
- Mostrar siempre los formularios con showDialog/AlertDialog si es posible.
- Priorizar widget pequeños y reutilizables.
- Hive es la única base de datos.
- Estructurar los métodos providers también como services.
- Los modelos guardan su propia id como llave en Hive.
- Permitir autocompletar formularios con el widget Autocomplete en los campos de nombre y grupo.
- Solo puede existir una jornada abierta por negocio.
- Cada producto pertenece a un negocio y a un lote.

## Arquitectura

Se utiliza una arquitectura simple basada en:

lib/
  app/
  models/
  provider/
  screens/
  widgets/

## Modelos

### BusinessModel

- String id
- String name
- DateTime startTime

### WorkdayModel

- String id
- String businessId
- bool isOpen
- DateTime startTime
- DateTime endTime

### LotModel

- String id
- String businessId
- double totalPrice
- double totalCost
- double totalArticles
- bool isActive
- DateTime uploadedAt
- DateTime endedAt

### ProductModel

- String id
- String businessId
- String lotId
- String name
- String group
- double stock
- double minStock
- double price
- CostType costType
- double cost
- bool isActive
- DateTime uploadedAt
- DateTime endedAt

### SaleModel

- String id
- String businessId
- String workdayId
- List<ItemModel> items
- double totalSold
- DateTime soldAt

### WasteModel

- String id
- String businessId
- List<ItemModel> items
- double totalWaste
- DateTime wastedAt

### ItemModel

- String productId
- String lotId
- double amount
- double unityPrice

### ProductDraftModel

- String name
- String group
- double stock
- double minStock
- double price
- CostType costType
- double cost

## Buenas prácticas

- Evitar lógica de negocio en build().
- No ejecutar operaciones pesadas en build().
- Utilizar dispose() para liberar controladores.
- Mantener widgets Stateless cuando sea posible.
- Preferir const constructors.
- Utilizar late únicamente cuando sea necesario.
- Manejar errores de Hive mediante try/catch.

## Reglas para IA

Cuando se solicite código:

- respetar la arquitectura existente.
- no introducir nuevas dependencias sin justificarlo.
- priorizar soluciones sencillas.
- reutilizar widgets existentes.
- mantener compatibilidad con Hive.
- evitar romper adapters ya desplegados.
- comentar únicamente código complejo.

Cuando se propongan cambios:

- explicar ventajas.
- explicar posibles impactos sobre datos persistidos.
- indicar si requiere migración de Hive.

## Objetivo del proyecto

Construir una aplicación ligera, offline-first, mantenible y fácil de extender, enfocada en pequeños
comercios y emprendimientos.