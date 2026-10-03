*"* local class implementation for ZCL_IM_CTS_MANDATORY_ATTR

class lcl_wboattr_provider implementation.

  method lif_oblig_provider~get_config.
    " Natural, honest SELECT on the config table. WBOATTR is a tiny config
    " table keyed only by ATTR, so there is no index on OBLIGATORY/REFERENCE;
    " if ZABAP_CLOUD_DEVELOPMENT flags the WHERE (CI_ANALYZE_WHERE), that is an
    " exemption decision for the COE - reading the whole table instead would
    " only trade it for a "no WHERE" finding.
    try.
        select attr, obligatory, reference
          from wboattr
          where obligatory = @abap_true
             or reference  = @abap_true
          into table @rt_cfg.
      catch cx_sy_open_sql_db.
        " Fail open: config unreadable -> empty set -> no block.
        clear rt_cfg.
    endtry.
  endmethod.

endclass.