  METHOD get_header.
    rv_value = mo_server->request->get_header_field( iv_name ).
  ENDMETHOD.