/* AA : AA Main dashboard : weekly ss mm per channel by app date : prod */ 
SELECT
    str_to_date(concat(yearweek(oca.interested), ' Sunday'),'%X%V %W') AS 'date',
    oca.opportunity_id AS 'ID',
    tc.utm_medium AS 'Tracking Codes__utm_medium',
    count(distinct oca.id) AS 'weekly_mm_channel_appdate_ss'
FROM
    opportunity_candidates oca 
    INNER JOIN opportunities o ON oca.opportunity_id = o.id 
    LEFT JOIN tracking_code_candidates tcc ON oca.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
    LEFT JOIN opportunity_candidate_column_history occh ON oca.id = occh.candidate_id
    LEFT JOIN opportunity_columns oc ON occh.to = oc.id
WHERE
    oca.interested IS NOT NULL 
    AND oc.name = 'mutual matches'
    AND occh.created IS NOT NULL
    AND oca.interested > '2021-7-18'
    AND o.objective NOT LIKE '**%'
    AND oca.application_step IS NOT NULL
    AND o.id IN (
        SELECT
            DISTINCT o.id AS opportunity_id
        FROM
            opportunities o
            INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
            AND omp.poster = TRUE
            INNER JOIN person_flags pf ON pf.person_id = omp.person_id
            AND pf.opportunity_crawler = FALSE
        WHERE
            o.reviewed >= '2021/01/01'
            AND o.objective NOT LIKE '**%'
            AND o.review = 'approved'
            AND (o.fulfillment LIKE '%self_service%' or o.fulfillment LIKE '%essentials%')
    )
GROUP BY 
    str_to_date(concat(yearweek(oca.interested), ' Sunday'),'%X%V %W'),
    tc.utm_medium,
    oca.opportunity_id