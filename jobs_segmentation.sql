/* AA : Users segmentation: jobs_segmentation : prod */ 
SELECT 
    o.id,
    date(coalesce(null, o.first_reviewed, o.last_reviewed)) as 'approved_date',
    o.fulfillment as 't_service',
    o.opportunity as 't_job',
    o.commitment_id as 't_preference',
    o.locale as 'post_language',
    o.remote as 'remote',
    opportunity_segments.name as 'segment',
    opportunity_languages.language_code as 'languages',
    opportunity_languages.fluency as 'languages_fluency',
    opportunity_strengths.code as 'Skill ID',
    opportunity_strengths.proficiency as 'skill_proficiency',
    compensation.currency AS 'currency',
    CASE
        compensation.periodicity
        WHEN 'yearly' THEN compensation.value/12
        WHEN 'monthly' THEN compensation.value
        WHEN 'weekly' THEN compensation.value * 4
        WHEN 'daily' THEN compensation.value * 20
        WHEN 'hourly' THEN compensation.value * 160
        WHEN 'project' THEN compensation.value
    END AS monthly_value
FROM
    opportunities o
    LEFT JOIN opportunity_strengths ON o.id = opportunity_strengths.opportunity_id
    LEFT JOIN opportunity_segments ON o.id = opportunity_segments.opportunity_id
    LEFT JOIN opportunity_languages ON o.id = opportunity_languages.opportunity_id
    LEFT JOIN (
        SELECT
            opportunity_compensations.opportunity_id,
            SUBSTR(opportunity_compensations.currency, 1, 3) AS 'currency',
            opportunity_compensations.periodicity,
            COALESCE(NULLIF(opportunity_compensations.max_amount,0), opportunity_compensations.min_amount) AS value
        FROM
            opportunity_compensations
        WHERE 
            opportunity_compensations.active = true
        GROUP BY
            opportunity_compensations.opportunity_id
    ) AS compensation ON o.id = compensation.opportunity_id
WHERE 
    date(coalesce(null, o.first_reviewed, o.last_reviewed)) > '2022-2-1'
    AND o.review = 'approved'