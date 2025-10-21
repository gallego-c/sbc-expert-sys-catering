;;======================================================
;;;   Dishes Database
;;;
;;;     All dishes data organized by course
;;======================================================

(deffacts dishes-data
  ; ===== PRIMEROS PLATOS =====
  ; Platos normales
  (dish (id "ensalada_mixta") (course primero) 
        (ingredients lechuga tomate cebolla aceite) (diets vegetariana) (price 5.50))
  (dish (id "sopa_tomate") (course primero) 
        (ingredients tomate pan aceite) (diets vegetariana) (price 4.00))
  (dish (id "sopa_marisco") (course primero) 
        (ingredients gambas calamar pescado) (diets) (price 8.50))
  (dish (id "crema_calabacin") (course primero) 
        (ingredients calabacin patata cebolla) (diets vegetariana vegana) (price 4.50))
  
  ; Platos para bodas
  (dish (id "salmon_ahumado") (course primero) 
        (ingredients salmon limon eneldo) (diets) (price 12.00))
  (dish (id "foie_gourmet") (course primero) 
        (ingredients foie pan cebolla) (diets) (price 15.00))
  (dish (id "ensalada_queso_cabra") (course primero) 
        (ingredients lechuga queso_cabra nueces miel) (diets vegetariana) (price 9.00))
  
  ; Platos para congresos
  (dish (id "ensalada_cesar") (course primero) 
        (ingredients lechuga pollo queso salsa_cesar) (diets) (price 7.50))
  (dish (id "sopa_miso") (course primero) 
        (ingredients tofu alga miso) (diets vegetariana vegana) (price 5.00))
  
  ; Platos sin gluten
  (dish (id "ensalada_quinoa") (course primero) 
        (ingredients quinoa aguacate tomate pepino) (diets vegetariana vegana sin_gluten) (price 6.50))
  (dish (id "crema_espinacas") (course primero) 
        (ingredients espinacas patata cebolla) (diets vegetariana vegana sin_gluten) (price 4.50))
  
  ; Platos veganos
  (dish (id "gazpacho_andaluz") (course primero) 
        (ingredients tomate pepino pimiento ajo) (diets vegetariana vegana sin_gluten) (price 4.00))
  (dish (id "ensalada_lentejas") (course primero) 
        (ingredients lentejas cebolla pimiento zanahoria) (diets vegetariana vegana sin_gluten) (price 5.50))

  ; ===== SEGUNDOS PLATOS =====
  ; Platos normales
  (dish (id "merluza_plancha") (course segundo) 
        (ingredients merluza aceite limon) (diets) (price 12.00))
  (dish (id "pollo_asado") (course segundo) 
        (ingredients pollo patatas romero) (diets) (price 10.00))
  (dish (id "ternera_brasa") (course segundo) 
        (ingredients ternera patatas pimientos) (diets) (price 16.00))
  (dish (id "lubina_sal") (course segundo) 
        (ingredients lubina sal limon) (diets) (price 14.00))
  
  ; Platos para bodas
  (dish (id "solomillo_ternera") (course segundo) 
        (ingredients solomillo patatas salsa) (diets) (price 22.00))
  (dish (id "rodaballo_plancha") (course segundo) 
        (ingredients rodaballo verduras) (diets) (price 18.00))
  (dish (id "cordero_horno") (course segundo) 
        (ingredients cordero patatas romero) (diets) (price 20.00))
  
  ; Platos para congresos
  (dish (id "pasta_carbonara") (course segundo) 
        (ingredients pasta bacon queso huevo) (diets) (price 8.50))
  (dish (id "lasana_carne") (course segundo) 
        (ingredients pasta carne tomate queso) (diets) (price 9.00))
  
  ; Platos vegetarianos
  (dish (id "lasana_vegetal") (course segundo) 
        (ingredients pasta berenjena calabacin queso) (diets vegetariana) (price 8.00))
  (dish (id "risotto_champinones") (course segundo) 
        (ingredients arroz champinones queso) (diets vegetariana) (price 9.50))
  (dish (id "huevos_rotos") (course segundo) 
        (ingredients huevos patatas jamon) (diets) (price 7.50))
  
  ; Platos veganos
  (dish (id "curry_vegetal") (course segundo) 
        (ingredients leche_coco curcuma verduras) (diets vegetariana vegana) (price 8.50))
  (dish (id "tofu_salteado") (course segundo) 
        (ingredients tofu soja verduras) (diets vegetariana vegana) (price 7.50))
  (dish (id "hamburguesa_lentejas") (course segundo) 
        (ingredients lentejas avena cebolla) (diets vegetariana vegana) (price 6.50))
  
  ; Platos sin gluten
  (dish (id "pollo_plancha_sin_gluten") (course segundo) 
        (ingredients pollo patatas ensalada) (diets sin_gluten) (price 11.00))
  (dish (id "salmon_papillote") (course segundo) 
        (ingredients salmon verduras limon) (diets sin_gluten) (price 13.50))
  
  ; Platos sin lactosa
  (dish (id "pollo_curry_sin_lactosa") (course segundo) 
        (ingredients pollo leche_coco curcuma) (diets sin_lactosa) (price 10.50))
  (dish (id "pescado_horno_sin_lactosa") (course segundo) 
        (ingredients pescado patatas pimenton) (diets sin_lactosa) (price 12.00))

  ; ===== POSTRES =====
  ; Postres normales
  (dish (id "tarta_queso") (course postre) 
        (ingredients queso leche trigo huevo) (diets) (price 5.00))
  (dish (id "fruta_fresca") (course postre) 
        (ingredients fruta) (diets vegetariana vegana sin_gluten sin_lactosa) (price 3.00))
  (dish (id "flan_huevo") (course postre) 
        (ingredients huevo leche azucar) (diets) (price 4.00))
  (dish (id "helado_chocolate") (course postre) 
        (ingredients leche chocolate azucar) (diets) (price 4.50))
  
  ; Postres para bodas
  (dish (id "tarta_nupcial") (course postre) 
        (ingredients harina huevo mantequilla chocolate) (diets) (price 8.00))
  (dish (id "profiteroles") (course postre) 
        (ingredients harina huevo nata chocolate) (diets) (price 6.50))
  (dish (id "souffle_chocolate") (course postre) 
        (ingredients chocolate huevo azucar) (diets) (price 7.00))
  
  ; Postres para congresos
  (dish (id "mousse_chocolate") (course postre) 
        (ingredients chocolate huevo nata) (diets) (price 4.50))
  (dish (id "brownie_nueces") (course postre) 
        (ingredients chocolate harina nueces huevo) (diets) (price 5.00))
  
  ; Postres vegetarianos/veganos
  (dish (id "mousse_frutas") (course postre) 
        (ingredients fruta azucar agar) (diets vegetariana vegana) (price 4.00))
  (dish (id "tarta_manzana_vegana") (course postre) 
        (ingredients manzana harina_avena aceite) (diets vegetariana vegana) (price 5.50))
  (dish (id "helado_coco_vegano") (course postre) 
        (ingredients coco azucar vainilla) (diets vegetariana vegana sin_lactosa) (price 4.50))
  
  ; Postres sin gluten
  (dish (id "tarta_almendra") (course postre) 
        (ingredients almendra huevo azucar) (diets sin_gluten) (price 6.00))
  (dish (id "crema_catalana_sin_gluten") (course postre) 
        (ingredients leche huevo azucar maizena) (diets sin_gluten) (price 4.50))
  
  ; Postres sin lactosa
  (dish (id "sorbete_limon") (course postre) 
        (ingredients limon azucar agua) (diets vegetariana vegana sin_gluten sin_lactosa) (price 3.50))
  (dish (id "tarta_naranja_sin_lactosa") (course postre) 
        (ingredients naranja harina aceite) (diets vegetariana sin_lactosa) (price 5.00))
)
