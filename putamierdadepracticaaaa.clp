; =================================
; SISTEMA DE MENUS - Chatbot Interactivo
; =================================

; =========================
; MÓDULOS PRINCIPALES
; =========================

(defmodule MAIN
  (export ?ALL))

(defmodule ENTRADA (import MAIN ?ALL))
(defmodule PERFIL_DATOS (import MAIN ?ALL))
(defmodule PERFIL_RESTRICCIONES (import MAIN ?ALL))
(defmodule PERFIL_BEBIDAS (import MAIN ?ALL))
(defmodule PERFIL_VALIDACION (import MAIN ?ALL))
(defmodule RECOMENDACION_FILTRADO (import MAIN ?ALL))
(defmodule RECOMENDACION_MENUS (import MAIN ?ALL))
(defmodule SALIDA (import MAIN ?ALL))

; =========================
; CLASES (deben definirse PRIMERO)
; =========================

(defclass MAIN::user-profile
  (is-a USER)
  (role concrete)
  (slot season (default any))
  (slot event (default any))
  (multislot diet (default))
  (slot wants-beverage (default no))
  (slot beverage-type (default any))
  (slot specific-beverage (default any)))

(defclass MAIN::dish
  (is-a USER)
  (role concrete)
  (slot id)
  (slot course)
  (multislot ingredients)
  (multislot diets)
  (slot price (type FLOAT)))

(defclass MAIN::ingredient-category
  (is-a USER)
  (role concrete)
  (slot ingredient)
  (slot category))

(defclass MAIN::beverage
  (is-a USER)
  (role concrete)
  (slot id)
  (slot type)
  (slot subtype)
  (slot price (type FLOAT)))

(defclass MAIN::filtrado-completado
  (is-a USER)
  (role concrete))

(defclass MAIN::plato-valido
  (is-a USER)
  (role concrete)
  (slot id)
  (slot course)
  (slot price (type FLOAT)))

(defclass MAIN::menu-shown
  (is-a USER)
  (role concrete))

(defclass MAIN::start
  (is-a USER)
  (role concrete))

(defclass MAIN::datos-basicos-capturados
  (is-a USER)
  (role concrete))

(defclass MAIN::dietas-capturadas
  (is-a USER)
  (role concrete))

(defclass MAIN::bebidas-configuradas
  (is-a USER)
  (role concrete))

; =========================
; FUNCIONES AUXILIARES
; =========================

(deffunction MAIN::ask (?prompt $?allowed-values)
  (printout t ?prompt)
  (if (> (length$ ?allowed-values) 0) then
    (printout t " (" (implode$ ?allowed-values) ")")
  )
  (printout t ": ")
  (bind ?response (read))
  (if (and (> (length$ ?allowed-values) 0) (not (member$ ?response ?allowed-values))) then
    (printout t "Respuesta no válida. Intente nuevamente." crlf)
    (return (ask ?prompt ?allowed-values))
  )
  ?response)

(deffunction MAIN::askline (?prompt)
  (printout t ?prompt crlf "> ")
  (readline))

(deffunction MAIN::parse-list (?input)
  (if (eq ?input "") then
    (return (create$))
  else
    (bind ?lower (lowcase ?input))
    (return (explode$ ?lower))))

(deffunction MAIN::first-fact (?fact-list)
  (if (> (length$ ?fact-list) 0) then
    (return (nth$ 1 ?fact-list))
    else
    (return nil)))

(deffunction MAIN::es-plato-valido (?dish-id $?dietas-usuario)
  (bind ?dish-objs (find-all-instances ((?d MAIN::dish)) (eq (send ?d get-id) ?dish-id)))
  (if (> (length$ ?dish-objs) 0) then
    (bind ?dish-obj (nth$ 1 ?dish-objs))
    (bind ?dish-diets (send ?dish-obj get-diets))
    (if (or (eq (length$ ?dietas-usuario) 0)
            (subsetp ?dietas-usuario ?dish-diets)) then
      (return TRUE)
      else
      (return FALSE))
    else
    (return FALSE)))

; =========================
; FUNCIONES PRINCIPALES DEL CHATBOT
; =========================

(defrule ENTRADA::iniciar-sistema
   ?s <- (object (is-a MAIN::start))
   =>
   (printout t crlf "=== SISTEMA DE RECOMENDACIÓN DE MENÚS ===" crlf)
   (printout t "¡Hola! Vamos a empezar con algunas preguntas para personalizar tu menú." crlf)
   (make-instance of MAIN::user-profile)
   (focus PERFIL_DATOS)
   (send ?s delete))

; =========================
; MÓDULO PERFIL - DATOS DEL USUARIO
; =========================

(defrule PERFIL_DATOS::capturar-datos-basicos
   ?s <- (object (is-a MAIN::user-profile) (season any) (event any))
   (not (object (is-a MAIN::datos-basicos-capturados)))
   =>
   (printout t "== DATOS BÁSICOS DEL USUARIO ==" crlf)
   (bind ?season (ask "¿Qué temporada prefieres?" invierno primavera verano otono any))
   (bind ?event  (ask "¿Qué tipo de evento es?" boda congreso reunion any))
   (send ?s put-season ?season)
   (send ?s put-event ?event)
   (make-instance of MAIN::datos-basicos-capturados)
   (focus PERFIL_RESTRICCIONES))

; =========================
; MÓDULO PERFIL - RESTRICCIONES ALIMENTARIAS
; =========================

(defrule PERFIL_RESTRICCIONES::capturar-dietas
   ?s <- (object (is-a MAIN::user-profile) (diet $?d&:(eq (length$ ?d) 0)))
   (object (is-a MAIN::datos-basicos-capturados))
   (not (object (is-a MAIN::dietas-capturadas)))
   =>
   (printout t crlf "== RESTRICCIONES DIETARIAS ==" crlf)
   (printout t "Opciones disponibles: vegan, vegetarian, lactose_free, gluten_free," crlf)
   (printout t "egg_free, seafood_free, nut_free" crlf)
   (bind ?dietL (parse-list (askline "Ingresa tus restricciones alimentarias separadas por espacios o vacío para ninguna:")))
   (send ?s put-diet ?dietL)
   (make-instance of MAIN::dietas-capturadas)
   (focus PERFIL_BEBIDAS))

; =========================
; MÓDULO PERFIL - PREFERENCIAS DE BEBIDAS
; =========================

(defrule PERFIL_BEBIDAS::configurar-bebidas
   ?s <- (object (is-a MAIN::user-profile) (wants-beverage no))
   (object (is-a MAIN::dietas-capturadas))
   (not (object (is-a MAIN::bebidas-configuradas)))
   =>
   (printout t crlf "== PREFERENCIAS DE BEBIDAS ==" crlf)
   (bind ?beverage-type (ask "¿Prefieres bebida alcohólica o no alcohólica?" alcoholica no_alcoholica))
   (bind ?specific-beverage (ask "¿Qué bebida prefieres?" cerveza vino agua refresco))
   (send ?s put-wants-beverage yes)
   (send ?s put-beverage-type ?beverage-type)
   (send ?s put-specific-beverage ?specific-beverage)
   (make-instance of MAIN::bebidas-configuradas)
   (focus PERFIL_VALIDACION))

; =========================
; MÓDULO PERFIL - VALIDACIÓN
; =========================

(defrule PERFIL_VALIDACION::validar-perfil-completo
   ?s <- (object (is-a MAIN::user-profile) (season ?season) (event ?event) (diet $?diet)
         (wants-beverage yes) (beverage-type ?btype) (specific-beverage ?bsubtype))
   (object (is-a MAIN::bebidas-configuradas))
   =>
   (printout t crlf "== RESUMEN Y VALIDACIÓN DEL PERFIL ==" crlf)
   (printout t "✓ Temporada: " ?season crlf)
   (printout t "✓ Evento: " ?event crlf)
   (printout t "✓ Bebida: " ?btype " - " ?bsubtype crlf)
   (printout t "✓ Dietas: " (if (eq (length$ ?diet) 0) then "ninguna" else (implode$ ?diet)) crlf)
   (focus RECOMENDACION_FILTRADO))

; =========================
; MÓDULO RECOMENDACION - FILTRADO
; =========================

(defrule RECOMENDACION_FILTRADO::filtrar-por-dietas
   (object (is-a MAIN::user-profile) (diet $?user-diets))
   (not (object (is-a MAIN::filtrado-completado)))
   =>
   (printout t crlf "== FILTRANDO PLATOS POR RESTRICCIONES DIETARIAS ==" crlf)
   (bind ?total-platos 0)
   (bind ?platos-validos 0)
   (do-for-all-instances ((?d MAIN::dish)) TRUE
     (bind ?total-platos (+ ?total-platos 1))
     (if (es-plato-valido (send ?d get-id) $?user-diets) then
       (bind ?platos-validos (+ ?platos-validos 1))
       (make-instance of MAIN::plato-valido (id (send ?d get-id)) (course (send ?d get-course)) (price (send ?d get-price)))))
   (printout t "Platos totales: " ?total-platos crlf)
   (printout t "Platos válidos: " ?platos-validos crlf)
   (printout t "Filtrado completado ✓" crlf)
   (make-instance of MAIN::filtrado-completado)
   (focus RECOMENDACION_MENUS))

; =========================
; MÓDULO RECOMENDACION - GENERACION MENUS
; =========================

(defrule RECOMENDACION_MENUS::generar-menus-basicos
   (object (is-a MAIN::user-profile) (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype))
   ?bev <- (object (is-a MAIN::beverage) (id ?bebida) (type ?btype) (subtype ?bsubtype) (price ?bebida-precio))
   (object (is-a MAIN::filtrado-completado))
   (not (object (is-a MAIN::menu-shown)))
   =>
   (printout t crlf "== MENÚS SUGERIDOS ==" crlf)
   (printout t "Bebida seleccionada: " ?bebida " - Precio: " ?bebida-precio "€" crlf crlf)
   
   ; Buscar platos válidos por curso
   (bind ?appetizers (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course appetizer)))
   (bind ?mains (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course main)))
   (bind ?desserts (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course dessert)))
   
   (printout t "Platos disponibles:" crlf)
   (printout t "- Entrantes: " (length$ ?appetizers) crlf)
   (printout t "- Platos principales: " (length$ ?mains) crlf)
   (printout t "- Postres: " (length$ ?desserts) crlf crlf)

   (bind ?num-menus 0)
   (bind ?max-menus 3)
   
   (if (and (> (length$ ?appetizers) 0) (> (length$ ?mains) 0) (> (length$ ?desserts) 0)) then
     (printout t "=== MENÚS COMPLETOS ===" crlf crlf)
     (loop-for-count (?i 1 (min ?max-menus (min (length$ ?appetizers) (min (length$ ?mains) (length$ ?desserts))))) do
       (bind ?num-menus (+ ?num-menus 1))
       (bind ?app (nth$ ?i ?appetizers))
       (bind ?main (nth$ ?i ?mains))
       (bind ?dessert (nth$ ?i ?desserts))
       (bind ?total-precio (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
       
       (printout t "MENÚ " ?num-menus ":" crlf)
       (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
       (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
       (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
       (printout t "Bebida: " ?bebida " - " ?bebida-precio "€" crlf)
       (printout t "PRECIO TOTAL: " ?total-precio "€" crlf crlf))
   else
     (printout t "No hay suficientes platos de todos los cursos para generar menús completos." crlf)
     (printout t "Platos disponibles por categoría:" crlf)
     (if (> (length$ ?appetizers) 0) then
       (printout t crlf "ENTRANTES:" crlf)
       (progn$ (?app ?appetizers)
         (printout t "  - " (send ?app get-id) " (" (send ?app get-price) "€)" crlf)))
     (if (> (length$ ?mains) 0) then
       (printout t crlf "PLATOS PRINCIPALES:" crlf)
       (progn$ (?main ?mains)
         (printout t "  - " (send ?main get-id) " (" (send ?main get-price) "€)" crlf)))
     (if (> (length$ ?desserts) 0) then
       (printout t crlf "POSTRES:" crlf)
       (progn$ (?dessert ?desserts)
         (printout t "  - " (send ?dessert get-id) " (" (send ?dessert get-price) "€)" crlf))))
   
   (make-instance of MAIN::menu-shown)
   (focus SALIDA))

; =========================
; MÓDULO SALIDA
; =========================

(defrule SALIDA::mostrar-fin
   (object (is-a MAIN::menu-shown))
   =>
   (printout t crlf "=== FIN DEL SISTEMA ===" crlf)
   (printout t "¡Gracias por usar nuestro sistema de recomendación!" crlf)
   (halt))

; =========================
; FUNCIÓN DE INICIALIZACIÓN DE DATOS
; =========================

(deffunction MAIN::cargar-datos-sistema ()
  ; Ingredientes y categorías
  (make-instance ic1 of MAIN::ingredient-category (ingredient "chicken") (category meat))
  (make-instance ic2 of MAIN::ingredient-category (ingredient "beef") (category meat))
  (make-instance ic3 of MAIN::ingredient-category (ingredient "steak") (category meat))
  (make-instance ic4 of MAIN::ingredient-category (ingredient "lamb") (category meat))
  (make-instance ic5 of MAIN::ingredient-category (ingredient "bacon") (category meat))
  (make-instance ic6 of MAIN::ingredient-category (ingredient "ham") (category meat))
  (make-instance ic7 of MAIN::ingredient-category (ingredient "pork") (category meat))
  (make-instance ic8 of MAIN::ingredient-category (ingredient "sausage") (category meat))
  (make-instance ic9 of MAIN::ingredient-category (ingredient "meat") (category meat))
  (make-instance ic10 of MAIN::ingredient-category (ingredient "fish") (category fish))
  (make-instance ic11 of MAIN::ingredient-category (ingredient "salmon") (category fish))
  (make-instance ic12 of MAIN::ingredient-category (ingredient "tuna") (category fish))
  (make-instance ic13 of MAIN::ingredient-category (ingredient "cod") (category fish))
  (make-instance ic14 of MAIN::ingredient-category (ingredient "trout") (category fish))
  (make-instance ic15 of MAIN::ingredient-category (ingredient "halibut") (category fish))
  (make-instance ic16 of MAIN::ingredient-category (ingredient "shrimp") (category seafood))
  (make-instance ic17 of MAIN::ingredient-category (ingredient "prawns") (category seafood))
  (make-instance ic18 of MAIN::ingredient-category (ingredient "scallops") (category seafood))
  (make-instance ic19 of MAIN::ingredient-category (ingredient "lobster") (category seafood))
  (make-instance ic20 of MAIN::ingredient-category (ingredient "crab") (category seafood))
  (make-instance ic21 of MAIN::ingredient-category (ingredient "mussels") (category seafood))
  (make-instance ic22 of MAIN::ingredient-category (ingredient "clams") (category seafood))
  (make-instance ic23 of MAIN::ingredient-category (ingredient "seafood") (category seafood))
  (make-instance ic24 of MAIN::ingredient-category (ingredient "cheese") (category dairy))
  (make-instance ic25 of MAIN::ingredient-category (ingredient "milk") (category dairy))
  (make-instance ic26 of MAIN::ingredient-category (ingredient "cream") (category dairy))
  (make-instance ic27 of MAIN::ingredient-category (ingredient "butter") (category dairy))
  (make-instance ic28 of MAIN::ingredient-category (ingredient "parmesan") (category dairy))
  (make-instance ic29 of MAIN::ingredient-category (ingredient "yogurt") (category dairy))
  (make-instance ic30 of MAIN::ingredient-category (ingredient "egg") (category egg))
  (make-instance ic31 of MAIN::ingredient-category (ingredient "eggs") (category egg))
  (make-instance ic32 of MAIN::ingredient-category (ingredient "wheat") (category gluten))
  (make-instance ic33 of MAIN::ingredient-category (ingredient "bread") (category gluten))
  (make-instance ic34 of MAIN::ingredient-category (ingredient "pasta") (category gluten))
  (make-instance ic35 of MAIN::ingredient-category (ingredient "flour") (category gluten))
  (make-instance ic36 of MAIN::ingredient-category (ingredient "fettuccine") (category gluten))
  (make-instance ic37 of MAIN::ingredient-category (ingredient "noodles") (category gluten))
  (make-instance ic38 of MAIN::ingredient-category (ingredient "nuts") (category nuts))
  (make-instance ic39 of MAIN::ingredient-category (ingredient "walnuts") (category nuts))
  (make-instance ic40 of MAIN::ingredient-category (ingredient "almonds") (category nuts))
  (make-instance ic41 of MAIN::ingredient-category (ingredient "peanuts") (category nuts))
  (make-instance ic42 of MAIN::ingredient-category (ingredient "cashews") (category nuts))
  (make-instance ic43 of MAIN::ingredient-category (ingredient "hazelnuts") (category nuts))
  (make-instance ic44 of MAIN::ingredient-category (ingredient "soy") (category soy))
  (make-instance ic45 of MAIN::ingredient-category (ingredient "tofu") (category soy))
  (make-instance ic46 of MAIN::ingredient-category (ingredient "soya") (category soy))
  (make-instance ic47 of MAIN::ingredient-category (ingredient "tomatoes") (category vegetable))
  (make-instance ic48 of MAIN::ingredient-category (ingredient "basil") (category vegetable))
  (make-instance ic49 of MAIN::ingredient-category (ingredient "garlic") (category vegetable))
  (make-instance ic50 of MAIN::ingredient-category (ingredient "olive_oil") (category vegetable))
  (make-instance ic51 of MAIN::ingredient-category (ingredient "spinach") (category vegetable))
  (make-instance ic52 of MAIN::ingredient-category (ingredient "artichoke") (category vegetable))
  (make-instance ic53 of MAIN::ingredient-category (ingredient "mushrooms") (category vegetable))
  (make-instance ic54 of MAIN::ingredient-category (ingredient "lettuce") (category vegetable))
  (make-instance ic55 of MAIN::ingredient-category (ingredient "onion") (category vegetable))
  (make-instance ic56 of MAIN::ingredient-category (ingredient "zucchini") (category vegetable))
  (make-instance ic57 of MAIN::ingredient-category (ingredient "potato") (category vegetable))
  (make-instance ic58 of MAIN::ingredient-category (ingredient "pepper") (category vegetable))
  (make-instance ic59 of MAIN::ingredient-category (ingredient "cucumber") (category vegetable))
  (make-instance ic60 of MAIN::ingredient-category (ingredient "eggplant") (category vegetable))
  (make-instance ic61 of MAIN::ingredient-category (ingredient "carrot") (category vegetable))
  (make-instance ic62 of MAIN::ingredient-category (ingredient "broccoli") (category vegetable))
  (make-instance ic63 of MAIN::ingredient-category (ingredient "cauliflower") (category vegetable))
  (make-instance ic64 of MAIN::ingredient-category (ingredient "asparagus") (category vegetable))
  (make-instance ic65 of MAIN::ingredient-category (ingredient "celery") (category vegetable))
  (make-instance ic66 of MAIN::ingredient-category (ingredient "vegetables") (category vegetable))
  (make-instance ic67 of MAIN::ingredient-category (ingredient "fruit") (category fruit))
  (make-instance ic68 of MAIN::ingredient-category (ingredient "lemon") (category fruit))
  (make-instance ic69 of MAIN::ingredient-category (ingredient "orange") (category fruit))
  (make-instance ic70 of MAIN::ingredient-category (ingredient "apple") (category fruit))
  (make-instance ic71 of MAIN::ingredient-category (ingredient "avocado") (category fruit))
  (make-instance ic72 of MAIN::ingredient-category (ingredient "strawberry") (category fruit))
  (make-instance ic73 of MAIN::ingredient-category (ingredient "raspberry") (category fruit))
  (make-instance ic74 of MAIN::ingredient-category (ingredient "banana") (category fruit))
  (make-instance ic75 of MAIN::ingredient-category (ingredient "berries") (category fruit))
  (make-instance ic76 of MAIN::ingredient-category (ingredient "oil") (category vegetable))
  (make-instance ic77 of MAIN::ingredient-category (ingredient "sugar") (category vegetable))
  (make-instance ic78 of MAIN::ingredient-category (ingredient "honey") (category vegetable))
  (make-instance ic79 of MAIN::ingredient-category (ingredient "salt") (category vegetable))
  (make-instance ic80 of MAIN::ingredient-category (ingredient "rosemary") (category vegetable))
  (make-instance ic81 of MAIN::ingredient-category (ingredient "dill") (category vegetable))
  (make-instance ic82 of MAIN::ingredient-category (ingredient "chocolate") (category vegetable))
  (make-instance ic83 of MAIN::ingredient-category (ingredient "coconut_milk") (category vegetable))
  (make-instance ic84 of MAIN::ingredient-category (ingredient "coconut") (category vegetable))
  (make-instance ic85 of MAIN::ingredient-category (ingredient "truffle") (category vegetable))
  (make-instance ic86 of MAIN::ingredient-category (ingredient "sauce") (category vegetable))
  (make-instance ic87 of MAIN::ingredient-category (ingredient "confidential") (category vegetable))
  (make-instance ic88 of MAIN::ingredient-category (ingredient "alfredo_sauce") (category vegetable))
  
  ; Platos
  (make-instance d1 of MAIN::dish (id "soda_R003_0") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.55))
  (make-instance d2 of MAIN::dish (id "spinach_artichoke_dip_R001_1") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 11.12))
  (make-instance d3 of MAIN::dish (id "new_york_cheesecake_R003_2") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 18.66))
  (make-instance d4 of MAIN::dish (id "chicken_alfredo_R003_3") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 29.55))
  (make-instance d5 of MAIN::dish (id "grilled_steak_R002_4") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 17.73))
  (make-instance d6 of MAIN::dish (id "stuffed_mushrooms_R001_5") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 12.28))
  (make-instance d7 of MAIN::dish (id "soda_R001_6") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.87))
  (make-instance d8 of MAIN::dish (id "tiramisu_R003_7") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 10.47))
  (make-instance d9 of MAIN::dish (id "grilled_steak_R003_8") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 26.78))
  (make-instance d10 of MAIN::dish (id "lemonade_R003_9") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 4.95))
  (make-instance d11 of MAIN::dish (id "chocolate_lava_cake_R001_10") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 16.08))
  (make-instance d12 of MAIN::dish (id "spinach_artichoke_dip_R001_11") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.09))
  (make-instance d13 of MAIN::dish (id "iced_tea_R001_12") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 4.43))
  (make-instance d14 of MAIN::dish (id "chicken_alfredo_R001_13") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 18.46))
  (make-instance d15 of MAIN::dish (id "lemonade_R003_14") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 3.83))
  (make-instance d16 of MAIN::dish (id "tiramisu_R003_15") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 13.91))
  (make-instance d17 of MAIN::dish (id "coffee_R002_16") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.94))
  (make-instance d18 of MAIN::dish (id "grilled_steak_R002_17") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 23.52))
  (make-instance d19 of MAIN::dish (id "tiramisu_R001_18") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.75))
  (make-instance d20 of MAIN::dish (id "grilled_steak_R002_19") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 28.90))
  (make-instance d21 of MAIN::dish (id "lemonade_R003_20") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.27))
  (make-instance d22 of MAIN::dish (id "soda_R003_21") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 4.88))
  (make-instance d23 of MAIN::dish (id "soda_R001_22") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.81))
  (make-instance d24 of MAIN::dish (id "iced_tea_R001_23") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 4.90))
  (make-instance d25 of MAIN::dish (id "bruschetta_R001_24") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 13.62))
  (make-instance d26 of MAIN::dish (id "spinach_artichoke_dip_R001_25") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 10.96))
  (make-instance d27 of MAIN::dish (id "coffee_R001_26") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.02))
  (make-instance d28 of MAIN::dish (id "chocolate_lava_cake_R003_27") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.11))
  (make-instance d29 of MAIN::dish (id "spinach_artichoke_dip_R003_28") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.52))
  (make-instance d30 of MAIN::dish (id "chicken_alfredo_R003_29") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 28.72))
  (make-instance d31 of MAIN::dish (id "coffee_R001_30") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.99))
  (make-instance d32 of MAIN::dish (id "tiramisu_R003_31") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 13.25))
  (make-instance d33 of MAIN::dish (id "coffee_R003_32") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 2.82))
  (make-instance d34 of MAIN::dish (id "spinach_artichoke_dip_R003_33") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.84))
  (make-instance d35 of MAIN::dish (id "chocolate_lava_cake_R002_34") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.22))
  (make-instance d36 of MAIN::dish (id "tiramisu_R003_35") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 14.94))
  (make-instance d37 of MAIN::dish (id "new_york_cheesecake_R001_36") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 11.11))
  (make-instance d38 of MAIN::dish (id "new_york_cheesecake_R001_37") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 18.96))
  (make-instance d39 of MAIN::dish (id "soda_R001_38") (course beverage) (ingredients confidential) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 3.53))
  (make-instance d40 of MAIN::dish (id "spinach_artichoke_dip_R002_39") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 12.23))
  
  ; Bebidas no alcohólicas
  (make-instance b1 of MAIN::beverage (id "agua_mineral") (type no_alcoholica) (subtype agua) (price 1.50))
  (make-instance b2 of MAIN::beverage (id "refresco_cola") (type no_alcoholica) (subtype refresco) (price 3.00))
  (make-instance b3 of MAIN::beverage (id "zumo_naranja") (type no_alcoholica) (subtype refresco) (price 2.50))
  (make-instance b4 of MAIN::beverage (id "limonada") (type no_alcoholica) (subtype refresco) (price 2.80))
  (make-instance b5 of MAIN::beverage (id "agua_gas") (type no_alcoholica) (subtype agua) (price 1.80))
  
  ; Bebidas alcohólicas - Cervezas
  (make-instance b6 of MAIN::beverage (id "cerveza_rubia") (type alcoholica) (subtype cerveza) (price 3.50))
  (make-instance b7 of MAIN::beverage (id "cerveza_tostada") (type alcoholica) (subtype cerveza) (price 3.80))
  (make-instance b8 of MAIN::beverage (id "cerveza_artesanal") (type alcoholica) (subtype cerveza) (price 4.50))
  
  ; Bebidas alcohólicas - Vinos
  (make-instance b9 of MAIN::beverage (id "vino_tinto_crianza") (type alcoholica) (subtype vino) (price 5.00))
  (make-instance b10 of MAIN::beverage (id "vino_blanco_joven") (type alcoholica) (subtype vino) (price 4.00))
  (make-instance b11 of MAIN::beverage (id "vino_rosado") (type alcoholica) (subtype vino) (price 4.20))
  (make-instance b12 of MAIN::beverage (id "cava_brut") (type alcoholica) (subtype vino) (price 6.00))
  (make-instance b13 of MAIN::beverage (id "rioja_reserva") (type alcoholica) (subtype vino) (price 7.50))
  
  (printout t "Datos del sistema cargados correctamente." crlf))

; =========================
; DATOS - INGREDIENTES Y CATEGORÍAS
; =========================

; Los datos se cargan mediante la función cargar-datos-sistema()

; =========================
; INICIAR SISTEMA
; =========================

; El orden correcto es: reset, cargar datos, crear instancia inicial, hacer focus, run
(reset)
(cargar-datos-sistema)
(make-instance start-inst of MAIN::start)
(focus ENTRADA)
(run)