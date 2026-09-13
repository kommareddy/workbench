METHOD get_users_by_filter.
    SELECT bname FROM usr02 WHERE (iv_where) INTO TABLE @rt_names.
  ENDMETHOD.