/* AA : AA Main dashboard : weekly hires per channel : prod */ 
SELECT
    str_to_date(concat(yearweek(ooh.hiring_date),' Sunday'),'%X%V %W') AS 'date',
    ooh.opportunity_id AS 'ID',
    tc.utm_medium AS 'Tracking Codes__utm_medium',
    count(distinct ooh.opportunity_candidate_id) AS 'weekly_hires_channel'
FROM 
    opportunity_operational_hires ooh
    LEFT JOIN tracking_code_candidates tcc ON ooh.opportunity_candidate_id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE
    ooh.hiring_date IS NOT NULL 
    AND ooh.hiring_date > '2021-7-18'
    AND ooh.opportunity_id IN (
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
    str_to_date(concat(yearweek(ooh.hiring_date),' Sunday'),'%X%V %W'),
    tc.utm_medium,
    ooh.opportunity_id