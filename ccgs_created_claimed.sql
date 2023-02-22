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
                INNER JOIN notifications ON people.id = notifications.to
            WHERE
                (
                    people.subject_identifier IS NULL
                    OR people.subject_identifier != people.gg_id
                )
                AND 
                (
                    notifications.template = 'career-advisor-sourcing-first-evaluation'
                        OR notifications.template = 'career-advisor-syndication-first-evaluation'
                )
                AND date(people.created) > date(date_add(now(6), INTERVAL -1 year))
            GROUP BY
                date(people.created)
        ) AS created
        LEFT JOIN(
            SELECT
                date(person_flags.community_created_claimed_at) AS date_claimed,
                count(*) AS CCGs_claimed
            FROM
                person_flags
                INNER JOIN people ON person_flags.person_id = people.id
                INNER JOIN notifications ON person_flags.person_id = notifications.to
            WHERE
                people.subject_identifier != people.gg_id
                AND date(person_flags.community_created_claimed_at) IS NOT NULL
                AND date(people.created) > date(date_add(now(6), INTERVAL -1 year))
                AND (
                    notifications.template = 'career-advisor-sourcing-first-evaluation'
                        OR notifications.template = 'career-advisor-syndication-first-evaluation'
                )
            GROUP BY
                date_claimed
        ) AS claimed ON created.date_created = claimed.date_claimed
    )