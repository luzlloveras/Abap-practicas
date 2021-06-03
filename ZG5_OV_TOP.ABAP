*&---------------------------------------------------------------------*
*& Include          ZG5_OV_TOP
*&---------------------------------------------------------------------*

*---------------------------------------- Parametros ---------------------------
data: v_ov      type string,
      wa_string type string.

*---------------------- ORDEN DE VENTA ( Types | Types Tables | Tabla global | Workin Area ) ---------------------------
*Declaro type
types: begin of ty_ov,
         vbeln   type zg5_vbeln_va,
         matnr   type zg5_matnr,
         werks   type zg5_werks_d,
         zmeng   type zg5_dzmeng,
         meins   type zg5_meins,
         vbeln_f type zg5_vbeln_vf,
         kunnr   type zg5_kunnr,
       end of ty_ov.

*Declaro type table
types: tt_ov type standard table of ty_ov.

*Declaro tabla global y workin area
data gt_ov type tt_ov.
data wa_ov type ty_ov.
data: bdc_tab     TYPE TABLE OF bdcdata,
      wa_bdc_tab  TYPE bdcdata.

*declaro parametros
parameters: p_vbeln type zg5_vbeln_va OBLIGATORY,
            p_MATNR type zg5_matnr,
            p_WERKS type zg5_werks_d,
            p_ZMENG type zg5_zmeng,
            p_MEINS type zg5_meins,
            p_vF type zg5_vbeln_vf,
            p_KUNNR type kunnr.