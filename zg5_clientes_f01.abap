*&---------------------------------------------------------------------*
*& Include          ZG5_CLIENTES_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form F_RECUPERO_DATOS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_recupero_datos.


  *Declaro variable para levantar parametro
    data v_string type string.
  
  *---------------------------- Levanto archivo  ------------------------------
  
    OPEN DATASET p_cli FOR INPUT IN LEGACY TEXT MODE CODE PAGE '1100'. "Abro el archivo para poder copiarlo en la wa
    if sy-subrc is initial.
      do.
        read dataset p_cli into v_string.
        if sy-subrc is initial.
          split v_string at ',' into wa_clientes-kunnr wa_clientes-name1 wa_clientes-name2 wa_clientes-bukrs wa_clientes-stkzn wa_clientes-regio wa_clientes-pstlz.
          append wa_clientes to gt_clientes. "Guardo el primer registro en la tabla
          clear wa_clientes. "inicializo la wa para reutilizarla en el siguiente registro
        else. "Sino da okey
          exit. "Salir
        endif.
      enddo.  "Termina la vuelta
      close dataset p_cli. "Cierro el archivo que ya termine de copiar a la wa
    endif.
  
  
  
  *---------- Cambio los campos por los de mi wa para dsp llenar la tabla con los datos del archivo que cargo ivan
  
    loop at gt_clientes into wa_clientes.
      refresh bdc_tab.
  
      perform zfill_clientes using :   "Relleno campo a campo
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '=UPD',
      ' ' 'VIEWNAME' 'ZG5_CLI',
      ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=NEWL',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '/00',
      ' ' 'ZG5_CLI-KUNNR(01)' wa_clientes-kunnr,
      ' ' 'ZG5_CLI-NAME1_GP(01)' wa_clientes-name1,
      ' ' 'ZG5_CLI-NAME2_GP(01)' wa_clientes-name2,
      ' ' 'ZG5_CLI-BUKRS(01)' wa_clientes-bukrs,
      ' ' 'ZG5_CLI-STKZN(01)' wa_clientes-stkzn,
      ' ' 'ZG5_CLI-REGIO(01)' wa_clientes-regio,
      ' ' 'ZG5_CLI-PSTLZ(01)' wa_clientes-pstlz,
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=SAVE',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '/EBACK'.
  
      call transaction 'SM30' using bdc_tab mode 'N' . "Lo guardo en el registro
  
    endloop.
  
  endform.
  
  form zfill_clientes using dynbegin name value.
    clear wa_bdc_tab.
    if dynbegin = 'X'.
      move: name to wa_bdc_tab-program,
      value to wa_bdc_tab-dynpro,
      'X' to wa_bdc_tab-dynbegin.
      append wa_bdc_tab to bdc_tab.
    else.
      clear wa_bdc_tab.
      move: name to wa_bdc_tab-fnam,
      value to wa_bdc_tab-fval.
      append wa_bdc_tab to bdc_tab.
    endif.
  
  
  endform.