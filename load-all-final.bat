; Catering Expert System Batch Load File
; This file can be loaded with: (batch "load-all.bat")

(load "config/globals.clp")
(load "core/templates.clp")
(load "core/functions.clp")
(load "knowledge/dishes.clp")
(load "knowledge/beverages.clp")
(load "knowledge/initial-facts.clp")
(load "rules/01-input-rules.clp")
(load "rules/02-filter-rules.clp")
(load "rules/03-recommendation-rules.clp")
(load "rules/04-finish-rules.clp")
(reset)
