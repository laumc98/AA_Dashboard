/* AA : Users segmentation: applicants : prod */ 
SELECT
    people.gg_id AS `gg_id`,
    date(people.created) AS `date_signed_up`,
    date(oc.created) AS `date_started_app`
FROM
    people
    LEFT JOIN opportunity_candidates oc ON people.id = oc.person_id
WHERE
    (
        oc.created IS NOT NULL
        AND people.created >= '2021-06-01'
        AND people.verified = TRUE
    )
GROUP BY gg_id
ORDER BY Date_Signed_up ASC