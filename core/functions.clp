;;======================================================
;;;   Utility Functions
;;;
;;;     Reusable helper functions
;;======================================================

;;****************
;;* FUNCTIONS    *
;;****************

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

;; Función auxiliar para obtener lista de platos por curso
(deffunction get-dishes-by-course (?course ?diets)
  (bind ?result (create$))
  (do-for-all-facts ((?d dish)) (eq ?d:course ?course)
    (if (or (eq (length$ ?diets) 0) (subsetp ?diets ?d:diets)) then
      (bind ?result (create$ ?result ?d:id ?d:price))))
  ?result)
