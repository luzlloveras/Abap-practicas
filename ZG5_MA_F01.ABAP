*&---------------------------------------------------------------------*
*& Include          ZG5_MA_F01
*&---------------------------------------------------------------------*
FORM alta_de_materiales.

  *--------------- ALTA DE MATERIALES ----------------------------
  
  
  *Declaro variable para copiar el numero del parametro labst y al hacerlo string le saco los espacios en blanco para que lo lea la bcd.
    DATA v_labst(18) TYPE c.
    v_labst = p_labst.
    CONDENSE v_labst. "Saco espacios en blanco
  
    REFRESH bdc_tab.
  
    PERFORM fill_bdc_tab USING:
    'X' 'SAPMSVMA' '0100',
    ' ' 'BDC_OKCODE' '=UPD',
    ' ' 'VIEWNAME' 'ZG5_MA',
    ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
    'X' 'SAPLZLLOVERAS' '0004',
    ' ' 'BDC_OKCODE' '=NEWL',
    'X' 'SAPLZLLOVERAS' '0004',
    ' ' 'BDC_OKCODE' '/00',
    ' ' 'ZG5_MA-MATNR(01)' p_matnr,
    ' ' 'ZG5_MA-WERKS(01)' p_werks,
    ' ' 'ZG5_MA-LABST(01)' v_labst,
    ' ' 'ZG5_MA-MEINS(01)' p_meins,
    ' ' 'ZG5_MA-MAKTX(01)' p_des,
    'X' 'SAPLZLLOVERAS' '0004',
    ' ' 'BDC_OKCODE' '=SAVE',
    'X' 'SAPLZLLOVERAS' '0004',
    ' ' 'BDC_OKCODE' '=ENDE',
    'X' 'SAPMSVMA' '0100',
    ' ' 'BDC_OKCODE' '/EBACK'.
    CALL TRANSACTION 'SM30' USING bdc_tab MODE 'N'.
    IF sy-subrc = 0.
      MESSAGE s001(00) WITH 'Se cargo el material: 'p_matnr p_werks.
    ELSE.
      MESSAGE e001(00) WITH 'Ya existe el material: 'p_matnr p_werks.
    ENDIF.
  ENDFORM.
  
  *--------------- BAJA DE MATERIALES ----------------------------
  
  *--------------- INICIO: PASO A PASO CONCEPTUAL ---------------------------------------
  * recuperar datos (werks matnr( de ordenes de venta con key matnr y la guardo en lt_ov
  * recuperar datos de fac con la key vbeln comparandola ya con lt_ov y la guardo en lt_fac
  * y hago un read table buscando el p_matnr en lv_fac.
  * si encuentro el p_matrn en lv_fac, NO SE PUEDE ELIMINAR.
  * y ademas fijarse que p_mtnr no figure en  mas de un werk.
  *si hay un material con una orden de venta: SIN factura, NO se elimina.
  *--------------- FIN: PASO A PASO CONCEPTUAL -----------------------------------------
  
  FORM baja_de_materiales.
  
  *Declaracion de local table
    DATA: lt_ov  TYPE STANDARD TABLE OF zg5_ov,
          lt_fac TYPE STANDARD TABLE OF zg5_fac.
  
    SELECT SINGLE *
    FROM zg5_ma
    INTO @DATA(wa_ma)
    WHERE matnr = @p_matnr AND werks = @p_werks.
  
    IF sy-subrc = 0.
      SELECT *
      FROM zg5_ov
      INTO TABLE lt_ov
      WHERE matnr = p_matnr AND werks = p_werks.
  
      IF sy-subrc IS INITIAL. "Me asegura que la tabla lt_ov tenga registros
      DATA(lv_existeFactura) = abap_true.
      loop at lt_ov INTO data(wa_ov).
          select single *
          from zg5_fac
          into @data(wa_fac)
          where vbeln = @wa_ov-vbeln.
          if sy-subrc <> 0.
            lv_existeFactura = abap_false.
          endif.
      endloop.
  
        IF lv_existeFactura = abap_true.
  
          DELETE FROM zg5_ma WHERE matnr = p_matnr AND werks = p_werks.
          COMMIT WORK.
  
          IF sy-subrc = 0.
            MESSAGE s001(00) WITH 'Eliminado con exito: 'p_matnr p_werks.
          ELSE.
            MESSAGE e001(00) WITH 'Hubo un error con la clave: 'p_matnr p_werks.
          ENDIF.
        ELSE.
          MESSAGE e001(00) WITH 'No se puede eliminar este material'.
        ENDIF.
      ELSE.
        DELETE FROM zg5_ma WHERE matnr = p_matnr AND werks = p_werks.
        COMMIT WORK.
        IF sy-subrc = 0.
          MESSAGE s001(00) WITH 'Eliminado con exito: 'p_matnr p_werks.
        ELSE.
          MESSAGE e001(00) WITH 'Hubo un error con la clave: 'p_matnr p_werks.
        ENDIF.
      ENDIF.
    ELSE.
      WRITE: 'No se puede encontro este material'.
    ENDIF.
  
  
  ENDFORM.
  
  
  
  *--------------- MODIFICACION DE MATERIALES ----------------------------
  
  FORM modificacion_de_material.
    SELECT SINGLE * FROM zg5_ma
    INTO @DATA(r_ma)
    WHERE matnr = @p_matnr AND werks = @p_werks.
  
    IF sy-subrc = 0.
      r_ma-labst = p_labst.
      r_ma-meins = p_meins.
      r_ma-maktx = p_des.
      MODIFY zg5_ma FROM r_ma.
      MESSAGE s001(00) WITH 'Se modifico con exito el material: 'p_matnr p_werks.
    ELSE.
      MESSAGE e001(00) WITH 'No se encontro este material: 'p_matnr p_werks.
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