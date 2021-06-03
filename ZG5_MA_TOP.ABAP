*&---------------------------------------------------------------------*
*& Include          ZG5_MA_TOP
*&---------------------------------------------------------------------*

*---------------------- Materiales ( Types | Types Tables | Tabla global | Workin Area ) ---------------------------
*Declaro type
types: begin of ty_ma,
         matnr   type zg5_matnr,
         werks   type zg5_werks_d,
         labst   type zg5_labst,
         meins   type zg5_meins,
       end of ty_ma.

*Declaro type table
types: tt_ma type standard table of ty_ma.

*Declaro tabla global y workin area
data gt_ma type tt_ma.
data wa_ma type ty_ma.
DATA: bdc_tab     TYPE TABLE OF bdcdata,
      wa_bdc_tab  TYPE bdcdata.

*declaro parametros
parameters: p_MATNR type zg5_matnr,
            p_WERKS type zg5_werks_d,
            p_labst type p,
            p_MEINS type zg5_meins,
            p_des type zg5_maktx,
            so1 radiobutton group rb1,
            so2 radiobutton group rb1,
            so3 radiobutton group rb1.