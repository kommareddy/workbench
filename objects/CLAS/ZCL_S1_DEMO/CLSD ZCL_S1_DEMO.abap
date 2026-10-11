class-pool .
*"* class pool for class ZCL_S1_DEMO

*"* local type definitions
include ZCL_S1_DEMO===================ccdef.

*"* class ZCL_S1_DEMO definition
*"* public declarations
  include ZCL_S1_DEMO===================cu.
*"* protected declarations
  include ZCL_S1_DEMO===================co.
*"* private declarations
  include ZCL_S1_DEMO===================ci.
endclass. "ZCL_S1_DEMO definition

*"* macro definitions
include ZCL_S1_DEMO===================ccmac.
*"* local class implementation
include ZCL_S1_DEMO===================ccimp.

*"* test class
include ZCL_S1_DEMO===================ccau.

class ZCL_S1_DEMO implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_S1_DEMO implementation
