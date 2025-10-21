;;======================================================
;;;   Recommendation Rules
;;;
;;;     Generate complete menu recommendations
;;======================================================

;; Generar recomendaciones completas con bebidas
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
