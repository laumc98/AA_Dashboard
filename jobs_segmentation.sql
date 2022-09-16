/* AA : Users segmentation: jobs_segmentation : prod */ 
SELECT 
    o.id,
    o.reviewed as 'approved_date',
    o.fulfillment as 't_service',
    o.opportunity as 't_job',
    o.commitment_id as 't_preference',
    o.locale as 'post_language',
    o.remote as 'remote',
    opportunity_segments.name as 'segment',
    opportunity_languages.language_code as 'languages',
    opportunity_languages.fluency as 'languages_fluency',
    opportunity_compensations.currency as 'currency',
    opportunity_compensations.max_amount as 'max_amount_compensation',
    opportunity_compensations.min_amount as 'min_amount_compensation',
    opportunity_compensations.periodicity as 'compensation_periodicity',
    opportunity_strengths.code as 'Skill ID',
    opportunity_strengths.proficiency as 'skill_proficiency'
FROM
    opportunities o
    LEFT JOIN opportunity_compensations ON o.id = opportunity_compensations.opportunity_id AND opportunity_compensations.active = true
    LEFT JOIN opportunity_strengths ON o.id = opportunity_strengths.opportunity_id
    LEFT JOIN opportunity_segments ON o.id = opportunity_segments.opportunity_id
    LEFT JOIN opportunity_languages ON o.id = opportunity_languages.opportunity_id
WHERE 
    date(o.reviewed) > '2021-12-01'
    AND o.review = 'approved'