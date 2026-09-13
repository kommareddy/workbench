  METHOD handle_graphql.
    " Here we will eventually call our custom GraphQL Engine
    " ZCL_GRAPHQL_ENGINE=>execute( query = io_context->body_payload ... )
    io_server->response->set_cdata( '{"message": "GraphQL engine placeholder"}' ).
    io_server->response->set_header_field( name = 'Content-Type' value = 'application/json' ).
    io_server->response->set_status( code = 200 reason = 'OK' ).
  ENDMETHOD.