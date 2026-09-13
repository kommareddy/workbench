  METHOD constructor.
    mo_server = io_server.
    method    = mo_server->request->get_header_field( '~request_method' ).
    path      = mo_server->request->get_header_field( '~path_info' ).

    " Extract the raw JSON or GraphQL query payload
    body_payload = mo_server->request->get_cdata( ).
  ENDMETHOD.