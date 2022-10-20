/* AA : AA Main dashboard : weekly ss opps approved : prod */ 
SELECT
    str_to_date(concat(yearweek(date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`))), ' Sunday'),'%X%V %W') AS `date`,
    count(distinct `opportunities`.`id`) AS `opps_approved_weekly_ss`
FROM
    `opportunities`
    LEFT JOIN `opportunity_organizations` `Opportunity Organizations` ON `opportunities`.`id` = `Opportunity Organizations`.`opportunity_id`
WHERE
    (
        `opportunities`.`last_reviewed` IS NOT NULL
        AND `opportunities`.`last_reviewed` > "2021-7-18"
        AND `opportunities`.`last_reviewed` < date(date_add(now(6), INTERVAL 1 day))
        AND `opportunities`.`review` = 'approved'
        AND (
            `Opportunity Organizations`.`organization_id` <> 665801
            OR `Opportunity Organizations`.`organization_id` IS NULL
        )
        AND (`opportunities`.`fulfillment` like '%self_service%' or `opportunities`.`fulfillment` like '%essentials%' )
    )
GROUP BY
    str_to_date(concat(yearweek(date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`))), ' Sunday'),'%X%V %W')
ORDER BY
    str_to_date(concat(yearweek(date(coalesce(null, `opportunities`.`first_reviewed`, `opportunities`.`last_reviewed`))), ' Sunday'),'%X%V %W') ASC