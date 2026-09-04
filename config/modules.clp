;;======================================================
;;;   Module Definitions
;;;
;;;     Defines all system modules for execution flow
;;======================================================

;;****************
;;* MODULES      *
;;****************

(defmodule MAIN
  (export ?ALL))

(defmodule ENTRADA (import MAIN ?ALL))
(defmodule PERFIL_DATOS (import MAIN ?ALL))
(defmodule PERFIL_RESTRICCIONES (import MAIN ?ALL))
(defmodule PERFIL_APLICAR_RESTRICCIONES (import MAIN ?ALL))
(defmodule PERFIL_COCINA (import MAIN ?ALL))
(defmodule PERFIL_BEBIDAS (import MAIN ?ALL))
(defmodule PERFIL_VALIDACION (import MAIN ?ALL))
(defmodule RECOMENDACION_FILTRADO (import MAIN ?ALL))
(defmodule RECOMENDACION_MENUS (import MAIN ?ALL))
(defmodule SALIDA (import MAIN ?ALL))
