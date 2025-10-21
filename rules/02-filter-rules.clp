;;======================================================
;;;   Filter Rules
;;;
;;;     Filter and display compatible dishes and beverages
;;======================================================

;; Filtrar platos por dieta, alergenos y evento

(defrule filter-dishes
  (user-profile (diet $?ud) (event ?event))
  =>
  (printout t crlf "=== PLATOS COMPATIBLES ===" crlf)
  (bind ?count-primero 0)
  (bind ?count-segundo 0)
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

;; Mostrar bebidas compatibles
(defrule show-beverages
  (user-profile (beverage-type ?type) (specific-beverage ?subtype))
  =>
  (printout t crlf "=== BEBIDAS COMPATIBLES ===" crlf)
  (do-for-all-facts ((?b beverage)) (and (eq ?b:type ?type) (eq ?b:subtype ?subtype))
    (printout t ?b:subtype ": " ?b:id " - " ?b:price " EUR" crlf)))
