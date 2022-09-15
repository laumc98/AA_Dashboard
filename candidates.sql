/* AA : Users segmentation: candidates : prod */ 
SELECT
    people.gg_id AS `gg_id`,
    people.subject_identifier AS `id`,
    people.id AS `Person ID`,
    date(people.created) AS `date_signed_up`
FROM
    people
    LEFT JOIN opportunities_preferences ON people.id = opportunities_preferences.person_id
WHERE
    (
        opportunities_preferences.interest IS NOT NULL 
        AND (opportunities_preferences.interest = 'jobs-full-time'
            OR opportunities_preferences.interest = 'jobs-part-time'
            OR opportunities_preferences.interest = 'gigs'
            OR opportunities_preferences.interest = 'internships')
        AND DATE(people.created) >= date(date_add(now(6), INTERVAL -300 day))
        AND people.verified IS NOT NULL
    )