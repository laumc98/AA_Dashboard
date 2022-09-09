/* AA : Users segmentation: segments: prod */ 
SELECT
    people.gg_id AS `gg_id`,
    person_segments.person_id AS `Person ID`,
    person_segments.name AS `segments`
FROM
    person_segments
    LEFT JOIN people ON person_segments.person_id = people.id
WHERE
    (
        people.created >= '2021-12-01'
    )
ORDER BY people.gg_id DESC