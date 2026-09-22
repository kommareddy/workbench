*"* use this source file for your ABAP unit test classes
CLASS ltc_users_resource DEFINITION FINAL FOR TESTING
  DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS passes FOR TESTING.
*    METHODS fails FOR TESTING.
ENDCLASS.

CLASS ltc_users_resource IMPLEMENTATION.
  METHOD passes.
    cl_abap_unit_assert=>assert_equals( act = 2 exp = 2 msg = 'always passes' ).
  ENDMETHOD.
*  METHOD fails.
*    cl_abap_unit_assert=>assert_equals( act = 1 exp = 2 msg = 'deliberately fails - test_results proof' ).
*  ENDMETHOD.
ENDCLASS.