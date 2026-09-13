CLASS zcl_rest_router DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS route
      IMPORTING io_context     TYPE REF TO zcl_api_request_context
      EXPORTING ev_payload     TYPE string
                ev_status_code TYPE i.