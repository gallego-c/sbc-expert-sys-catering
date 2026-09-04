;;======================================================
;;;   Finish Rules - SALIDA Module
;;;
;;;     System completion and farewell
;;======================================================

(defrule SALIDA::mostrar-fin
   (object (is-a MAIN::menu-shown))
   =>
   (printout t crlf "========================================" crlf)
   (printout t "   Gracias por usar el sistema de" crlf)
   (printout t "   recomendación de menús" crlf)
   (printout t "========================================" crlf)
   (printout t crlf "¡Que aproveche!" crlf crlf)
   (halt))
