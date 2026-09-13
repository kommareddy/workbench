  PRIVATE SECTION.
    METHODS handle_graphql
      IMPORTING io_context TYPE REF TO zcl_api_request_context
                io_server  TYPE REF TO if_http_server.

    METHODS handle_rest
      IMPORTING io_context TYPE REF TO zcl_api_request_context
                io_server  TYPE REF TO if_http_server.