*&---------------------------------------------------------------------*
*& Report ZG5_OC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZG5_OC.

include: ZG5_OC_top,
ZG5_OC_f01.

start-of-selection.

  perform f_validaciones using p_ebeln p_matnr p_werks p_zmeng p_meins p_vbeln p_lifnr.

end-of-selection.