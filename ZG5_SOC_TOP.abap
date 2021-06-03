*&---------------------------------------------------------------------*
*& Include          ZG5_SOC_TOP
*&---------------------------------------------------------------------*

*------------------------ Parametro para levantar archivo -----------------------------

parameters: p_soc type localfile.

*----------------- Parametros de pantalla -----------------------------
tables zg5_soc.
parameters: p_bukrs type zg5_soc-bukrs obligatory,
p_butxt type zg5_soc-butxt obligatory,
p_ort01 type zg5_soc-ort01,
p_land1 type zg5_soc-land1,
p_waers type zg5_soc-waers.

*---------------------- SOCIEDADES ( Types | Types Tables | Tabla global | Workin Area ) ---------------------------
*Declaro type
types: begin of ty_soc,
         bukrs  type zg5_bukrs,
         butxt  type zg5_butxt,
         ort01  type zg5_ort01,
         land1 type zg5_land1,
         waers type zg5_waers,
       end of ty_soc.

*Declaro type table
types: tt_soc type standard table of ty_soc.

*Declaro tabla global y workin area
data gt_soc type tt_soc.
data wa_soc type ty_soc.

*------------------------ Estructura con los datos del programa --------------------------------
data: bdc_tab    type table of bdcdata,
      wa_bdc_tab type bdcdata.

*Mensajes de error
data: itab type table of bdcmsgcoll.