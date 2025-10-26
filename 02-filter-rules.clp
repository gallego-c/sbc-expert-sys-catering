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
   (object (is-a MAIN::user-profile) (diet $?user-diets))
   (not (object (is-a MAIN::filtrado-completado)))
   =>
   (printout t crlf "== FILTRANDO PLATOS POR RESTRICCIONES DIETARIAS ==" crlf)
   (bind ?total-platos 0)
   (bind ?platos-validos 0)
   (do-for-all-instances ((?d MAIN::dish)) TRUE
     (bind ?total-platos (+ ?total-platos 1))
     (if (es-plato-valido (send ?d get-id) (expand$ ?user-diets)) then
       (bind ?platos-validos (+ ?platos-validos 1))
       (make-instance of MAIN::plato-valido (id (send ?d get-id)) (course (send ?d get-course)) (price (send ?d get-price)))))
   (printout t "Platos totales: " ?total-platos crlf)
   (printout t "Platos válidos: " ?platos-validos crlf)
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
