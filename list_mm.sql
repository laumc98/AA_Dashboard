/* AA : AA Main dashboard : list mm : prod */
SELECT
    occh.candidate_id AS id,
    date(occh.created) AS date,
    o.fulfillment
FROM
    opportunity_candidate_column_history occh
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
WHERE
    oc.name = 'mutual matches'
    AND o.objective NOT LIKE '**%'
    AND (
        occh.created >= date(now(6))
        AND occh.created < date(date_add(now(6), INTERVAL 1 day))
    )
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
            o.last_reviewed >= '2021/01/01'
            AND o.objective NOT LIKE '**%'
            AND o.review = 'approved'
    )
GROUP BY
    occh.candidate_id