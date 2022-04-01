SELECT str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`), ' Sunday'), '%X%V %W') AS `date`, count(distinct `opportunity_changes_history`.`opportunity_id`) AS `opps_commited_review_date_prime`
FROM `opportunity_changes_history`
LEFT JOIN `opportunities` `opportunities__via__opportunit` ON `opportunity_changes_history`.`opportunity_id` = `opportunities__via__opportunit`.`id`
WHERE (`opportunity_changes_history`.`type` = 'commit' AND  `opportunity_changes_history`.`value` = 0   
   AND `opportunities__via__opportunit`.`reviewed` >= date(date_add(now(6), INTERVAL -262 day)) AND `opportunities__via__opportunit`.`reviewed` < date(now(6)) AND `opportunities__via__opportunit`.`fulfillment` = 'prime')
GROUP BY str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`), ' Sunday'), '%X%V %W')
ORDER BY str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`), ' Sunday'), '%X%V %W') ASC