*&---------------------------------------------------------------------*
*& Include          ZG5_OV_F01
*&---------------------------------------------------------------------*

FORM cargar_orden_venta.

  SELECT SINGLE *
  FROM zg5_cli
  INTO @DATA(w_cli)
  WHERE kunnr = @p_kunnr.

  IF sy-subrc <> 0.
    MESSAGE e001(00) WITH 'El cliente con el codigo ' p_kunnr ' no existe'.
  ELSE.
    SELECT SINGLE *
    FROM zg5_soc
    INTO @DATA(w_soc)
    WHERE bukrs = @w_cli-bukrs.
    IF sy-subrc <> 0.
      MESSAGE e001(00) WITH 'Este cliente no pertenece a ninguna sociedad'.
    ELSE.

      SELECT SINGLE *
      FROM zg5_ma
      INTO @DATA(w_ma)
      WHERE matnr = @p_matnr
      AND werks = @p_werks.

      IF sy-subrc <> 0.
        MESSAGE e001(00) WITH 'Este Material no existe/La planta no existe/ El material no existe en esta planta'.
      ELSE.
        DATA(lv_labst_aux) =  w_ma-labst - p_zmeng. "Guardo en una variable el stock de material y le resto la cantidad que necesito
        IF lv_labst_aux < 0. "Si el stock es menor a mi necesidad de material
          WRITE: 'No existe suficiente Stock para este material, se generara una orden de compra'.
          SELECT MAX( zg5_oc~ebeln ) FROM zg5_oc INTO @DATA(lv_ebeln). "Busco el valor máximo de documento de compra
          DATA lv_ebeln_num TYPE p.
*pasar char a numero
          CALL FUNCTION 'MOVE_CHAR_TO_NUM'
            EXPORTING
              chr             = lv_ebeln
            IMPORTING
              num             = lv_ebeln_num
            EXCEPTIONS
              convt_no_number = 1
              convt_overflow  = 2
              OTHERS          = 3.
          lv_ebeln_num = lv_ebeln_num + 1.
          DATA lv_ebeln_aux type string.
          lv_ebeln_aux = lv_ebeln_num.
          CONDENSE lv_ebeln_aux NO-GAPS.
          IF sy-subrc <> 0.
* Implement suitable error handling here
          ENDIF.

          DATA l_zmeng_aux2 TYPE string. " como la dynpro no acepta caracteres largos, guardamos el valor en un string y luego hacemos un condense
          l_zmeng_aux2 = '10000'.
          CONDENSE l_zmeng_aux2 NO-GAPS.

          REFRESH bdc_tab.
          PERFORM fill_bdc_tab USING:
          'X' 'ZG5_OC' '1000',
          ' ' 'BDC_OKCODE' '=ONLI',
          ' ' 'p_ebeln' lv_ebeln_aux,
          ' ' 'P_MATNR' w_ma-matnr,
          ' ' 'P_WERKS' w_ma-werks,
          ' ' 'P_ZMENG' l_zmeng_aux2,
          ' ' 'P_MEINS' p_meins,
          ' ' 'P_VBELN' p_vf,
          ' ' 'P_LIFNR' '10000',
          'X' 'SAPMSVMA' '0100',
          ' ' 'BDC_OKCODE' '/EE'.
          CALL TRANSACTION 'ZG5_OC' USING bdc_tab MODE 'A'.
          IF sy-subrc <> 0.
            MESSAGE e001(00) WITH 'Hubo un error con la generacion de orden de compra'.
          ELSE.
            WRITE: 'Se genero una orden de compra ya que no habia stock'.
          ENDIF.
        ELSE.

          DATA l_zmeng_aux TYPE string. " como la dynpro no acepta caracteres largos, guardamos el valor en un string y luego hacemos un condense
          l_zmeng_aux = p_zmeng.
          CONDENSE l_zmeng_aux NO-GAPS.

          REFRESH bdc_tab.
          PERFORM fill_bdc_tab USING:

          'X ' 'SAPMSVMA' '0100',
          ' '  'BDC_OKCODE' '=UPD',
          ' '  'VIEWNAME' 'zg5_ov',
          ' '  'VIMDYNFLDS-LTD_DTA_NO' 'X',
          'X'  'SAPLZLLOVERAS' '0009',
          ' '  'BDC_OKCODE' '=NEWL',
          'X'  'SAPLZLLOVERAS' '0009',
          ' '  'BDC_OKCODE' '/00',
          ' '  'ZG5_OV-VBELN(01)' p_vbeln,
          ' '  'ZG5_OV-MATNR(01)' p_matnr,
          ' '  'ZG5_OV-WERKS(01)' p_werks,
          ' '  'ZG5_OV-ZMENG(01)' l_zmeng_aux,
          ' '  'ZG5_OV-MEINS(01)' p_meins,
          ' '  'ZG5_OV-VBELN_F(01)' p_vf,
          ' '  'ZG5_OV-KUNNR(01)' p_kunnr,
          'X'  'SAPLZLLOVERAS' '0009',
          ' '  'BDC_OKCODE' '=SAVE',
          'X'  'SAPLZLLOVERAS' '0009',
          ' '  'BDC_OKCODE' '=BACK',
          'X'  'SAPLZLLOVERAS' '0009',
          ' '  'BDC_OKCODE' '=BACK',
          'X ' 'SAPMSVMA' '0100',
          ' '  'BDC_OKCODE' '/EBACK'.

          CALL TRANSACTION 'SM30' USING bdc_tab MODE 'A'.

          IF sy-subrc IS INITIAL.
            WRITE: 'Cargado con exito'.
          ELSE.
            WRITE: 'Error en la carga'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.

FORM fill_bdc_tab USING dynbegin name value.
  IF dynbegin = 'X'.
    CLEAR wa_bdc_tab.
    MOVE: name TO wa_bdc_tab-program,
          value TO wa_bdc_tab-dynpro,
          'X' TO wa_bdc_tab-dynbegin.
    APPEND wa_bdc_tab TO bdc_tab.
  ELSE.
    CLEAR wa_bdc_tab.
    MOVE: name TO wa_bdc_tab-fnam,
          value TO wa_bdc_tab-fval.
    APPEND wa_bdc_tab TO bdc_tab.
  ENDIF.
ENDFORM.