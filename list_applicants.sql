/* AA : AA Main dashboard : list app : prod */ 
SELECT
   `People`.`subject_identifier` AS `SubjectID`,
   `opportunity_candidates`.`id` AS `id`,
   date(`opportunity_candidates`.`interested`) AS `date`,
   `o`.`fulfillment`,
   `People`.`email` AS `email`
FROM
   `opportunity_candidates`
   LEFT JOIN `opportunities` `o` on `opportunity_candidates`.`opportunity_id` = `o`.`id`
   LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
WHERE
   (
      `opportunity_candidates`.`interested` IS NOT NULL
      AND (`opportunity_candidates`.`interested` >= date(now(6))
            AND `opportunity_candidates`.`interested` < date(date_add(now(6), INTERVAL 1 day)))
   )