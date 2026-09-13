class ZCL_API_USERS_RESOURCE definition
  public
  create public .

public section.

  interfaces ZIF_REST_RESOURCE .
    TYPES tt_names TYPE STANDARD TABLE OF usr02-bname WITH DEFAULT KEY.

  "! Returns the users matching a WHERE condition the caller passes in.
  METHODS get_users_by_filter
    IMPORTING
      iv_where        TYPE string
    RETURNING
      VALUE(rt_names) TYPE tt_names.