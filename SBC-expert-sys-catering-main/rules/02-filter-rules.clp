;;======================================================
;;;   Filter Rules - RECOMENDACION_FILTRADO Module
;;;
;;;     Filter dishes by dietary restrictions
;;======================================================

(defrule RECOMENDACION_FILTRADO::filtrar-por-dietas
   ?profile <- (object (is-a MAIN::user-profile) (diet $?user-diets) (specific-beverage ?bev-subtype) (num-people ?num-people) (budget ?budget) (cuisine ?cuisine) (season ?event-season))
   (not (object (is-a MAIN::filtrado-completado)))
   =>
   (printout t crlf "== FILTRANDO PLATOS POR RESTRICCIONES DIETARIAS ==" crlf)
   
   ;; Validate num-people and budget are numbers
   (if (not (numberp ?num-people)) then (bind ?num-people 0))
   (if (not (numberp ?budget)) then (bind ?budget 0.0))
   
   (if (> ?num-people 100) then
     (printout t " Evento grande detectado (>100 personas): solo platos de dificultad 'easy'" crlf))
   (if (> ?budget 0.0) then
     (printout t " Presupuesto por persona: " ?budget "€ - filtrando platos por precio" crlf))
   (if (neq ?cuisine any) then
     (printout t " Filtrando por cocina: " ?cuisine crlf))
   (if (neq ?event-season any) then
     (printout t " Filtrando por temporada: " ?event-season " (verificando ingredientes)" crlf))
   (bind ?total-platos 0)
   (bind ?platos-validos 0)
   (bind ?platos-descartados-dificultad 0)
   (bind ?platos-descartados-precio 0)
   (bind ?platos-descartados-cocina 0)
   (bind ?platos-descartados-temporada 0)
   (do-for-all-instances ((?d MAIN::dish)) TRUE
     (bind ?total-platos (+ ?total-platos 1))
     (bind ?dish-id (send ?d get-id))
     (bind ?dish-price (send ?d get-price))
     (bind ?dish-cuisine (send ?d get-cuisine))
     (bind ?dish-difficulty (send ?d get-difficulty))
     (bind ?valido FALSE)
     ;; First check dietary restrictions
     (if (not (es-plato-valido ?dish-id (expand$ ?user-diets))) then
       ;; Skip - not valid for diet
       (bind ?valido FALSE)
     else
       ;; Then check cuisine preference
       (if (and (neq ?cuisine any) (neq ?dish-cuisine ?cuisine)) then
         (bind ?platos-descartados-cocina (+ ?platos-descartados-cocina 1))
       else
         ;; Then check difficulty for large events (only if >100 people)
         (if (and (> ?num-people 100) (neq ?dish-difficulty easy)) then
           (bind ?platos-descartados-dificultad (+ ?platos-descartados-dificultad 1))
         else
           ;; Then check budget constraint
           (if (and (> ?budget 0.0) (> ?dish-price (* ?budget 0.4))) then
             (bind ?platos-descartados-precio (+ ?platos-descartados-precio 1))
           else
             (bind ?valido TRUE)))))
     ;; Create instance if valid
     (if ?valido then
       (bind ?platos-validos (+ ?platos-validos 1))
       (make-instance of MAIN::plato-valido (id ?dish-id) (course (send ?d get-course)) (price ?dish-price))))
   (printout t "Platos totales: " ?total-platos crlf)
   (printout t "Platos válidos: " ?platos-validos crlf)
   (if (> ?platos-descartados-cocina 0) then
     (printout t "Platos descartados por cocina: " ?platos-descartados-cocina crlf))
   (if (> ?platos-descartados-dificultad 0) then
     (printout t "Platos descartados por dificultad: " ?platos-descartados-dificultad crlf))
   (if (> ?platos-descartados-precio 0) then
     (printout t "Platos descartados por precio: " ?platos-descartados-precio crlf))
   (if (> ?platos-descartados-temporada 0) then
     (printout t "Platos descartados por ingredientes fuera de temporada: " ?platos-descartados-temporada crlf))
   ;; Filter by beverage pairing if wine
   (if (or (eq ?bev-subtype vino_blanco) (eq ?bev-subtype vino_tinto)) then
     (bind ?required-pairing (if (eq ?bev-subtype vino_blanco) then pescado else carne))
     (printout t "Filtrando platos principales por emparejamiento con " ?required-pairing crlf)
     (bind ?mains-removed 0)
     (do-for-all-instances ((?p MAIN::plato-valido)) (eq ?p:course main)
       (bind ?pairing (get-pairing ?p:id))
       (if (neq ?pairing ?required-pairing) then
         (bind ?mains-removed (+ ?mains-removed 1))
         (send ?p delete)))
     (printout t "Platos principales eliminados: " ?mains-removed crlf))
   (printout t "Filtrado completado " crlf)
  (make-instance of MAIN::filtrado-completado)
  (focus RECOMENDACION_MENUS)
  (run))

;; Mostrar bebidas compatibles (simple helper rule)
(defrule RECOMENDACION_FILTRADO::mostrar-bebidas-compatibles

   (object (is-a MAIN::user-profile) (beverage-type ?type) (specific-beverage ?subtype))
   =>
   (printout t crlf "=== BEBIDAS COMPATIBLES ===" crlf)
   (do-for-all-instances ((?b MAIN::beverage)) TRUE
     (if (and (eq ?b:type ?type) (eq ?b:subtype ?subtype)) then
       (printout t ?b:id " - " (send ?b get-price) "€" crlf))))
