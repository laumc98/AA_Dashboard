/* AA : AA Main dashboard : weekly ats opps approved : prod */ 
SELECT
    str_to_date(concat(yearweek(date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`))), ' Sunday'),'%X%V %W') AS `date`,
    `opportunities`.`fulfillment`,
    count(distinct `opportunities`.`id`) AS `opps_approved_weekly_ats`
FROM
    `opportunities`
    LEFT JOIN `opportunity_organizations` `Opportunity Organizations` ON `opportunities`.`id` = `Opportunity Organizations`.`opportunity_id`
WHERE
    (
        `opportunities`.`last_reviewed` IS NOT NULL
        AND date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`)) > "2021-7-18"
        AND date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`)) < date(date_add(now(6), INTERVAL 1 day))
        AND `opportunities`.`review` = 'approved'
        AND `opportunities`.`crawled` = FALSE
        AND (
            `Opportunity Organizations`.`organization_id` <> 748404
            OR `Opportunity Organizations`.`organization_id` IS NULL
        )
    )
GROUP BY
    str_to_date(concat(yearweek(date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`))), ' Sunday'),'%X%V %W'),
    `opportunities`.`fulfillment`
ORDER BY
    str_to_date(concat(yearweek(date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`))), ' Sunday'),'%X%V %W') ASC