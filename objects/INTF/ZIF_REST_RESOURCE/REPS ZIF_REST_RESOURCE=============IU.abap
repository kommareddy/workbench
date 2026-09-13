INTERFACE zif_rest_resource
  PUBLIC .

  " Each method takes the context and returns a JSON string and an HTTP status code
  METHODS get
    IMPORTING io_context     TYPE REF TO zcl_api_request_context
    EXPORTING ev_payload     TYPE string
              ev_status_code TYPE i.

  METHODS post
    IMPORTING io_context     TYPE REF TO zcl_api_request_context
    EXPORTING ev_payload     TYPE string
              ev_status_code TYPE i.

ENDINTERFACE.