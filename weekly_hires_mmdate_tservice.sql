/* AA : AA Main dashboard : hires by mm date by type of service : prod */
SELECT
    str_to_date(concat(yearweek(general.hiring_date), 'Monday'),'%X%V %W') as date,
    sum(
        if(
            general.fulfillment LIKE '%prime%'
            or general.fulfillment LIKE '%ats%'
            or general.fulfillment LIKE '%self_service%',
            general.hires,
            0
        )
    ) AS general_hires_mmdate,
    sum(
        if(
            (general.fulfillment LIKE '%prime%' or general.fulfillment LIKE '%agile%'),
            general.hires,
            0
        )
    ) AS prime_hires_mmdate,
    sum(
        if(
            general.fulfillment LIKE '%ats%',
            general.hires,
            0
        )
    ) AS ats_hires_mmdate,
    sum(
        if(
            general.fulfillment LIKE '%self_service%',
            general.hires,
            0
        )
    ) AS ss_hires_mmdate
FROM(
SELECT
    date(occh.created) AS hiring_date,
    o.fulfillment,
    count(distinct occh.candidate_id) AS hires
FROM
    opportunity_candidate_column_history occh
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
    LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
    LEFT JOIN opportunity_operational_hires ooh ON occh.candidate_id = ooh.opportunity_candidate_id
WHERE
    oc.name = 'mutual matches'
    AND occh.created >= '2021-7-18'
    AND oca.interested IS NOT NULL
    AND ooh.hiring_date IS NOT NULL
    AND oca.application_step IS NOT NULL
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
    date(occh.created),
    o.fulfillment
) AS general
GROUP BY 
    str_to_date(concat(yearweek(general.hiring_date), ' Sunday'),'%X%V %W')