SELECT
    str_to_date(concat(yearweek(date(coalesce(null, opportunities.first_reviewed, opportunities.last_reviewed))), 'Sunday'),'%X%V %W') AS date,
    opportunities.fulfillment,
    count(distinct opportunities.id) AS opps_approved_weekly
FROM
    opportunities
    LEFT JOIN opportunity_organizations ON opportunities.id = opportunity_organizations.opportunity_id
WHERE
    (
        opportunities.last_reviewed IS NOT NULL
        AND date(coalesce(null, opportunities.first_reviewed, opportunities.last_reviewed)) >= date(date_add(now(6), INTERVAL -1 year))
        AND opportunities.review = 'approved'
        AND opportunities.crawled = FALSE
    )
GROUP BY
    str_to_date(concat(yearweek(date(coalesce(null,opportunities.first_reviewed, opportunities.last_reviewed))), ' Sunday'),'%X%V %W'),
    opportunities.fulfillment
ORDER BY
    str_to_date(concat(yearweek(date(coalesce(null,opportunities.first_reviewed, opportunities.last_reviewed))), ' Sunday'),'%X%V %W') ASC