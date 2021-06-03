*&---------------------------------------------------------------------*
*& Include          ZG5_OV_02
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form F_RECUPERO_DATOS2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FAC
*&---------------------------------------------------------------------*
FORM cargar_orden_venta.


  *&----------------------------DATOS LOCALES PARA COMPLETAR TABLA------------------------------*
  
  
  *&----------------------------LOGICA DEL PROBLEMA--------------------------------------------------*
  *VERIFICAMOS QUE LA OV EXISTA
  
    SELECT SINGLE * FROM zg5_ov
    INTO @DATA(wa_ov)
    WHERE vbeln = @p_op2.
  *si no existe tiramos un error
    IF sy-subrc <> 0.
      MESSAGE e001(00) WITH 'No existe una orden de venta con este numero: ' p_op2.
    ELSE.
  *VERIFICAMOS QUE LA OV NO TENGA UNA FACTURA ASOCIADA
      SELECT * FROM zg5_fac
      INTO TABLE @DATA(it_fac)
      WHERE vbeln = @p_op2.
  
      IF sy-subrc = 0.
        MESSAGE e001(00) WITH 'Ya existe una factura con orden de venta: ' p_op2.
  
  *&----------------------------SI NO EXISTE SE CREA-------------------------------------------------*
      ELSE.
        IF sy-subrc IS NOT INITIAL.
          DATA l_dmbtr_aux TYPE string.
          l_dmbtr_aux = p_op9.
  
          DATA(lv_fecha) = |{ p_op7 DATE = USER }|.
  
          REFRESH bdc_tab.
  
          PERFORM fill_bdc_tab2 USING:
  
          'X ' 'SAPMSVMA' '0100',
          ' '  'BDC_OKCODE' '=UPD',
          ' '  'VIEWNAME' 'zg5_fac',
          ' '  'VIMDYNFLDS-LTD_DTA_NO' 'X',
  
          'X'  'SAPLZLLOVERAS' '0011',
          ' '  'BDC_OKCODE' '=NEWL',
  
          'X'  'SAPLZLLOVERAS' '0011',
          ' '  'BDC_OKCODE' '/00',
          ' '  'zg5_fac-vbeln_vf(01)' p_op3,
          ' '  'zg5_fac-fkart(01)' p_op10,
          ' '  'ZG5_FAC-DMBTR(01)' l_dmbtr_aux,
          ' '  'zg5_fac-waers(01)' p_op8,
          ' '  'zg5_fac-fkdat(01)' lv_fecha,
          ' '  'zg5_fac-bukrs(01)' p_op6,
          ' '  'zg5_fac-vbeln(01)' p_op2,
          ' '  'zg5_fac-kunnr(01)' p_op5,
  
          'X'  'SAPLZLLOVERAS' '0011',
          ' '  'BDC_OKCODE' '=SAVE',
  
          'X'  'SAPLZLLOVERAS' '0011',
          ' '  'BDC_OKCODE' '=BACK',
  
          'X'  'SAPLZLLOVERAS' '0011',
          ' '  'BDC_OKCODE' '=BACK',
  
          'X ' 'SAPMSVMA' '0100',
          ' '  'BDC_OKCODE' '/EBACK'.
  
          CALL TRANSACTION 'SM30' USING bdc_tab MODE 'A'.
  
          IF sy-subrc IS NOT INITIAL.
            WRITE: 'No se pudo cargar el dato'.
          ELSE.
            WRITE:'Se cargo el dato exitosamente'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  
  *&----------------------------FIN DEL PROGRAMA -------------------------------------------------*
  ENDFORM.
  
  FORM fill_bdc_tab2 USING dynbegin name value.
  
    IF dynbegin = 'X'.
      CLEAR wa_bdc_tab.
      MOVE: name TO wa_bdc_tab-program,
      value TO wa_bdc_tab-dynpro,
      'X' TO wa_bdc_tab-dynbegin.
      APPEND wa_bdc_tab TO bdc_tab.
    ELSE.
      CLEAR wa_bdc_tab.
      MOVE:name TO wa_bdc_tab-fnam,
      value TO wa_bdc_tab-fval.
      APPEND wa_bdc_tab TO bdc_tab.
    ENDIF.
  
  ENDFORM.