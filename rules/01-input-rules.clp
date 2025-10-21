;;======================================================
;;;   Input Rules
;;;
;;;     User interview and profile configuration
;;======================================================

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
