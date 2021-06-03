*&---------------------------------------------------------------------*
*& Include          ZG5_OC_F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form F_VALIDACIONES
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_EBELN
*&      --> P_MATNR
*&      --> P_WERKS
*&      --> P_ZMENG
*&      --> P_MEINS
*&      --> P_VBELN
*&      --> P_LIFNR
*&---------------------------------------------------------------------*
form f_validaciones  using    p_p_ebeln type zg5_ebeln
                              p_p_matnr type zg5_matnr
                              p_p_werks type zg5_werks_d
                              p_p_zmeng type zg5_zmeng
                              p_p_meins type zg5_meins
                              p_p_vbeln type zg5_vbeln
                              p_p_lifnr type zg5_lifnr.



*--------------- Pasos a seguir ------------
* chequear p_p_matnr (material - existencia) y p_p_zmeng (cantidad - stock) de tabla materiales zg5_ma
* chequear p_p_lifnr (proveedor) de tabla proveedores
*validar los parametros de ordenes de venta
*validar el stock del material pasado en abm de materiales

*hacer la orden de compra: si es que ov no tiene stock ---> 10000 materiales
*si es nuevo producto 50000 materiales

*--------------- Seleccion para chequear parametros ------------

  select single *
  from zg5_ma        "de la tabla se11 materiales zg5_ma
  into @data(wa_material)   "dentro de la workin area guarde el material y su cantidad
  where matnr = @p_p_matnr
  and werks = @p_p_werks.

  if sy-subrc is initial.        "Si el material existe, hacemos orden de compra con los parametros que me pasan
    data l_zmeng_aux type string.
    l_zmeng_aux = p_p_zmeng.
    condense l_zmeng_aux no-gaps.
*--------------------------------------- BATCH DE ORDEN DE COMPRA PARA MATERIAL EXISTENTE ---------------------------
    refresh bdc_tab.
    perform zfill_oc_tab using:
    'X' 'SAPMSVMA' '0100',
    ' ' 'BDC_OKCODE' '=UPD',
    ' ' 'VIEWNAME' 'ZG5_OC',
    ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
    'X' 'SAPLZLLOVERAS' '0008',
    ' ' 'BDC_OKCODE' '=NEWL',
    'X' 'SAPLZLLOVERAS' '0008',
    ' ' 'BDC_OKCODE' '/00',
    ' ' 'ZG5_OC-EBELN(01)' p_p_ebeln,
    ' ' 'ZG5_OC-MATNR(01)' p_p_matnr,
    ' ' 'ZG5_OC-WERKS(01)' p_p_werks,
    ' ' 'ZG5_OC-ZMENG(01)' l_zmeng_aux,
    ' ' 'ZG5_OC-MEINS(01)' p_p_meins,
    ' ' 'ZG5_OC-VBELN_F(01)' p_p_vbeln,
    ' ' 'ZG5_OC-LIFNR(01)' p_p_lifnr,
    'X' 'SAPLZLLOVERAS' '0008',
    ' ' 'BDC_OKCODE' '/00',
    'X' 'SAPLZLLOVERAS' '0008',
    ' ' 'BDC_OKCODE' '=SAVE',
    'X' 'SAPLZLLOVERAS' '0008',
    ' ' 'BDC_OKCODE' '=BACK',
    'X' 'SAPLZLLOVERAS' '0008',
    ' ' 'BDC_OKCODE' '=BACK',
    'X' 'SAPMSVMA' '0100',
    ' ' 'BDC_OKCODE' '/EBACK'.
    call transaction 'SM30' using bdc_tab mode 'A'.

    if sy-subrc is initial.
      write 'Se realizo orden de compra exitosamente de material existente'.
    else.
      write 'No se realizo orden de compra de material existente'.
    endif.
  else. "alta de materiales
*--------------------------------------- BATCH PARA ALTA DE MATERIAL EN TABLA MATERIALES --------------------------
    refresh bdc_tab.
    perform zfill_oc_tab using:
    'X' 'ZG5_MA' '1000',
    ' ' 'BDC_OKCODE' '=ONLI',
    ' ' 'P_MATNR' p_p_matnr,
    ' ' 'P_WERKS' p_p_werks,
    ' ' 'P_LABST' '0',
    ' ' 'P_MEINS' p_p_meins,
    ' ' 'P_DES' 'Alta material',
    ' ' 'SO1' 'X',
    'X' 'SAPMSVMA' '0100',
    ' ' 'BDC_OKCODE' '/EBACK',
    'X' 'ZG5_MA' '1000',
    ' ' 'BDC_OKCODE' '/EE'.
    call transaction 'ZG5_ABM' using bdc_tab mode 'A'.
    if sy-subrc is initial.
      write 'Alta exitosa de material nuevo'.
*-------------------------- BATCH DE ORDEN DE COMPRA PARA NUEVO MATERIAL -----------------
      refresh bdc_tab.
      perform zfill_oc_tab using:
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '=UPD',
      ' ' 'VIEWNAME' 'ZG5_OC',
      ' ' 'VIMDYNFLDS-LTD_DTA_NO' 'X',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=NEWL',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '/00',
      ' ' 'ZG5_OC-EBELN(01)' p_p_ebeln,
      ' ' 'ZG5_OC-MATNR(01)' p_p_matnr,
      ' ' 'ZG5_OC-WERKS(01)' p_p_werks,
      ' ' 'ZG5_OC-ZMENG(01)' '50000',
      ' ' 'ZG5_OC-MEINS(01)' p_p_meins,
      ' ' 'ZG5_OC-VBELN_F(01)' p_p_vbeln,
      ' ' 'ZG5_OC-LIFNR(01)' p_p_lifnr,
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '/00',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=SAVE',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPLZLLOVERAS' '0008',
      ' ' 'BDC_OKCODE' '=BACK',
      'X' 'SAPMSVMA' '0100',
      ' ' 'BDC_OKCODE' '/EBACK'.
      call transaction 'SM30' using bdc_tab mode 'A'.

      if sy-subrc is initial.
        write 'Se realizo orden de compra exitosamente de nuevo material'.
      else.
        write 'No se realizo orden de compra de nuevo material'.
      endif.
    endif.
  endif.
endform.

*--------------------- BATCH INPUT ----------------------------

form zfill_oc_tab using dynbegin name value.

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