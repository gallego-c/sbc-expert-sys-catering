;;======================================================
;;;   Input Rules - ENTRADA Module
;;;
;;;     Initial system startup
;;======================================================

(defrule ENTRADA::iniciar-sistema
   ?s <- (object (is-a MAIN::start))
   =>
   (printout t crlf "=== SISTEMA DE RECOMENDACIÓN DE MENÚS ===" crlf)
   (printout t "¡Hola! Vamos a empezar con algunas preguntas para personalizar tu menú." crlf crlf)
   (make-instance of MAIN::user-profile)
   (focus PERFIL_DATOS)
   (send ?s delete))

;;======================================================
;;;   Profile Rules - PERFIL_DATOS Module
;;;
;;;     Capture basic user data
;;======================================================

(defrule PERFIL_DATOS::capturar-datos-basicos
   ?s <- (object (is-a MAIN::user-profile) (season any) (event any) (num-people 0) (budget 0.0) (cuisine any))
   (not (object (is-a MAIN::datos-basicos-capturados)))
   =>
   (printout t "== DATOS BÁSICOS DEL USUARIO ==" crlf)
   (bind ?season (ask "¿Qué temporada prefieres?" invierno primavera verano otono any))
   (bind ?event  (ask "¿Qué tipo de evento es?" boda congreso reunion any))
   (printout t "¿Cuántas personas asistirán al evento?" crlf "> ")
   (bind ?num-people (read))
   (printout t "¿Cuál es el presupuesto por persona (en EUR)?" crlf "> ")
   (bind ?budget (read))
   (printout t "¿Qué tipo de cocina prefieres?" crlf)
   (printout t "Opciones: italian, french, spanish, american, greek, indian, asian," crlf)
   (printout t "         japanese, mediterranean, middle_eastern, caribbean, any" crlf "> ")
   (bind ?cuisine (read))
   (send ?s put-season ?season)
   (send ?s put-event ?event)
   (send ?s put-num-people ?num-people)
   (send ?s put-budget ?budget)
   (send ?s put-cuisine ?cuisine)
   (make-instance of MAIN::datos-basicos-capturados)
   (focus PERFIL_RESTRICCIONES))

;;======================================================
;;;   Profile Rules - PERFIL_RESTRICCIONES Module
;;;
;;;     Capture dietary restrictions
;;======================================================

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

;;======================================================
;;;   Profile Rules - PERFIL_BEBIDAS Module
;;;
;;;     Capture beverage preferences
;;======================================================

(defrule PERFIL_BEBIDAS::configurar-bebidas
   ?s <- (object (is-a MAIN::user-profile) (wants-beverage no))
   (object (is-a MAIN::dietas-capturadas))
   (not (object (is-a MAIN::bebidas-configuradas)))
   =>
   (printout t crlf "== PREFERENCIAS DE BEBIDAS ==" crlf)
   (bind ?alcoholic (ask "¿Deseas bebida alcohólica?" si no))
   (if (eq ?alcoholic si) then
     (bind ?beverage-type alcoholica)
     (bind ?specific-beverage (ask "¿Qué bebida prefieres?" cerveza vino))
   else
     (bind ?beverage-type no_alcoholica)
     (bind ?specific-beverage (ask "¿Qué bebida prefieres?" agua refresco)))
   (send ?s put-wants-beverage yes)
   (send ?s put-beverage-type ?beverage-type)
   (send ?s put-specific-beverage ?specific-beverage)
   (make-instance of MAIN::bebidas-configuradas)
   (focus PERFIL_VALIDACION))

;;======================================================
;;;   Profile Rules - PERFIL_VALIDACION Module
;;;
;;;     Validate complete profile
;;======================================================

(defrule PERFIL_VALIDACION::validar-perfil-completo
   ?s <- (object (is-a MAIN::user-profile) (season ?season) (event ?event) (num-people ?num-people) (budget ?budget) (cuisine ?cuisine) (diet $?diet)
         (wants-beverage yes) (beverage-type ?btype) (specific-beverage ?bsubtype))
   (object (is-a MAIN::bebidas-configuradas))
   =>
   (printout t crlf "== RESUMEN Y VALIDACIÓN DEL PERFIL ==" crlf)
   (printout t "✓ Temporada: " ?season crlf)
   (printout t "✓ Evento: " ?event crlf)
   (printout t "✓ Número de personas: " ?num-people crlf)
   (printout t "✓ Presupuesto por persona: " ?budget " EUR" crlf)
   (printout t "✓ Cocina preferida: " ?cuisine crlf)
   (printout t "✓ Presupuesto por persona: " ?budget " EUR" crlf)
   (printout t "✓ Bebida: " ?btype " - " ?bsubtype crlf)
   (printout t "✓ Dietas: " (if (eq (length$ ?diet) 0) then "ninguna" else (implode$ ?diet)) crlf)
   (focus RECOMENDACION_FILTRADO))
