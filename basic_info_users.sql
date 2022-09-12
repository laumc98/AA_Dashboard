/* AA : Users segmentation: rol, country, genome completion : prod */ 
SELECT
    people.gg_id AS `gg_id`,
    people.id AS `Person ID`,
    people.current_role AS `role`,
    person_location.country AS `Country`,
    person_stats.completion_global AS `genome_completion`,
    languages.person_id AS `Person ID`,
    languages.language AS `Languages`,
    languages.fluency AS `Languages__fluency`,
    person_segments.name AS `segments`,
    strengths.code AS `Skill ID`,
    strengths.proficiency AS `Skill_proficiency`
FROM
    people
    LEFT JOIN person_location ON people.id = person_location.person_id
    LEFT JOIN person_stats ON people.id = person_stats.person_id
    LEFT JOIN languages ON people.id = languages.person_id 
    LEFT JOIN person_segments ON people.id = person_segments.person_id 
    LEFT JOIN strengths ON people.id = strengths.person_id 
WHERE 
    DATE(people.created) >= date(date_add(now(6), INTERVAL -400 day))
    AND strengths.active = TRUE
    AND languages.active = TRUE
ORDER BY people.id DESC