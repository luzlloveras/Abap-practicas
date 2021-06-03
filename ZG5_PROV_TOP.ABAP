*&---------------------------------------------------------------------*
*& Include          ZG5_PROV_TOP
*&---------------------------------------------------------------------*


*------------------------ Parametro para levantar archivo -------------------------
parameters: p_prov type localfile.

*---------------------- PROVEEDORES ( Types | Types Tables | Tabla global | Workin Area ) ----------
*Declaro type
types: begin of ty_proveedores,
         lifnr  type zg5_lifnr,
         name1  type zg5_name1_gp,
         name2  type zg5_name2_gp,
         bukrs type zg5_bukrs,
         stkzn type zg5_stkzn,
         regio type zg5_regio,
         pstlz type zg5_pstlz,
       end of ty_proveedores.

*Declaro type table
types: tt_proveedores type standard table of ty_proveedores.

*Declaro tabla global y workin area
data gt_proveedores type tt_proveedores.
data wa_proveedores type ty_proveedores.

*------------------------ Estructura con los datos del programa --------------------------------
data: bdc_tab    type table of bdcdata,
      wa_bdc_tab type bdcdata.

*Mensajes de error
data: itab type table of bdcmsgcoll.