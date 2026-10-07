  method is_blank_or_placeholder.
    " Normalise: trim surrounding blanks and upper-case, so the compare is
    " case-insensitive and blank-insensitive.
    data(lv_norm) = to_upper( iv_value ).
    condense lv_norm.

    if lv_norm is initial.
      rv_result = abap_true.
      return.
    endif.

    split c_placeholders at '|' into table data(lt_tokens).
    rv_result = xsdbool( line_exists( lt_tokens[ table_line = lv_norm ] ) ).
  endmethod.