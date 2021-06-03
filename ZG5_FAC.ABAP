*&---------------------------------------------------------------------*
*& Report ZG5_FAC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZG5_FAC.
*&----------------------------------DECLARACIONES GLOBALES------------------------------*

include:
ZG5_FAC_TOP, "DECLARACIONES GLOBALES
ZG5_OC_01, "ORDEN DE COMPRA
ZG5_OV_02. "ORDEN DE VENTA

*&----------------------------------ESTRUCTURA RADIOBUTTOMS------------------------------*
at selection-screen output.

  if p01 = 'X'. "verificar nombre siempre
    loop at screen.
      if screen-group1 = 'MD2'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  else.
    loop at screen.
      if screen-group1 = 'MD1'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
  endif.

*&----------------------------------EJECUCION DE CODIGO-----------------------------*

start-of-selection.

if p01 = 'X'.
PERFORM cargar_orden_compra.


endif.


if p02 = 'X'.
PERFORM cargar_orden_venta.

endif.

end-of-selection.