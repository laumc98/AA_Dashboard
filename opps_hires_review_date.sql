/* AA : AA Main dashboard : weekly hires by event date : prod */ 
SELECT
   str_to_date(concat(yearweek(`opportunity_operational_hires`.`hiring_date`),' Sunday'),'%X%V %W') AS `date`,
   count(distinct `opportunity_operational_hires`.`opportunity_id`) AS `opps_hires_review_date`
FROM
   `opportunity_operational_hires`
   LEFT JOIN `opportunities` `opportunities__via__opportunit` ON `opportunity_operational_hires`.`opportunity_id` = `opportunities__via__opportunit`.`id`
WHERE
   (
      (date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))) > "2021-7-18"
      AND (date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))) < date(now(6))
      AND `opportunities__via__opportunit`.`crawled` = FALSE
   )
GROUP BY
   str_to_date(concat(yearweek(`opportunity_operational_hires`.`hiring_date`),' Sunday'),'%X%V %W')
ORDER BY
   str_to_date(concat(yearweek(`opportunity_operational_hires`.`hiring_date`),' Sunday'),'%X%V %W') ASC