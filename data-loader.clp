;;======================================================
;;;   Data Loader
;;;
;;;     Central function to load all system data
;;======================================================

(deffunction MAIN::cargar-datos-sistema ()
  (MAIN::cargar-ingredientes)
  (MAIN::cargar-platos)
  (MAIN::cargar-bebidas)
  (printout t "Datos del sistema cargados correctamente." crlf))
