/* AA : Users segmentation: segments: prod */ 
SELECT
    people.gg_id AS `gg_id`,
    person_segments.person_id AS `Person ID`,
    person_segments.name AS `segments`
FROM
    person_segments
    LEFT JOIN people ON person_segments.person_id = people.id
WHERE
    DATE(people.created) >= date(date_add(now(6), INTERVAL -260 day))
ORDER BY people.gg_id DESC