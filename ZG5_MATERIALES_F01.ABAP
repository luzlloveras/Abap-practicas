*&---------------------------------------------------------------------*
*& Include          ZG5_MATERIALES_F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form F_RECUPERO_DATOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATERIALES
*&      --> WA_MATERIALES
*&      <-- GT_MATERIALES
*&---------------------------------------------------------------------*
form f_recupero_datos  using    p_p_mate type localfile
                                p_wa_mate type ty_materiales
                       changing p_gt_mate type tt_materiales.


*Declaro variable para levantar parametro
  data v_string type string.
*---------------------------- Levanto archivo  ------------------------------

  open dataset p_p_mate for input in text mode encoding default. "Abro el archivo para poder copiarlo en la wa
  read dataset p_p_mate into v_string. "Leo el primer registro y lo guardo en la wa
  if sy-subrc is initial.
    do.
      read dataset p_p_mate into v_string. "Leo el primer registro y lo guardo en la wa
      if sy-subrc = 0. "Si esto da okey

        split v_string at ',' into p_wa_mate-matnr p_wa_mate-werks p_wa_mate-labst p_wa_mate-meins p_wa_mate-maktx. "separo los campos del string archivo con comas y las guardo en la wa

        append p_wa_mate to p_gt_mate. "Guardo el primer registro en la tabla
        clear p_wa_mate. "inicializo la wa para reutilizarla en el siguiente registro
      else. "Sino da okey
        exit. "Salir
      endif. "Termina la condicion
    enddo.  "Termina la vuelta
    close dataset p_p_mate. "Cierro el archivo que ya termine de copiar a la wa
  endif.


*----------
*Declaro variable para levantar parametro
  data wa_mat type ty_materiales.

*Declaro variable contador para registrar 15 registros de una vez
  data: v_contador_i type i,
        v_contador_c type char2.

v_contador_i = 1.


*Declaro variable para contadores
  data: cont_matnr type string,
        cont_werks type string,
        cont_labst type string,
        cont_meins type string,
        cont_maktx type string.

  refresh bdc_tab.
  loop at p_gt_mate into wa_mat.


    v_contador_c = v_contador_i.

    if v_contador_i lt 10. "si contador es menor a 10
      "Le agrego 0 al armar el campo
      concatenate 'ZG5_MA-MATNR(0' v_contador_c ')' into cont_matnr.
      concatenate 'ZG5_MA-WERKS(0' v_contador_c ')' into cont_werks.
      concatenate 'ZG5_MA-LABST(0' v_contador_c ')' into cont_labst.
      concatenate 'ZG5_MA-MEINS(0' v_contador_c ')' into cont_meins.
      concatenate 'ZG5_MA-MAKTX(0' v_contador_c ')' into cont_maktx.
    else.
      "No agrego nada
      concatenate 'ZG5_MA-MATNR(' v_contador_c ')' into cont_matnr.
      concatenate 'ZG5_MA-WERKS(' v_contador_c ')' into cont_werks.
      concatenate 'ZG5_MA-LABST(' v_contador_c ')' into cont_labst.
      concatenate 'ZG5_MA-MEINS(' v_contador_c ')' into cont_meins.
      concatenate 'ZG5_MA-MAKTX(' v_contador_c ')' into cont_maktx.
    endif.



    if v_contador_i = 1.
      perform zfill_mat_tab using :   "1 VEZ Q ENTRO
          "PANTALLA DE INICIO
          'X' 'SAPMSVMA' '0100',  "inicio
          ' ' 'BDC_OKCODE' '=UPD',
          ' ' 'VIEWNAME' 'ZG5_MA',
          ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
          "NUEVA ENTRADA
          'X' 'SAPLZLLOVERAS' '0004',
          ' ' 'BDC_OKCODE' '=NEWL'.
    endif.

    perform zfill_mat_tab using :
        "RELLENO CAMPOS HASTA LLEGAR A 15
        'X' 'SAPLZLLOVERAS' '0004',
        ' ' 'BDC_OKCODE' '/00',
        ' ' cont_matnr wa_mat-matnr,
        ' ' cont_werks wa_mat-werks,
        ' ' cont_labst wa_mat-labst,
        ' ' cont_meins wa_mat-meins,
        ' ' cont_maktx wa_mat-maktx.

    if v_contador_i = 15.
      perform zfill_mat_tab using :
        'X' 'SAPLZLLOVERAS' '0004',
        ' ' 'BDC_OKCODE' '=SAVE',
        'X' 'SAPLZLLOVERAS' '0004',
        ' ' 'BDC_OKCODE' '=BACK',
        'X' 'SAPLZLLOVERAS' '0004',
        ' ' 'BDC_OKCODE' '=BACK',
        'X' 'SAPMSVMA' '0100',
        ' ' 'BDC_OKCODE' '/EBACK'.

  call transaction 'SM30' using bdc_tab mode 'N' . "Lo guardo en el registro

v_contador_i = 0.
  refresh bdc_tab.
    endif.
    add 1 to v_contador_i.
endloop.

if v_contador_i <= 15.
  perform zfill_mat_tab using :
      'X' 'SAPLZLLOVERAS' '0004',
      ' ' 'BDC_OKCODE' '=SAVE',
      'X' 'SAPLZLLOVERAS' '0004',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPLZLLOVERAS' '0004',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '/EBACK'.
  call transaction 'SM30' using bdc_tab mode 'N' . "Lo guardo en el registro
  refresh bdc_tab.
endif.

endform.
*--------------------- BATCH INPUT ----------------------------

form zfill_mat_tab using dynbegin name value.

  clear wa_bdc_tab.

*Condicion para completar el archivo
  if dynbegin = 'X' .

    move : name to wa_bdc_tab-program ,
           value to wa_bdc_tab-dynpro ,
           'X' to wa_bdc_tab-dynbegin .
    append wa_bdc_tab to bdc_tab.
  else .
    move : name to wa_bdc_tab-fnam ,
           value to wa_bdc_tab-fval.
    append wa_bdc_tab to bdc_tab.
  endif.



endform.