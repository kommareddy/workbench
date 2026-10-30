FUNCTION Z_GIT_DEMO_GREET.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_NAME) TYPE  STRING DEFAULT 'Hello'
*"     REFERENCE(IV_SPARS) TYPE  SPRAS
*"  EXPORTING
*"     REFERENCE(EV_TEXT) TYPE  STRING
*"----------------------------------------------------------------------

if iv_name = '1'.
  EV_TEXT = 'Nothing there'.
ENDIF.



ENDFUNCTION.