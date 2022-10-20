/* AA : AA Main dashboard : weekly opps commited by event date : prod */ 
SELECT
   str_to_date(concat(yearweek(`opportunity_changes_history`.`created`),' Sunday'),'%X%V %W') AS `date`,
   count(distinct `opportunity_changes_history`.`opportunity_id`) AS `opps_commited_review_date`
FROM
   `opportunity_changes_history`
   LEFT JOIN `opportunities` `opportunities__via__opportunit` ON `opportunity_changes_history`.`opportunity_id` = `opportunities__via__opportunit`.`id`
WHERE
   (
      `opportunity_changes_history`.`type` = 'outbound'
      AND `opportunity_changes_history`.`value` = 0
      AND (date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))) > "2021-7-18"
      AND (date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))) < date(now(6))
   )
GROUP BY
   str_to_date(concat(yearweek(`opportunity_changes_history`.`created`),' Sunday'),'%X%V %W')
ORDER BY
   str_to_date(concat(yearweek(`opportunity_changes_history`.`created`),' Sunday'),'%X%V %W') ASC