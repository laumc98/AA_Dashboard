/* AA : AA Main dashboard : weekly hires by approved date : prod */ 
SELECT
    str_to_date(concat(yearweek(`Opportunities`.`reviewed`), ' Sunday'),'%X%V %W') AS `Opportunities__reviewed`,
    count(distinct `opportunity_operational_hires`.`opportunity_id`) AS `count`
FROM
    `opportunity_operational_hires`
    LEFT JOIN `opportunities` `Opportunities` ON `opportunity_operational_hires`.`opportunity_id` = `Opportunities`.`id`
WHERE
    (
    `opportunity_operational_hires`.`hiring_date` >= "2021-7-18"
    AND `opportunity_operational_hires`.`hiring_date` < date(now(6))
    )
GROUP BY
    str_to_date(concat(yearweek(`Opportunities`.`reviewed`), ' Sunday'),'%X%V %W')
ORDER BY
    str_to_date(concat(yearweek(`Opportunities`.`reviewed`), ' Sunday'),'%X%V %W') ASC