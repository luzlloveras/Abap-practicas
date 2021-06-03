*&---------------------------------------------------------------------*
*& Include          ZG5_PROVCLI_F01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form F_SELEC_PROV
*&---------------------------------------------------------------------*
*&                         SELECCIÓN DE PROVEEDORES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_selec_prov .

  wa_proveedores-lifnr = p_lifnr.
  wa_proveedores-name1_gp = p_name1.
  wa_proveedores-name2_gp = p_name2.
  wa_proveedores-bukrs = p_bukrs.
  wa_proveedores-stkzn = p_stkzn.
  wa_proveedores-regio = p_regio.
  wa_proveedores-pstlz = p_pstlz.

  write 'Proveedores funciona'.

endform.


*&---------------------------------------------------------------------*
*& Form F_SELEC_CLI
*&---------------------------------------------------------------------*
*&                         SELECCIÓN DE CLIENTES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_selec_cli .

  wa_clientes-kunnr = p_kunnr.
  wa_clientes-name1_gp = p_name1.
  wa_clientes-name2_gp = p_name2.
  wa_clientes-bukrs = p_bukrs.
  wa_clientes-stkzn = p_stkzn.
  wa_clientes-regio = p_regio.
  wa_clientes-pstlz = p_pstlz.

  write 'Clientes funciona'.

endform.


*&---------------------------------------------------------------------*
*& Form F_ALTA_PROV
*&---------------------------------------------------------------------*
*&                         ALTA DE PROVEEDORES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_alta_prov .

  insert into zg5_prov values wa_proveedores.
  if sy-subrc is initial .
    commit work .
    write: 'Proveedor ingresado exitosamente',/,
    wa_proveedores.
  else.
    rollback work.
  endif.
  write 'Alta Proveedores funciona'.
endform.


*&---------------------------------------------------------------------*
*& Form F_MOD_PROV
*&---------------------------------------------------------------------*
*&                         MODIFICACIÓN DE PROVEEDORES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_mod_prov .

  update  zg5_prov from wa_proveedores.
  if sy-subrc <> 0 .
    write 'Proveedor inexistente'.
  else .
    write  'Proveedor actualizado exitosamente'.
    commit work .
  endif.
  write 'Modificación Proveedores funciona'.
endform.


*&---------------------------------------------------------------------*
*& Form F_BAJA_PROV
*&---------------------------------------------------------------------*
*&                         BAJA DE PROVEEDORES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_baja_prov .

  select *
    from zg5_prov   "Agarro de proveedores
    into table @data(lt_prov)
    where lifnr = @p_lifnr.   "Donde el lifnr que me pasan por parametro sea igual al de mi tabla proveedores


  if sy-subrc is initial.

    select *
      from zg5_oc   "Agarro de ordenes de compra
      into table @data(lt_oc)
      where lifnr = @p_lifnr.  "Donde el lifnr que me pasan por parametro sea igual al de mi tabla de ordenes de compra

    if sy-subrc is initial.
      data(lv_existefactura) = abap_true.
      loop at lt_oc into data(wa_oc).
        select single *
        from zg5_fac
        into @data(wa_fac)
        where lifnr = @wa_oc-lifnr.
        if sy-subrc is not initial.
          lv_existefactura = abap_false.
        endif.
      endloop.

      if lv_existefactura = abap_true.
        delete from zg5_prov where lifnr = p_lifnr.
        write 'Se elimino existosamente el proveedor porque su orden de compra tiene factura'.
      else.
        write 'No se puede eliminar el proveedor porque su orden de compra no tiene factura'.
      endif.
      write 'Baja Proveedores funciona'.
    else.
      delete from zg5_prov where lifnr = p_lifnr.
      write ' Se encontro proveedor sin orden de compra, eliminado'.
    endif.
  else.
    write ' No se encontro este proveedor'.
  endif.
endform.


*&---------------------------------------------------------------------*
*& Form F_ALTA_CLI
*&---------------------------------------------------------------------*
*&                         ALTA DE CLIENTES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_alta_cli .

  insert into zg5_cli values wa_clientes.
  if sy-subrc is initial .
    commit work .
    write: 'Cliente ingresado exitosamente',/,
    wa_clientes .
  else.
    rollback work.
  endif.
  write 'Alta Clientes funciona'.
endform.


*&---------------------------------------------------------------------*
*& Form F_MOD_CLI
*&---------------------------------------------------------------------*
*&                         MODIFICACIÓN DE CLIENTES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_mod_cli .

  update  zg5_cli from wa_clientes.
  if sy-subrc <> 0 .
    write 'Cliente inexistente'.
  else .
    write  'Cliente actualizado exitosamente'.
    commit work .
  endif.
  write 'Modificación Clientes funciona'.
endform.


*&---------------------------------------------------------------------*
*& Form F_BAJA_CLI
*&---------------------------------------------------------------------*
*&                         BAJA DE CLIENTES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_baja_cli .

  select *
    from zg5_cli   "Agarro de clientes
    into table @data(lt_cli)
    where kunnr = @p_kunnr.   "Donde el kunnr que me pasan por parametro sea igual al de mi tabla clientes


  if sy-subrc is initial.

    select *
      from zg5_ov   "Agarro de ordenes de venta
      into table @data(lt_ov)
      where kunnr = @p_kunnr.  "Donde el kunnr que me pasan por parametro sea igual al de mi tabla de ordenes de venta

    if sy-subrc is initial.
      data(lv_existefactura) = abap_true.
      loop at lt_ov into data(wa_ov).
        select single *
        from zg5_fac
        into @data(wa_fac)
        where kunnr = @wa_ov-kunnr.
        if sy-subrc is not initial.
          lv_existefactura = abap_false.
        endif.
      endloop.

      if lv_existefactura = abap_true.
        delete from zg5_cli where kunnr = p_kunnr.
        write 'Se elimino existosamente el cliente porque su orden de venta tiene factura'.
      else.
        write 'No se puede eliminar el cliente porque su orden de venta no tiene factura'.
      endif.
      write 'Baja cliente funciona'.
    else.
      delete from zg5_cli where kunnr = p_kunnr.
      write ' Se encontro cliente sin orden de venta, eliminado'.
    endif.
  else.
    write ' No se encontro este cliente'.
  endif.
endform.


*&---------------------------------------------------------------------*
*& Form F_RADIOBUTTOM
*&---------------------------------------------------------------------*
*&                         RADIO BUTTOMS PROVEEDORES | CLIENTES
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form f_radiobuttom .

  if p_cli eq 'X'.
    loop at screen.
      if screen-name = 'P_LIFNR'.
        screen-input = 0. "Campo no editable
        p_lifnr = ''.
        modify screen.
      endif.
    endloop.
  else.
    if p_prov eq 'X'.
      loop at screen.
        if screen-name = 'P_KUNNR'.
          screen-input = 0. "Campo no editable
          p_kunnr = ''.
          modify screen.
        endif.
      endloop.
    endif.
  endif.

endform.