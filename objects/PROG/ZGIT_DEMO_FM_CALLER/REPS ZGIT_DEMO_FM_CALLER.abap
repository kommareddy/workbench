*&---------------------------------------------------------------------*
*& Report zgit_demo_fm_caller
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgit_demo_fm_caller.
DATA lv_text TYPE string.

CALL FUNCTION 'Z_GIT_DEMO_GREET'
  EXPORTING
    iv_name       = '1'
 IMPORTING
   EV_TEXT       = lv_text
          .

WRITE lv_text.