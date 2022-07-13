/* AA : AA Main dashboard : Opp's fulfillment : prod */
SELECT
    o.id,
    o.fulfillment,
    o.reviewed,
    (SELECT p.name FROM people p WHERE o.applicant_coordinator_person_id=p.id) as AAC,
    (SELECT p.name FROM opportunity_members omp LEFT JOIN people p ON omp.person_id = p.id WHERE omp.tso_operator = TRUE AND omp.opportunity_id = o.id) as DR
FROM
    opportunities o
WHERE
    o.id IN (
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