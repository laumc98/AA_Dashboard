/* AA : AA Main dashboard : notified users - users info : prod */ 
SELECT
    date(notifications.sent_at) AS 'notification_date',
    notifications.template AS 'template',
    TRIM('"' FROM JSON_EXTRACT(notifications.context, '$.opportunityId')) as 'AlfaID',
    notifications.to AS 'person_id',
    people.gg_id AS 'gg_id'
FROM
    notifications
    LEFT JOIN people ON notifications.to = people.id
WHERE
    (
        (notifications.template = 'career-advisor-job-opportunity'
            or notifications.template = 'career-advisor-invited-job-opportunity'
            or notifications.template = 'career-advisor-invited-similar-job-opportunity'
            or notifications.template = 'career-advisor-sourcing-already-exist'
            or notifications.template = 'career-advisor-sourcing-first-evaluation'
            or notifications.template = 'career-advisor-sourcing-first-evaluation-matrix-c'
            or notifications.template = 'career-advisor-sourcing-first-evaluation-matrix-b'
            or notifications.template = 'career-advisor-sourcing-first-evaluation-matrix-a'
            or notifications.template = 'talent-candidate-manually-invited'
            or notifications.template = 'talent-candidate-invited'
            or notifications.template = 'career-advisor-manual-invited-reminder'
            )
        AND notifications.status = 'sent'
        AND people.name not like '%test%'
        AND date(notifications.sent_at) > '2022-04-01'
    )
ORDER BY notification_date desc