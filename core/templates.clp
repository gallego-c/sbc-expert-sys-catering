;;======================================================
;;;   Data Templates
;;;
;;;     Defines all templates for the catering system
;;======================================================

;;****************
;;* TEMPLATES    *
;;****************

(deftemplate dish
  (slot id)
  (slot course)
  (multislot ingredients)
  (multislot diets)
  (slot price (type FLOAT)))

(deftemplate beverage
  (slot id)
  (slot type) ; alcoholica / no_alcoholica
  (slot subtype) ; agua/refresco/cerveza/vino
  (slot price (type FLOAT)))

(deftemplate user-profile
  (slot season (default any))
  (slot event (default any))
  (multislot diet)
  (slot wants-beverage (default no))
  (slot beverage-type (default any))
  (slot specific-beverage (default any)))

(deftemplate start)
