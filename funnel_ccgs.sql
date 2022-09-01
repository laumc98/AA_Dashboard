/* AA : AA Main dashboard : Funnels CCGs : prod */
SELECT
    str_to_date(concat(yearweek(pending.date), ' Sunday'),'%X%V %W') AS date,
    ifnull(pending.pending_notifications,0) AS pending_notifications,
    ifnull(sent.sent_notifications,0) AS notifications_sent
FROM
(
        SELECT
            str_to_date(concat(yearweek(career_advisor.evaluate_at), ' Sunday'),'%X%V %W') AS date,
            count(*) AS pending_notifications
        FROM
            career_advisor
            LEFT JOIN people ON career_advisor.person_id = people.id
        WHERE
            (career_advisor.current = 'career-advisor-job-opportunity'
                OR career_advisor.current = 'career-advisor-invited-job-opportunity')
            AND career_advisor.notification_status = 'pending'
            AND career_advisor.active = true
            AND people.subject_identifier IS NULL
            AND career_advisor.evaluate_at >= '2022-07-17'
        GROUP BY
            str_to_date(concat(yearweek(career_advisor.evaluate_at), ' Sunday'),'%X%V %W')
    ) AS pending
    LEFT JOIN (
        SELECT
            str_to_date(concat(yearweek(career_advisor.deleted), ' Sunday'),'%X%V %W') AS date,
            count(*) AS sent_notifications
        FROM
            career_advisor
            LEFT JOIN people ON career_advisor.person_id = people.id
        WHERE
            (career_advisor.current = 'career-advisor-job-opportunity'
                OR career_advisor.current = 'career-advisor-invited-job-opportunity')
            AND career_advisor.notification_status = 'sent'
            AND career_advisor.active = false
            AND people.subject_identifier IS NULL
            AND career_advisor.deleted >= '2022-07-17'
        GROUP BY
            str_to_date(concat(yearweek(career_advisor.evaluate_at), ' Sunday'),'%X%V %W')
    ) AS sent ON pending.date = sent.date
GROUP BY 1,2