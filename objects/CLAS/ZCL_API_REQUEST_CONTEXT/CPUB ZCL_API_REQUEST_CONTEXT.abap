class ZCL_API_REQUEST_CONTEXT definition
  public
  create public .

public section.

  data METHOD type STRING read-only .
  data PATH type STRING read-only .
  data BODY_PAYLOAD type STRING read-only .

  methods CONSTRUCTOR
    importing
      !IO_SERVER type ref to IF_HTTP_SERVER
      !IV_TRACE type ABAP_BOOL optional
      !IV_GET_HEADER type ABAP_BOOL optional .
  methods GET_HEADER
    importing
      !IV_NAME type STRING
    returning
      value(RV_VALUE) type STRING .