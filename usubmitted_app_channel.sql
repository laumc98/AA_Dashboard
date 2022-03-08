select str_to_date(concat(yearweek(`opportunity_candidates`.`created`), ' Sunday'), '%X%V %W')  as date,  IF(ISNULL(interested), 'started', 'finished') as finished, tc.utm_medium as UTM, count(distinct opportunity_candidates.id) as applications 
from opportunity_candidates
inner join opportunities as o on opportunity_candidates.opportunity_id = o.id
left join tracking_code_candidates as tcc
    left join tracking_codes as tc on tcc.tracking_code_id = tc.id
  on tcc.candidate_id = opportunity_candidates.id
left join opportunity_members on o.id = opportunity_members.opportunity_id and poster = 1
left join people on opportunity_members.person_id = people.id
left join person_flags on people.id = person_flags.person_id
where  date(opportunity_candidates.created) between date_sub(now(), interval 262 day) and now() AND
o.objective not like '***%'
and tc.utm_medium in ('srh_jobs', 'ja_mtc', 'am_sug', 'rc_cb_rcdt', 'rc_trrx_inv', 'ro_sug', 'rc_syn', 'rc_src', 'pr_sml_jobs','syn','src')
group by 1, 2,3
