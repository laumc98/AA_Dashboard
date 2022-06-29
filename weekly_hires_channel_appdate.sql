/* AA : AA Main dashboard : weekly hires per channel by mm date : prod */ 
SELECT
    str_to_date(concat(yearweek(occh.created), ' Sunday'),'%X%V %W') AS 'date',
    oca.opportunity_id AS 'ID',
    tc.utm_medium AS 'Tracking Codes__utm_medium',
    count(distinct occh.candidate_id) AS 'weekly_hires_channel_appdate'
FROM
    opportunity_candidate_column_history occh
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
    LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
    LEFT JOIN tracking_code_candidates tcc ON oca.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
    LEFT JOIN opportunity_operational_hires ooh ON occh.candidate_id = ooh.opportunity_candidate_id
WHERE
    oc.name = 'mutual matches'
    AND occh.created >= '2021-7-18'
    AND oca.interested IS NOT NULL
    AND ooh.hiring_date IS NOT NULL
    AND o.objective NOT LIKE '**%'
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
    )
GROUP BY
    str_to_date(concat(yearweek(occh.created), ' Sunday'),'%X%V %W'),
    tc.utm_medium,
    oca.opportunity_id
ORDER BY
    str_to_date(concat(yearweek(occh.created), ' Sunday'),'%X%V %W') ASC