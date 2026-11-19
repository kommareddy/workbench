*"* use this source file for your ABAP unit test classes
CLASS ltcl_api_request_context DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_request TYPE REF TO if_http_request.
    DATA mo_server  TYPE REF TO if_http_server.

    METHODS setup.
    METHODS configure_header
      IMPORTING iv_name  TYPE string
                iv_value TYPE string.
    METHODS configure_body
      IMPORTING iv_body TYPE string.

    METHODS constructor_sets_method       FOR TESTING.
    METHODS constructor_sets_path         FOR TESTING.
    METHODS constructor_sets_body         FOR TESTING.
    METHODS constructor_ignores_flags     FOR TESTING.
    METHODS get_header_returns_value      FOR TESTING.
    METHODS get_header_unknown_is_initial FOR TESTING.
ENDCLASS.


CLASS ltcl_api_request_context IMPLEMENTATION.

  METHOD setup.
    mo_request = CAST #( cl_abap_testdouble=>create( 'IF_HTTP_REQUEST' ) ).
    mo_server  = CAST #( cl_abap_testdouble=>create( 'IF_HTTP_SERVER' ) ).
    mo_server->request = mo_request.
  ENDMETHOD.

  METHOD configure_header.
    cl_abap_testdouble=>configure_call( mo_request )->returning( iv_value ).
    mo_request->get_header_field( iv_name ).
  ENDMETHOD.

  METHOD configure_body.
    cl_abap_testdouble=>configure_call( mo_request )->returning( iv_body ).
    mo_request->get_cdata( ).
  ENDMETHOD.

  METHOD constructor_sets_method.
    configure_header( iv_name = '~request_method' iv_value = 'POST' ).

    DATA(lo_cut) = NEW zcl_api_request_context( io_server = mo_server ).

    cl_abap_unit_assert=>assert_equals( act = lo_cut->method exp = 'POST' ).
  ENDMETHOD.

  METHOD constructor_sets_path.
    configure_header( iv_name = '~path_info' iv_value = '/api/users' ).

    DATA(lo_cut) = NEW zcl_api_request_context( io_server = mo_server ).

    cl_abap_unit_assert=>assert_equals( act = lo_cut->path exp = '/api/users' ).
  ENDMETHOD.

  METHOD constructor_sets_body.
    configure_body( 'payload' ).

    DATA(lo_cut) = NEW zcl_api_request_context( io_server = mo_server ).

    cl_abap_unit_assert=>assert_equals( act = lo_cut->body_payload exp = 'payload' ).
  ENDMETHOD.

  METHOD constructor_ignores_flags.
    configure_header( iv_name = '~request_method' iv_value = 'GET' ).
    configure_header( iv_name = '~path_info' iv_value = '/api/users' ).
    configure_body( 'payload' ).

    DATA(lo_plain) = NEW zcl_api_request_context( io_server = mo_server ).
    DATA(lo_flags) = NEW zcl_api_request_context( io_server      = mo_server
                                                  iv_trace       = abap_true
                                                  iv_get_header  = abap_true ).

    cl_abap_unit_assert=>assert_equals( act = lo_flags->method       exp = lo_plain->method ).
    cl_abap_unit_assert=>assert_equals( act = lo_flags->path         exp = lo_plain->path ).
    cl_abap_unit_assert=>assert_equals( act = lo_flags->body_payload exp = lo_plain->body_payload ).
  ENDMETHOD.

  METHOD get_header_returns_value.
    configure_header( iv_name = 'x-test' iv_value = 'abc' ).
    DATA(lo_cut) = NEW zcl_api_request_context( io_server = mo_server ).

    cl_abap_unit_assert=>assert_equals( act = lo_cut->get_header( 'x-test' ) exp = 'abc' ).
  ENDMETHOD.

  METHOD get_header_unknown_is_initial.
    configure_header( iv_name = 'x-test' iv_value = 'abc' ).
    DATA(lo_cut) = NEW zcl_api_request_context( io_server = mo_server ).

    cl_abap_unit_assert=>assert_initial( lo_cut->get_header( 'x-other' ) ).
  ENDMETHOD.

ENDCLASS.