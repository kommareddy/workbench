  METHOD zif_rest_resource~get.
    " Reject a blank user name (empty or spaces-only) with a 400; otherwise return the list.
    DATA(lv_user_name) = io_context->get_header( 'user_name' ).
    respond(
      EXPORTING iv_user_name  = lv_user_name
      IMPORTING ev_payload     = ev_payload
                ev_status_code = ev_status_code ).
  ENDMETHOD.