/* AA : Users segmentation: skills: prod */ 
SELECT
    people.gg_id AS `gg_id`,
    people.created,
    strengths.person_id AS `Person ID`,
    strengths.code AS `Skill ID`,
    strengths.proficiency AS `Skill_proficiency`
FROM
    strengths
    LEFT JOIN people ON strengths.person_id = people.id
WHERE
    (
        strengths.active = TRUE
        AND strengths.proficiency IS NOT NULL
        AND DATE(people.created) >= date(date_add(now(6), INTERVAL -180 day))
    )
ORDER BY people.created asc