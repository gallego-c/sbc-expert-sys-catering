# SBC-expert-sys-catering

![CLIPS](https://img.shields.io/badge/CLIPS-6.4-blue)
![Architecture](https://img.shields.io/badge/Architecture-COOL-purple)
![Topic](https://img.shields.io/badge/Topic-Expert_Systems-orange)
![Project](https://img.shields.io/badge/Project-Coursework-lightgrey)

A CLIPS expert system for generating personalized catering menus using COOL (CLIPS Object-Oriented Language).

The system collects a customer profile—including guest count, total budget, dietary restrictions, and beverage preferences—then validates the profile, filters dishes, and generates up to three complete menus with price calculations. Its architecture combines object-based knowledge representation with a modular rule-based execution flow.

## Features

- **Dish knowledge base:** 40 dishes organized into starters, main courses, and desserts.
- **Beverage selection:** 13 beverages, including beer, wine, water, and soft drinks.
- **Ingredient classification:** 88 categorized ingredients used to cross-check dietary compatibility.
- **Dietary filtering:** Seven supported dietary restrictions.
- **Menu generation:** Up to three complete menu suggestions with calculated prices.
- **Modular design:** COOL classes represent system data, while CLIPS modules and rules control each processing stage.

## Getting started

### Prerequisite

The project is documented for **CLIPS 6.4** and uses COOL. Open CLIPS with the repository root (`SBC-expert-sys-catering/`) as its working directory so that relative file paths resolve correctly.

### Run the complete system

Enter the following command at the CLIPS prompt:

```clips
(batch "load-all-final.bat")
```

`load-all-final.bat` is a CLIPS batch file. It loads the modules, calls `(reset)`, loads the knowledge base through `(cargar-datos-sistema)`, creates the startup instance, sets focus to `ENTRADA`, and calls `(run)`.

### Load and start manually

Alternatively, enter these commands in order at the CLIPS prompt:

```clips
(load "main.clp")
(reset)
(cargar-datos-sistema)
(make-instance start-inst of MAIN::start)
(focus ENTRADA)
(run)
```

`main.clp` is the load-only entry point; the remaining commands initialize the data and start rule execution.

## Usage example

During a session, the system asks for customer details, dietary restrictions, and beverage preferences. The following illustrates the inputs shown in the original documentation; it is not a verified execution transcript:

```text
Nombre del cliente: > Juan Perez
Numero de comensales: > 50
Presupuesto total (EUR): > 1500
Restricciones: > vegetarian,lactose_free
Tipo de bebida: > alcoholica
Subtipo: > vino
```

After profile validation and dish filtering, the system generates menu suggestions with starter, main course, dessert, beverage, and price information. The original documentation does not establish whether the displayed menu total is per guest or for the whole event, or how the total budget constrains menu selection.

## Project structure

```text
SBC-expert-sys-catering/
├── load-all-final.bat             # Load, initialize, and run the system
├── main.clp                       # Load-only entry point
├── config/
│   └── globals.clp                # System-wide configuration
├── core/
│   ├── templates.clp              # COOL class definitions (defclass)
│   └── functions.clp              # Auxiliary functions
├── knowledge/
│   ├── ingredients.clp            # 88 ingredient-category instances
│   ├── dishes.clp                 # 40 dish instances
│   ├── beverages.clp              # 13 beverage instances
│   └── data-loader.clp            # Knowledge-base loading orchestration
└── rules/
    ├── 01-input-rules.clp          # Startup and customer-profile modules
    ├── 02-filter-rules.clp         # Dietary filtering
    ├── 03-recommendation-rules.clp # Menu generation
    └── 04-finish-rules.clp         # Finalization
```

## Architecture

### Execution flow

The system uses `defmodule` to organize rules and `focus` to control execution. `MAIN` exports the shared classes and functions used by the processing modules.

| Stage | Module | Responsibility |
| --- | --- | --- |
| 1 | `ENTRADA` | Initialize the session and display the welcome message. |
| 2 | `PERFIL_DATOS` | Collect the customer name, guest count, and budget. |
| 3 | `PERFIL_RESTRICCIONES` | Collect dietary restrictions. |
| 4 | `PERFIL_BEBIDAS` | Collect beverage preferences. |
| 5 | `PERFIL_VALIDACION` | Validate the completed profile before recommendation. |
| 6 | `RECOMENDACION_FILTRADO` | Filter dishes according to dietary restrictions. |
| 7 | `RECOMENDACION_MENUS` | Generate complete menus. |
| 8 | `SALIDA` | Finalize the session. |

### Object model

The classes are defined with COOL's `defclass` construct in `core/templates.clp`.

| Class | Purpose |
| --- | --- |
| `user-profile` | Store customer data and dietary and beverage preferences. |
| `dish` | Represent a dish, including course, ingredients, compatible diets, and price. |
| `ingredient-category` | Classify ingredients by type. |
| `beverage` | Represent a beverage with a type and subtype. |
| `plato-valido` | Represent a dish that passed dietary filtering. |
| `filtrado-completado` | Mark completion of the filtering stage. |
| `menu-shown` | Mark that menus have been displayed. |
| `start` | Trigger system startup. |

### COOL and template-based representation

This version represents data as objects. For readers familiar with template-based CLIPS systems, the main conceptual correspondences are:

| Template-based approach | COOL approach |
| --- | --- |
| Define a fact structure with `deftemplate` | Define a class with `defclass` |
| Create a fact with `assert` | Create an object with `make-instance` |
| Match facts in rules | Match objects in rules |
| Remove a fact with `retract` | Delete an instance through a `delete` message |
| Update fact slots with `modify` | Update instance slots through `put-<slot>` messages |

## Knowledge base

`knowledge/data-loader.clp` coordinates data loading through `cargar-datos-sistema`.

| File | Loader function | Contents |
| --- | --- | --- |
| `knowledge/dishes.clp` | `cargar-platos` | 40 `dish` instances |
| `knowledge/beverages.clp` | `cargar-bebidas` | 13 `beverage` instances |
| `knowledge/ingredients.clp` | `cargar-ingredientes` | 88 `ingredient-category` instances |

### Courses and dietary restrictions

Dishes use the course identifiers `appetizer`, `main`, and `dessert`.

| Dietary restriction | Identifier |
| --- | --- |
| Vegan | `vegan` |
| Vegetarian | `vegetarian` |
| Lactose-free | `lactose_free` |
| Gluten-free | `gluten_free` |
| Egg-free | `egg_free` |
| Seafood-free | `seafood_free` |
| Nut-free | `nut_free` |

Ingredient categories are `meat`, `fish`, `seafood`, `dairy`, `egg`, `gluten`, `nuts`, `soy`, `vegetable`, and `fruit`. These categories support cross-checking ingredients against dietary restrictions.

### Beverage categories

| Type | Meaning | Subtypes |
| --- | --- | --- |
| `alcoholica` | Alcoholic | `cerveza`, `vino` |
| `no_alcoholica` | Non-alcoholic | `agua`, `refresco` |

## Customization

### System settings

Edit `config/globals.clp` to configure the documented global variables:

| Variable | Purpose |
| --- | --- |
| `?*SYSTEM-NAME*` | System display name |
| `?*VERSION*` | System version |
| `?*MAX-MENUS*` | Maximum number of menus to generate |

### Add a dish

Add a `dish` instance inside the `cargar-platos` function in `knowledge/dishes.clp`. This illustrative definition uses the structure documented by the project:

```clips
(make-instance of MAIN::dish
  (id "ensalada_tomate_cebolla")
  (course appetizer)
  (ingredients tomate cebolla)
  (diets vegetarian lactose_free)
  (price 10.50))
```

Choose `appetizer`, `main`, or `dessert` for the course. Ensure that the declared dietary compatibility agrees with every ingredient and that the ingredients are categorized consistently in `knowledge/ingredients.clp`.

### Add a beverage

Add a `beverage` instance inside the `cargar-bebidas` function in `knowledge/beverages.clp`:

```clips
(make-instance of MAIN::beverage
  (id "nombre_bebida")
  (type alcoholica)
  (subtype vino)
  (price 8.50))
```

Use a type and subtype from the beverage categories above. After changing configuration or knowledge-base files, reload and initialize the system to apply the changes.

## Debugging

Run these commands at the CLIPS prompt to inspect the loaded system:

```clips
; Inspect current instances.
(instances)

; List rules in the startup module.
(list-defrules ENTRADA)

; Inspect the current rule agenda.
(agenda)
```

To clear the loaded environment and start a fresh session:

```clips
(clear)
(batch "load-all-final.bat")
```

`(clear)` removes the loaded environment; it does not reload the project. The following batch command performs loading, initialization, and execution again. Run it from the repository root.

## License

The project is described as an educational expert-system project using CLIPS 6.4. The supplied documentation does not specify a license. Educational purpose alone does not establish permission to use, modify, or redistribute the code; consult the repository owner for licensing terms.
