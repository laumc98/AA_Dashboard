/* AA : AA Main dashboard : weekly prime hires by approved date : prod */ 
SELECT
   str_to_date(concat(yearweek(`Opportunities`.`reviewed`),'Sunday'),'%X%V %W') AS `date`,
   count(distinct `opportunity_stats_hires`.`opportunity_id`) AS `opps_hire_weekly_prime`
FROM
   `opportunity_stats_hires`
   LEFT JOIN `opportunities` `Opportunities` ON `opportunity_stats_hires`.`opportunity_id` = `Opportunities`.`id`
WHERE
   (
      `opportunity_stats_hires`.`hiring_date` > "2021-7-18"
      AND `opportunity_stats_hires`.`hiring_date` < date(now(6))
      AND `Opportunities`.`fulfillment` = 'prime'
   )
GROUP BY
   str_to_date(concat(yearweek(`Opportunities`.`reviewed`),'Sunday'),'%X%V %W')
ORDER BY
   str_to_date(concat(yearweek(`Opportunities`.`reviewed`),'Sunday'),'%X%V %W') ASC