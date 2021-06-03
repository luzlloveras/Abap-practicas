*&---------------------------------------------------------------------*
*& Report ZG5_MA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zg5_ma.
include: zg5_ma_top.
include zg5_ma_f01.

start-of-selection.
  if so1 eq 'X'.
    perform alta_de_materiales.
  endif.
  if so2 eq 'X'.
    perform baja_de_materiales.
  endif.
  if so3 eq 'X'.
    perform modificacion_de_material.
  endif.

end-of-selection.