/* AA : AA Main dashboard : weekly ready for interview by app date: prod */
SELECT
    str_to_date(concat(yearweek(mutual_matches.mm_date), ' Sunday'),'%X%V %W') AS 'date',
    o.id AS 'ID',
    o.fulfillment AS 'fulfillment',
    tc.utm_medium AS 'Tracking Codes__utm_medium',
    count(distinct occh.candidate_id) AS 'weekly_ready_interview_mmdate'
FROM
    (
        SELECT
            date(occh.created) AS 'mm_date',
            occh.candidate_id
        FROM
            opportunity_candidate_column_history occh
            INNER JOIN opportunity_columns oc ON occh.to = oc.id
        WHERE
            oc.name = 'mutual matches'
            AND date(occh.created) >= '2021-07-18'
    ) AS mutual_matches
    INNER JOIN opportunity_candidate_column_history occh ON mutual_matches.candidate_id = occh.candidate_id
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
    LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
    LEFT JOIN tracking_code_candidates tcc ON oca.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE
    oc.funnel_tag = 'ready_for_interview'
    AND o.objective NOT LIKE '**%'
    AND date(occh.created) <= date(mutual_matches.mm_date) + 7
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
    str_to_date(concat(yearweek(mutual_matches.mm_date), ' Sunday'),'%X%V %W'),
    tc.utm_medium,
    o.id,
    o.fulfillment
ORDER BY
    str_to_date(concat(yearweek(mutual_matches.mm_date), ' Sunday'),'%X%V %W') ASC