/* AA : AA Main dashboard : hires value by type of service : prod */ 
select
    str_to_date(concat(yearweek(final.hiring_date), ' Sunday'), '%X%V %W') as date,
    sum(
        if(
            final.fulfillment LIKE '%prime%'
            or final.fulfillment  LIKE '%ats%'
            or final.fulfillment  LIKE '%self_service%',
            final.hire_value,
            0
        )
    ) AS general_hiresvalue,
    sum(
        if(
            final.fulfillment LIKE '%prime%',
            final.hire_value,
            0
        )
    ) AS prime_hiresvalue,
    sum(
        if(
            final.fulfillment LIKE '%ats%',
            final.hire_value,
            0
        )
    ) AS ats_hiresvalue,
    sum(
        if(
            final.fulfillment LIKE '%self_service%',
            final.hire_value,
            0
        )
    ) AS ss_hiresvalue
from
    (
        select
            compensations.hiring_date,
            compensations.periodicity,
            compensations.fulfillment,
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
                    o.fulfillment,
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
                where
                    oc.currency in ('COP$', 'USD$')
                    and osh.hiring_date is not null
            ) as compensations
    ) as final
where final.hire_value < '600000'
group by 
    str_to_date(concat(yearweek(hiring_date), ' Sunday'), '%X%V %W')