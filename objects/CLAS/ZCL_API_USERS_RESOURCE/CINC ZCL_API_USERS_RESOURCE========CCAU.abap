*"* use this source file for your ABAP unit test classes
CLASS ltc_users_resource DEFINITION FINAL FOR TESTING
  DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    "METHODS passes FOR TESTING.
    " DEVSECOPS-13: the respond() decision is unit-tested directly.
    " The live header read in get() (io_context->get_header) is NOT unit-tested:
    " ZCL_API_REQUEST_CONTEXT has no test seam (its only constructor needs a
    " real IF_HTTP_SERVER and reads headers live), and only this class may change.
    METHODS blank_name_is_rejected  FOR TESTING.
    METHODS spaces_only_is_rejected FOR TESTING.
    METHODS valid_name_returns_users FOR TESTING.
    METHODS too_long_is_rejected     FOR TESTING.
    METHODS exactly_12_is_accepted   FOR TESTING.
*    METHODS fails FOR TESTING.
ENDCLASS.

CLASS zcl_api_users_resource DEFINITION LOCAL FRIENDS ltc_users_resource.

CLASS ltc_users_resource IMPLEMENTATION.


  METHOD blank_name_is_rejected.
    DATA(lo_cut) = NEW zcl_api_users_resource( ).
    DATA lv_payload TYPE string.
    DATA lv_status  TYPE i.
    lo_cut->respond(
      EXPORTING iv_user_name  = ''
      IMPORTING ev_payload     = lv_payload
                ev_status_code = lv_status ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_status exp = 400 msg = 'empty user name must be rejected with 400' ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lv_payload CS 'user_name' )
      msg = 'the 400 payload must name the field user_name' ).
  ENDMETHOD.

  METHOD spaces_only_is_rejected.
    DATA(lo_cut) = NEW zcl_api_users_resource( ).
    DATA lv_payload TYPE string.
    DATA lv_status  TYPE i.
    lo_cut->respond(
      EXPORTING iv_user_name  = '   '
      IMPORTING ev_payload     = lv_payload
                ev_status_code = lv_status ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_status exp = 400 msg = 'spaces-only user name must be rejected with 400' ).
  ENDMETHOD.

  METHOD valid_name_returns_users.
    DATA(lo_cut) = NEW zcl_api_users_resource( ).
    DATA lv_payload TYPE string.
    DATA lv_status  TYPE i.
    lo_cut->respond(
      EXPORTING iv_user_name  = 'ALICE'
      IMPORTING ev_payload     = lv_payload
                ev_status_code = lv_status ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_status exp = 200 msg = 'a valid user name must still return 200' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_payload
      exp = |\{ "users": [ \{ "id": 1, "name": "Alice" \}, \{ "id": 2, "name": "Bob" \} ] \}|
      msg = 'a valid user name must return the user list as before' ).
  ENDMETHOD.

  METHOD too_long_is_rejected.
    DATA(lo_cut) = NEW zcl_api_users_resource( ).
    DATA lv_payload TYPE string.
    DATA lv_status  TYPE i.
    " 13 characters - one over the SAP limit of 12.
    lo_cut->respond(
      EXPORTING iv_user_name  = 'ABCDEFGHIJKLM'
      IMPORTING ev_payload     = lv_payload
                ev_status_code = lv_status ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_status exp = 400 msg = 'a user name longer than 12 must be rejected with 400' ).
    cl_abap_unit_assert=>assert_true(
      act = xsdbool( lv_payload CS 'user_name' )
      msg = 'the 400 payload must name the field user_name' ).
  ENDMETHOD.

  METHOD exactly_12_is_accepted.
    DATA(lo_cut) = NEW zcl_api_users_resource( ).
    DATA lv_payload TYPE string.
    DATA lv_status  TYPE i.
    " Exactly 12 characters - the boundary must still be looked up as before.
    lo_cut->respond(
      EXPORTING iv_user_name  = 'ABCDEFGHIJKL'
      IMPORTING ev_payload     = lv_payload
                ev_status_code = lv_status ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_status exp = 200 msg = 'a 12-character user name must still return 200' ).
    cl_abap_unit_assert=>assert_equals(
      act = lv_payload
      exp = |\{ "users": [ \{ "id": 1, "name": "Alice" \}, \{ "id": 2, "name": "Bob" \} ] \}|
      msg = 'a 12-character user name must return the documented user list unchanged' ).
  ENDMETHOD.
*  METHOD fails.
*    cl_abap_unit_assert=>assert_equals( act = 1 exp = 2 msg = 'deliberately fails - test_results proof' ).
*  ENDMETHOD.
ENDCLASS.