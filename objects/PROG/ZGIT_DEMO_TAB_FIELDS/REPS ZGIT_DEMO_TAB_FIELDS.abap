*&---------------------------------------------------------------------*
*& Report zgit_demo_tab_fields
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgit_demo_tab_fields.
DATA lv_text TYPE CHAR40.

SELECT SINGLE text into lv_text FROM zgit_demo_tab.