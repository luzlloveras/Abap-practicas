*&---------------------------------------------------------------------*
*& Report ZG5_PROVCLI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zg5_provcli.

initialization.

  include: zg5_provcli_top,
  zg5_provcli_f01.


start-of-selection.

  case: p_prov.
    when 'X'.
      perform f_selec_prov.
      if p_alta eq 'X'.
        perform f_alta_prov.
      else.
        if p_mod eq 'X'.
          perform f_mod_prov.
        else.
          perform f_baja_prov.
        endif.
      endif.
    when ''.
      perform f_selec_cli.
      if p_alta eq 'X'.
        perform f_alta_cli.
      else.
        if p_mod eq 'X'.
          perform f_mod_cli.
        else.
          perform f_baja_cli.
        endif.
      endif.
  endcase.


at selection-screen output.

  perform f_radiobuttom.