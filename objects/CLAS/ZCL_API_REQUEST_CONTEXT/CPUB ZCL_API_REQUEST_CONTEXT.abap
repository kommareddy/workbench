CLASS zcl_api_request_context DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    DATA: method       TYPE string READ-ONLY,
          path         TYPE string READ-ONLY,
          body_payload TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING io_server TYPE REF TO if_http_server.

    METHODS get_header
      IMPORTING iv_name          TYPE string
      RETURNING VALUE(rv_value)  TYPE string.
