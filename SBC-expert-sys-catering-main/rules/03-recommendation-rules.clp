;;======================================================
;;;   Recommendation Rules - RECOMENDACION_MENUS Module
;;;
;;;     Generate complete menu recommendations
;;======================================================

(defrule RECOMENDACION_MENUS::generar-menus-basicos
   ?profile <- (object (is-a MAIN::user-profile) (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype) (budget ?budget) (cuisine ?user-cuisine) (cuisine-region ?user-region) (event ?event-type))
   (object (is-a MAIN::filtrado-completado))
   (not (object (is-a MAIN::menu-shown)))
   =>
  (printout t crlf "== MENÚS SUGERIDOS ==" crlf)
  ;; Prevent duplicate activations: mark menu as shown immediately
  (make-instance of MAIN::menu-shown)

  ;; Calculate offset for menu selection to get different menus each time
  (bind ?offset (mod (+ (* (random) 100) (integer (time))) 100))

  ;; Determinar si se necesitan 2 aperitivos (para bodas y congresos)
  (bind ?double-appetizer (or (eq ?event-type boda) (eq ?event-type congreso)))
  (if ?double-appetizer then
    (printout t "Evento especial detectado: se incluirán 2 aperitivos en cada menú" crlf))

  ;; Preparar listas de platos válidos por curso
  (bind ?raw-season (send ?profile get-season))
  (bind ?event-season (normalize-season ?raw-season))
  (bind ?all-appetizers (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course appetizer)))
   (bind ?all-mains (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course main)))
  (bind ?all-desserts (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course dessert)))
  
  ;; BUSCAR PASTEL DE BODAS (NUEVO)
  (bind ?wedding-cake (find-all-instances ((?p MAIN::plato-valido)) (eq ?p:course wedding_cake)))
  (bind ?wedding-cake-instance (if (> (length$ ?wedding-cake) 0) then (nth$ 1 ?wedding-cake) else nil))
  (bind ?wedding-cake-price (if (neq ?wedding-cake-instance nil) then (send ?wedding-cake-instance get-price) else 0))
  (bind ?has-wedding-cake (and (eq ?event-type boda) (neq ?wedding-cake-instance nil)))
  
  ;; If cuisine is "any", group dishes by cuisine to ensure coherent menus
  ;; If region is specified, only include cuisines from that region
  (bind ?cuisine-groups (create$))
  (if (eq ?user-cuisine any) then
    (printout t "Agrupando platos por tipo de cocina para crear menús coherentes..." crlf)
    (if (neq ?user-region any) then
      (printout t "Filtrando por región: " ?user-region crlf))
    ;; Find all unique cuisines from main dishes (main course determines menu style)
    (foreach ?m ?all-mains
      (bind ?dish-inst (find-instance ((?d MAIN::dish)) (eq ?d:id (send ?m get-id))))
      (if (> (length$ ?dish-inst) 0) then
        (bind ?cuisine-type (send (nth$ 1 ?dish-inst) get-cuisine))
        ;; Only add if not already in list AND belongs to selected region
        (if (and (not (member$ ?cuisine-type ?cuisine-groups))
                 (cuisine-belongs-to-region ?cuisine-type ?user-region)) then
          (bind ?cuisine-groups (insert$ ?cuisine-groups (+ (length$ ?cuisine-groups) 1) ?cuisine-type)))))
    (printout t "Cocinas disponibles: " (implode$ ?cuisine-groups) crlf crlf))
  ;; Ensure bebida price variable exists (may be set later when selecting beverage)
  (bind ?bebida-precio 0)

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
   (bind ?menu-appetizers2 (create$))  ;; Nuevo: segundo aperitivo
   (bind ?menu-mains (create$))
   (bind ?menu-desserts (create$))
   (bind ?menu-in-season (create$))  ; TRUE or FALSE for each menu
   (bind ?menu-cuisines (create$))   ; Track cuisine type for each menu
   (bind ?menu-double-appetizer (create$))  ;; Nuevo: track si usa 2 aperitivos

   ;; Try to build in-season menus first (all 3 dishes must be in season)
   (bind ?menus-rejected-budget 0)
   
   (if (eq ?user-cuisine any) then
     ;; When cuisine is "any", create menus grouped by cuisine type
     (foreach ?cuisine-type ?cuisine-groups
       (if (< (length$ ?menu-appetizers) ?max-menus) then
         ;; Filter dishes by this cuisine type
         (bind ?cuisine-appetizers (create$))
         (bind ?cuisine-mains (create$))
         (bind ?cuisine-desserts (create$))
         
         (foreach ?a ?in-appetizers
           (if (eq (get-dish-cuisine (send ?a get-id)) ?cuisine-type) then
             (bind ?cuisine-appetizers (insert$ ?cuisine-appetizers (+ (length$ ?cuisine-appetizers) 1) ?a))))
         
         (foreach ?m ?in-mains
           (if (eq (get-dish-cuisine (send ?m get-id)) ?cuisine-type) then
             (bind ?cuisine-mains (insert$ ?cuisine-mains (+ (length$ ?cuisine-mains) 1) ?m))))
         
         (foreach ?d ?in-desserts
           (if (eq (get-dish-cuisine (send ?d get-id)) ?cuisine-type) then
             (bind ?cuisine-desserts (insert$ ?cuisine-desserts (+ (length$ ?cuisine-desserts) 1) ?d))))
         
         ;; Try to create a menu with this cuisine if all courses available
         (if (and (> (length$ ?cuisine-appetizers) 0) 
                  (> (length$ ?cuisine-mains) 0) 
                  (> (length$ ?cuisine-desserts) 0)) then
           (bind ?idx-app (+ 1 (mod ?offset (length$ ?cuisine-appetizers))))
           (bind ?idx-main (+ 1 (mod ?offset (length$ ?cuisine-mains))))
           (bind ?idx-dessert (+ 1 (mod ?offset (length$ ?cuisine-desserts))))
           (bind ?app-inst (nth$ ?idx-app ?cuisine-appetizers))
           (bind ?main-inst (nth$ ?idx-main ?cuisine-mains))
           (bind ?dessert-inst (nth$ ?idx-dessert ?cuisine-desserts))
           ;; Check budget
           (bind ?menu-total (+ (send ?app-inst get-price) (send ?main-inst get-price) (send ?dessert-inst get-price)))
           (if (or (= ?budget 0.0) (<= ?menu-total ?budget)) then
             (bind ?menu-appetizers (insert$ ?menu-appetizers (+ (length$ ?menu-appetizers) 1) ?app-inst))
             (bind ?menu-mains (insert$ ?menu-mains (+ (length$ ?menu-mains) 1) ?main-inst))
             (bind ?menu-desserts (insert$ ?menu-desserts (+ (length$ ?menu-desserts) 1) ?dessert-inst))
             (bind ?menu-in-season (insert$ ?menu-in-season (+ (length$ ?menu-in-season) 1) TRUE))
             (bind ?menu-cuisines (insert$ ?menu-cuisines (+ (length$ ?menu-cuisines) 1) ?cuisine-type))
           else
             (if (> ?budget 0.0) then
               (bind ?menus-rejected-budget (+ ?menus-rejected-budget 1)))))))
   else
     ;; When cuisine is specific, use original logic
   else
     ;; When cuisine is specific, use original logic
     (if (and (> (length$ ?in-appetizers) 0) (> (length$ ?in-mains) 0) (> (length$ ?in-desserts) 0)) then
       (bind ?max-possible (min (length$ ?in-appetizers) (min (length$ ?in-mains) (length$ ?in-desserts))))
       (bind ?menus-added 0)
       (loop-for-count (?i 1 ?max-possible) do
         (if (< ?menus-added ?max-menus) then
         ;; Use offset to select different dishes each time
         (bind ?idx-app (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?in-appetizers))))
         (bind ?idx-main (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?in-mains))))
         (bind ?idx-dessert (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?in-desserts))))
         (bind ?app-inst (nth$ ?idx-app ?in-appetizers))
         (bind ?main-inst (nth$ ?idx-main ?in-mains))
         (bind ?dessert-inst (nth$ ?idx-dessert ?in-desserts))
           ;; Check if menu fits budget before adding (estimate using dishes only)
           (bind ?menu-total (+ (send ?app-inst get-price) (send ?main-inst get-price) (send ?dessert-inst get-price)))
           (if (or (= ?budget 0.0) (<= ?menu-total ?budget)) then
         (bind ?menu-appetizers (insert$ ?menu-appetizers (+ (length$ ?menu-appetizers) 1) ?app-inst))
         (bind ?menu-mains (insert$ ?menu-mains (+ (length$ ?menu-mains) 1) ?main-inst))
         (bind ?menu-desserts (insert$ ?menu-desserts (+ (length$ ?menu-desserts) 1) ?dessert-inst))
             (bind ?menu-in-season (insert$ ?menu-in-season (+ (length$ ?menu-in-season) 1) TRUE))
             (bind ?menu-cuisines (insert$ ?menu-cuisines (+ (length$ ?menu-cuisines) 1) ?user-cuisine))
             (bind ?menus-added (+ ?menus-added 1))
           else
             (if (> ?budget 0.0) then
               (bind ?menus-rejected-budget (+ ?menus-rejected-budget 1))))))))

   ;; If we don't have enough menus, build mixed menus (at least one dish out of season)
   (if (< (length$ ?menu-appetizers) ?max-menus) then
     (bind ?remaining (- ?max-menus (length$ ?menu-appetizers)))
     (bind ?max-all (min (length$ ?all-appetizers) (min (length$ ?all-mains) (length$ ?all-desserts))))
     (bind ?added 0)
     (loop-for-count (?i 1 ?max-all) do
       (if (< ?added ?remaining) then
         ;; Use offset to select different dishes each time
         (bind ?idx-app (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?all-appetizers))))
         (bind ?idx-main (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?all-mains))))
         (bind ?idx-dessert (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?all-desserts))))
         (bind ?app (nth$ ?idx-app ?all-appetizers))
         (bind ?main (nth$ ?idx-main ?all-mains))
         (bind ?dessert (nth$ ?idx-dessert ?all-desserts))
         ;; Check if this combination is out of season
         (bind ?is-out-of-season FALSE)
         (if (or (ingredientes-fuera-de-temporada (send ?app get-id) ?event-season)
                 (ingredientes-fuera-de-temporada (send ?main get-id) ?event-season)
                 (ingredientes-fuera-de-temporada (send ?dessert get-id) ?event-season)) then
           (bind ?is-out-of-season TRUE))
         ;; Only add if it's out of season AND fits budget (with surcharge)
         (if ?is-out-of-season then
           ;; Estimate raw total using dishes only (beverage added later). Apply surcharge for out-of-season.
           (bind ?raw-total (+ (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
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
   (bind ?in-season-count 0)
   (bind ?out-season-count 0)
   (if (> ?total-menus 0) then
     ;; Count in-season vs out-of-season
     (loop-for-count (?i 1 ?total-menus) do
       (if (nth$ ?i ?menu-in-season) then
         (bind ?in-season-count (+ ?in-season-count 1))
       else
         (bind ?out-season-count (+ ?out-season-count 1))))
     
     ;; Print in-season menus (all are within budget due to pre-filtering)
     (if (> ?in-season-count 0) then
       (printout t "=== MENÚS COMPLETOS (EN TEMPORADA) ===" crlf crlf)
       (loop-for-count (?i 1 ?total-menus) do
         (if (nth$ ?i ?menu-in-season) then
           (bind ?app (nth$ ?i ?menu-appetizers))
           (bind ?main (nth$ ?i ?menu-mains))
           (bind ?dessert (nth$ ?i ?menu-desserts))
           ;; Select beverage based on main course pairing
           (bind ?pairing (get-pairing (send ?main get-id)))
           ;; Try pairing first (only wines have pairs_with)
           (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?bsubtype) (member$ ?pairing ?b:pairs_with))))
           (if (eq (length$ ?bevs) 0) then
             ;; If wine, try alternative wine type
             (if (and (eq ?btype alcoholica) (or (eq ?bsubtype vino_blanco) (eq ?bsubtype vino_tinto))) then
               (bind ?alt-subtype (if (eq ?bsubtype vino_blanco) then vino_tinto else vino_blanco))
               (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?alt-subtype) (member$ ?pairing ?b:pairs_with))))
               (if (eq (length$ ?bevs) 0) then
                 (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?alt-subtype)))))))
             ;; For non-alcoholic or if wine pairing failed, just match type and subtype
             (if (eq (length$ ?bevs) 0) then
               (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?bsubtype))))))
           (if (> (length$ ?bevs) 0) then
             ;; Use offset to vary beverage selection
             (bind ?bev-idx (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?bevs))))
             (bind ?bev (nth$ ?bev-idx ?bevs))
             (bind ?bebida (send ?bev get-id))
             (bind ?bebida-precio (send ?bev get-price))
           else
             (bind ?bebida "No disponible")
             (bind ?bebida-precio 0))
           (bind ?num-menus (+ ?num-menus 1))
           (bind ?total-precio (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           ;; Añadir precio del pastel de bodas si es necesario
           (if ?has-wedding-cake then
             (bind ?total-precio (+ ?total-precio ?wedding-cake-price)))
           (bind ?menu-cuisine (nth$ ?i ?menu-cuisines))
           (printout t "MENÚ " ?num-menus)
           (if (eq ?user-cuisine any) then
             (printout t " (Cocina: " ?menu-cuisine ")"))
           (printout t ":" crlf)
           (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
           (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
           (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
           ;; Añadir pastel de bodas si es necesario
           (if ?has-wedding-cake then
             (printout t "Pastel de bodas: " (send ?wedding-cake-instance get-id) " - " ?wedding-cake-price "€" crlf))
           (printout t "Bebida: " ?bebida " - " ?bebida-precio "€" crlf)
           (printout t "PRECIO TOTAL: " ?total-precio "€" crlf)
           (if (> ?budget 0.0) then
             (printout t "✓ Dentro del presupuesto de " ?budget "€ por persona" crlf))
           (printout t crlf)))
       (bind ?printed TRUE))
     
     ;; Print out-of-season menus with surcharge
     (if (> ?out-season-count 0) then
       (if (not ?printed) then
         (printout t "=== MENÚS CON RECARGO (FUERA DE TEMPORADA) ===" crlf crlf))
       (loop-for-count (?i 1 ?total-menus) do
         (if (not (nth$ ?i ?menu-in-season)) then
           (bind ?app (nth$ ?i ?menu-appetizers))
           (bind ?main (nth$ ?i ?menu-mains))
           (bind ?dessert (nth$ ?i ?menu-desserts))
           ;; Select beverage based on main course pairing
           (bind ?pairing (get-pairing (send ?main get-id)))
           ;; Try pairing first (only wines have pairs_with)
           (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?bsubtype) (member$ ?pairing ?b:pairs_with))))
           (if (eq (length$ ?bevs) 0) then
             ;; If wine, try alternative wine type
             (if (and (eq ?btype alcoholica) (or (eq ?bsubtype vino_blanco) (eq ?bsubtype vino_tinto))) then
               (bind ?alt-subtype (if (eq ?bsubtype vino_blanco) then vino_tinto else vino_blanco))
               (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?alt-subtype) (member$ ?pairing ?b:pairs_with))))
               (if (eq (length$ ?bevs) 0) then
                 (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?alt-subtype)))))))
             ;; For non-alcoholic or if wine pairing failed, just match type and subtype
             (if (eq (length$ ?bevs) 0) then
               (bind ?bevs (find-all-instances ((?b MAIN::beverage)) (and (eq ?b:type ?btype) (eq ?b:subtype ?bsubtype))))))
           (if (> (length$ ?bevs) 0) then
             ;; Use offset to vary beverage selection
             (bind ?bev-idx (+ 1 (mod (+ ?offset (- ?i 1)) (length$ ?bevs))))
             (bind ?bev (nth$ ?bev-idx ?bevs))
             (bind ?bebida (send ?bev get-id))
             (bind ?bebida-precio (send ?bev get-price))
           else
             (bind ?bebida "No disponible")
             (bind ?bebida-precio 0))
           (bind ?num-menus (+ ?num-menus 1))
           (bind ?raw-total (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           ;; Añadir precio del pastel de bodas si es necesario (también con recargo fuera de temporada)
           (if ?has-wedding-cake then
             (bind ?raw-total (+ ?raw-total ?wedding-cake-price)))
           (bind ?total-precio (* ?raw-total 1.1))
           (bind ?menu-cuisine (nth$ ?i ?menu-cuisines))
           (printout t "MENÚ " ?num-menus)
           (if (eq ?user-cuisine any) then
             (printout t " (Cocina: " ?menu-cuisine ")"))
           (printout t ":" crlf)
           (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
           (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
           (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
           ;; Añadir pastel de bodas si es necesario (con recargo fuera de temporada)
           (if ?has-wedding-cake then
             (printout t "Pastel de bodas: " (send ?wedding-cake-instance get-id) " - " (* ?wedding-cake-price 1.1) "€ (con recargo por fuera de temporada)" crlf))
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
         (printout t "   - Número de personas muy alto (>100 requiere platos fáciles)" crlf)))
     else
       (printout t crlf "⚠ No hay suficientes platos de todos los cursos para generar menús completos." crlf crlf)
       (printout t "Platos disponibles:" crlf)
       (printout t "  • Entrantes: " (length$ ?all-appetizers) crlf)
       (printout t "  • Platos principales: " (length$ ?all-mains) crlf)
       (printout t "  • Postres: " (length$ ?all-desserts) crlf crlf)
       (printout t "Sugerencias:" crlf)
       (printout t "  - Revise las restricciones dietéticas" crlf)
       (printout t "  - Verifique que hay ingredientes disponibles para la temporada seleccionada" crlf))))

  (focus SALIDA))
