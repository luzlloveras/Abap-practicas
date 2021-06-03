*&---------------------------------------------------------------------*
*& Include          ZG5_PROV_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_RECUPERO_DATOS
*&---------------------------------------------------------------------*

*& text
*&---------------------------------------------------------------------*
*&      --> P_PROVEEDORES
*&      --> WA_PROVEEDORES
*&      <-- GT_PROVEEDORES
*&---------------------------------------------------------------------*
form f_recupero_datos.

  *Declaro variable para levantar parametro
    data v_string type string.
  
  *---------------------------- Levanto archivo  ------------------------------
  
    OPEN DATASET p_prov FOR INPUT IN LEGACY TEXT MODE CODE PAGE '1100'. "Abro el archivo para poder copiarlo en la wa
    if sy-subrc is initial.
      do.
        read dataset p_prov into v_string.
        if sy-subrc is initial.
          split v_string at ',' into wa_proveedores-lifnr wa_proveedores-name1 wa_proveedores-name2 wa_proveedores-bukrs wa_proveedores-stkzn wa_proveedores-regio wa_proveedores-pstlz.
          append wa_proveedores to gt_proveedores. "Guardo el primer registro en la tabla
          clear wa_proveedores. "inicializo la wa para reutilizarla en el siguiente registro
        else. "Sino da okey
          exit. "Salir
        endif.
      enddo.  "Termina la vuelta
      close dataset p_prov. "Cierro el archivo que ya termine de copiar a la wa
    endif.
  
  
  
  *---------- Cambio los campos por los de mi wa para dsp llenar la tabla con los datos del archivo que cargo ivan
  
    loop at gt_proveedores into wa_proveedores.
      refresh bdc_tab.
  
      perform zfill_proveedores using :   "Relleno campo a campo
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '=UPD',
      ' ' 'VIEWNAME' 'ZG5_PROV',
      ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '=NEWL',
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '/00',
      ' ' 'ZG5_PROV-LIFNR(01)' wa_proveedores-lifnr,
      ' ' 'ZG5_PROV-NAME1_GP(01)' wa_proveedores-name1,
      ' ' 'ZG5_PROV-NAME2_GP(01)' wa_proveedores-name2,
      ' ' 'ZG5_PROV-BUKRS(01)' wa_proveedores-bukrs,
      ' ' 'ZG5_PROV-STKZN(01)' wa_proveedores-stkzn,
      ' ' 'ZG5_PROV-REGIO(01)' wa_proveedores-regio,
      ' ' 'ZG5_PROV-PSTLZ(01)' wa_proveedores-pstlz,
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '/00',
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '/00',
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '=SAVE',
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPLZLLOVERAS' '0007',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '/EBACK'.
  
      call transaction 'SM30' using bdc_tab mode 'N' . "Lo guardo en el registro
  
    endloop.
  
  endform.
  
  form zfill_proveedores using dynbegin name value.
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