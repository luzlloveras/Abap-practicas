*&---------------------------------------------------------------------*
*& Include          ZG5_PROVCLI_TOP
*&---------------------------------------------------------------------*

*---------------  Parametros ---------------
tables: zg5_cli,
        zg5_prov.

parameters: p_prov  radiobutton group rb1 user-command uc default 'X', "Radio buttom
            p_cli   radiobutton group rb1, "Radio buttom
            p_alta  radiobutton group rb2 user-command uc default 'X',
            p_mod   radiobutton group rb2,
            p_baja  radiobutton group rb2,
            p_lifnr type zg5_lifnr modif id A,
            p_kunnr type zg5_kunnr modif id B,
            p_name1 type zg5_name1_gp,
            p_name2 type zg5_name2_gp,
            p_bukrs type zg5_bukrs,
            p_stkzn type zg5_stkzn,
            p_regio type zg5_regio,
            p_pstlz type zg5_pstlz.

*---------------  Declaraciones PROVCLI ---------------
types: begin of ty_provcli,
         lifnr type zg5_lifnr,
         kunnr type zg5_kunnr,
         name1_gp type zg5_name1_gp,
         name2_gp type zg5_name2_gp,
         bukrs type zg5_bukrs,
         stkzn type zg5_stkzn,
         regio type zg5_regio,
         pstlz type zg5_pstlz,
       end of ty_provcli.

*Declaro type table
types: tt_provcli type standard table of ty_provcli.

*Declaro tabla global y workin area
data gt_provcli type tt_provcli.
data wa_provcli type ty_provcli.

*---------------  Declaraciones WA para clientes y proveedores ---------------
types: ty_clientes type zg5_cli,
ty_proveedores type zg5_prov.

data: wa_clientes type ty_clientes,
wa_proveedores type ty_proveedores.