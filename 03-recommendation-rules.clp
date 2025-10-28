;;======================================================
;;;   Recommendation Rules - RECOMENDACION_MENUS Module
;;;
;;;     Generate complete menu recommendations
;;======================================================

 (defrule RECOMENDACION_MENUS::generar-menus-basicos
   ?profile <- (object (is-a MAIN::user-profile) (diet $?ud) (beverage-type ?btype) (specific-beverage ?bsubtype))
   (object (is-a MAIN::filtrado-completado))
   (not (object (is-a MAIN::menu-shown)))
   =>
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
   (if (and (> (length$ ?in-appetizers) 0) (> (length$ ?in-mains) 0) (> (length$ ?in-desserts) 0)) then
     (bind ?max-in (min ?max-menus (min (length$ ?in-appetizers) (min (length$ ?in-mains) (length$ ?in-desserts)))))
     (printout t "[DEBUG] Building " ?max-in " in-season menu(s)..." crlf)
     (loop-for-count (?i 1 ?max-in) do
       (bind ?app-inst (nth$ ?i ?in-appetizers))
       (bind ?main-inst (nth$ ?i ?in-mains))
       (bind ?dessert-inst (nth$ ?i ?in-desserts))
       (printout t "[DEBUG] Menu " ?i ": " (send ?app-inst get-id) " + " (send ?main-inst get-id) " + " (send ?dessert-inst get-id) crlf)
       (bind ?menu-appetizers (insert$ ?menu-appetizers (+ (length$ ?menu-appetizers) 1) ?app-inst))
       (bind ?menu-mains (insert$ ?menu-mains (+ (length$ ?menu-mains) 1) ?main-inst))
       (bind ?menu-desserts (insert$ ?menu-desserts (+ (length$ ?menu-desserts) 1) ?dessert-inst))
       (bind ?menu-in-season (insert$ ?menu-in-season (+ (length$ ?menu-in-season) 1) TRUE)))
     (printout t "[DEBUG] Total in-season menus built: " (length$ ?menu-appetizers) crlf))

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
         ;; Only add if it's out of season
         (if ?is-out-of-season then
           (bind ?menu-appetizers (insert$ ?menu-appetizers (+ (length$ ?menu-appetizers) 1) ?app))
           (bind ?menu-mains (insert$ ?menu-mains (+ (length$ ?menu-mains) 1) ?main))
           (bind ?menu-desserts (insert$ ?menu-desserts (+ (length$ ?menu-desserts) 1) ?dessert))
           (bind ?menu-in-season (insert$ ?menu-in-season (+ (length$ ?menu-in-season) 1) FALSE))
           (bind ?added (+ ?added 1))))))

   ;; Get wedding cake if event is a wedding
  (bind ?wedding-cake nil)
  (if (eq (send ?profile get-event) wedding) then
    (bind ?wedding-cake (find-instance ((?d MAIN::plato-valido)) (eq ?d:course wedding-dessert))))

  ;; Print all menus (in-season first, then out-of-season with surcharge)
  (bind ?total-menus (length$ ?menu-appetizers))
  (if (> ?total-menus 0) then
    (bind ?in-season-count 0)
    (bind ?out-season-count 0)
    ;; Count in-season vs out-of-season
    (loop-for-count (?i 1 ?total-menus) do
      (if (nth$ ?i ?menu-in-season) then
        (bind ?in-season-count (+ ?in-season-count 1))
      else
        (bind ?out-season-count (+ ?out-season-count 1))))
     
     ;; Print in-season menus
     (if (> ?in-season-count 0) then
       (printout t "=== MENÚS COMPLETOS (EN TEMPORADA) ===" crlf crlf)
       (loop-for-count (?i 1 ?total-menus) do
         (if (nth$ ?i ?menu-in-season) then
           (bind ?app (nth$ ?i ?menu-appetizers))
           (bind ?main (nth$ ?i ?menu-mains))
           (bind ?dessert (nth$ ?i ?menu-desserts))
           (bind ?num-menus (+ ?num-menus 1))
           (bind ?total-precio (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           (if ?wedding-cake then
             (bind ?total-precio (+ ?total-precio (send ?wedding-cake get-price))))
           (printout t "MENÚ " ?num-menus ":" crlf)
           (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
           (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
           (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
           (if ?wedding-cake then
             (printout t "Tarta Nupcial: " (send ?wedding-cake get-id) " - " (send ?wedding-cake get-price) "€" crlf))
           (printout t "Bebida: " ?bebida " - " ?bebida-precio "€" crlf)
           (printout t "PRECIO TOTAL: " ?total-precio "€" crlf crlf)))
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
           (bind ?num-menus (+ ?num-menus 1))
           (bind ?raw-total (+ ?bebida-precio (send ?app get-price) (send ?main get-price) (send ?dessert get-price)))
           (if ?wedding-cake then
             (bind ?raw-total (+ ?raw-total (send ?wedding-cake get-price))))
           (bind ?total-precio (* ?raw-total 1.1))
           (printout t "MENÚ " ?num-menus ":" crlf)
           (printout t "Entrante: " (send ?app get-id) " - " (send ?app get-price) "€" crlf)
           (printout t "Principal: " (send ?main get-id) " - " (send ?main get-price) "€" crlf)
           (printout t "Postre: " (send ?dessert get-id) " - " (send ?dessert get-price) "€" crlf)
           (if ?wedding-cake then
             (printout t "Tarta Nupcial: " (send ?wedding-cake get-id) " - " (send ?wedding-cake get-price) "€" crlf))
           (printout t "Bebida: " ?bebida " - " ?bebida-precio "€" crlf)
           (printout t "PRECIO TOTAL (con +10% por fuera de temporada): " ?total-precio "€" crlf crlf)))
       (bind ?printed TRUE)))
   
   ;; Fallback: no complete menus available
   (if (not ?printed) then
     (printout t "No hay suficientes platos de todos los cursos para generar menús completos." crlf)
     (printout t "Platos disponibles por categoría:" crlf)
     (if (> (length$ ?all-appetizers) 0) then (printout t crlf "ENTRANTES:" crlf) (progn$ (?app ?all-appetizers) (printout t "  - " (send ?app get-id) " (" (send ?app get-price) "€)" crlf)))
     (if (> (length$ ?all-mains) 0) then (printout t crlf "PLATOS PRINCIPALES:" crlf) (progn$ (?main ?all-mains) (printout t "  - " (send ?main get-id) " (" (send ?main get-price) "€)" crlf)))
     (if (> (length$ ?all-desserts) 0) then (printout t crlf "POSTRES:" crlf) (progn$ (?dessert ?all-desserts) (printout t "  - " (send ?dessert get-id) " (" (send ?dessert get-price) "€)" crlf))))

  (focus SALIDA))
