/* AA : Users segmentation: candidates : prod */ 
SELECT
    people.gg_id AS `gg_id`,
    people.id AS `Person ID`,
    date(people.created) AS `date_signed_up`
FROM
    people
    LEFT JOIN opportunities_preferences ON people.id = opportunities_preferences.person_id
WHERE
    (
        opportunities_preferences.interest IS NOT NULL 
        AND DATE(people.created) >= '2021-06-01'
        AND people.verified IS NOT NULL
    )