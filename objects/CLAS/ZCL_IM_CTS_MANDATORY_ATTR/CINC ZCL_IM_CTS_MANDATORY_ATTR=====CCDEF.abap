*"* local class definitions for ZCL_IM_CTS_MANDATORY_ATTR

" DEVSECOPS-10: configuration row for one request attribute and its two
" obligation flags (WBOATTR-OBLIGATORY, WBOATTR-REFERENCE).
types:
  begin of ty_oblig_cfg,
    attr       type wboattr-attr,
    obligatory type wboattr-obligatory,
    reference  type wboattr-reference,
  end of ty_oblig_cfg,
  ty_oblig_cfg_t type standard table of ty_oblig_cfg with empty key.

" Provider of the obligatory-attribute configuration. Factored out so the
" validation can be unit-tested with a test double, no database needed.
interface lif_oblig_provider.
  methods get_config
    returning value(rt_cfg) type ty_oblig_cfg_t.
endinterface.

" Production provider: reads WBOATTR. Fails open - on a read failure it
" returns an empty set, so the caller takes the "nothing mandatory" path
" rather than blocking every release.
class lcl_wboattr_provider definition create public.
  public section.
    interfaces lif_oblig_provider.
endclass.