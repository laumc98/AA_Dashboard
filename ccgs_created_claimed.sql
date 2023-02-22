/* AA : AA Main dashboard : # of CCGs created & claimed : prod */
SELECT
    created.date_created,
    created.CCGs_created,
    claimed.CCGs_claimed
FROM
(
        (
            SELECT
                date(people.created) AS date_created,
                count(*) AS CCGs_created
            FROM
                people
                LEFT JOIN person_flags ON people.id = person_flags.person_id
            WHERE
                (
                    people.subject_identifier IS NULL
                    OR people.subject_identifier != people.gg_id
                )
                AND date(people.created) > date(date_add(now(6), INTERVAL -1 year))
            GROUP BY
                date(people.created)
        ) AS created
        LEFT JOIN(
            SELECT
                date(people.created) AS date_created,
                count(*) AS CCGs_claimed
            FROM
                people
                LEFT JOIN person_flags ON people.id = person_flags.person_id
            WHERE
                (
                    people.subject_identifier IS NULL
                    OR people.subject_identifier != people.gg_id
                )
                AND date(people.created) > date(date_add(now(6), INTERVAL -1 year))
                AND date(person_flags.community_created_claimed_at) IS NOT NULL
            GROUP BY
                date(people.created)
        ) AS claimed ON created.date_created = claimed.date_created
    )