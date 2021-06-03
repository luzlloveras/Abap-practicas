*&---------------------------------------------------------------------*
*& Include          ZG5_OC_01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form F_RECUPERO_DATOS1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FAC
*&---------------------------------------------------------------------*
form cargar_orden_compra.

  select *
   from zg5_oc
   into table @data(it_oc)
   where ebeln = @p_op1.
 
 if sy-subrc <> 0.
  message e001(00) with 'No existe una orden de compra con este numero: ' p_op1.
 else.
 
 *VERIFICO EN LA ORDEN DE COMPRA NO TENGA UNA FACTURA ASOCIADA
   select *
   from zg5_fac
   into table @DATA(it_fac)
   where ebeln = @p_op1.
 
 *SI NO EXISTE SE CREA
   if sy-subrc is not initial.
   data l_DMBTR_aux type string.
   l_DMBTR_aux = P_OP9.
 
   DATA(lv_fecha) = |{ P_OP7 DATE = USER }|.
 
   CONDENSE l_DMBTR_aux no-gaps.
           refresh bdc_tab.
 
           perform fill_bdc_tab using:
 
           'X ' 'SAPMSVMA' '0100',
           ' '  'BDC_OKCODE' '=UPD',
           ' '  'VIEWNAME' 'zg5_fac',
           ' '  'VIMDYNFLDS-LTD_DTA_NO' 'X',
 
           'X'  'SAPLZLLOVERAS' '0011',
           ' '  'BDC_OKCODE' '=NEWL',
 
           'X'  'SAPLZLLOVERAS' '0011',
           ' '  'BDC_OKCODE' '/00',
           ' '  'zg5_fac-vbeln_vf(01)' p_op3,
           ' '  'zg5_fac-fkart(01)' P_OP10,
           ' '  'ZG5_FAC-DMBTR(01)' l_DMBTR_aux,
           ' '  'zg5_fac-waers(01)' P_OP8,
           ' '  'zg5_fac-fkdat(01)' lv_fecha,
           ' '  'zg5_fac-bukrs(01)' P_OP6,
           ' '  'zg5_fac-ebeln(01)' p_op1,
           ' '  'zg5_fac-lifnr(01)' P_OP4,
 
           'X'  'SAPLZLLOVERAS' '0011',
           ' '  'BDC_OKCODE' '=SAVE',
 
           'X'  'SAPLZLLOVERAS' '0011',
           ' '  'BDC_OKCODE' '=BACK',
 
           'X'  'SAPLZLLOVERAS' '0011',
           ' '  'BDC_OKCODE' '=BACK',
 
           'X ' 'SAPMSVMA' '0100',
           ' '  'BDC_OKCODE' '/EBACK'.
 
           call transaction 'SM30' using bdc_tab mode 'A'.
           WRITE: 'Cargado con exito'.
           if sy-subrc is initial.
 
           endif.
 
 *SI LA FACTURA ES EXISTENTE INDICAR POR MENSAJE
   else.
     message e001(00) with 'Factura existente para la orden de compra' p_op1.
   endif.
  endif.
 
 endform.
 
 form fill_bdc_tab using dynbegin name value.
 
   if dynbegin = 'X'.
     clear wa_bdc_tab.
     move: name to wa_bdc_tab-program,
     value to wa_bdc_tab-dynpro,
     'X' to wa_bdc_tab-dynbegin.
     append wa_bdc_tab to bdc_tab.
   else.
     clear wa_bdc_tab.
     move:name to wa_bdc_tab-fnam,
     value to wa_bdc_tab-fval.
     append wa_bdc_tab to bdc_tab.
   endif.
 
 endform.