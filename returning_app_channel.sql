/* AA : AA Main dashboard : returning general applications : prod */
SELECT
    str_to_date(concat(yearweek(oc.interested), ' Sunday'),'%X%V %W') AS date,
    tc.utm_medium AS UTM,
    count(distinct oc.id) AS returning_applications
FROM
    opportunity_candidates oc 
    INNER JOIN opportunities o ON oc.opportunity_id = o.id 
    LEFT JOIN tracking_code_candidates tcc ON oc.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id 
WHERE
    oc.interested IS NOT NULL 
    AND oc.interested > '2021-7-18'
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
    AND oc.id NOT IN (
        SELECT
            min(oc.id)
        FROM
            opportunity_candidates oc
        GROUP BY
            oc.person_id
    )
GROUP BY 
    str_to_date(concat(yearweek(oc.interested), ' Sunday'),'%X%V %W'),
    tc.utm_medium