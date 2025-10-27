;;======================================================;;======================================================

;;;   Filter Rules - RECOMENDACION_FILTRADO Module;;;   Filter Rules

;;;;;;

;;;     Filter dishes by dietary restrictions;;;     Filter and display compatible dishes and beverages

;;======================================================;;======================================================



;;======================================================
;;;   Filter Rules - RECOMENDACION_FILTRADO Module
;;;
;;;     Filter dishes by dietary restrictions
;;======================================================

(defrule RECOMENDACION_FILTRADO::filtrar-por-dietas
   ?profile <- (object (is-a MAIN::user-profile) (diet $?user-diets) (num-people ?num-people) (budget ?budget) (cuisine ?cuisine))
   (not (object (is-a MAIN::filtrado-completado)))
   =>
   (printout t crlf "== FILTRANDO PLATOS POR RESTRICCIONES DIETARIAS ==" crlf)
   
   ;; Validate num-people and budget are numbers
   (if (not (numberp ?num-people)) then (bind ?num-people 0))
   (if (not (numberp ?budget)) then (bind ?budget 0.0))
   
   (if (> ?num-people 100) then
     (printout t "⚠ Evento grande detectado (>100 personas): solo platos con menos de 5 ingredientes" crlf))
   (if (> ?budget 0.0) then
     (printout t "⚠ Presupuesto por persona: " ?budget "€ - filtrando platos por precio" crlf))
   (if (neq ?cuisine any) then
     (printout t "⚠ Filtrando por cocina: " ?cuisine crlf))
   (bind ?total-platos 0)
   (bind ?platos-validos 0)
   (bind ?platos-descartados-ingredientes 0)
   (bind ?platos-descartados-precio 0)
   (bind ?platos-descartados-cocina 0)
   (do-for-all-instances ((?d MAIN::dish)) TRUE
     (bind ?total-platos (+ ?total-platos 1))
     (bind ?dish-id (send ?d get-id))
     (bind ?dish-price (send ?d get-price))
     (bind ?dish-cuisine (send ?d get-cuisine))
     (bind ?num-ingredientes (contar-ingredientes ?dish-id))
     ;; First check dietary restrictions
     (if (es-plato-valido ?dish-id (expand$ ?user-diets)) then
       ;; Then check cuisine preference
       (if (and (neq ?cuisine any) (neq ?dish-cuisine ?cuisine)) then
         (bind ?platos-descartados-cocina (+ ?platos-descartados-cocina 1))
       ;; Then check ingredient count for large events
       else (if (and (> ?num-people 100) (>= ?num-ingredientes 5)) then
         (bind ?platos-descartados-ingredientes (+ ?platos-descartados-ingredientes 1))
       ;; Then check budget constraint (rough estimate: dish price should be <= budget/2 to leave room for beverage)
       else (if (and (> ?budget 0.0) (> ?dish-price (* ?budget 0.4))) then
         (bind ?platos-descartados-precio (+ ?platos-descartados-precio 1))
       else
         (bind ?platos-validos (+ ?platos-validos 1))
         (make-instance of MAIN::plato-valido (id ?dish-id) (course (send ?d get-course)) (price ?dish-price)))))))
   (printout t "Platos totales: " ?total-platos crlf)
   (printout t "Platos válidos: " ?platos-validos crlf)
   (if (> ?platos-descartados-cocina 0) then
     (printout t "Platos descartados por cocina: " ?platos-descartados-cocina crlf))
   (if (> ?platos-descartados-ingredientes 0) then
     (printout t "Platos descartados por complejidad: " ?platos-descartados-ingredientes crlf))
   (if (> ?platos-descartados-precio 0) then
     (printout t "Platos descartados por precio: " ?platos-descartados-precio crlf))
   (printout t "Filtrado completado ✓" crlf)
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
