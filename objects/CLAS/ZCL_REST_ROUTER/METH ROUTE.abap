  METHOD route.
    DATA: lv_resource_name TYPE string,
          lv_class_name    TYPE string,
          lo_resource      TYPE REF TO zif_rest_resource.

    " 1. Extract the resource name from the path.
    " Example: path is "/v1/users". We want "users".
    " (You can make this regex/parsing much more robust later)
    SPLIT io_context->path AT '/' INTO TABLE DATA(lt_path_segments).

    " Assuming segment 1 is empty (before first /), segment 2 is 'v1', segment 3 is resource
    READ TABLE lt_path_segments INTO lv_resource_name INDEX 3.
    IF sy-subrc <> 0 OR lv_resource_name IS INITIAL.
      ev_status_code = 400.
      ev_payload = |\{ "error": "Bad Request: No resource specified" \}|.
      RETURN.
    ENDIF.

    " 2. Construct the target class name based on our convention
    lv_class_name = |ZCL_API_{ to_upper( lv_resource_name ) }_RESOURCE|.

    " 3. Dynamically instantiate the class
    TRY.
        CREATE OBJECT lo_resource TYPE (lv_class_name).
      CATCH cx_sy_create_object_error.
        ev_status_code = 404.
        ev_payload = |\{ "error": "Resource not found" \}|.
        RETURN.
    ENDTRY.

    " 4. Route to the correct HTTP verb method
    CASE io_context->method.
      WHEN 'GET'.
        lo_resource->get( EXPORTING io_context = io_context
                          IMPORTING ev_payload = ev_payload
                                    ev_status_code = ev_status_code ).
      WHEN 'POST'.
        lo_resource->post( EXPORTING io_context = io_context
                           IMPORTING ev_payload = ev_payload
                                     ev_status_code = ev_status_code ).
      WHEN OTHERS.
        ev_status_code = 405. " Method Not Allowed
        ev_payload = |\{ "error": "HTTP method not supported" \}|.
    ENDCASE.

  ENDMETHOD.