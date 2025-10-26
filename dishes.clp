;;======================================================
;;;   Dishes Database
;;;
;;;     All dishes data as COOL instances
;;======================================================

(deffunction MAIN::cargar-platos ()
  ; Platos
  ;; Appetizers
  (make-instance d2 of MAIN::dish (id "spinach_artichoke_dip_R001_1") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 11.12))
  (make-instance d6 of MAIN::dish (id "stuffed_mushrooms_R001_5") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 12.28))
  (make-instance d12 of MAIN::dish (id "spinach_artichoke_dip_R001_11") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.09))
  (make-instance d25 of MAIN::dish (id "bruschetta_R001_24") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 13.62))
  (make-instance d26 of MAIN::dish (id "spinach_artichoke_dip_R001_25") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 10.96))
  (make-instance d29 of MAIN::dish (id "spinach_artichoke_dip_R003_28") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.52))
  (make-instance d34 of MAIN::dish (id "spinach_artichoke_dip_R003_33") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.84))
  (make-instance d40 of MAIN::dish (id "spinach_artichoke_dip_R002_39") (course appetizer) (ingredients tomatoes garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 12.23))

  ;; Mains
  (make-instance d4 of MAIN::dish (id "chicken_alfredo_R003_3") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 29.55))
  (make-instance d5 of MAIN::dish (id "grilled_steak_R002_4") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 17.73))
  (make-instance d9 of MAIN::dish (id "grilled_steak_R003_8") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 26.78))
  (make-instance d14 of MAIN::dish (id "chicken_alfredo_R001_13") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 18.46))
  (make-instance d18 of MAIN::dish (id "grilled_steak_R002_17") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 23.52))
  (make-instance d20 of MAIN::dish (id "grilled_steak_R002_19") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 28.90))
  (make-instance d30 of MAIN::dish (id "chicken_alfredo_R003_29") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 28.72))

  ;; Desserts
  (make-instance d3 of MAIN::dish (id "new_york_cheesecake_R003_2") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 18.66))
  (make-instance d8 of MAIN::dish (id "tiramisu_R003_7") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 10.47))
  (make-instance d11 of MAIN::dish (id "chocolate_lava_cake_R001_10") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 16.08))
  (make-instance d16 of MAIN::dish (id "tiramisu_R003_15") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 13.91))
  (make-instance d19 of MAIN::dish (id "tiramisu_R001_18") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.75))
  (make-instance d28 of MAIN::dish (id "chocolate_lava_cake_R003_27") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.11))
  (make-instance d32 of MAIN::dish (id "tiramisu_R003_31") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 13.25))
  (make-instance d35 of MAIN::dish (id "chocolate_lava_cake_R002_34") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.22))
  (make-instance d36 of MAIN::dish (id "tiramisu_R003_35") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 14.94))
  (make-instance d37 of MAIN::dish (id "new_york_cheesecake_R001_36") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 11.11))
  (make-instance d38 of MAIN::dish (id "new_york_cheesecake_R001_37") (course dessert) (ingredients butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 18.96))
  
)
