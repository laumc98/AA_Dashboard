/* AA : AA Main dashboard : notified ccgs - users info : prod */ 
SELECT
    date(notifications.sent_at) AS 'notification_date',
    TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.opportunityId')) as 'AlfaID',
    notifications.to AS 'person_id',
    people.gg_id AS 'gg_id'
FROM
    notifications
    LEFT JOIN people ON notifications.to = people.id
WHERE
    (
        (notifications.template = 'career-advisor-job-opportunity'
            or notifications.template = 'career-advisor-invited-job-opportunity')
        AND notifications.status = 'sent'
        AND people.subject_identifier IS NULL
        AND people.name not like '%test%'
        AND date(notifications.sent_at) > '2022-01-01'
    )