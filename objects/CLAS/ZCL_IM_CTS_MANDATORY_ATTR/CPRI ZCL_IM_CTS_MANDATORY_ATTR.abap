private section.

  constants:
    " Governed request types (TRFUNCTION): K = Workbench, W = Customizing.
    " Everything else (tasks S/R/X/Q, transport of copies T, relocations
    " C/O/E, piece lists, ...) passes through untouched.
    c_type_workbench   type trfunction value 'K',
    c_type_customizing type trfunction value 'W'.

  constants:
    c_msgid       type symsgid value 'ZCTS_MANDATORY_ATTR',
    c_msgno_miss  type symsgno value '001',
    c_msgno_empty type symsgno value '002'.

  data mo_provider type ref to lif_oblig_provider .

  " Pure: no DB, no MESSAGE. Given the config and the attached attributes,
  " returns the error rows (empty = release may proceed). Unit-tested.
  methods validate
    importing
      !it_cfg        type ty_oblig_cfg_t
      !it_attributes type trattributes
    returning
      value(rt_err)  type ctsgerrmsgs .

  " Setter for unit tests to inject a provider double.
  methods set_provider
    importing
      !io_provider type ref to lif_oblig_provider .