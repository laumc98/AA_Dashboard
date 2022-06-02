/* AA : AA Main dashboard : weekly prime opps commited by approved date : prod */ 
SELECT
   str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`),' Sunday'),'%X%V %W') AS `date`,
   count(distinct `opportunity_changes_history`.`opportunity_id`) AS `opps_commited_weekly_prime`
FROM
   `opportunity_changes_history`
   LEFT JOIN `opportunities` `opportunities__via__opportunit` ON `opportunity_changes_history`.`opportunity_id` = `opportunities__via__opportunit`.`id`
WHERE
   (
      `opportunity_changes_history`.`type` = 'outbound'
      AND `opportunity_changes_history`.`value` = 0
      AND `opportunities__via__opportunit`.`reviewed` > "2021-7-18"
      AND `opportunities__via__opportunit`.`reviewed` < date(now(6))
      AND `opportunities__via__opportunit`.`fulfillment` = 'prime'
   )
GROUP BY
   str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`),' Sunday'),'%X%V %W')
ORDER BY
   str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`),' Sunday'),'%X%V %W') ASC