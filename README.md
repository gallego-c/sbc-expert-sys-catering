# Sistema de Menús - Catering Expert System

Sistema experto basado en CLIPS para la generación de menús de catering personalizados según preferencias dietéticas, temporada y tipo de evento.

## 📁 Estructura del Proyecto

```
expert-sys-catering/
├── load-all.bat               # Archivo batch para cargar todo el sistema
├── main.clp                   # Punto de entrada alternativo
├── config/
│   └── globals.clp           # Constantes globales del sistema
├── core/
│   ├── templates.clp         # Definiciones de templates
│   └── functions.clp         # Funciones auxiliares
├── knowledge/
│   ├── dishes.clp            # Base de datos de platos
│   ├── beverages.clp         # Base de datos de bebidas
│   └── initial-facts.clp     # Hechos iniciales
└── rules/
    ├── 01-input-rules.clp    # Reglas de entrada de usuario
    ├── 02-filter-rules.clp   # Reglas de filtrado
    ├── 03-recommendation-rules.clp  # Reglas de recomendación
    └── 04-finish-rules.clp   # Reglas de finalización
```

## 🚀 Cómo Ejecutar

### Método 1: Usando batch file (Recomendado)

1. Abre CLIPS en el directorio `expert-sys-catering`
2. Ejecuta:
   ```clips
   CLIPS> (batch "load-all.bat")
   CLIPS> (assert (start))
   CLIPS> (run)
   ```

### Método 2: Usando la función chat()

1. Abre CLIPS en el directorio `expert-sys-catering`
2. Ejecuta:
   ```clips
   CLIPS> (batch "load-all.bat")
   CLIPS> (chat)
   ```

### Método 3: Carga manual

```clips
CLIPS> (load "config/globals.clp")
CLIPS> (load "core/templates.clp")
CLIPS> (load "core/functions.clp")
CLIPS> (load "knowledge/dishes.clp")
CLIPS> (load "knowledge/beverages.clp")
CLIPS> (load "knowledge/initial-facts.clp")
CLIPS> (load "rules/01-input-rules.clp")
CLIPS> (load "rules/02-filter-rules.clp")
CLIPS> (load "rules/03-recommendation-rules.clp")
CLIPS> (load "rules/04-finish-rules.clp")
CLIPS> (reset)
CLIPS> (assert (start))
CLIPS> (run)
```

## 📋 Descripción de Módulos

### config/globals.clp
Configuración global del sistema y constantes.

### core/templates.clp
Define las estructuras de datos:
- `dish`: Representa un plato (curso, ingredientes, dietas, precio)
- `beverage`: Representa una bebida (tipo, subtipo, precio)
- `user-profile`: Perfil del usuario (temporada, evento, dietas, preferencias)

### core/functions.clp
Funciones auxiliares:
- `ask$`: Hace preguntas con opciones validadas
- `askline`: Lee una línea de texto
- `parse-list`: Parsea listas separadas por comas
- `get-dishes-by-course`: Obtiene platos por curso y dietas
- `chat`: Función de conveniencia para iniciar el sistema

### knowledge/dishes.clp
Base de datos de platos organizados por:
- Primeros platos (13 opciones)
- Segundos platos (18 opciones)
- Postres (14 opciones)

Cada plato tiene:
- ID único
- Curso (primero/segundo/postre)
- Ingredientes
- Dietas compatibles (vegetariana, vegana, sin_gluten, sin_lactosa)
- Precio

### knowledge/beverages.clp
Base de datos de bebidas:
- Bebidas no alcohólicas (5 opciones)
- Cervezas (3 opciones)
- Vinos (5 opciones)

### knowledge/initial-facts.clp
Hechos iniciales del sistema (perfil de usuario por defecto).

### rules/01-input-rules.clp
Entrevista al usuario para recopilar:
- Temporada (invierno/primavera/verano/otoño/any)
- Evento (boda/congreso/reunion/any)
- Tipo de bebida (alcohólica/no_alcohólica)
- Subtipo de bebida (cerveza/vino o agua/refresco)
- Restricciones dietéticas

### rules/02-filter-rules.clp
Filtra y muestra platos y bebidas compatibles con las preferencias del usuario.

### rules/03-recommendation-rules.clp
Genera 6 menús completos combinando:
- Primero + Segundo + Postre + Bebida
- Calcula el precio total de cada menú

### rules/04-finish-rules.clp
Finaliza la ejecución del sistema.

## 🍽️ Características

- **45 platos diferentes** organizados por curso
- **13 bebidas** (alcohólicas y no alcohólicas)
- **Filtrado por dietas**: vegetariana, vegana, sin gluten, sin lactosa
- **Personalización por evento**: bodas, congresos, reuniones
- **Generación automática de menús completos**
- **Cálculo de precios totales**

## 📝 Ejemplo de Uso

```
== CONFIGURACION DE PERFIL ==
Temporada? invierno primavera verano otono any
> verano
Evento? boda congreso reunion any
> boda
Tipo de bebida? (alcoholica/no_alcoholica) alcoholica no_alcoholica
> alcoholica
Especifica bebida? (cerveza/vino) cerveza vino
> vino
Dietas (vegana,vegetariana,sin_gluten,sin_lactosa) o vacio:
> vegetariana

== RESUMEN DE CONFIGURACION ==
Temporada: verano
Evento: boda
Bebida: alcoholica - vino
Dietas: vegetariana

=== PLATOS COMPATIBLES ===
[Lista de platos filtrados]

=== BEBIDAS COMPATIBLES ===
[Lista de bebidas]

--- 6 MENUS SUGERIDOS ---
Menu 1:
  Primero: ensalada_mixta
  Segundo: lasana_vegetal
  Postre: fruta_fresca
  Bebida: vino_blanco_joven
  TOTAL: 20.50 EUR
...
```

## 🔧 Personalización

### Añadir nuevos platos
Edita `knowledge/dishes.clp` y añade:
```clips
(dish (id "nombre_plato") (course primero|segundo|postre) 
      (ingredients ...) (diets ...) (price X.XX))
```

### Añadir nuevas bebidas
Edita `knowledge/beverages.clp` y añade:
```clips
(beverage (id "nombre_bebida") (type alcoholica|no_alcoholica) 
          (subtype ...) (price X.XX))
```

### Modificar número de menús generados
Edita `config/globals.clp`:
```clips
(defglobal ?*MAX-MENUS* = 10)  ; Cambiar el número
```

## 📄 Licencia

Proyecto educativo para sistemas expertos.
