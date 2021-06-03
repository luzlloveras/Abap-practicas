*&---------------------------------------------------------------------*
*& Report ZG5_CLIENTES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZG5_CLIENTES.

include: ZG5_CLIENTES_top,
ZG5_CLIENTES_f01.

start-of-selection.

  perform f_recupero_datos.

end-of-selection.