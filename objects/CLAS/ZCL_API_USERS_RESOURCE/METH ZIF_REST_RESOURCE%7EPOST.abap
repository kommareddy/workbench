  METHOD zif_rest_resource~post.
    " Simulated business logic for a POST request (creating a user)
    " In reality, you'd parse io_context->body_payload here
    ev_payload = |\{ "message": "User created successfully" \}|.
    ev_status_code = 201. " 201 Created
  ENDMETHOD.