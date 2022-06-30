/* AA : AA Main dashboard : weekly ats opps approved : prod */ 
SELECT
    str_to_date(concat(yearweek(`opportunities`.`reviewed`), ' Sunday'),'%X%V %W') AS `date`,
    count(distinct `opportunities`.`id`) AS `opps_approved_weekly_ats`
FROM
    `opportunities`
    LEFT JOIN `opportunity_organizations` `Opportunity Organizations` ON `opportunities`.`id` = `Opportunity Organizations`.`opportunity_id`
WHERE
    (
        `opportunities`.`reviewed` IS NOT NULL
        AND `opportunities`.`reviewed` > "2021-7-18"
        AND `opportunities`.`reviewed` < date(date_add(now(6), INTERVAL 1 day))
        AND `opportunities`.`review` = 'approved'
        AND (
            `Opportunity Organizations`.`organization_id` <> 665801
            OR `Opportunity Organizations`.`organization_id` IS NULL
        )
        AND `opportunities`.`fulfillment` like '%ats%'
    )
GROUP BY
    str_to_date(concat(yearweek(`opportunities`.`reviewed`), ' Sunday'),'%X%V %W')
ORDER BY
    str_to_date(concat(yearweek(`opportunities`.`reviewed`), ' Sunday'),'%X%V %W') ASC