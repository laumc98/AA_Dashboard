/* AA : AA Main dashboard : weekly prime opps commited by approved date : prod */ 
SELECT
   str_to_date(concat(yearweek(date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))),' Sunday'),'%X%V %W') AS `date`,
   count(distinct `opportunity_changes_history`.`opportunity_id`) AS `opps_commited_weekly_prime`
FROM
   `opportunity_changes_history`
   LEFT JOIN `opportunities` `opportunities__via__opportunit` ON `opportunity_changes_history`.`opportunity_id` = `opportunities__via__opportunit`.`id`
WHERE
   (
      `opportunity_changes_history`.`type` = 'outbound'
      AND `opportunity_changes_history`.`value` = 0
      AND (date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))) > "2021-7-18"
      AND (date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))) < date(now(6))
      AND (`opportunities__via__opportunit`.`fulfillment` like '%prime%' OR `opportunities__via__opportunit`.`fulfillment` like '%agile%' or `opportunities__via__opportunit`.`fulfillment` like '%staff_augmentation%')
   )
GROUP BY
   str_to_date(concat(yearweek(date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))),' Sunday'),'%X%V %W')
ORDER BY
   str_to_date(concat(yearweek(date(coalesce(null, `opportunities__via__opportunit`.`first_reviewed`, `opportunities__via__opportunit`.`last_reviewed`))),' Sunday'),'%X%V %W') ASC