;;======================================================
;;;   Recommendation Rules - RECOMENDACION_MENUS Module
;;;
;;;     Generate complete menu recommendations
;;======================================================

 (defrule RECOMENDACION_MENUS::generar-menus-basicos
   ?profile <- (object (is-a MAIN::user-profile) (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype) (budget ?budget))
   (object (is-a MAIN::filtrado-completado))
   (not (object (is-a MAIN::menu-shown)))
   =>
  (printout t crlf "[DEBUG] ====== STARTING MENU GENERATION ======" crlf)
  (printout t "[DEBUG] Budget received: " ?budget "€" crlf)
  (printout t crlf "== MENÚS SUGERIDOS ==" crlf)
  ;; Prevent duplicate activations: mark menu as shown immediately
  (make-instance of MAIN::menu-shown)
   ;; Seleccionar una única bebida que coincida con el perfil (primera coincidencia)
   (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?bsubtype))))
   (if (and (neq ?bevs nil) (> (length$ ?bevs) 0)) then
     (bind ?bev (nth$ 1 ?bevs))
     (bind ?bebida (send ?bev get-id))
     (bind ?bebida-precio (send ?bev get-price))
     (printout t "Bebida seleccionada: " ?bebida " - Precio: " ?bebida-precio "€" crlf crlf)
   else
     (printout t "No se encontró bebida que coincida con la selección." crlf crlf)
     (bind ?bebida "")
    (bind ?bebida-precio 0))

  ;; Preparar listas de platos válidos por curso
  (bind ?raw-season (send ?profile get-season))
  (bind ?event-season (normalize-season ?raw-season))
  (bind ?all-appetizers (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course appetizer)))
   (bind ?all-mains (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course main)))
  (bind ?all-desserts (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course dessert)))

  ;; DEBUG: show season and counts
  (printout t crlf "[DEBUG] event-season: " ?event-season crlf)
  (printout t "[DEBUG] total appetizers: " (length$ ?all-appetizers) " | mains: " (length$ ?all-mains) " | desserts: " (length$ ?all-desserts) crlf)

   ;; Separate in-season and out-of-season dishes
   (bind ?in-appetizers (create$))
   (bind ?out-appetizers (create$))
   (bind ?in-mains (create$))
   (bind ?out-mains (create$))
   (bind ?in-desserts (create$))
   (bind ?out-desserts (create$))
   
   (foreach ?a ?all-appetizers 
     (if (not (ingredientes-fuera-de-temporada (send ?a get-id) ?event-season)) then 
       (bind ?in-appetizers (insert$ ?in-appetizers (+ (length$ ?in-appetizers) 1) ?a))
     else
       (bind ?out-appetizers (insert$ ?out-appetizers (+ (length$ ?out-appetizers) 1) ?a))))
   
   (foreach ?m ?all-mains 
     (if (not (ingredientes-fuera-de-temporada (send ?m get-id) ?event-season)) then 
       (bind ?in-mains (insert$ ?in-mains (+ (length$ ?in-mains) 1) ?m))
     else
       (bind ?out-mains (insert$ ?out-mains (+ (length$ ?out-mains) 1) ?m))))
   
   (foreach ?d ?all-desserts 
     (if (not (ingredientes-fuera-de-temporada (send ?d get-id) ?event-season)) then 
       (bind ?in-desserts (insert$ ?in-desserts (+ (length$ ?in-desserts) 1) ?d))
     else
       (bind ?out-desserts (insert$ ?out-desserts (+ (length$ ?out-desserts) 1) ?d))))

   (printout t "Platos disponibles en temporada:" crlf)
   (printout t "- Entrantes: " (length$ ?in-appetizers) " (total: " (length$ ?all-appetizers) ")" crlf)
   (printout t "- Platos principales: " (length$ ?in-mains) " (total: " (length$ ?all-mains) ")" crlf)
   (printout t "- Postres: " (length$ ?in-desserts) " (total: " (length$ ?all-desserts) ")" crlf crlf)

   (bind ?num-menus 0)
   (bind ?max-menus 3)
   (bind ?printed FALSE)
   
   ;; Use parallel lists to store menu components (can't nest multifields)
   (bind ?menu-appetizers (create$))
   (bind ?menu-mains (create$))
   (bind ?menu-desserts (create$))
   (bind ?menu-in-season (create$))  ; TRUE or FALSE for each menu

   ;; Try to build in-season menus first (all 3 dishes must be in season)
   (bind ?menus-rejected-budget 0)
   (if (and (> (length$ ?in-appetizers) 0) (> (length$ ?in-mains) 0) (> (length$ ?in-desserts) 0)) then
     (bind ?max-possible (min (length$ ?in-appetizers) (min (length$ ?in-mains) (length$ ?in-desserts))))
     (bind ?menus-added 0)
     (loop-for-count (?i 1 ?max-possible) do
       (if (< ?menus-added ?max-menus) then
         (bind ?app-inst (nth$ ?i ?in-appetizers))
         (bind ?main-inst (nth$ ?i ?in-mains))
         (bind ?dessert-inst (nth$ ?i ?in-desserts))
         ;; Check if menu fits budget before adding
         (bind ?menu-total (+ ?bebida-precio (send ?app-inst get-price) (send ?main-inst get-price) (send ?dessert-inst get-price)))
         (if (or (= ?budget 0.0) (<= ?menu-total ?budget)) then
           (bind ?menu-appetizers (insert$ ?menu-appetizers (+ (length$ ?menu-appetizers) 1) ?app-inst))
           (bind ?menu-mains (insert$ ?menu-mains (+ (length$ ?menu-mains) 1) ?main-inst))
           (bind ?menu-desserts (insert$ ?menu-desserts (+ (length$ ?menu-desserts) 1) ?dessert-inst))
           (bind ?menu-in-season (insert$ ?menu-in-season (+ (length$ ?menu-in-season) 1) TRUE))
           (bind ?menus-added (+ ?menus-added 1))
         else
           (if (> ?budget 0.0) then
             (bind ?menus-rejected-budget (+ ?menus-rejected-budget 1)))))))

   ;; If we don't have enough menus, build mixed menus (at least one dish out of season)
   (if (< (length$ ?menu-appetizers) ?max-menus) then
     (bind ?remaining (- ?max-menus (length$ ?menu-appetizers)))
     (bind ?max-all (min (length$ ?all-appetizers) (min (length$ ?all-mains) (length$ ?all-desserts))))
     (bind ?added 0)
     (loop-for-count (?i 1 ?max-all) do
       (if (< ?added ?remaining) then
         (bind ?app (nth$ ?i ?all-appetizers))
         (bind ?main (nth$ ?i ?all-mains))
         (bind ?dessert (nth$ ?i ?all-desserts))
         ;; Check if this combination is out of season
         (bind ?is-out-of-season FALSE)
         (if (or (ingredientes-fuera-de-temporada (send ?app get-id) ?event-season)
                 (ingredientes-fuera-de-temporada (send ?main get-id) ?event-season)
                 (ingredientes-fuera-de-temporada (send ?dessert get-id) ?event-season)) then
           (bind ?is-out-of-season TRUE))
         ;; Only add if it's out of season AND fits budget (with surcharge)
         (if ?is-out-of-season then
           (bind ?raw-total (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           (bind ?menu-total-with-surcharge (* ?raw-total 1.1))
           (if (or (= ?budget 0.0) (<= ?menu-total-with-surcharge ?budget)) then
             (bind ?menu-appetizers (insert$ ?menu-appetizers (+ (length$ ?menu-appetizers) 1) ?app))
             (bind ?menu-mains (insert$ ?menu-mains (+ (length$ ?menu-mains) 1) ?main))
             (bind ?menu-desserts (insert$ ?menu-desserts (+ (length$ ?menu-desserts) 1) ?dessert))
             (bind ?menu-in-season (insert$ ?menu-in-season (+ (length$ ?menu-in-season) 1) FALSE))
             (bind ?added (+ ?added 1))
           else
             (if (> ?budget 0.0) then
               (bind ?menus-rejected-budget (+ ?menus-rejected-budget 1))))))))

   ;; Print all menus (in-season first, then out-of-season with surcharge)
   (bind ?total-menus (length$ ?menu-appetizers))
   (printout t "[DEBUG] Total menus to evaluate: " ?total-menus crlf)
   (if (> ?total-menus 0) then
     (printout t "[DEBUG] Entering menu evaluation block" crlf)
     (bind ?in-season-count 0)
     (bind ?out-season-count 0)
     ;; Count in-season vs out-of-season
     (loop-for-count (?i 1 ?total-menus) do
       (if (nth$ ?i ?menu-in-season) then
         (bind ?in-season-count (+ ?in-season-count 1))
       else
         (bind ?out-season-count (+ ?out-season-count 1))))
     (printout t "[DEBUG] In-season: " ?in-season-count " | Out-of-season: " ?out-season-count crlf)
     
     ;; Print in-season menus (all are within budget due to pre-filtering)
     (if (> ?in-season-count 0) then
       (printout t "=== MENÚS COMPLETOS (EN TEMPORADA) ===" crlf crlf)
       (loop-for-count (?i 1 ?total-menus) do
         (if (nth$ ?i ?menu-in-season) then
           (bind ?app (nth$ ?i ?menu-appetizers))
           (bind ?main (nth$ ?i ?menu-mains))
           (bind ?dessert (nth$ ?i ?menu-desserts))
           (bind ?total-precio (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           (bind ?num-menus (+ ?num-menus 1))
           (printout t "MENÚ " ?num-menus ":" crlf)
           (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
           (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
           (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
           (printout t "Bebida: " ?bebida " - " ?bebida-precio "€" crlf)
           (printout t "PRECIO TOTAL: " ?total-precio "€" crlf)
           (if (> ?budget 0.0) then
             (printout t "✓ Dentro del presupuesto de " ?budget "€ por persona" crlf))
           (printout t crlf)))
       (bind ?printed TRUE))
     
     ;; Print out-of-season menus with surcharge (all are within budget due to pre-filtering)
     (if (> ?out-season-count 0) then
       (if (not ?printed) then
         (printout t "=== MENÚS CON RECARGO (FUERA DE TEMPORADA) ===" crlf crlf))
       (loop-for-count (?i 1 ?total-menus) do
         (if (not (nth$ ?i ?menu-in-season)) then
           (bind ?app (nth$ ?i ?menu-appetizers))
           (bind ?main (nth$ ?i ?menu-mains))
           (bind ?dessert (nth$ ?i ?menu-desserts))
           (bind ?raw-total (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           (bind ?total-precio (* ?raw-total 1.1))
           (bind ?num-menus (+ ?num-menus 1))
           (printout t "MENÚ " ?num-menus ":" crlf)
           (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
           (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
           (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
           (printout t "Bebida: " ?bebida " - " ?bebida-precio "€" crlf)
           (printout t "PRECIO TOTAL (con +10% por fuera de temporada): " ?total-precio "€" crlf)
           (if (> ?budget 0.0) then
             (printout t "✓ Dentro del presupuesto de " ?budget "€ por persona" crlf))
           (printout t crlf)))
       (bind ?printed TRUE)))
   
   ;; Show budget rejection message if applicable
   (if (and ?printed (> ?budget 0.0) (> ?menus-rejected-budget 0)) then
     (printout t "ℹ " ?menus-rejected-budget " menú(s) adicional(es) no se mostraron" crlf)
     (printout t "porque excedían el presupuesto de " ?budget "€ por persona." crlf crlf))
   
   ;; Fallback: no complete menus available
   (if (not ?printed) then
     (if (> ?budget 0.0) then
       (printout t crlf "⚠ No se encontraron menús completos dentro del presupuesto de " ?budget "€ por persona." crlf crlf)
       (printout t "Para poder ofrecer menús, considere las siguientes opciones:" crlf)
       (printout t "  1. Aumentar el presupuesto por persona" crlf)
       (printout t "  2. Modificar las restricciones dietéticas" crlf)
       (printout t "  3. Elegir una bebida más económica" crlf)
       (printout t "  4. Cambiar la temporada del evento (algunos ingredientes están fuera de temporada)" crlf crlf)
       (printout t "Información útil:" crlf)
       (printout t "- Presupuesto actual: " ?budget "€ por persona" crlf)
       (printout t "- Precio de la bebida seleccionada: " ?bebida-precio "€" crlf)
       (printout t "- Platos disponibles después del filtrado: " crlf)
       (printout t "  • Entrantes: " (length$ ?all-appetizers) crlf)
       (printout t "  • Platos principales: " (length$ ?all-mains) crlf)
       (printout t "  • Postres: " (length$ ?all-desserts) crlf)
       (if (= (length$ ?all-mains) 0) then
         (printout t crlf "⚠ NOTA: No hay platos principales disponibles. Esto puede deberse a:" crlf)
         (printout t "   - Restricciones dietéticas muy estrictas" crlf)
         (printout t "   - Presupuesto insuficiente" crlf)
         (printout t "   - Número de personas muy alto (>100 elimina platos complejos)" crlf))
     else
       (printout t crlf "⚠ No hay suficientes platos de todos los cursos para generar menús completos." crlf crlf)
       (printout t "Platos disponibles:" crlf)
       (printout t "  • Entrantes: " (length$ ?all-appetizers) crlf)
       (printout t "  • Platos principales: " (length$ ?all-mains) crlf)
       (printout t "  • Postres: " (length$ ?all-desserts) crlf crlf)
       (printout t "Sugerencias:" crlf)
       (printout t "  - Revise las restricciones dietéticas" crlf)
       (printout t "  - Verifique que hay ingredientes disponibles para la temporada seleccionada" crlf)))

  (focus SALIDA))
