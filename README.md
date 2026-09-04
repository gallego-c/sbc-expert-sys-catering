# Sistema de Menus - Catering Expert System (COOL Version)

Expert system built with CLIPS using COOL (CLIPS Object-Oriented Language) for generating personalized catering menus based on dietary preferences and beverage choices.

---

## Project Structure

```
SBC-expert-sys-catering/
├── load-all-final.bat         # Batch file to load and run the full system
├── main.clp                   # Alternative entry point (load only)
├── config/
│   └── globals.clp            # System global variables
├── core/
│   ├── templates.clp          # Class definitions (COOL defclass)
│   └── functions.clp          # Auxiliary functions
├── knowledge/
│   ├── ingredients.clp        # Ingredient categorization (88 instances)
│   ├── dishes.clp             # Dish database (40 instances)
│   ├── beverages.clp          # Beverage database (13 instances)
│   └── data-loader.clp        # Data loading orchestrator
└── rules/
    ├── 01-input-rules.clp     # 5 input modules (ENTRADA, PERFIL_*)
    ├── 02-filter-rules.clp    # Diet-based filtering (RECOMENDACION_FILTRADO)
    ├── 03-recommendation-rules.clp  # Menu generation (RECOMENDACION_MENUS)
    └── 04-finish-rules.clp    # Finalization (SALIDA)
```

---

## COOL Architecture

### System Modules
The system uses `defmodule` and `focus` to control execution flow:

1. **MAIN** - Main module, exports all classes and functions
2. **ENTRADA** - Initializes the system and displays welcome message
3. **PERFIL_DATOS** - Captures basic data (name, guests, budget)
4. **PERFIL_RESTRICCIONES** - Captures dietary restrictions
5. **PERFIL_BEBIDAS** - Configures beverage preferences
6. **PERFIL_VALIDACION** - Validates complete profile before recommending
7. **RECOMENDACION_FILTRADO** - Filters dishes according to restrictions
8. **RECOMENDACION_MENUS** - Generates complete menus
9. **SALIDA** - Terminates the system

### Main Classes (defclass)

- **user-profile**: User profile with dietary and beverage preferences
- **dish**: Dish with course, ingredients, compatible diets, price
- **ingredient-category**: Ingredient categorization by type
- **beverage**: Drink with type (alcoholic/non-alcoholic) and subtype
- **plato-valido**: Dish that passed the diet filter
- **filtrado-completado**: Marks end of filtering phase
- **menu-shown**: Marks that menus were displayed
- **start**: Triggers system startup

---

## How to Run

### Method 1: Using the batch file (Recommended)

1. Open CLIPS in the `SBC-expert-sys-catering` directory.
2. Execute:
   ```clips
   CLIPS> (batch "load-all-final.bat")
   ```

   The batch file automatically:
   - Loads all modules
   - Initializes the system with `(reset)`
   - Loads data with `(cargar-datos-sistema)`
   - Creates the start instance
   - Sets focus to ENTRADA
   - Runs the system with `(run)`

### Method 2: Manual loading

```clips
CLIPS> (load "main.clp")
CLIPS> (reset)
CLIPS> (cargar-datos-sistema)
CLIPS> (make-instance start-inst of MAIN::start)
CLIPS> (focus ENTRADA)
CLIPS> (run)
```

---

## Module Descriptions

### config/globals.clp
System global variables:
- `?*SYSTEM-NAME*`: System name
- `?*VERSION*`: Version
- `?*MAX-MENUS*`: Maximum number of menus to generate

### knowledge/dishes.clp
`cargar-platos` function creating 40 `dish` instances:
- Courses: `appetizer` (starters), `main` (main courses), `dessert` (desserts)
- Diets: `vegan`, `vegetarian`, `lactose_free`, `gluten_free`, `egg_free`, `seafood_free`, `nut_free`

### knowledge/beverages.clp
`cargar-bebidas` function creating 13 `beverage` instances:
- Types: `alcoholica` (beers, wines), `no_alcoholica` (water, soft drinks)

### knowledge/ingredients.clp
`cargar-ingredientes` function creating 88 `ingredient-category` instances:
- Categories: `meat`, `fish`, `seafood`, `dairy`, `egg`, `gluten`, `nuts`, `soy`, `vegetable`, `fruit`

---

## Features

- **40 different dishes** organized by course (appetizer, main, dessert)
- **13 beverages** (alcoholic: beers and wines; non-alcoholic: water and soft drinks)
- **88 categorized ingredients** for precise diet validation
- **7 diet types**: vegan, vegetarian, lactose_free, gluten_free, egg_free, seafood_free, nut_free
- **Modular COOL architecture**: Object-oriented programming
- **Module system**: Execution flow with `focus` and `defmodule`
- **Up to 3 complete menus** with price calculation
- **Intelligent validation**: Cross-checks ingredients against dietary categories

---

## Usage Example

```
========================================
   SISTEMA DE RECOMENDACION DE MENUS
========================================
Nombre del cliente: > Juan Perez
Numero de comensales: > 50
Presupuesto total (EUR): > 1500
Restricciones: > vegetarian,lactose_free
Tipo de bebida: > alcoholica
Subtipo: > vino

== MENUS SUGERIDOS ==
MENU 1:
  Entrante: ensalada_cesar - 8.5 EUR
  Principal: lasana_vegetal - 13.0 EUR
  Postre: tarta_chocolate - 6.0 EUR
  Bebida: vino_tinto_joven - 12.0 EUR
  PRECIO TOTAL: 39.5 EUR
```

---

## Customization

### Adding new dishes
Edit `knowledge/dishes.clp` in the `cargar-platos` function:
```clips
(make-instance of MAIN::dish
  (id "nombre_plato")
  (course appetizer)  ; or main, dessert
  (ingredients pollo tomate cebolla)
  (diets vegetarian lactose_free)
  (price 10.50))
```

### Adding new beverages
Edit `knowledge/beverages.clp` in the `cargar-bebidas` function:
```clips
(make-instance of MAIN::beverage
  (id "nombre_bebida")
  (type alcoholica)  ; or no_alcoholica
  (subtype vino)     ; cerveza, vino, agua, refresco
  (price 8.50))
```

---

## COOL vs Template Version

| Template Version | COOL Version |
| :--- | :--- |
| `deftemplate` | `defclass` |
| `assert` | `make-instance` |
| `retract` | `send delete` |
| `modify` | `send put-` |
| `?fact` | `?instance` |
| Fact matching | Object matching |

---

## Debugging

```clips
CLIPS> (instances)                          ; View all instances
CLIPS> (list-defrules ENTRADA)              ; List rules in a module
CLIPS> (agenda)                             ; View rule agenda
CLIPS> (clear)                              ; Reset and reload
CLIPS> (batch "load-all-final.bat")
```

---

## License

Educational project for expert systems with CLIPS 6.4.
