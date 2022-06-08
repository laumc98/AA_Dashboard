/* AA : AA Main dashboard : hires value remote : prod */ 
select
    str_to_date(concat(yearweek(hiring_date), ' Sunday'), '%X%V %W') as hiring_date,
    utm,
    final.hire_value  as weekly_from_TSO
from
    (
        select
            compensations.hiring_date,
            compensations.utm,
            case
                when compensations.periodicity = 'yearly' then dollars
                when compensations.periodicity = 'monthly' then dollars * 12
                when compensations.periodicity = 'weekly' then dollars * 48
                when compensations.periodicity = 'daily' then dollars * 240
                when compensations.periodicity = 'hourly' then dollars * 1920
                when compensations.periodicity = 'project' then dollars
            end as hire_value
        from
            (
                select
                    oc.periodicity,
                    osh.hiring_date,
                    tc.utm_medium as utm,
                    case
                        when oc.max_amount is not null then IF(
                            oc.currency = 'COP$',
                            oc.max_amount / 4000,
                            oc.max_amount
                        )
                        else IF(
                            oc.currency = 'COP$',
                            oc.min_amount / 4000,
                            oc.min_amount
                        )
                    end as dollars
                from
                    opportunity_operational_hires osh
                    inner join opportunities o on o.id = osh.opportunity_id
                    inner join opportunity_compensations oc on o.id = oc.opportunity_id
                    and oc.active
                    and o.remote
                    inner join opportunity_organizations org on org.opportunity_id = o.id
                    and org.organization_id != '748404'
                    and org.active = true
                    inner join opportunity_candidates oca on (
                        oca.opportunity_id = osh.opportunity_id
                        and oca.id = osh.opportunity_candidate_id
                    )
                    left join tracking_code_candidates tcc on tcc.candidate_id = oca.id
                    left join tracking_codes tc on tc.id = tcc.tracking_code_id
                where
                    oc.currency in ('COP$', 'USD$')
                    and osh.hiring_date is not null
            ) as compensations
    ) as final
where final.hire_value < '600000'
