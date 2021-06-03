

*&---------------------------------------------------------------------*
*& Include          ZG5_OC_TOP
*&---------------------------------------------------------------------*

*----------------- Parámetros de pantalla -----------------------------

parameters: p_ebeln type zg5_ebeln obligatory,
p_matnr type zg5_matnr,
p_werks type zg5_werks_d,
p_zmeng type zg5_zmeng,
p_meins type zg5_meins,
p_vbeln type zg5_vbeln_f,
p_lifnr type zg5_lifnr.

*---------------------- ORDEN_COMPRA ( Types | Types Tables | Tabla global | Workin Area ) ---------------------------
*Declaro type
types: begin of ty_oc,
         ebeln type zg5_ebeln,
         matnr type zg5_matnr,
         werks type zg5_werks_d,
         zmeng type zg5_dzmeng,
         meins  type zg5_meins,
         vbeln_f type zg5_vbeln_vf,
         lifnr type zg5_lifnr,
       end of ty_oc.

*Declaro type table
types: tt_oc type standard table of ty_oc.

*Declaro tabla global y workin area
data gt_oc type tt_oc.
data wa_oc type ty_oc.



*------------- BDC TAB -----------
data: wa_bdc_tab type bdcdata,
bdc_tab    type table of bdcdata.