;;======================================================
;;;   Catering Expert System - MAIN (COOL Version)
;;;
;;;     Entry point that loads all system modules
;;;     Uses COOL (CLIPS Object-Oriented Language)
;;;     
;;;     CLIPS Version 6.4
;;;
;;;     To execute from CLIPS: 
;;;       (batch "load-all-final.bat")
;;;
;;;     Or load manually:
;;;       (load "main.clp")
;;;       (reset)
;;;       (cargar-datos-sistema)
;;;       (make-instance start-inst of MAIN::start)
;;;       (focus ENTRADA)
;;;       (run)
;;======================================================

;; Configuration (modules must be loaded first)
(load "config/globals.clp")

;; Core definitions (templates = classes in COOL)
(load "core/templates.clp")
(load "core/functions.clp")

;; Knowledge base (data loaders)
(load "knowledge/ingredients.clp")
(load "knowledge/dishes.clp")
(load "knowledge/beverages.clp")
(load "knowledge/data-loader.clp")

;; Rules (by module execution order)
(load "rules/01-input-rules.clp")
(load "rules/02-filter-rules.clp")
(load "rules/03-recommendation-rules.clp")
(load "rules/04-finish-rules.clp")
