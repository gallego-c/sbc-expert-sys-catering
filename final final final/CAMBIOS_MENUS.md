# Modificaciones al Sistema de Menús

## Resumen de Cambios

Se ha modificado el sistema de recomendación de menús para que ahora genere **3 menús categorizados por precio**: BARATO, MEDIO y CARO, todos dentro del presupuesto especificado por el usuario.

## Archivos Modificados

### 1. `core/functions.clp`
Se añadieron dos nuevas funciones auxiliares:

- **`sort-dishes-by-price`**: Ordena una lista de platos por precio (ascendente o descendente)
- **`select-dishes-by-price-range`**: Selecciona platos de un rango de precio específico (bajo/medio/alto)

Estas funciones dividen los platos disponibles en tres segmentos de precio y permiten seleccionar platos de cada segmento.

### 2. `rules/03-recommendation-rules.clp`
Se modificaron las reglas de generación de menús:

#### Regla: `generar-menus-basicos`
- **Antes**: Generaba 3 menús de forma aleatoria
- **Ahora**: Genera 3 menús específicos:
  - MENÚ 1 - BARATO: Selecciona platos del tercio más económico
  - MENÚ 2 - MEDIO: Selecciona platos del tercio intermedio
  - MENÚ 3 - CARO: Selecciona platos del tercio más costoso

#### Regla: `generar-menus-mixtos`
- **Antes**: Generaba 1 vegetariano + 2 sin restricciones de forma aleatoria
- **Ahora**: Genera:
  - MENÚ 1 (Vegetariano): Mantiene la lógica original
  - MENÚ 2 - MEDIO (Sin restricciones): Platos de precio medio
  - MENÚ 3 - CARO (Sin restricciones): Platos de precio alto

## Funcionalidad

### Cómo Funciona

1. **Ordenamiento**: Los platos disponibles (después del filtrado) se ordenan por precio
2. **Segmentación**: Se dividen en tres rangos de precio:
   - Tercio inferior (BARATO)
   - Tercio medio (MEDIO)
   - Tercio superior (CARO)
3. **Selección**: Para cada menú, se seleccionan:
   - Un entrante del rango correspondiente
   - Un plato principal del rango correspondiente
   - Un postre del rango correspondiente
   - Una bebida apropiada
4. **Validación**: Todos los menús se validan contra el presupuesto especificado

### Visualización

Los menús ahora se muestran con su categoría de precio:

```
MENÚ 1 - BARATO:
Entrante: ...
Principal: ...
Postre: ...
Bebida: ...
PRECIO TOTAL: X.XX€

MENÚ 2 - MEDIO:
...

MENÚ 3 - CARO:
...
```

## Ventajas

1. **Variedad de Precios**: Los usuarios ven opciones en diferentes rangos de precio
2. **Flexibilidad**: Pueden elegir según su presupuesto exacto
3. **Transparencia**: Cada menú está claramente etiquetado con su categoría
4. **Cumplimiento**: Todos los menús respetan el presupuesto máximo establecido

## Compatibilidad

- Funciona con todos los tipos de eventos
- Compatible con restricciones dietéticas
- Respeta preferencias de cocina y región
- Mantiene el sistema de temporada (in-season / out-of-season)
- Compatible con eventos especiales (bodas con 2 aperitivos)

## Notas Técnicas

- Si hay menos de 3 platos de un tipo, el sistema ajusta los rangos automáticamente
- Si un rango no tiene suficientes platos, intenta con menús fuera de temporada
- La categorización es relativa a los platos disponibles después del filtrado
