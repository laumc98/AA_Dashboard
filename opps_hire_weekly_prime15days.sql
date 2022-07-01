/* AA : AA Main dashboard : weekly prime hires 15 days by approved date : prod */ 
SELECT
   str_to_date(concat(yearweek(`Opportunities`.`reviewed`),'Sunday'),'%X%V %W') AS `date`,
   count(distinct `opportunity_operational_hires`.`opportunity_id`) AS `opps_hire_weekly_prime14days`
FROM
   `opportunity_operational_hires`
   LEFT JOIN `opportunities` `Opportunities` ON `opportunity_operational_hires`.`opportunity_id` = `Opportunities`.`id`
WHERE
   (
      `opportunity_operational_hires`.`hiring_date` > "2021-7-18"
      AND `opportunity_operational_hires`.`hiring_date` < date(now(6))
      AND datediff(
         date(`opportunity_operational_hires`.`hiring_date`),
         date(`Opportunities`.`reviewed`)
      ) > 7
      AND datediff(
         date(`opportunity_operational_hires`.`hiring_date`),
         date(`Opportunities`.`reviewed`)
      ) <= 15
      AND `Opportunities`.`fulfillment` like '%prime%'
   )
GROUP BY
   str_to_date(concat(yearweek(`Opportunities`.`reviewed`),'Sunday'),'%X%V %W')
ORDER BY
   str_to_date(concat(yearweek(`Opportunities`.`reviewed`),'Sunday'),'%X%V %W') ASC