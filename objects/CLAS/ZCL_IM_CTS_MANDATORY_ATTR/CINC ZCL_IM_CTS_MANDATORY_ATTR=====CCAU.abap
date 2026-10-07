*"* ABAP Unit tests for ZCL_IM_CTS_MANDATORY_ATTR
*"* validate( ) is tested directly; the gate / ERR_MESSAGES / CANCEL path is
*"* tested through check_before_release with an injected provider double.
*"* No database and no live transport are needed.

" The test class reaches private members (set_provider, validate) of the CUT.
class ltc_validate definition deferred.
class zcl_im_cts_mandatory_attr definition local friends ltc_validate.

" Provider double: returns a fixed config set, no database.
class ltd_provider definition.
  public section.
    interfaces lif_oblig_provider.
    data mt_cfg type ty_oblig_cfg_t.
endclass.

class ltd_provider implementation.
  method lif_oblig_provider~get_config.
    rt_cfg = mt_cfg.
  endmethod.
endclass.


class ltc_validate definition
  for testing
  risk level harmless
  duration short
  final.

  private section.
    data mo_cut type ref to zcl_im_cts_mandatory_attr.

    methods setup.

    " helpers
    methods cfg
      importing iv_attr       type trattr
                iv_obligatory type abap_bool
                iv_reference  type abap_bool
      returning value(rs)     type ty_oblig_cfg.
    methods attr
      importing iv_attr      type trattr
                iv_reference type trvalue
      returning value(rs)    type e070a.
    methods make_provider
      importing it_cfg          type ty_oblig_cfg_t
      returning value(ro_prov)  type ref to lif_oblig_provider.

    " validate( ) cases
    methods obligatory_missing      for testing.
    methods reference_blank         for testing.
    methods reference_only_absent   for testing.
    methods obligatory_only_blankval for testing.
    methods all_present_ok          for testing.
    methods both_flags_absent_one   for testing.
    methods empty_config_ok         for testing.
    methods multiple_failures       for testing.

    " DEVSECOPS-11: placeholder values count as empty for REFERENCE.
    methods placeholder_tbd          for testing.
    methods placeholder_na_lower     for testing.
    methods placeholder_dash_blanks  for testing.
    methods real_key_ok              for testing.
    methods placeholder_obligatory_ok for testing.

    " check_before_release( ) integration cases (gate, ERR_MESSAGES, CANCEL)
    methods release_task_passes     for testing.
    methods release_wb_blocks       for testing.
endclass.


class ltc_validate implementation.

  method setup.
    mo_cut = new zcl_im_cts_mandatory_attr( ).
  endmethod.

  method cfg.
    rs-attr       = iv_attr.
    rs-obligatory = iv_obligatory.
    rs-reference  = iv_reference.
  endmethod.

  method attr.
    rs-attribute = iv_attr.
    rs-reference = iv_reference.
  endmethod.

  method make_provider.
    data(lo_prov) = new ltd_provider( ).
    lo_prov->mt_cfg = it_cfg.
    ro_prov = lo_prov.
  endmethod.

  method obligatory_missing.
    " Scenario 1: obligatory attribute not attached -> one 001 error.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_true iv_reference = abap_false ) ) ).
    data(lt_att) = value trattributes( ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '001' ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgv1 exp = 'ZSTORY' ).
  endmethod.

  method reference_blank.
    " Scenario 2: reference-mandatory attribute attached but value blank -> 002.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = space ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '002' ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgv1 exp = 'ZSTORY' ).
  endmethod.

  method reference_only_absent.
    " reference-only, not attached -> no error (value-obligation applies
    " only once the attribute is attached).
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes( ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method obligatory_only_blankval.
    " obligatory-only, attached with a blank value -> no error (presence
    " satisfied, value not required).
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_true iv_reference = abap_false ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = space ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method all_present_ok.
    " Scenario 3: all flagged attributes present with non-blank values.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY'      iv_obligatory = abap_true iv_reference = abap_true ) )
      ( cfg( iv_attr = 'ZTARGET_SYS' iv_obligatory = abap_true iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY'      iv_reference = 'DEVSECOPS-10' ) )
      ( attr( iv_attr = 'ZTARGET_SYS' iv_reference = 'PRD' ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method both_flags_absent_one.
    " Attribute with both flags, absent -> exactly one error (001), not two.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_true iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes( ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '001' ).
  endmethod.

  method empty_config_ok.
    " No flagged attributes at all -> no error.
    data(lt_cfg) = value ty_oblig_cfg_t( ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = space ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method multiple_failures.
    " Two flagged attrs: one missing (001), one attached-but-blank (002).
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY'      iv_obligatory = abap_true  iv_reference = abap_false ) )
      ( cfg( iv_attr = 'ZTARGET_SYS' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZTARGET_SYS' iv_reference = space ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_err[ msgv1 = 'ZSTORY' ]-msgno      exp = '001' ).
    cl_abap_unit_assert=>assert_equals(
      act = lt_err[ msgv1 = 'ZTARGET_SYS' ]-msgno exp = '002' ).
  endmethod.

  method placeholder_tbd.
    " Scenario 1: ZSTORY = TBD on a reference-mandatory attr -> 002, as empty.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = 'TBD' ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '002' ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgv1 exp = 'ZSTORY' ).
  endmethod.

  method placeholder_na_lower.
    " Scenario 2a: n/a in lower case -> blocked the same way (002).
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = 'n/a' ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '002' ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgv1 exp = 'ZSTORY' ).
  endmethod.

  method placeholder_dash_blanks.
    " Scenario 2b: a dash with blanks around it -> blocked the same way (002).
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = ' - ' ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '002' ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgv1 exp = 'ZSTORY' ).
  endmethod.

  method real_key_ok.
    " Scenario 3: a real key such as DEVSECOPS-11 -> no error, release proceeds.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_false iv_reference = abap_true ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = 'DEVSECOPS-11' ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method placeholder_obligatory_ok.
    " A placeholder in an OBLIGATORY-only attr is NOT an error: presence is
    " satisfied and the value is not required (REFERENCE flag off). Guards
    " against the placeholder rule leaking into the obligatory-only branch.
    data(lt_cfg) = value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_true iv_reference = abap_false ) ) ).
    data(lt_att) = value trattributes(
      ( attr( iv_attr = 'ZSTORY' iv_reference = 'TBD' ) ) ).

    data(lt_err) = mo_cut->validate( it_cfg = lt_cfg it_attributes = lt_att ).

    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method release_task_passes.
    " Type 'S' (task) with a missing obligatory attr -> gate passes it
    " through: no exception, ERR_MESSAGES empty.
    mo_cut->set_provider( make_provider( value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_true iv_reference = abap_false ) ) ) ) ).

    data lt_err type ctsgerrmsgs.
    mo_cut->if_ex_cts_request_check~check_before_release(
      exporting type       = 'S'
      changing  err_messages = lt_err
      exceptions cancel     = 1
                 others     = 2 ).

    cl_abap_unit_assert=>assert_subrc( exp = 0 act = sy-subrc ).
    cl_abap_unit_assert=>assert_initial( lt_err ).
  endmethod.

  method release_wb_blocks.
    " Type 'K' (Workbench) with a missing obligatory attr -> aborts:
    " CANCEL raised (sy-subrc 1) and one 001 row in ERR_MESSAGES.
    mo_cut->set_provider( make_provider( value ty_oblig_cfg_t(
      ( cfg( iv_attr = 'ZSTORY' iv_obligatory = abap_true iv_reference = abap_false ) ) ) ) ).

    data lt_err type ctsgerrmsgs.
    mo_cut->if_ex_cts_request_check~check_before_release(
      exporting type       = 'K'
      changing  err_messages = lt_err
      exceptions cancel     = 1
                 others     = 2 ).

    cl_abap_unit_assert=>assert_subrc( exp = 1 act = sy-subrc ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_err ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgno exp = '001' ).
    cl_abap_unit_assert=>assert_equals( act = lt_err[ 1 ]-msgv1 exp = 'ZSTORY' ).
  endmethod.

endclass.