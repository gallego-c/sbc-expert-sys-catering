;;======================================================
;;;   Utility Functions
;;;
;;;     Reusable helper functions
;;======================================================

;;****************
;;* FUNCTIONS    *
;;****************

(deffunction MAIN::ask (?prompt $?allowed-values)
  (printout t ?prompt)
  (if (> (length$ ?allowed-values) 0) then
    (printout t " (" (implode$ ?allowed-values) ")"))
  (printout t ": ")
  (bind ?response (read))
  (if (and (> (length$ ?allowed-values) 0) (not (member$ ?response ?allowed-values))) then
    (printout t "Respuesta no válida. Intente nuevamente." crlf)
    (return (ask ?prompt ?allowed-values)))
  ?response)

(deffunction MAIN::askline (?prompt)
  (printout t ?prompt crlf "> ")
  (readline))

(deffunction MAIN::parse-list (?input)
  (if (eq ?input "") then
    (return (create$))
  else
    (bind ?lower (lowcase ?input))
    (return (explode$ ?lower))))

(deffunction MAIN::first-fact (?fact-list)
  (if (> (length$ ?fact-list) 0) then
    (return (nth$ 1 ?fact-list))
  else
    (return nil)))

(deffunction MAIN::es-plato-valido (?dish-id $?dietas-usuario)
  (bind ?dish-objs (find-all-instances ((?d MAIN::dish)) (eq (send ?d get-id) ?dish-id)))
  (if (> (length$ ?dish-objs) 0) then
    (bind ?dish-obj (nth$ 1 ?dish-objs))
    (bind ?dish-diets (send ?dish-obj get-diet))
    (if (or (eq (length$ ?dietas-usuario) 0)
            (subsetp ?dietas-usuario ?dish-diets)) then
      (return TRUE)
    else
      (return FALSE))
  else
    (return FALSE)))


(deffunction MAIN::contar-ingredientes (?dish-id)
  "Returns the number of ingredients in a dish."
  (bind ?dish-objs (find-all-instances ((?d MAIN::dish)) (eq (send ?d get-id) ?dish-id)))
  (if (> (length$ ?dish-objs) 0) then
    (bind ?dish-obj (nth$ 1 ?dish-objs))
    (bind ?ingredients (send ?dish-obj get-ingredients))
    (return (length$ ?ingredients))
  else
    (return 0)))


 (deffunction MAIN::ingredientes-fuera-de-temporada (?dish-id ?event-season)
  "Returns TRUE if the dish contains any ingredient that is NOT in season for ?event-season."
  ;; If event season is 'any', all dishes are in season
  (if (eq ?event-season any) then (return FALSE))
  (bind ?dish-objs (find-all-instances ((?d MAIN::dish)) (eq (send ?d get-id) ?dish-id)))
  (if (eq ?dish-objs nil) then (return FALSE))
  (bind ?dish (nth$ 1 ?dish-objs))
  (bind ?ings (send ?dish get-ingredients))
  (foreach ?ing ?ings
    ;; Convert symbol to string for comparison
    (bind ?ing-str (str-cat ?ing))
    (bind ?ic (find-all-instances ((?c MAIN::ingredient-category)) (eq ?c:ingredient ?ing-str)))
    (if (> (length$ ?ic) 0) then
      (bind ?icat (nth$ 1 ?ic))
      (bind ?seasons (send ?icat get-seasons))
      ;; If no seasons specified, treat as 'any' (always in season)
      (if (eq (length$ ?seasons) 0) then (bind ?seasons (create$ any)))
      ;; treat symbol any or year_round as always in season
      (if (and (not (member$ any ?seasons)) (not (member$ year_round ?seasons)) (not (member$ ?event-season ?seasons))) then
        (return TRUE))))
  FALSE)


(deffunction MAIN::normalize-season (?season)
  "Normalize user-entered season tokens (Spanish/English) to internal season symbols." 
  (if (or (eq ?season any) (eq ?season year_round) (eq ?season spring) (eq ?season summer) (eq ?season autumn) (eq ?season winter)) then
    (return ?season))
  ;; Convert symbol to string, then lowercase
  (bind ?s (lowcase (str-cat ?season)))
  (if (eq ?s "otono") then (return autumn))
  (if (eq ?s "otoño") then (return autumn))
  (if (eq ?s "primavera") then (return spring))
  (if (eq ?s "verano") then (return summer))
  (if (eq ?s "invierno") then (return winter))
  (if (eq ?s "autumn") then (return autumn))
  (if (eq ?s "spring") then (return spring))
  (if (eq ?s "summer") then (return summer))
  (if (eq ?s "winter") then (return winter))
  (return any))

(deffunction MAIN::get-pairing (?dish-id)
  (bind ?dish-objs (find-all-instances ((?d MAIN::dish)) (eq (send ?d get-id) ?dish-id)))
  (if (> (length$ ?dish-objs) 0) then
    (bind ?dish (nth$ 1 ?dish-objs))
    (bind ?ings (send ?dish get-ingredients))
    (bind ?has-meat FALSE)
    (bind ?has-fish FALSE)
    (foreach ?ing ?ings
      ;; Convert symbol to string for comparison
      (bind ?ing-str (str-cat ?ing))
      (bind ?ic (find-all-instances ((?c MAIN::ingredient-category)) (eq ?c:ingredient ?ing-str)))
      (if (> (length$ ?ic) 0) then
        (bind ?cat (send (nth$ 1 ?ic) get-category))
        (if (eq ?cat meat) then (bind ?has-meat TRUE))
        (if (or (eq ?cat fish) (eq ?cat seafood)) then (bind ?has-fish TRUE))))
    (if ?has-meat then (return carne))
    (if ?has-fish then (return pescado))
    (return any))
  (return any))

(deffunction MAIN::get-dish-cuisine (?dish-id)
  "Returns the cuisine type of a dish given its ID."
  (bind ?dish-objs (find-all-instances ((?d MAIN::dish)) (eq (send ?d get-id) ?dish-id)))
  (if (> (length$ ?dish-objs) 0) then
    (bind ?dish (nth$ 1 ?dish-objs))
    (return (send ?dish get-cuisine))
  else
    (return any)))

(deffunction MAIN::cuisine-belongs-to-region (?cuisine ?region)
  "Returns TRUE if a cuisine belongs to the specified region."
  (if (eq ?region any) then (return TRUE))
  
  ;; European cuisines
  (if (eq ?region europea) then
    (if (or (eq ?cuisine italian) (eq ?cuisine french) (eq ?cuisine spanish) 
            (eq ?cuisine greek) (eq ?cuisine british) (eq ?cuisine irish)) then
      (return TRUE)
    else
      (return FALSE)))
  
  ;; Asian cuisines
  (if (eq ?region asiatica) then
    (if (or (eq ?cuisine chinese) (eq ?cuisine japanese) (eq ?cuisine thai) 
            (eq ?cuisine korean) (eq ?cuisine indian) (eq ?cuisine vietnamese) 
            (eq ?cuisine filipino) (eq ?cuisine asian)) then
      (return TRUE)
    else
      (return FALSE)))
  
  ;; Latin American cuisines
  (if (eq ?region latinoamericana) then
    (if (or (eq ?cuisine mexican) (eq ?cuisine peruvian) (eq ?cuisine brazilian) 
            (eq ?cuisine cajun_creole) (eq ?cuisine jamaican) (eq ?cuisine latin)) then
      (return TRUE)
    else
      (return FALSE)))
  
  ;; Mediterranean cuisines
  (if (eq ?region mediterranea) then
    (if (or (eq ?cuisine italian) (eq ?cuisine spanish) (eq ?cuisine greek) 
            (eq ?cuisine moroccan) (eq ?cuisine mediterranean)) then
      (return TRUE)
    else
      (return FALSE)))
  
  ;; Other cuisines
  (if (eq ?region otras) then
    (if (or (eq ?cuisine american) (eq ?cuisine british) (eq ?cuisine southern_us) 
            (eq ?cuisine fusion) (eq ?cuisine tropical) (eq ?cuisine asian)) then
      (return TRUE)
    else
      (return FALSE)))
  
  (return FALSE))

(deffunction MAIN::chat ()
  (reset)
  (MAIN::cargar-datos-sistema)
  (make-instance start-inst of MAIN::start)
  (focus ENTRADA)
  (run))
