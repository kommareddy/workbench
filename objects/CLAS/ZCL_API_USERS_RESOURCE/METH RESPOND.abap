  METHOD respond.
    DATA lv_trimmed TYPE string.
    lv_trimmed = iv_user_name.
    CONDENSE lv_trimmed.
    IF lv_trimmed IS INITIAL.
      " Blank user name (empty or spaces-only): refuse with a 400-type answer naming the field.
      ev_payload = |\{ "error": "user_name must not be blank" \}| ##NO_TEXT.
      ev_status_code = 400.
      RETURN.
    ENDIF.

    " Simulated business logic for a GET request
    ev_payload = |\{ "users": [ \{ "id": 1, "name": "Alice" \}, \{ "id": 2, "name": "Bob" \} ] \}| ##NO_TEXT.
    ev_status_code = 200.
  ENDMETHOD.