  METHOD if_http_extension~handle_request.
    " 1. Create the Request Context
    DATA(lo_context) = NEW zcl_api_request_context( server ).

    " 2. High-level Routing (Protocol Selection)
    " If you map your SICF node to /api, then /api/graphql goes one way, /api/v1/ goes another.
    IF lo_context->path CP '/graphql*'.

      me->handle_graphql( io_context = lo_context io_server = server ).

    ELSEIF lo_context->path CP '/v1/*'.

      me->handle_rest( io_context = lo_context io_server = server ).

    ELSE.
      " 404 - Unsupported Protocol or Endpoint
      server->response->set_status( code = 404 reason = 'Endpoint Not Found' ).
    ENDIF.

    " 3. Close the ICF cycle
    if_http_extension~flow_rc = if_http_extension=>co_flow_ok.
  ENDMETHOD.