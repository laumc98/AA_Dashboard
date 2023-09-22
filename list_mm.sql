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
    AND o.crawled = FALSE
    AND (
        occh.created >= date(now(6))
        AND occh.created < date(date_add(now(6), INTERVAL 1 day))
    )