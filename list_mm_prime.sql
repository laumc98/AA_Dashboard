SELECT 
   `member_evaluations`.`candidate_id` AS `candidate_id`, 
   `member_evaluations`.`interested` AS `MM_interested`
FROM `member_evaluations`
LEFT JOIN `opportunity_candidates` `opportunity_candidates__via__c` ON `member_evaluations`.`candidate_id` = `opportunity_candidates__via__c`.`id`
LEFT JOIN `opportunities` `o` on `opportunity_candidates__via__c`.`opportunity_id` = `o`.`id`
WHERE (`opportunity_candidates__via__c`.`interested` IS NOT NULL
   AND `member_evaluations`.`interested` >= convert_tz('2021-06-20 00:00:00.000', 'UTC', @@session.time_zone)) AND (`o`.`fulfillment` = 'prime')
LIMIT 1048575