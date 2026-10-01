  METHOD get_users_by_filter.
    " Returns the names of users matching the supplied filter.
    " No dynamic SQL: the name pattern and the optional user type are passed
    " as host variables into a static WHERE. The caller's * wildcard is
    " translated to the SQL % wildcard before the SELECT.
    DATA lt_users TYPE STANDARD TABLE OF usr02-bname WITH EMPTY KEY.
    DATA lv_pattern TYPE xubname.

    lv_pattern = iv_name_pattern.
    REPLACE ALL OCCURRENCES OF '*' IN lv_pattern WITH '%'.

    IF iv_user_type IS INITIAL.
      SELECT bname
        FROM usr02
        WHERE bname LIKE @lv_pattern
        INTO TABLE @lt_users.
    ELSE.
      SELECT bname
        FROM usr02
        WHERE bname LIKE @lv_pattern
          AND ustyp = @iv_user_type
        INTO TABLE @lt_users.
    ENDIF.

    rt_names = VALUE #( FOR ls_user IN lt_users ( CONV string( ls_user ) ) ).
  ENDMETHOD.