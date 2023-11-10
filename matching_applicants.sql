/* AA : AA Main dashboard : matching applicants : prod */
SELECT
    applications.opportunity_reference_id AS 'Alfa ID',
    date(applications.timestamp) AS application_date,
    applications.gg_id
FROM
    applications
    INNER JOIN opportunity ON applications.opportunity_reference_id = opportunity.ref_id
    LEFT JOIN mutual_matches ON (
            mutual_matches.gg_id = applications.gg_id
            AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id
    )
WHERE
    (applications.filters_passed = true
    OR mutual_matches.timestamp IS NOT NULL)
    AND applications.timestamp >= '2021-01-01'
    AND JSON_EXTRACT(opportunity.opportunity_snapshot, '$."crawled"') = FALSE
    AND JSON_EXTRACT(opportunity.opportunity_snapshot, '$."review"') = 'approved'