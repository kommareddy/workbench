class-pool .
*"* class pool for class ZCL_API_USERS_RESOURCE

*"* local type definitions
include ZCL_API_USERS_RESOURCE========ccdef.

*"* class ZCL_API_USERS_RESOURCE definition
*"* public declarations
  include ZCL_API_USERS_RESOURCE========cu.
*"* protected declarations
  include ZCL_API_USERS_RESOURCE========co.
*"* private declarations
  include ZCL_API_USERS_RESOURCE========ci.
endclass. "ZCL_API_USERS_RESOURCE definition

*"* macro definitions
include ZCL_API_USERS_RESOURCE========ccmac.
*"* local class implementation
include ZCL_API_USERS_RESOURCE========ccimp.

*"* test class
include ZCL_API_USERS_RESOURCE========ccau.

class ZCL_API_USERS_RESOURCE implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_API_USERS_RESOURCE implementation
