# Sistema de Menús - Catering Expert System (COOL Version)

Sistema experto basado en CLIPS usando COOL (CLIPS Object-Oriented Language) para la generación de menús de catering personalizados según preferencias dietéticas y bebidas.

## 📁 Estructura del Proyecto

```
expert-sys-catering/
├── load-all-final.bat         # Archivo batch para cargar y ejecutar todo el sistema
├── main.clp                   # Punto de entrada alternativo (solo carga)
├── config/
│   └── globals.clp           # Variables globales del sistema
├── core/
│   ├── templates.clp         # Definiciones de clases (COOL defclass)
│   └── functions.clp         # Funciones auxiliares
├── knowledge/
│   ├── ingredients.clp       # Categorización de ingredientes (88 instancias)
│   ├── dishes.clp            # Base de datos de platos (40 instancias)
│   ├── beverages.clp         # Base de datos de bebidas (13 instancias)
│   └── data-loader.clp       # Orquestador de carga de datos
├── base/
│   └── dishes_data.clp       # (Archivo auxiliar - no usado actualmente)
└── rules/
    ├── 01-input-rules.clp    # 5 módulos de entrada (ENTRADA, PERFIL_*)
    ├── 02-filter-rules.clp   # Filtrado por dietas (RECOMENDACION_FILTRADO)
    ├── 03-recommendation-rules.clp  # Generación de menús (RECOMENDACION_MENUS)
    └── 04-finish-rules.clp   # Finalización (SALIDA)
```

## 🏗️ Arquitectura COOL

### Módulos del Sistema
El sistema usa `defmodule` y `focus` para controlar el flujo de ejecución:

1. **MAIN** - Módulo principal, exporta todas las clases y funciones
2. **ENTRADA** - Inicializa el sistema y muestra bienvenida
3. **PERFIL_DATOS** - Captura datos básicos (nombre, comensales, presupuesto)
4. **PERFIL_RESTRICCIONES** - Captura restricciones dietéticas
5. **PERFIL_BEBIDAS** - Configura preferencias de bebidas
6. **PERFIL_VALIDACION** - Valida perfil completo antes de recomendar
7. **RECOMENDACION_FILTRADO** - Filtra platos según restricciones
8. **RECOMENDACION_MENUS** - Genera menús completos
9. **SALIDA** - Finaliza el sistema

### Clases Principales (defclass)

- **user-profile**: Perfil del usuario con dietas y preferencias de bebida
- **dish**: Plato con curso, ingredientes, dietas compatibles, precio
- **ingredient-category**: Categorización de ingredientes por tipo
- **beverage**: Bebida con tipo (alcoholica/no_alcoholica) y subtipo
- **plato-valido**: Plato que pasó el filtro de dietas
- **filtrado-completado**: Marca el fin del filtrado
- **menu-shown**: Marca que los menús fueron mostrados
- **start**: Dispara el inicio del sistema
- **datos-basicos-capturados**: Datos básicos capturados
- **dietas-capturadas**: Dietas capturadas
- **bebidas-configuradas**: Bebidas configuradas

## 🚀 Cómo Ejecutar

### Método 1: Usando batch file (Recomendado)

1. Abre CLIPS en el directorio `expert-sys-catering`
2. Ejecuta:
   ```clips
   CLIPS> (batch "load-all-final.bat")
   ```
   
   El batch file automáticamente:
   - Carga todos los módulos
   - Inicializa el sistema con (reset)
   - Carga los datos con (cargar-datos-sistema)
   - Crea la instancia start
   - Establece el foco en ENTRADA
   - Ejecuta el sistema con (run)

### Método 2: Carga manual

```clips
CLIPS> (load "main.clp")
CLIPS> (reset)
CLIPS> (cargar-datos-sistema)
CLIPS> (make-instance start-inst of MAIN::start)
CLIPS> (focus ENTRADA)
CLIPS> (run)
```

## 📋 Descripción de Módulos

### config/globals.clp
Variables globales del sistema:
- `?*SYSTEM-NAME*`: Nombre del sistema
- `?*VERSION*`: Versión
- `?*MAX-MENUS*`: Número máximo de menús a generar

### core/templates.clp
Define 10 clases usando `defclass`:
- Clases de datos: `user-profile`, `dish`, `ingredient-category`, `beverage`
- Clases de control: `plato-valido`, `filtrado-completado`, `menu-shown`
- Clases de estado: `start`, `datos-basicos-capturados`, `dietas-capturadas`, `bebidas-configuradas`

### core/functions.clp
Funciones auxiliares en el módulo MAIN:
- `ask`: Hace preguntas con opciones validadas
- `askline`: Lee una línea de texto del usuario
- `parse-list`: Parsea listas separadas por comas
- `es-plato-valido`: Valida si un plato cumple con las dietas del usuario
- `chat`: Mensaje de bienvenida del sistema

### knowledge/ingredients.clp
Función `cargar-ingredientes` que crea 88 instancias de `ingredient-category`:
- Categorías: meat, fish, seafood, dairy, egg, gluten, nuts, soy, vegetable, fruit
- Ejemplos: pollo→meat, salmon→fish, queso→dairy, trigo→gluten

### knowledge/dishes.clp
Función `cargar-platos` que crea 40 instancias de `dish`:
- Cursos: appetizer (entrantes), main (principales), dessert (postres)
- Dietas: vegan, vegetarian, lactose_free, gluten_free, egg_free, seafood_free, nut_free
- Cada plato tiene precio y lista de ingredientes
### knowledge/beverages.clp
Función `cargar-bebidas` que crea 13 instancias de `beverage`:
- Tipos: alcoholica (cervezas, vinos), no_alcoholica (aguas, refrescos)
- Cada bebida tiene precio

### knowledge/data-loader.clp
Función `cargar-datos-sistema` que orquesta la carga:
- Llama a `cargar-ingredientes`
- Llama a `cargar-platos`
- Llama a `cargar-bebidas`
- Muestra confirmación de carga

### rules/01-input-rules.clp
5 módulos de entrada que recopilan información del usuario:

1. **ENTRADA::iniciar-sistema** - Muestra bienvenida y captura nombre
2. **PERFIL_DATOS::capturar-datos-basicos** - Captura comensales y presupuesto
3. **PERFIL_RESTRICCIONES::capturar-dietas** - Captura restricciones dietéticas
4. **PERFIL_BEBIDAS::configurar-bebidas** - Configura preferencias de bebidas
5. **PERFIL_VALIDACION::validar-perfil-completo** - Valida y muestra resumen

### rules/02-filter-rules.clp
**RECOMENDACION_FILTRADO::filtrar-por-dietas** - Filtra platos:
- Itera sobre todos los platos cargados
- Valida cada plato con `es-plato-valido`
- Crea instancias de `plato-valido` para platos compatibles
- Muestra estadísticas de filtrado
- Cambia foco a RECOMENDACION_MENUS

### rules/03-recommendation-rules.clp
**RECOMENDACION_MENUS::generar-menus-basicos** - Genera menús:
- Busca platos válidos por curso usando `find-all-instances`
- Combina appetizer + main + dessert + bevida
- Calcula precio total de cada menú
- Genera hasta 3 menús completos
- Cambia foco a SALIDA

### rules/04-finish-rules.clp
**SALIDA::mostrar-fin** - Finaliza el sistema con mensaje de despedida

## 🍽️ Características

- **40 platos diferentes** organizados por curso (appetizer, main, dessert)
- **13 bebidas** (alcohólicas: cervezas y vinos; no alcohólicas: aguas y refrescos)
- **88 ingredientes categorizados** para validación precisa
- **7 tipos de dietas**: vegan, vegetarian, lactose_free, gluten_free, egg_free, seafood_free, nut_free
- **Arquitectura modular con COOL**: Usa programación orientada a objetos
- **Sistema de módulos**: Control de flujo con `focus` y `defmodule`
- **Generación de hasta 3 menús completos** con cálculo de precios
- **Validación inteligente**: Revisa ingredientes contra categorías dietéticas

## 📝 Ejemplo de Uso

```
========================================
   SISTEMA DE RECOMENDACION DE MENUS
========================================
¡Bienvenido!
Nombre del cliente: > Juan Perez

== DATOS BASICOS ==
Numero de comensales: > 50
Presupuesto total (€): > 1500

== RESTRICCIONES DIETETICAS ==
Restricciones dieteticas separadas por comas
(vegan, vegetarian, lactose_free, gluten_free, egg_free, seafood_free, nut_free)
o presiona Enter si no hay restricciones:
> vegetarian,lactose_free

== CONFIGURACION DE BEBIDAS ==
Tipo de bebida (alcoholica/no_alcoholica): > alcoholica
Subtipo (cerveza/vino): > vino

== RESUMEN DEL PERFIL ==
Cliente: Juan Perez
Comensales: 50
Presupuesto: 1500.0€
Dietas: vegetarian lactose_free
Bebida: alcoholica - vino

== FILTRADO DE PLATOS ==
Total de platos en sistema: 40
Platos compatibles: 15
Platos descartados: 25

== MENÚS SUGERIDOS ==
Bebida seleccionada: vino_tinto_joven - Precio: 12.0€

MENÚ 1:
Entrante: ensalada_cesar - 8.5€
Principal: lasana_vegetal - 13.0€
Postre: tarta_chocolate - 6.0€
Bebida: vino_tinto_joven - 12.0€
PRECIO TOTAL: 39.5€

MENÚ 2:
Entrante: crema_calabaza - 7.0€
Principal: paella_verduras - 14.5€
Postre: flan_caramelo - 5.0€
Bebida: vino_tinto_joven - 12.0€
PRECIO TOTAL: 38.5€

MENÚ 3:
Entrante: gazpacho - 6.5€
Principal: risotto_setas - 12.5€
Postre: mousse_chocolate - 6.5€
Bebida: vino_tinto_joven - 12.0€
PRECIO TOTAL: 37.5€

========================================
   Gracias por usar el sistema de
   recomendación de menús
========================================
¡Que aproveche!
```

## 🔧 Personalización

### Añadir nuevos platos
Edita `knowledge/dishes.clp` y añade en la función `cargar-platos`:
```clips
(make-instance of MAIN::dish 
  (id "nombre_plato") 
  (course appetizer)  ; o main, dessert
  (ingredients pollo tomate cebolla)
  (diets vegetarian lactose_free)
  (price 10.50))
```
```

### Añadir nuevas bebidas
Edita `knowledge/beverages.clp` y añade en la función `cargar-bebidas`:
```clips
(make-instance of MAIN::beverage 
  (id "nombre_bebida") 
  (type alcoholica)  ; o no_alcoholica
  (subtype vino)     ; cerveza, vino, agua, refresco
  (price 8.50))
```

### Añadir nuevos ingredientes
Edita `knowledge/ingredients.clp` y añade en la función `cargar-ingredientes`:
```clips
(make-instance of MAIN::ingredient-category 
  (ingredient "nuevo_ingrediente") 
  (category meat))  ; meat, fish, seafood, dairy, egg, gluten, nuts, soy, vegetable, fruit
```

### Modificar número de menús generados
Edita `rules/03-recommendation-rules.clp` en la regla `generar-menus-basicos`:
```clips
(bind ?max-menus 5)  ; Cambiar de 3 a cualquier número
```

## 🔍 Debugging y Desarrollo

### Ver instancias creadas
```clips
CLIPS> (instances)
```

### Ver reglas de un módulo
```clips
CLIPS> (list-defrules ENTRADA)
CLIPS> (list-defrules RECOMENDACION_FILTRADO)
```

### Ver agenda de reglas
```clips
CLIPS> (agenda)
```

### Ver valores de variables globales
```clips
CLIPS> ?*SYSTEM-NAME*
CLIPS> ?*VERSION*
```

### Reiniciar el sistema
```clips
CLIPS> (clear)
CLIPS> (batch "load-all-final.bat")
```

## 🏛️ Diferencias con versión Template

Esta versión usa **COOL (CLIPS Object-Oriented Language)** en lugar de templates:

| Template Version | COOL Version |
|-----------------|--------------|
| `deftemplate` | `defclass` |
| `assert` | `make-instance` |
| `retract` | `send delete` |
| `modify` | `send put-` |
| `?fact` | `?instance` |
| Coincidencia de hechos | Coincidencia de objetos |
| `(fact-slot-value)` | `(send ?obj get-slot)` |

**Ventajas de COOL:**
- Herencia de clases
- Métodos y encapsulación
- Mejor organización de datos complejos
- Más cercano a programación orientada a objetos

## 📄 Licencia

Proyecto educativo para sistemas expertos con CLIPS 6.4.
