  method IF_EX_CTS_REQUEST_CHECK~CHECK_BEFORE_RELEASE.
    " Govern Workbench (K) and Customizing (W) requests only.
    if type <> c_type_workbench and type <> c_type_customizing.
      return.
    endif.

    " Read the obligatory-attribute configuration (fails open to empty).
    data(lt_cfg) = mo_provider->get_config( ).
    if lt_cfg is initial.
      " Nothing is mandatory (or config unreadable) -> do not block.
      return.
    endif.

    " SIMULATION behaves identically; this method has no side effects.
    data(lt_err) = validate( it_cfg        = lt_cfg
                             it_attributes = attributes ).
    if lt_err is initial.
      return.
    endif.

    " Return the full list on the structured channel (GUI, ADT, background),
    " then abort with the first error so every caller stops.
    append lines of lt_err to err_messages.

    data(ls_first) = lt_err[ 1 ].
    message id ls_first-msgid
            type 'E'
            number ls_first-msgno
            with ls_first-msgv1
            raising cancel.
  endmethod.