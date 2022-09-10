/* AA : Users segmentation: skills: prod */ 
SELECT
    people.gg_id AS `gg_id`,
    strengths.person_id AS `Person ID`,
    strengths.code AS `Skill ID`,
    strengths.proficiency AS `Skill_proficiency`
FROM
    strengths
    LEFT JOIN people ON strengths.person_id = people.id
WHERE
    (
        strengths.active = TRUE
        AND DATE(people.created) >= '2021-6-01'
    )
ORDER BY strengths.person_id DESC