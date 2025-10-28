(defclass MAIN::user-profile
  (is-a USER)
  (role concrete)
  (slot season (default any))
  (slot event (default any))
  (slot num-people (type INTEGER) (default 0))
  (slot budget (type FLOAT) (default 0.0))
  (slot cuisine-region (default any))
  (slot cuisine (default any))
  (multislot diet (default))
  (slot wants-beverage (default no))
  (slot beverage-type (default any))
  (slot specific-beverage (default any)))

(defclass MAIN::dish
  (is-a USER)
  (role concrete)
  (slot id)
  (slot course)
  (slot cuisine (default international))
  (slot difficulty (default medium))
  (multislot diet (default))
  (multislot ingredients)
  (slot price (type FLOAT)))

(defclass MAIN::ingredient-category
  (is-a USER)
  (role concrete)
  (slot ingredient)
  (slot category)
  (multislot seasons (default)))

(defclass MAIN::beverage
  (is-a USER)
  (role concrete)
  (slot id)
  (slot type)
  (slot subtype)
  (slot price (type FLOAT))
  (multislot pairs_with (default)))

(defclass MAIN::filtrado-completado
  (is-a USER)
  (role concrete))

(defclass MAIN::plato-valido
  (is-a USER)
  (role concrete)
  (slot id)
  (slot course)
  (slot price (type FLOAT)))

(defclass MAIN::menu-shown
  (is-a USER)
  (role concrete))

(defclass MAIN::pregunta-mas-menus
  (is-a USER)
  (role concrete))

(defclass MAIN::start
  (is-a USER)
  (role concrete))

(defclass MAIN::datos-basicos-capturados
  (is-a USER)
  (role concrete))

(defclass MAIN::dietas-capturadas
  (is-a USER)
  (role concrete))

(defclass MAIN::bebidas-configuradas
  (is-a USER)
  (role concrete))

(defclass MAIN::region-cocina-capturada
  (is-a USER)
  (role concrete))

(defclass MAIN::cocina-especifica-capturada
  (is-a USER)
  (role concrete))
