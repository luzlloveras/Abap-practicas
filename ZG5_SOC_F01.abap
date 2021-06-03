*&---------------------------------------------------------------------*
*& Include          ZG5_SOC_F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form F_RECUPERO_DATOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_SOC
*&      --> V_STRING
*&      --> WA_SOC
*&      <-- GT_SOC
*&---------------------------------------------------------------------*
form f_recupero_datos  using    p_sociedad type localfile
                                p_wa_soc type ty_soc
                       changing p_gt_soc type tt_soc.

*Declaro variable para levantar parametro
  data v_string type string.

*---------------------------- Levanto archivo  ------------------------------

  open dataset p_sociedad for input in text mode encoding default. "Abro el archivo para poder copiarlo en la wa
  read dataset p_sociedad into v_string. "Leo el primer registro y lo guardo en la wa
  if sy-subrc is initial.
    do.
      read dataset p_sociedad into v_string. "Leo el primer registro y lo guardo en la wa
      if sy-subrc = 0. "Si esto da okey
        split v_string at ',' into p_wa_soc-bukrs p_wa_soc-butxt p_wa_soc-ort01 p_wa_soc-land1 p_wa_soc-waers. "separo los campos del string archivo con comas y las guardo en la wa
        append p_wa_soc to p_gt_soc. "Guardo el primer registro en la tabla
        clear p_wa_soc. "inicializo la wa para reutilizarla en el siguiente registro
      else. "Sino da okey
        exit. "Salir
      endif. "Termina la condicion
    enddo.  "Termina la vuelta
    close dataset p_soc. "Cierro el archivo que ya termine de copiar a la wa
  endif.


endform.



*&---------------------------------------------------------------------*
*& Form F_ACTUALIZAR_SOC_SE11
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SOC
*&---------------------------------------------------------------------*
form f_actualizar_soc_se11  using    p_gt_soc type tt_soc.

*Declaro variable para levantar parametro
  data wa_soc type ty_soc.

*Declaro variable contador para registrar 15 registros de una vez
  data: v_contador_i type i,
        v_contador_c type char2.

  v_contador_i = 1.


*Declaro variable para contadores
  data: cont_bukrs type string,
        cont_butxt type string,
        cont_ort01 type string,
        cont_land1 type string,
        cont_waers type string.

  refresh bdc_tab.
  loop at p_gt_soc into wa_soc.


    v_contador_c = v_contador_i.

    if v_contador_i lt 10. "si contador es menor a 10
      "Le agrego 0 al armar el campo
      concatenate 'ZG5_SOC-BUKRS(0' v_contador_c ')' into cont_bukrs.
      concatenate 'ZG5_SOC-BUTXT(0' v_contador_c ')' into cont_butxt.
      concatenate 'ZG5_SOC-ORT01(0' v_contador_c ')' into cont_ort01.
      concatenate 'ZG5_SOC-LAND1(0' v_contador_c ')' into cont_land1.
      concatenate 'ZG5_SOC-WAERS(0' v_contador_c ')' into cont_waers.
    else.
      "No agrego nada
      concatenate 'ZG5_SOC-BUKRS(' v_contador_c ')' into cont_bukrs.
      concatenate 'ZG5_SOC-BUTXT(' v_contador_c ')' into cont_butxt.
      concatenate 'ZG5_SOC-ORT01(' v_contador_c ')' into cont_ort01.
      concatenate 'ZG5_SOC-LAND1(' v_contador_c ')' into cont_land1.
      concatenate 'ZG5_SOC-WAERS(' v_contador_c ')' into cont_waers.
    endif.



    if v_contador_i = 1.
      perform zfill_soc_tab using :   "1 VEZ Q ENTRO
          "PANTALLA DE INICIO
          'X' 'SAPMSVMA' '0100',  "inicio
          ' ' 'BDC_OKCODE' '=UPD',
          ' ' 'VIEWNAME' 'ZG5_SOC',
          ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
          "NUEVA ENTRADA
          'X' 'SAPLZLLOVERAS' '0003',
          ' ' 'BDC_OKCODE' '=NEWL'.
    endif.

    perform zfill_soc_tab using :
        "RELLENO CAMPOS HASTA LLEGAR A 15
        'X' 'SAPLZLLOVERAS' '0003',
        ' ' 'BDC_OKCODE' '/00',
        ' ' cont_bukrs wa_soc-bukrs,
        ' ' cont_butxt wa_soc-butxt,
        ' ' cont_ort01 wa_soc-ort01,
        ' ' cont_land1 wa_soc-land1,
        ' ' cont_waers wa_soc-waers.

    if v_contador_i = 15.
      perform zfill_soc_tab using :
        'X' 'SAPLZLLOVERAS' '0003',
        ' ' 'BDC_OKCODE' '=SAVE',
        'X' 'SAPLZLLOVERAS' '0003',
        ' ' 'BDC_OKCODE' '=BACK',
        'X' 'SAPLZLLOVERAS' '0003',
        ' ' 'BDC_OKCODE' '=BACK',
        'X' 'SAPMSVMA' '0100',
        ' ' 'BDC_OKCODE' '/EBACK'.
    endif.
    add 1 to v_contador_i.
endloop.

if v_contador_i < 15.
  perform zfill_soc_tab using :
      'X' 'SAPLZLLOVERAS' '0003',
      ' ' 'BDC_OKCODE' '=SAVE',
      'X' 'SAPLZLLOVERAS' '0003',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPLZLLOVERAS' '0003',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '/EBACK'.
  call transaction 'SM30' using bdc_tab mode 'N' . "Lo guardo en el registro
  refresh bdc_tab.
endif.

endform.

*--------------------- BATCH INPUT ----------------------------

form zfill_soc_tab using dynbegin name value.

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



*&---------------------------------------------------------------------*
*& Form F_ALTA_SOCIEDADES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_SOC
*&---------------------------------------------------------------------*
form f_alta_sociedades  using    p_gt_soc type tt_soc.

*Levanto informacion de la pantalla de seleccion y lo asigno a la tabla
  perform zfill_soc_tab using :   "Relleno campo a campo
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '=UPD',
      ' ' 'VIEWNAME' 'ZG5_SOC',
      ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
      'X' 'SAPLZLLOVERAS' '0003',
      ' ' 'BDC_OKCODE' '=NEWL',
      'X' 'SAPLZLLOVERAS' '0003',
      ' ' 'BDC_OKCODE' '=SAVE',
      ' ' 'ZG5_SOC-BUKRS(01)' p_bukrs,
      ' ' 'ZG5_SOC-BUTXT(01)' p_butxt,
      ' ' 'ZG5_SOC-ORT01(01)' p_ort01,
      ' ' 'ZG5_SOC-LAND1(01)' p_land1,
      ' ' 'ZG5_SOC-WAERS(01)' p_waers,
      'X' 'SAPLZLLOVERAS' '0002',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPLZLLOVERAS' '0002',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '/EBACK'.

  call transaction 'SM30' using bdc_tab mode 'N' . "Lo guardo en el registro

if sy-subrc is not initial.
write 'Los campos ingresados son incorrectos'.
endif.


endform.