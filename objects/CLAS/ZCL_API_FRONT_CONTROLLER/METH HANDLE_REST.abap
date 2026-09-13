  METHOD handle_rest.
    DATA: lo_router      TYPE REF TO zcl_rest_router,
          lv_payload     TYPE string,
          lv_status_code TYPE i.

    " Instantiate the router and pass it the context
    CREATE OBJECT lo_router.

    lo_router->route(
      EXPORTING io_context     = io_context
      IMPORTING ev_payload     = lv_payload
                ev_status_code = lv_status_code
    ).

    " Send the final response back to SAP ICF
    io_server->response->set_cdata( lv_payload ).
    io_server->response->set_header_field( name = 'Content-Type' value = 'application/json' ).
    io_server->response->set_status( code = lv_status_code reason = 'REST Response' ).
  ENDMETHOD.