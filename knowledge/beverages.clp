;;======================================================
;;;   Beverages Database
;;;
;;;     All beverages data
;;======================================================

(deffacts beverages-data
  ; ===== BEBIDAS =====
  ; Bebidas no alcohólicas
  (beverage (id "agua_mineral") (type no_alcoholica) (subtype agua) (price 1.50))
  (beverage (id "refresco_cola") (type no_alcoholica) (subtype refresco) (price 3.00))
  (beverage (id "zumo_naranja") (type no_alcoholica) (subtype refresco) (price 2.50))
  (beverage (id "limonada") (type no_alcoholica) (subtype refresco) (price 2.80))
  (beverage (id "agua_gas") (type no_alcoholica) (subtype agua) (price 1.80))
  
  ; Bebidas alcohólicas - Cervezas
  (beverage (id "cerveza_rubia") (type alcoholica) (subtype cerveza) (price 3.50))
  (beverage (id "cerveza_tostada") (type alcoholica) (subtype cerveza) (price 3.80))
  (beverage (id "cerveza_artesanal") (type alcoholica) (subtype cerveza) (price 4.50))
  
  ; Bebidas alcohólicas - Vinos
  (beverage (id "vino_tinto_crianza") (type alcoholica) (subtype vino) (price 5.00))
  (beverage (id "vino_blanco_joven") (type alcoholica) (subtype vino) (price 4.00))
  (beverage (id "vino_rosado") (type alcoholica) (subtype vino) (price 4.20))
  (beverage (id "cava_brut") (type alcoholica) (subtype vino) (price 6.00))
  (beverage (id "rioja_reserva") (type alcoholica) (subtype vino) (price 7.50))
)
