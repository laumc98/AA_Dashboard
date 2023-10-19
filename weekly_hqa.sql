/* AA : AA Main dashboard : high quality applicants : prod */ 
SELECT
    str_to_date(concat(yearweek(applications.timestamp), ' Sunday'),'%X%V %W') AS 'date',
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.utm_medium AS 'utm_medium',
    count(distinct applications.id) AS 'HQA'
FROM
    applications
    INNER JOIN opportunity ON applications.opportunity_reference_id = opportunity.ref_id
    LEFT JOIN mutual_matches ON (mutual_matches.gg_id = applications.gg_id AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id)
WHERE
    (applications.filters_passed = TRUE
        OR mutual_matches.timestamp IS NOT NULL)
    AND JSON_EXTRACT(opportunity.opportunity_snapshot, '$."crawled"') = FALSE
GROUP BY 
    str_to_date(concat(yearweek(applications.timestamp), ' Sunday'),'%X%V %W'),
    applications.opportunity_reference_id,
    applications.utm_medium