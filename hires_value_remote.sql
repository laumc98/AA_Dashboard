select
  str_to_date(concat(yearweek(hiring_date), ' Sunday'), '%X%V %W') as date,
  final.utm,
  final.hire_value as weekly_from_TSO_remote
from (   
    select
      compensations.utm,
      compensations.hire_id,
      compensations.hiring_date,       
      compensations.hiring_verified,       
      case          
        when compensations.periodicity = 'yearly' then dollars         
        when compensations.periodicity = 'monthly' then dollars*12
        when compensations.periodicity = 'weekly' then dollars*48
        when compensations.periodicity = 'daily' then dollars*240
        when compensations.periodicity = 'hourly' then dollars*1920
        when compensations.periodicity = 'project' then dollars
      end as hire_value     
    from (
      select
        tc.utm_medium AS utm,
        osh.id AS hire_id,
        oc.periodicity,         
        osh.hiring_date,         
        osh.hiring_verified,
        case
	        when oc.max_amount is not null then IF(oc.currency = 'COP$', oc.max_amount/4000, oc.max_amount)
	        else IF(oc.currency = 'COP$', oc.min_amount/4000, oc.min_amount)
        end as dollars
      from opportunity_stats_hires osh       
      inner join opportunities o on o.id = osh.opportunity_id
      inner join opportunity_candidates oca on o.id = oca.opportunity_id
      inner join opportunity_compensations oc on o.id = oc.opportunity_id and oc.active and o.remote
			inner join opportunity_organizations org on org.opportunity_id = o.id and org.organization_id != '748404' and org.active = true
	  left join tracking_code_candidates as tcc on tcc.candidate_id = oca.id
	  left join tracking_codes as tc on tcc.tracking_code_id = tc.id 
      where oc.currency in ('COP$', 'USD$')
        and tc.utm_medium in ('srh_jobs', 'ja_mtc', 'am_sug', 'rc_cb_rcdt', 'rc_trrx_inv', 'ro_sug', 'rc_syn', 'rc_src', 'pr_sml_jobs','syn','src','sml_jobs','trr_crg','trr_webinars','google_jobs','syn_rqt','shr_ts','ref_ts','ref_ptn','ref_cdt','ref_vst_imp','ja_rlvsgl_prs','ja_allsgl_prs','ja_rlvsgl_org','ja_allsgl_org','rc_ccg','am_inv','refer')
    ) as compensations   
) as final 
group by 1,2