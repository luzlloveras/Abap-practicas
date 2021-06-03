*&---------------------------------------------------------------------*
*& Include          ZG5_CLIENTES_TOP
*&---------------------------------------------------------------------*

*------------------------ Parametro para levantar archivo -------------------------
parameters: p_cli type localfile.

*---------------------- CLIENTES ( Types | Types Tables | Tabla global | Workin Area ) ----------
*Declaro type
types: begin of ty_clientes,
         kunnr  type zg5_kunnr,
         name1  type zg5_name1_gp,
         name2  type zg5_name2_gp,
         bukrs type zg5_bukrs,
         stkzn type zg5_stkzn,
         regio type zg5_regio,
         pstlz type zg5_pstlz,
       end of ty_clientes.

*Declaro type table
types: tt_clientes type standard table of ty_clientes.

*Declaro tabla global y workin area
data gt_clientes type tt_clientes.
data wa_clientes type ty_clientes.

*------------------------ Estructura con los datos del programa --------------------------------
data: bdc_tab    type table of bdcdata,
      wa_bdc_tab type bdcdata.

*Mensajes de error
data: itab type table of bdcmsgcoll.