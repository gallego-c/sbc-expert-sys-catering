; Catering Expert System Batch Load File - COOL Version
; This file can be loaded with: (batch "load-all-final.bat")

(clear)
; Configuration (modules must be loaded first)
; Load module declarations first
(load "config/modules.clp")

; Configuration globals
(load "config/globals.clp")

; Core definitions (templates = classes in COOL)
(load "core/templates.clp")

; Knowledge base (data loaders) - load data creators before functions to avoid forward-reference errors
(load "knowledge/ingredients.clp")
(load "knowledge/dishes.clp")
(load "knowledge/beverages.clp")
(load "knowledge/data-loader.clp")

; Core functions (may call cargar-datos-sistema)
(load "core/functions.clp")

; Rules (by module execution order)
(load "rules/01-input-rules.clp")
(load "rules/02-filter-rules.clp")
(load "rules/03-recommendation-rules.clp")
(load "rules/04-finish-rules.clp")

; Initialize system
(reset)
(cargar-datos-sistema)
(make-instance start-inst of MAIN::start)
(focus ENTRADA)
(run)
