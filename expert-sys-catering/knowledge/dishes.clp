;;======================================================
;;;   Dishes Database
;;;
;;;     All dishes data as COOL instances
;;======================================================

(deffunction MAIN::cargar-platos ()
  ; Platos
  ;; Appetizers
  (make-instance d2 of MAIN::dish (id "spinach_artichoke_dip_R001_1") (course appetizer) (ingredients tomatoes olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 11.12))
  (make-instance d6 of MAIN::dish (id "stuffed_mushrooms_R001_5") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 12.28))
  (make-instance d12 of MAIN::dish (id "spinach_artichoke_dip_R001_11") (course appetizer) (ingredients tomatoes basil garlic) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.09))
  (make-instance d25 of MAIN::dish (id "bruschetta_R001_24") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 13.62))
  (make-instance d26 of MAIN::dish (id "spinach_artichoke_dip_R001_25") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 10.96))
  (make-instance d29 of MAIN::dish (id "spinach_artichoke_dip_R003_28") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.52))
  (make-instance d34 of MAIN::dish (id "spinach_artichoke_dip_R003_33") (course appetizer) (ingredients tomatoes basil garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.84))
  (make-instance d40 of MAIN::dish (id "spinach_artichoke_dip_R002_39") (course appetizer) (ingredients tomatoes garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 12.23))

  ;; Mains
  (make-instance d4 of MAIN::dish (id "chicken_alfredo_R003_3") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 29.55))
  (make-instance d5 of MAIN::dish (id "grilled_steak_R002_4") (course main) (ingredients chicken alfredo_sauce) (diets egg_free seafood_free nut_free) (price 17.73))
  (make-instance d9 of MAIN::dish (id "grilled_steak_R003_8") (course main) (ingredients chicken fettuccine alfredo_sauce) (diets egg_free seafood_free nut_free) (price 26.78))
  (make-instance d14 of MAIN::dish (id "chicken_alfredo_R001_13") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 18.46))
  (make-instance d18 of MAIN::dish (id "grilled_steak_R002_17") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 23.52))
  (make-instance d20 of MAIN::dish (id "grilled_steak_R002_19") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 28.90))
  (make-instance d30 of MAIN::dish (id "chicken_alfredo_R003_29") (course main) (ingredients chicken fettuccine alfredo_sauce parmesan) (diets egg_free seafood_free nut_free) (price 28.72))

  ;; Desserts
  (make-instance d3 of MAIN::dish (id "new_york_cheesecake_R003_2") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 18.66))
  (make-instance d8 of MAIN::dish (id "tiramisu_R003_7") (course dessert) (ingredients chocolate sugar) (diets vegetarian gluten_free seafood_free nut_free) (price 10.47))
  (make-instance d11 of MAIN::dish (id "chocolate_lava_cake_R001_10") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 16.08))
  (make-instance d16 of MAIN::dish (id "tiramisu_R003_15") (course dessert) (ingredients chocolate butter sugar) (diets vegetarian gluten_free seafood_free nut_free) (price 13.91))
  (make-instance d19 of MAIN::dish (id "tiramisu_R001_18") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.75))
  (make-instance d28 of MAIN::dish (id "chocolate_lava_cake_R003_27") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.11))
  (make-instance d32 of MAIN::dish (id "tiramisu_R003_31") (course dessert) (ingredients chocolate sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 13.25))
  (make-instance d35 of MAIN::dish (id "chocolate_lava_cake_R002_34") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 17.22))
  (make-instance d36 of MAIN::dish (id "tiramisu_R003_35") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 14.94))
  (make-instance d37 of MAIN::dish (id "new_york_cheesecake_R001_36") (course dessert) (ingredients chocolate butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 11.11))
  (make-instance d38 of MAIN::dish (id "new_york_cheesecake_R001_37") (course dessert) (ingredients butter sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 18.96))
  
  ;; NEW APPETIZERS - More variety with different seasons and diets
  (make-instance d41 of MAIN::dish (id "winter_salad") (course appetizer) (ingredients spinach carrot broccoli olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 9.50))
  (make-instance d42 of MAIN::dish (id "spring_asparagus") (course appetizer) (ingredients asparagus garlic olive_oil lemon) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 11.00))
  (make-instance d43 of MAIN::dish (id "summer_gazpacho") (course appetizer) (ingredients tomatoes cucumber pepper basil olive_oil garlic) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 8.75))
  (make-instance d44 of MAIN::dish (id "autumn_mushroom_soup") (course appetizer) (ingredients mushrooms onion garlic cream) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 10.25))
  (make-instance d45 of MAIN::dish (id "seafood_salad") (course appetizer) (ingredients shrimp lettuce lemon olive_oil) (diets lactose_free gluten_free egg_free nut_free) (price 14.50))
  (make-instance d46 of MAIN::dish (id "cheese_platter") (course appetizer) (ingredients cheese nuts honey) (diets vegetarian gluten_free egg_free seafood_free) (price 12.80))
  
  ;; NEW MAINS - More variety
  (make-instance d47 of MAIN::dish (id "grilled_salmon") (course main) (ingredients salmon asparagus lemon olive_oil) (diets lactose_free gluten_free egg_free nut_free) (price 24.50))
  (make-instance d48 of MAIN::dish (id "vegetarian_lasagna") (course main) (ingredients pasta tomatoes spinach cheese) (diets vegetarian egg_free seafood_free nut_free) (price 18.75))
  (make-instance d49 of MAIN::dish (id "beef_stew") (course main) (ingredients beef carrot potato onion) (diets lactose_free gluten_free egg_free seafood_free nut_free) (price 21.00))
  (make-instance d50 of MAIN::dish (id "vegan_curry") (course main) (ingredients cauliflower potato coconut_milk) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 16.50))
  (make-instance d51 of MAIN::dish (id "seafood_paella") (course main) (ingredients shrimp mussels prawns tomatoes garlic saffron) (diets lactose_free gluten_free egg_free nut_free) (price 26.00))
  (make-instance d52 of MAIN::dish (id "pork_tenderloin") (course main) (ingredients pork mushrooms rosemary) (diets lactose_free gluten_free egg_free seafood_free nut_free) (price 22.50))
  (make-instance d53 of MAIN::dish (id "tofu_stirfry") (course main) (ingredients tofu zucchini pepper soy) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 15.75))
  
  ;; NEW DESSERTS - More variety
  (make-instance d54 of MAIN::dish (id "fruit_salad") (course dessert) (ingredients strawberry apple orange) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 7.50))
  (make-instance d55 of MAIN::dish (id "apple_tart") (course dessert) (ingredients apple butter sugar flour) (diets vegetarian egg_free seafood_free nut_free) (price 9.25))
  (make-instance d56 of MAIN::dish (id "lemon_sorbet") (course dessert) (ingredients lemon sugar) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 6.00))
  (make-instance d57 of MAIN::dish (id "panna_cotta") (course dessert) (ingredients cream sugar berries) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 8.50))
  (make-instance d58 of MAIN::dish (id "chocolate_mousse") (course dessert) (ingredients chocolate cream eggs sugar) (diets vegetarian gluten_free seafood_free nut_free) (price 10.75))
  (make-instance d59 of MAIN::dish (id "banana_split") (course dessert) (ingredients banana chocolate cream nuts) (diets vegetarian gluten_free egg_free seafood_free) (price 9.80))
  (make-instance d60 of MAIN::dish (id "coconut_cake") (course dessert) (ingredients coconut flour eggs sugar butter vanilla) (diets vegetarian seafood_free nut_free) (price 11.50))
  
  ;; MORE APPETIZERS - Additional variety
  (make-instance d61 of MAIN::dish (id "artichoke_hearts") (course appetizer) (ingredients artichoke garlic olive_oil lemon) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 10.50))
  (make-instance d62 of MAIN::dish (id "caesar_salad") (course appetizer) (ingredients lettuce parmesan eggs bread) (diets vegetarian seafood_free nut_free) (price 9.75))
  (make-instance d63 of MAIN::dish (id "grilled_vegetables") (course appetizer) (ingredients zucchini eggplant pepper olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 11.25))
  (make-instance d64 of MAIN::dish (id "prawn_cocktail") (course appetizer) (ingredients prawns sauce) (diets lactose_free gluten_free egg_free nut_free) (price 13.50))
  (make-instance d65 of MAIN::dish (id "onion_soup") (course appetizer) (ingredients onion bread cheese) (diets vegetarian egg_free seafood_free nut_free) (price 8.90))
  (make-instance d66 of MAIN::dish (id "beet_salad") (course appetizer) (ingredients carrot lettuce nuts olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free) (price 10.00))
  (make-instance d67 of MAIN::dish (id "caprese_salad") (course appetizer) (ingredients tomatoes cheese basil olive_oil) (diets vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 9.50))
  (make-instance d68 of MAIN::dish (id "crab_cakes") (course appetizer) (ingredients crab eggs bread) (diets lactose_free nut_free) (price 15.00))
  (make-instance d69 of MAIN::dish (id "hummus_platter") (course appetizer) (ingredients garlic olive_oil vegetables) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 7.50))
  (make-instance d70 of MAIN::dish (id "stuffed_peppers") (course appetizer) (ingredients pepper tomatoes garlic olive_oil) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 10.80))
  
  ;; MORE MAINS - Additional variety
  (make-instance d71 of MAIN::dish (id "lamb_chops") (course main) (ingredients lamb rosemary garlic potato) (diets lactose_free gluten_free egg_free seafood_free nut_free) (price 28.50))
  (make-instance d72 of MAIN::dish (id "trout_almondine") (course main) (ingredients trout almonds butter lemon) (diets gluten_free egg_free seafood_free) (price 23.75))
  (make-instance d73 of MAIN::dish (id "eggplant_parmesan") (course main) (ingredients eggplant tomatoes cheese basil) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 17.25))
  (make-instance d74 of MAIN::dish (id "duck_confit") (course main) (ingredients duck potato mushrooms garlic olive_oil thyme) (diets lactose_free gluten_free egg_free seafood_free nut_free) (price 29.00))
  (make-instance d75 of MAIN::dish (id "vegetable_risotto") (course main) (ingredients zucchini asparagus parmesan) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 19.50))
  (make-instance d76 of MAIN::dish (id "tuna_steak") (course main) (ingredients tuna pepper olive_oil) (diets lactose_free gluten_free egg_free nut_free) (price 25.00))
  (make-instance d77 of MAIN::dish (id "mushroom_stroganoff") (course main) (ingredients mushrooms onion cream) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 16.75))
  (make-instance d78 of MAIN::dish (id "cod_provencal") (course main) (ingredients cod tomatoes basil garlic olive_oil) (diets lactose_free gluten_free egg_free nut_free) (price 22.50))
  (make-instance d79 of MAIN::dish (id "chicken_curry") (course main) (ingredients chicken coconut_milk cauliflower) (diets lactose_free gluten_free egg_free seafood_free nut_free) (price 20.25))
  (make-instance d80 of MAIN::dish (id "stuffed_zucchini") (course main) (ingredients zucchini tomatoes cheese) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 18.00))
  
  ;; MORE DESSERTS - Additional variety
  (make-instance d81 of MAIN::dish (id "strawberry_shortcake") (course dessert) (ingredients strawberry cream sugar flour eggs vanilla) (diets vegetarian seafood_free nut_free) (price 10.25))
  (make-instance d82 of MAIN::dish (id "creme_brulee") (course dessert) (ingredients cream eggs sugar) (diets vegetarian gluten_free seafood_free nut_free) (price 9.50))
  (make-instance d83 of MAIN::dish (id "orange_sorbet") (course dessert) (ingredients orange sugar) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 6.50))
  (make-instance d84 of MAIN::dish (id "raspberry_tart") (course dessert) (ingredients raspberry butter sugar flour) (diets vegetarian egg_free seafood_free nut_free) (price 10.00))
  (make-instance d85 of MAIN::dish (id "pecan_pie") (course dessert) (ingredients nuts eggs butter sugar) (diets vegetarian gluten_free seafood_free) (price 11.75))
  (make-instance d86 of MAIN::dish (id "mango_pudding") (course dessert) (ingredients mango) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 7.25))
  (make-instance d87 of MAIN::dish (id "vanilla_ice_cream") (course dessert) (ingredients milk cream sugar eggs) (diets vegetarian gluten_free seafood_free nut_free) (price 5.50))
  (make-instance d88 of MAIN::dish (id "berry_compote") (course dessert) (ingredients berries sugar) (diets vegan vegetarian lactose_free gluten_free egg_free seafood_free nut_free) (price 6.75))
  (make-instance d89 of MAIN::dish (id "caramel_flan") (course dessert) (ingredients milk eggs sugar) (diets vegetarian gluten_free seafood_free nut_free) (price 8.25))
  (make-instance d90 of MAIN::dish (id "chocolate_truffles") (course dessert) (ingredients chocolate cream butter) (diets vegetarian gluten_free egg_free seafood_free nut_free) (price 12.00))
  
)


