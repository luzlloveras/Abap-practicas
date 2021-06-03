*&---------------------------------------------------------------------*
*& Report ZG5_MATERIALES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZG5_MATERIALES.


include: zg5_materiales_top,
zg5_materiales_f01.

start-of-selection.

  perform f_recupero_datos using p_mate wa_materiales
changing gt_materiales.

end-of-selection.