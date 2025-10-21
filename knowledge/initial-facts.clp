;;======================================================
;;;   Initial Facts
;;;
;;;     Initial system state
;;======================================================

(deffacts initial-state
  ; Perfil de usuario por defecto
  (user-profile (season any) (event any) (diet)
                (wants-beverage no) (beverage-type any) (specific-beverage any))
)
