/* AA : Users segmentation: rol, country, genome completion : prod */ 
SELECT
    people.gg_id AS `gg_id`,
    people.id AS `Person ID`,
    people.current_role AS `role`,
    person_location.country AS `Country`,
    person_stats.completion_global AS `genome_completion`,
    opportunities_preferences.interest AS `interest`
FROM
    people
    LEFT JOIN person_location ON people.id = person_location.person_id
    LEFT JOIN person_stats ON people.id = person_stats.person_id
    LEFT JOIN opportunities_preferences ON people.id = opportunities_preferences.person_id
WHERE 
    DATE(people.created) >= date(date_add(now(6), INTERVAL -200 day))
ORDER BY people.id DESC