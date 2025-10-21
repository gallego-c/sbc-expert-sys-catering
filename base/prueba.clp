(load "dishes_data.clp")

(deffunction ask$ (?prompt $?opts)
  (printout t ?prompt " " ?opts crlf "> ")
  (bind ?ans (read))
  (if (> (length$ ?opts) 0) then
    (while (not (member$ ?ans ?opts)) do
      (printout t "Respuesta no valida. Opciones: " ?opts crlf "> ")
      (bind ?ans (read)) ))
  ?ans)

(deffunction askline (?prompt)
  (printout t ?prompt crlf "> ")
  (readline))

(deffunction parse-list (?txt)
  (bind ?s (lowcase (str-replace (str-cat ?txt) " " "")))
  (if (eq ?s "") then (return (create$)))
  (explode$ (str-replace ?s "," " ")))

(deffunction ask-float (?prompt ?default)
  (printout t ?prompt " (enter para " ?default ")" crlf "> ")
  (bind ?raw (readline))
  (if (eq ?raw "") then (return (float ?default)))
  (if (numberp (float ?raw))
    then (return (float ?raw))
    else (return (float ?default))))

(deffunction ask-int (?prompt ?default)
  (printout t ?prompt " (enter para " ?default ")" crlf "> ")
  (bind ?raw (readline))
  (if (eq ?raw "") then (return ?default))
  (if (numberp ?raw)
    then (return (integer ?raw))
    else (return ?default)))

(deffunction chat ()
  (reset)
  (assert (start))
  (run))

; Templates (deben coincidir con los de dishes_data.clp)
(deftemplate dish
  (slot id)
  (slot course)
  (multislot ingredients)
  (multislot diets)
  (slot price (type FLOAT)))

(deftemplate beverage
  (slot id)
  (slot type) ; alcoholica / no_alcoholica
  (slot subtype) ; agua/refresco/cerveza/vino
  (slot price (type FLOAT)))

(deftemplate user-profile
  (slot season (default any))
  (slot event (default any))
  (multislot diet)
  (slot wants-beverage (default no))
  (slot beverage-type (default any))
  (slot specific-beverage (default any)))

(deftemplate start)

; =========================
; DATOS BÁSICOS - PERFIL Y BEBIDAS
; =========================
(deffacts initial-data
  ; Bebidas no alcohólicas
  (beverage (id "agua_mineral") (type no_alcoholica) (subtype agua) (price 1.50))
  (beverage (id "refresco_cola") (type no_alcoholica) (subtype refresco) (price 3.00))
  (beverage (id "zumo_naranja") (type no_alcoholica) (subtype refresco) (price 2.50))
  (beverage (id "limonada") (type no_alcoholica) (subtype refresco) (price 2.80))
  (beverage (id "agua_gas") (type no_alcoholica) (subtype agua) (price 1.80))
  
  ; Bebidas alcohólicas - Cervezas
  (beverage (id "cerveza_rubia") (type alcoholica) (subtype cerveza) (price 3.50))
  (beverage (id "cerveza_tostada") (type alcoholica) (subtype cerveza) (price 3.80))
  (beverage (id "cerveza_artesanal") (type alcoholica) (subtype cerveza) (price 4.50))
  
  ; Bebidas alcohólicas - Vinos
  (beverage (id "vino_tinto_crianza") (type alcoholica) (subtype vino) (price 5.00))
  (beverage (id "vino_blanco_joven") (type alcoholica) (subtype vino) (price 4.00))
  (beverage (id "vino_rosado") (type alcoholica) (subtype vino) (price 4.20))
  (beverage (id "cava_brut") (type alcoholica) (subtype vino) (price 6.00))
  (beverage (id "rioja_reserva") (type alcoholica) (subtype vino) (price 7.50))

  ; Perfil de usuario por defecto
  (user-profile (season any) (event any) (diet)
                (wants-beverage no) (beverage-type any) (specific-beverage any))
)

; =========================
; REGLAS MEJORADAS
; =========================
(defrule interview
  ?s <- (start)
  =>
  (printout t crlf "== CONFIGURACION DE PERFIL ==" crlf)
  (bind ?season (ask$ "Temporada?" invierno primavera verano otono any))
  (bind ?event  (ask$ "Evento?" boda congreso reunion any))
  (bind ?beverage-type (ask$ "Tipo de bebida? (alcoholica/no_alcoholica)" alcoholica no_alcoholica))
  
  (bind ?specific-beverage any)
  (if (eq ?beverage-type alcoholica) then
    (bind ?specific-beverage (ask$ "Especifica bebida? (cerveza/vino)" cerveza vino))
    else
    (bind ?specific-beverage (ask$ "Especifica bebida? (agua/refresco)" agua refresco)))
  
  (bind ?dietL  (parse-list (askline "Dietas (vegan,vegetarian,lactose_free,gluten_free,egg_free,seafood_free,nut_free) o vacio:")))
  
  (printout t crlf "== RESUMEN DE CONFIGURACION ==" crlf)
  (printout t "Temporada: " ?season crlf)
  (printout t "Evento: " ?event crlf)
  (printout t "Bebida: " ?beverage-type " - " ?specific-beverage crlf)
  (printout t "Dietas: " (implode$ ?dietL) crlf)
  
  ; Actualizar perfil
  (do-for-all-facts ((?u user-profile)) TRUE (retract ?u))
  (assert (user-profile (season ?season) (event ?event) (diet $?dietL)
                        (wants-beverage yes) (beverage-type ?beverage-type) 
                        (specific-beverage ?specific-beverage)))
  
  (retract ?s)) 

; Función auxiliar para obtener lista de platos por curso
(deffunction get-dishes-by-course (?course ?diets)
  (bind ?result (create$))
  (do-for-all-facts ((?d dish)) (eq ?d:course ?course)
    (if (or (eq (length$ ?diets) 0) (subsetp ?diets ?d:diets)) then
      (bind ?result (create$ ?result ?d:id ?d:price))))
  ?result)

; Generar recomendaciones completas con bebidas
; Regla para mostrar menús sugeridos solo una vez por perfil
(defrule generate-recommendations-once
  (user-profile (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype))
  (beverage (id ?bebida) (type ?btype) (subtype ?bsubtype) (price ?bebida-precio))
  (not (menu-shown))
  (test (and (<= 2 (length$ (get-dishes-by-course appetizer $?ud)))
             (<= 2 (length$ (get-dishes-by-course main $?ud)))
             (<= 2 (length$ (get-dishes-by-course dessert $?ud)))))
  =>
  (assert (menu-shown))
  (printout t crlf "--- MENUS SUGERIDOS ---" crlf)
  (bind ?appetizers (get-dishes-by-course appetizer $?ud))
  (bind ?mains (get-dishes-by-course main $?ud))
  (bind ?desserts (get-dishes-by-course dessert $?ud))
  (bind ?n 1)
  (bind ?max-menus 3)
  (while (and (<= ?n ?max-menus)
              (<= (* ?n 2) (length$ ?appetizers))
              (<= (* ?n 2) (length$ ?mains))
              (<= (* ?n 2) (length$ ?desserts))) do
    (bind ?a-id (nth$ (- (* ?n 2) 1) ?appetizers))
    (bind ?a-price (nth$ (* ?n 2) ?appetizers))
    (bind ?m-id (nth$ (- (* ?n 2) 1) ?mains))
    (bind ?m-price (nth$ (* ?n 2) ?mains))
    (bind ?d-id (nth$ (- (* ?n 2) 1) ?desserts))
    (bind ?d-price (nth$ (* ?n 2) ?desserts))
    (bind ?total (+ ?a-price ?m-price ?d-price ?bebida-precio))
    (printout t "Menu " ?n ": " crlf)
    (printout t "  Entrante: " ?a-id crlf)
    (printout t "  Principal: " ?m-id crlf)
    (printout t "  Postre:  " ?d-id crlf)
    (printout t "  Bebida:  " ?bebida crlf)
    (printout t "  TOTAL:   " ?total " EUR" crlf crlf)
    (bind ?n (+ ?n 1)))
)

; Regla para mostrar mensaje de error solo una vez por perfil
(defrule no-menus-possible-once
  (user-profile (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype))
  (not (menu-error-shown))
  (test (or (< 2 (length$ (get-dishes-by-course appetizer $?ud)))
            (< 2 (length$ (get-dishes-by-course main $?ud)))
            (< 2 (length$ (get-dishes-by-course dessert $?ud)))))
  =>
  (assert (menu-error-shown))
  (printout t crlf "No hay suficientes platos para generar menus completos" crlf)
)

(defrule finish
  (declare (salience -1000))
  ?u <- (user-profile)
  =>
  (printout t crlf "=== FIN DEL SISTEMA ===" crlf)
  (halt))