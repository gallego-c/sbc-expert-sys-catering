;;======================================================
;;;   Catering Expert System - MAIN
;;;
;;;     Entry point that loads all system modules
;;;     
;;;     CLIPS Version 6.4
;;;
;;;     To execute: 
;;;       (batch "load-all-final.bat")
;;;       (assert (start))
;;;       (run)
;;;
;;;     Or use: (chat)
;;======================================================

;; Load all modules
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
