  METHOD zif_rest_resource~get.
    " Simulated business logic for a GET request
    ev_payload = |\{ "users": [ \{ "id": 1, "name": "Alice" \}, \{ "id": 2, "name": "Bob" \} ] \}|.
    ev_status_code = 200.
  ENDMETHOD.