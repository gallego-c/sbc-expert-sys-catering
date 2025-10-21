; =========================
; SISTEMA DE MENUS - Versión corregida
; =========================

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

; Templates
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
; DATOS AMPLIADOS - MUCHOS PLATOS Y BEBIDAS
; =========================
(deffacts initial-data
  ; ===== PRIMEROS PLATOS =====
  ; Platos normales
  (dish (id "ensalada_mixta") (course primero) 
        (ingredients lechuga tomate cebolla aceite) (diets vegetariana) (price 5.50))
  (dish (id "sopa_tomate") (course primero) 
        (ingredients tomate pan aceite) (diets vegetariana) (price 4.00))
  (dish (id "sopa_marisco") (course primero) 
        (ingredients gambas calamar pescado) (diets) (price 8.50))
  (dish (id "crema_calabacin") (course primero) 
        (ingredients calabacin patata cebolla) (diets vegetariana vegana) (price 4.50))
  
  ; Platos para bodas
  (dish (id "salmon_ahumado") (course primero) 
        (ingredients salmon limon eneldo) (diets) (price 12.00))
  (dish (id "foie_gourmet") (course primero) 
        (ingredients foie pan cebolla) (diets) (price 15.00))
  (dish (id "ensalada_queso_cabra") (course primero) 
        (ingredients lechuga queso_cabra nueces miel) (diets vegetariana) (price 9.00))
  
  ; Platos para congresos
  (dish (id "ensalada_cesar") (course primero) 
        (ingredients lechuga pollo queso salsa_cesar) (diets) (price 7.50))
  (dish (id "sopa_miso") (course primero) 
        (ingredients tofu alga miso) (diets vegetariana vegana) (price 5.00))
  
  ; Platos sin gluten
  (dish (id "ensalada_quinoa") (course primero) 
        (ingredients quinoa aguacate tomate pepino) (diets vegetariana vegana sin_gluten) (price 6.50))
  (dish (id "crema_espinacas") (course primero) 
        (ingredients espinacas patata cebolla) (diets vegetariana vegana sin_gluten) (price 4.50))
  
  ; Platos veganos
  (dish (id "gazpacho_andaluz") (course primero) 
        (ingredients tomate pepino pimiento ajo) (diets vegetariana vegana sin_gluten) (price 4.00))
  (dish (id "ensalada_lentejas") (course primero) 
        (ingredients lentejas cebolla pimiento zanahoria) (diets vegetariana vegana sin_gluten) (price 5.50))

  ; ===== SEGUNDOS PLATOS =====
  ; Platos normales
  (dish (id "merluza_plancha") (course segundo) 
        (ingredients merluza aceite limon) (diets) (price 12.00))
  (dish (id "pollo_asado") (course segundo) 
        (ingredients pollo patatas romero) (diets) (price 10.00))
  (dish (id "ternera_brasa") (course segundo) 
        (ingredients ternera patatas pimientos) (diets) (price 16.00))
  (dish (id "lubina_sal") (course segundo) 
        (ingredients lubina sal limon) (diets) (price 14.00))
  
  ; Platos para bodas
  (dish (id "solomillo_ternera") (course segundo) 
        (ingredients solomillo patatas salsa) (diets) (price 22.00))
  (dish (id "rodaballo_plancha") (course segundo) 
        (ingredients rodaballo verduras) (diets) (price 18.00))
  (dish (id "cordero_horno") (course segundo) 
        (ingredients cordero patatas romero) (diets) (price 20.00))
  
  ; Platos para congresos
  (dish (id "pasta_carbonara") (course segundo) 
        (ingredients pasta bacon queso huevo) (diets) (price 8.50))
  (dish (id "lasana_carne") (course segundo) 
        (ingredients pasta carne tomate queso) (diets) (price 9.00))
  
  ; Platos vegetarianos
  (dish (id "lasana_vegetal") (course segundo) 
        (ingredients pasta berenjena calabacin queso) (diets vegetariana) (price 8.00))
  (dish (id "risotto_champinones") (course segundo) 
        (ingredients arroz champinones queso) (diets vegetariana) (price 9.50))
  (dish (id "huevos_rotos") (course segundo) 
        (ingredients huevos patatas jamon) (diets) (price 7.50))
  
  ; Platos veganos
  (dish (id "curry_vegetal") (course segundo) 
        (ingredients leche_coco curcuma verduras) (diets vegetariana vegana) (price 8.50))
  (dish (id "tofu_salteado") (course segundo) 
        (ingredients tofu soja verduras) (diets vegetariana vegana) (price 7.50))
  (dish (id "hamburguesa_lentejas") (course segundo) 
        (ingredients lentejas avena cebolla) (diets vegetariana vegana) (price 6.50))
  
  ; Platos sin gluten
  (dish (id "pollo_plancha_sin_gluten") (course segundo) 
        (ingredients pollo patatas ensalada) (diets sin_gluten) (price 11.00))
  (dish (id "salmon_papillote") (course segundo) 
        (ingredients salmon verduras limon) (diets sin_gluten) (price 13.50))
  
  ; Platos sin lactosa
  (dish (id "pollo_curry_sin_lactosa") (course segundo) 
        (ingredients pollo leche_coco curcuma) (diets sin_lactosa) (price 10.50))
  (dish (id "pescado_horno_sin_lactosa") (course segundo) 
        (ingredients pescado patatas pimenton) (diets sin_lactosa) (price 12.00))

  ; ===== POSTRES =====
  ; Postres normales
  (dish (id "tarta_queso") (course postre) 
        (ingredients queso leche trigo huevo) (diets) (price 5.00))
  (dish (id "fruta_fresca") (course postre) 
        (ingredients fruta) (diets vegetariana vegana sin_gluten sin_lactosa) (price 3.00))
  (dish (id "flan_huevo") (course postre) 
        (ingredients huevo leche azucar) (diets) (price 4.00))
  (dish (id "helado_chocolate") (course postre) 
        (ingredients leche chocolate azucar) (diets) (price 4.50))
  
  ; Postres para bodas
  (dish (id "tarta_nupcial") (course postre) 
        (ingredients harina huevo mantequilla chocolate) (diets) (price 8.00))
  (dish (id "profiteroles") (course postre) 
        (ingredients harina huevo nata chocolate) (diets) (price 6.50))
  (dish (id "souffle_chocolate") (course postre) 
        (ingredients chocolate huevo azucar) (diets) (price 7.00))
  
  ; Postres para congresos
  (dish (id "mousse_chocolate") (course postre) 
        (ingredients chocolate huevo nata) (diets) (price 4.50))
  (dish (id "brownie_nueces") (course postre) 
        (ingredients chocolate harina nueces huevo) (diets) (price 5.00))
  
  ; Postres vegetarianos/veganos
  (dish (id "mousse_frutas") (course postre) 
        (ingredients fruta azucar agar) (diets vegetariana vegana) (price 4.00))
  (dish (id "tarta_manzana_vegana") (course postre) 
        (ingredients manzana harina_avena aceite) (diets vegetariana vegana) (price 5.50))
  (dish (id "helado_coco_vegano") (course postre) 
        (ingredients coco azucar vainilla) (diets vegetariana vegana sin_lactosa) (price 4.50))
  
  ; Postres sin gluten
  (dish (id "tarta_almendra") (course postre) 
        (ingredients almendra huevo azucar) (diets sin_gluten) (price 6.00))
  (dish (id "crema_catalana_sin_gluten") (course postre) 
        (ingredients leche huevo azucar maizena) (diets sin_gluten) (price 4.50))
  
  ; Postres sin lactosa
  (dish (id "sorbete_limon") (course postre) 
        (ingredients limon azucar agua) (diets vegetariana vegana sin_gluten sin_lactosa) (price 3.50))
  (dish (id "tarta_naranja_sin_lactosa") (course postre) 
        (ingredients naranja harina aceite) (diets vegetariana sin_lactosa) (price 5.00))

  ; ===== BEBIDAS =====
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
  
  (bind ?dietL  (parse-list (askline "Dietas (vegana,vegetariana,sin_gluten,sin_lactosa) o vacio:")))
  
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

; Filtrar platos por dieta, alergenos y evento
(defrule filter-dishes
  (user-profile (diet $?ud) (event ?event))
  =>
  (printout t crlf "=== PLATOS COMPATIBLES ===" crlf)
            )
      )
      (printout t crlf "Resumen: " ?count-primero " primeros, " ?count-segundo " segundos, " ?count-postre " postres" crlf)
)
  (bind ?count-postre 0)
  
  ; Mostrar platos filtrados
  (do-for-all-facts ((?d dish)) TRUE
    ; Verificar si el plato es compatible con las dietas
    (bind ?diet-compatible TRUE)
    (if (> (length$ $?ud) 0) then
      (bind ?diet-compatible (subsetp $?ud ?d:diets)))
    
    (if ?diet-compatible then
      (printout t ?d:course ": " ?d:id " - " ?d:price " EUR")
      (if (> (length$ ?d:diets) 0) then
        (printout t " [" (implode$ ?d:diets) "]"))
      (printout t crlf)
      
      ; Contar por curso
      (if (eq ?d:course primero) then (bind ?count-primero (+ ?count-primero 1)))
      (if (eq ?d:course segundo) then (bind ?count-segundo (+ ?count-segundo 1)))
      (if (eq ?d:course postre) then (bind ?count-postre (+ ?count-postre 1))))
  )
  
  (printout t crlf "Resumen: " ?count-primero " primeros, " ?count-segundo " segundos, " ?count-postre " postres" crlf))

; Mostrar bebidas compatibles
(defrule show-beverages
  (user-profile (beverage-type ?type) (specific-beverage ?subtype))
  =>
  (printout t crlf "=== BEBIDAS COMPATIBLES ===" crlf)
  (do-for-all-facts ((?b beverage)) (and (eq ?b:type ?type) (eq ?b:subtype ?subtype))
    (printout t ?b:subtype ": " ?b:id " - " ?b:price " EUR" crlf)))

; Función auxiliar para obtener lista de platos por curso
(deffunction get-dishes-by-course (?course ?diets)
      (bind ?result (create$))
      (do-for-all-facts ((?d dish)) (eq ?d:course ?course)
            (if (or (eq (length$ ?diets) 0) (subsetp ?diets ?d:diets)) then
                  (bind ?result (create$ ?result ?d:id ?d:price))))
      ?result)
)

; Generar recomendaciones completas con bebidas
(defrule generate-recommendations
  (user-profile (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype))
  (beverage (id ?bebida) (type ?btype) (subtype ?bsubtype) (price ?bebida-precio))
  =>
  (printout t crlf "--- 6 MENUS SUGERIDOS ---" crlf)
  
  ; Obtener listas de platos filtrados
      (bind ?primeros (get-dishes-by-course primero $?ud))
      (bind ?segundos (get-dishes-by-course segundo $?ud))
      (bind ?postres (get-dishes-by-course postre $?ud))
  
      (bind ?n 1)
      (while (and (<= ?n 6)
                                          (<= (* ?n 2) (length$ ?primeros))
                                          (<= (* ?n 2) (length$ ?segundos))
                                          (<= (* ?n 2) (length$ ?postres))) do
            (bind ?p-id (nth$ (- (* ?n 2) 1) ?primeros))
            (bind ?p-price (nth$ (* ?n 2) ?primeros))
            (bind ?s-id (nth$ (- (* ?n 2) 1) ?segundos))
            (bind ?s-price (nth$ (* ?n 2) ?segundos))
            (bind ?po-id (nth$ (- (* ?n 2) 1) ?postres))
            (bind ?po-price (nth$ (* ?n 2) ?postres))
            (bind ?total (+ ?p-price ?s-price ?po-price ?bebida-precio))
            (printout t "Menu " ?n ": " crlf)
            (printout t "  Primero: " ?p-id crlf)
            (printout t "  Segundo: " ?s-id crlf)
            (printout t "  Postre:  " ?po-id crlf)
            (printout t "  Bebida:  " ?bebida crlf)
            (printout t "  TOTAL:   " ?total " EUR" crlf crlf)
            (bind ?n (+ ?n 1)))
)

(defrule finish
  (declare (salience -1000))
  ?u <- (user-profile)
  =>
  (printout t crlf "=== FIN DEL SISTEMA ===" crlf)
  (halt))