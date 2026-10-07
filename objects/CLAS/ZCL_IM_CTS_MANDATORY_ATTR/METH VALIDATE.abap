  method validate.
    " OBLIGATORY = the attribute must be present; REFERENCE = its value must be filled.
    loop at it_cfg into data(ls_cfg).
      read table it_attributes into data(ls_attr)
        with key attribute = ls_cfg-attr.
      data(lv_attached) = xsdbool( sy-subrc = 0 ).

      if ls_cfg-obligatory = abap_true and lv_attached = abap_false.
        " Scenario 1: obligatory attribute not attached.
        append value #( msgid = c_msgid
                        msgty = 'E'
                        msgno = c_msgno_miss
                        msgv1 = ls_cfg-attr ) to rt_err.
        continue.
      endif.

      if ls_cfg-reference = abap_true
         and lv_attached = abap_true
         and is_blank_or_placeholder( ls_attr-reference ) = abap_true.
        " Scenario 2: attached, but value column blank or only a placeholder.
        append value #( msgid = c_msgid
                        msgty = 'E'
                        msgno = c_msgno_empty
                        msgv1 = ls_cfg-attr ) to rt_err.
      endif.
    endloop.
  endmethod.