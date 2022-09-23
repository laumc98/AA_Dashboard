/* AA : AA Main dashboard : weekly unsubmitted by type of service: prod */ 
select
    str_to_date(concat(yearweek(unsubmitted_date), 'Monday'),'%X%V %W') as date,
    general.finished,
    sum(
        if(
            general.fulfillment LIKE '%prime%',
            or general.fulfillment LIKE '%agile%',
            or general.fulfillment LIKE '%ats%',
            or general.fulfillment LIKE '%self_service%',
            or general.fulfillment LIKE '%essentials%',
            or general.fulfillment like '%staff_augmentation%',
            or general.fulfillment like '%pro%',
            general.applications,
            0
        )
    ) AS general_unsubmitted_app,
    sum(
        if(
            general.fulfillment LIKE '%prime%',
            or general.fulfillment LIKE '%agile%',
            or general.fulfillment like '%staff_augmentation%',
            general.applications,
            0
        )
    ) AS prime_unsubmitted_app,
    sum(
        if(
            general.fulfillment LIKE '%ats%',
            general.applications,
            0
        )
    ) AS ats_unsubmitted_app,
    sum(
        if(
            general.fulfillment LIKE '%self_service%',
            or general.fulfillment LIKE '%essentials%',
            general.applications,
            0
        )
    ) AS ss_unsubmitted_app
from
(
        select
            date(opportunity_candidates.created) as unsubmitted_date,
            IF(ISNULL(interested), 'started', 'finished') as finished,
            o.fulfillment,
            count(distinct opportunity_candidates.id) as applications
        from
            opportunity_candidates
            inner join opportunities as o on opportunity_candidates.opportunity_id = o.id
            left join opportunity_members on o.id = opportunity_members.opportunity_id
            and poster = 1
            left join people on opportunity_members.person_id = people.id
            left join person_flags on people.id = person_flags.person_id
            AND person_flags.opportunity_crawler = false
        where
            date(opportunity_candidates.created) > "2021-7-18"
            AND o.objective not like '***%'
            AND opportunity_candidates.application_step IS NOT NULL
        group by
            date(opportunity_candidates.created),
            IF(ISNULL(interested), 'started', 'finished'),
            o.fulfillment
    ) as general
group by
    str_to_date(concat(yearweek(unsubmitted_date), ' Sunday'),'%X%V %W'),
    general.finished