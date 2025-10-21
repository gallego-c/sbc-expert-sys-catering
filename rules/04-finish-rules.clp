;;======================================================
;;;   Finish Rules
;;;
;;;     System completion and cleanup
;;======================================================

(defrule finish
  (declare (salience -1000))
  ?u <- (user-profile)
  =>
  (printout t crlf "=== FIN DEL SISTEMA ===" crlf)
  (halt))
