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

  " DEVSECOPS-11: placeholder values that count as empty for a REFERENCE-
  " mandatory attribute. Compared case-insensitively and after trimming
  " surrounding blanks. A class constant (not TVARVC) so a later story can
  " extend the set without a customizing request. Pipe-delimited; each token
  " is already upper-case and condensed, matching the normalised value.
  constants c_placeholders type string value 'TBD|N/A|-'.

  data mo_provider type ref to lif_oblig_provider .

  " Pure: no DB, no MESSAGE. Given the config and the attached attributes,
  " returns the error rows (empty = release may proceed). Unit-tested.
  methods validate
    importing
      !it_cfg        type ty_oblig_cfg_t
      !it_attributes type trattributes
    returning
      value(rt_err)  type ctsgerrmsgs .

  " DEVSECOPS-11: true when the value is blank, or is only a placeholder
  " (TBD, N/A, -). Normalises by condensing (trims surrounding blanks) and
  " upper-casing, then compares against c_placeholders. Pure, unit-tested.
  methods is_blank_or_placeholder
    importing
      !iv_value        type csequence
    returning
      value(rv_result) type abap_bool .

  " Setter for unit tests to inject a provider double.
  methods set_provider
    importing
      !io_provider type ref to lif_oblig_provider .