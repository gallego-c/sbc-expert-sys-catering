;;======================================================
;;;   Beverages Database
;;;
;;;     All beverages data as COOL instances
;;======================================================

(deffunction MAIN::cargar-bebidas ()
  ; Bebidas no alcohólicas
  (make-instance b1 of MAIN::beverage (id "agua_mineral") (type no_alcoholica) (subtype agua) (price 1.50))
  (make-instance b2 of MAIN::beverage (id "refresco_cola") (type no_alcoholica) (subtype refresco) (price 3.00))
  (make-instance b3 of MAIN::beverage (id "zumo_naranja") (type no_alcoholica) (subtype refresco) (price 2.50))
  (make-instance b4 of MAIN::beverage (id "limonada") (type no_alcoholica) (subtype refresco) (price 2.80))
  (make-instance b5 of MAIN::beverage (id "agua_gas") (type no_alcoholica) (subtype agua) (price 1.80))
  
  ; Bebidas alcohólicas - Cervezas
  (make-instance b6 of MAIN::beverage (id "cerveza_rubia") (type alcoholica) (subtype cerveza) (price 3.50))
  (make-instance b7 of MAIN::beverage (id "cerveza_tostada") (type alcoholica) (subtype cerveza) (price 3.80))
  (make-instance b8 of MAIN::beverage (id "cerveza_artesanal") (type alcoholica) (subtype cerveza) (price 4.50))
  
  ; Bebidas alcohólicas - Vinos
  (make-instance b9 of MAIN::beverage (id "vino_tinto_crianza") (type alcoholica) (subtype vino) (price 5.00))
  (make-instance b10 of MAIN::beverage (id "vino_blanco_joven") (type alcoholica) (subtype vino) (price 4.00))
  (make-instance b11 of MAIN::beverage (id "vino_rosado") (type alcoholica) (subtype vino) (price 4.20))
  (make-instance b12 of MAIN::beverage (id "cava_brut") (type alcoholica) (subtype vino) (price 6.00))
  (make-instance b13 of MAIN::beverage (id "rioja_reserva") (type alcoholica) (subtype vino) (price 7.50))
)
