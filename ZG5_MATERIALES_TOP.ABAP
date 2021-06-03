*&---------------------------------------------------------------------*
*& Include          ZG5_MATERIALES_TOP
*&---------------------------------------------------------------------*

*------------------------ Parametro para levantar archivo -------------------------
parameters: p_mate type localfile.

*---------------------- MATERIALES ( Types | Types Tables | Tabla global | Workin Area ) ----------
*Declaro type
types: begin of ty_materiales,
         matnr  type zg5_matnr,
         werks  type zg5_werks_d,
         labst  type string,"zg5_labst,
         meins type zg5_meins,
         maktx type zg5_maktx,
       end of ty_materiales.

*Declaro type table
types: tt_materiales type standard table of ty_materiales.

*Declaro tabla global y workin area
data gt_materiales type tt_materiales.
data wa_materiales type ty_materiales.

*------------------------ Estructura con los datos del programa --------------------------------
data: bdc_tab    type table of bdcdata,
      wa_bdc_tab type bdcdata.

*Mensajes de error
data: itab type table of bdcmsgcoll.