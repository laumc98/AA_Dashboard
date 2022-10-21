/* AA : AA Main dashboard : list hires : prod */ 
SELECT
   `People`.`subject_identifier` AS `SubjectID`,
   `opportunity_candidates`.`id` AS `id`,
   date(`opportunity_operational_hires`.`hiring_date`) AS `date`,
   `o`.`fulfillment`,
   `People`.`email` AS `email`
FROM
   `opportunity_candidates`
   LEFT JOIN `opportunities` `o` on `opportunity_candidates`.`opportunity_id` = `o`.`id`
   LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
   LEFT JOIN `opportunity_operational_hires` ON `opportunity_candidates`.`id` = `opportunity_operational_hires`.`opportunity_candidate_id`
WHERE
   (
      `opportunity_operational_hires`.`hiring_date` IS NOT NULL
      AND (`opportunity_operational_hires`.`hiring_date` >= date(now(6))
            AND `opportunity_operational_hires`.`hiring_date` < date(date_add(now(6), INTERVAL 1 day)))
   )