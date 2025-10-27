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
   ?s <- (object (is-a MAIN::user-profile) (season any) (event any) (num-people 0) (budget 0.0))
   (not (object (is-a MAIN::datos-basicos-capturados)))
   =>
   (printout t "== DATOS BÁSICOS DEL USUARIO ==" crlf)
   (bind ?season (ask "¿Qué temporada prefieres?" invierno primavera verano otono any))
   (bind ?event  (ask "¿Qué tipo de evento es?" boda congreso reunion any))
   (printout t "¿Cuántas personas asistirán al evento?" crlf "> ")
   (bind ?num-people (read))
   (printout t "¿Cuál es el presupuesto por persona (en EUR)?" crlf "> ")
   (bind ?budget (read))
   (send ?s put-season ?season)
   (send ?s put-event ?event)
   (send ?s put-num-people ?num-people)
   (send ?s put-budget ?budget)
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
   (focus PERFIL_COCINA))

;;======================================================
;;;   Profile Rules - PERFIL_COCINA Module
;;;
;;;     Capture cuisine preferences (region then specific)
;;======================================================

(defrule PERFIL_COCINA::capturar-region-cocina
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region any))
   (object (is-a MAIN::dietas-capturadas))
   (not (object (is-a MAIN::region-cocina-capturada)))
   =>
   (printout t crlf "== PREFERENCIAS DE COCINA ==" crlf)
   (printout t "Selecciona una región culinaria:" crlf)
   (bind ?region (ask "¿Qué región de cocina prefieres?" europea asiatica latinoamericana mediterranea otras any))
   (send ?s put-cuisine-region ?region)
   (make-instance of MAIN::region-cocina-capturada))

(defrule PERFIL_COCINA::capturar-cocina-especifica-europea
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region europea) (cuisine any))
   (object (is-a MAIN::region-cocina-capturada))
   (not (object (is-a MAIN::cocina-especifica-capturada)))
   =>
   (printout t "Cocinas europeas disponibles: italiana, francesa, española, griega, britanica, irlandesa" crlf)
   (bind ?cuisine (ask "¿Qué cocina específica prefieres?" italian french spanish greek british irish any))
   (send ?s put-cuisine ?cuisine)
   (make-instance of MAIN::cocina-especifica-capturada)
   (focus PERFIL_BEBIDAS))

(defrule PERFIL_COCINA::capturar-cocina-especifica-asiatica
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region asiatica) (cuisine any))
   (object (is-a MAIN::region-cocina-capturada))
   (not (object (is-a MAIN::cocina-especifica-capturada)))
   =>
   (printout t "Cocinas asiáticas disponibles: china, japonesa, tailandesa, coreana, india, vietnamita, filipina" crlf)
   (bind ?cuisine (ask "¿Qué cocina específica prefieres?" chinese japanese thai korean indian vietnamese filipino any))
   (send ?s put-cuisine ?cuisine)
   (make-instance of MAIN::cocina-especifica-capturada)
   (focus PERFIL_BEBIDAS))

(defrule PERFIL_COCINA::capturar-cocina-especifica-latinoamericana
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region latinoamericana) (cuisine any))
   (object (is-a MAIN::region-cocina-capturada))
   (not (object (is-a MAIN::cocina-especifica-capturada)))
   =>
   (printout t "Cocinas latinoamericanas disponibles: mexicana, peruana, brasileña, caribeña (cajun/creole, jamaicana)" crlf)
   (bind ?cuisine (ask "¿Qué cocina específica prefieres?" mexican peruvian brazilian cajun_creole jamaican any))
   (send ?s put-cuisine ?cuisine)
   (make-instance of MAIN::cocina-especifica-capturada)
   (focus PERFIL_BEBIDAS))

(defrule PERFIL_COCINA::capturar-cocina-especifica-mediterranea
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region mediterranea) (cuisine any))
   (object (is-a MAIN::region-cocina-capturada))
   (not (object (is-a MAIN::cocina-especifica-capturada)))
   =>
   (printout t "Cocinas mediterráneas disponibles: italiana, española, griega, marroquí, mediterránea general" crlf)
   (bind ?cuisine (ask "¿Qué cocina específica prefieres?" italian spanish greek moroccan mediterranean any))
   (send ?s put-cuisine ?cuisine)
   (make-instance of MAIN::cocina-especifica-capturada)
   (focus PERFIL_BEBIDAS))

(defrule PERFIL_COCINA::capturar-cocina-especifica-otras
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region otras) (cuisine any))
   (object (is-a MAIN::region-cocina-capturada))
   (not (object (is-a MAIN::cocina-especifica-capturada)))
   =>
   (printout t "Otras cocinas disponibles: americana, británica (fish&chips), del sur de USA, fusion, tropical, asiática general" crlf)
   (bind ?cuisine (ask "¿Qué cocina específica prefieres?" american british southern_us fusion tropical asian any))
   (send ?s put-cuisine ?cuisine)
   (make-instance of MAIN::cocina-especifica-capturada)
   (focus PERFIL_BEBIDAS))

(defrule PERFIL_COCINA::sin-preferencia-cocina
   ?s <- (object (is-a MAIN::user-profile) (cuisine-region any) (cuisine any))
   (object (is-a MAIN::region-cocina-capturada))
   (not (object (is-a MAIN::cocina-especifica-capturada)))
   =>
   (printout t "Sin preferencia específica de cocina, se considerarán todas las opciones." crlf)
   (send ?s put-cuisine any)
   (make-instance of MAIN::cocina-especifica-capturada)
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
     (bind ?specific-beverage (ask "¿Qué tipo de bebida alcohólica prefieres?" cerveza vino_blanco vino_tinto))
   else
     (bind ?beverage-type no_alcoholica)
     (bind ?specific-beverage (ask "¿Qué tipo de bebida no alcohólica prefieres?" agua jugos refrescos)))
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
   ?s <- (object (is-a MAIN::user-profile) (season ?season) (event ?event) (num-people ?num-people) (budget ?budget) 
         (cuisine-region ?region) (cuisine ?cuisine) (diet $?diet)
         (wants-beverage yes) (beverage-type ?btype) (specific-beverage ?bsubtype))
   (object (is-a MAIN::bebidas-configuradas))
   =>
   (printout t crlf "== RESUMEN Y VALIDACIÓN DEL PERFIL ==" crlf)
   (printout t "✓ Temporada: " ?season crlf)
   (printout t "✓ Evento: " ?event crlf)
   (printout t "✓ Número de personas: " ?num-people crlf)
   (printout t "✓ Presupuesto por persona: " ?budget " EUR" crlf)
   (printout t "✓ Región de cocina: " ?region crlf)
   (printout t "✓ Cocina específica: " ?cuisine crlf)
   (printout t "✓ Bebida: " ?btype " - " ?bsubtype crlf)
   (printout t "✓ Dietas: " (if (eq (length$ ?diet) 0) then "ninguna" else (implode$ ?diet)) crlf)
   (focus RECOMENDACION_FILTRADO))
