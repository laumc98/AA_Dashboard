/* AA : AA Main dashboard : weekly mm per channel by app date : prod */ 
SELECT
    str_to_date(concat(yearweek(oca.interested), ' Sunday'),'%X%V %W') AS 'date',
    oca.opportunity_id AS 'ID',
    tc.utm_medium AS 'Tracking Codes__utm_medium',
    count(distinct oca.id) AS 'weekly_mm_channel_appdate'
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
    AND datediff(date(oca.interested), date(occh.created)) <= 7
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
            date(coalesce(null, o.first_reviewed, o.last_reviewed)) >= '2021/01/01'
            AND o.objective NOT LIKE '**%'
            AND o.review = 'approved'
    )
GROUP BY 
    str_to_date(concat(yearweek(oca.interested), ' Sunday'),'%X%V %W'),
    tc.utm_medium,
    oca.opportunity_id