/* AA : AA Main dashboard : list mm : prod */
SELECT
    applications.gg_id,
    date(applications.timestamp) AS date,
    applications.opportunity_reference_id AS 'Alfa ID'
FROM
    applications
    LEFT JOIN mutual_matches ON (
        mutual_matches.gg_id = applications.gg_id
        AND mutual_matches.opportunity_reference_id = applications.opportunity_reference_id
    )
WHERE
    (applications.filters_passed = true
    OR mutual_matches.timestamp IS NOT NULL)
    AND (
        applications.timestamp >= date(now(6))
        AND applications.timestamp < date(date_add(now(6), INTERVAL 1 day))
    )