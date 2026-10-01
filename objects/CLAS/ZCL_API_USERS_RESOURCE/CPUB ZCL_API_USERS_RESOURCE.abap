class ZCL_API_USERS_RESOURCE definition
  public
  create public .

public section.

  interfaces ZIF_REST_RESOURCE .

  "! Returns the names of users matching the supplied filter.
  "! @parameter iv_name_pattern | User name pattern; * is used as the wildcard
  "!                              and is translated to the SQL % wildcard.
  "! @parameter iv_user_type    | Optional user type (USR02-USTYP); when supplied
  "!                              only users of that type are returned.
  "! @parameter rt_names        | User names matching the filter.
  methods GET_USERS_BY_FILTER
    importing
      !IV_NAME_PATTERN type XUBNAME
      !IV_USER_TYPE    type XUUSTYP optional
    returning
      value(RT_NAMES)  type STRING_TABLE .