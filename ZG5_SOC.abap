*&---------------------------------------------------------------------*
*& Report ZG5_SOC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zg5_soc.

include: zg5_soc_top,
zg5_soc_f01.

start-of-selection.

  if p_soc is not initial. "Si el parametro sociedad tiene un valor
    perform f_recupero_datos using p_soc wa_soc
   changing gt_soc.
    perform f_actualizar_soc_se11 using gt_soc. "Entonces realizar perform con ruta de acceso
  else. "Sino
    if p_bukrs is not initial.
      perform f_alta_sociedades using gt_soc. "Utilizar la pantalla de seleccion
    endif.
  endif.

end-of-selection.