/* AA : Users segmentation: applicants : prod */ 
SELECT
    people.gg_id AS `gg_id`,
    people.subject_identifier AS `id`,
    min(date(oc.created)) AS `date_started_app`
FROM
    people
    LEFT JOIN opportunity_candidates oc ON people.id = oc.person_id
WHERE
    (
        oc.created IS NOT NULL
        AND date(oc.created) > '2021-08-01'
        AND people.verified = TRUE
    )
GROUP BY gg_id
ORDER BY date_started_app ASC