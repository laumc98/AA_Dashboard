/* AA : AA Main dashboard : high quality applicants : prod */ 
SELECT
    str_to_date(concat(yearweek(applications.timestamp), ' Sunday'),'%X%V %W') AS 'date',
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.utm_medium AS 'utm_medium',
    count(distinct applications.id) AS 'HQA'
FROM
    applications
    INNER JOIN opportunity ON applications.opportunity_reference_id = opportunity.ref_id
WHERE
    (
        applications.filters_passed = TRUE
        AND applications.match_score > 0.80
    )
GROUP BY 
    str_to_date(concat(yearweek(applications.timestamp), ' Sunday'),'%X%V %W'),
    applications.opportunity_reference_id,
    applications.utm_medium