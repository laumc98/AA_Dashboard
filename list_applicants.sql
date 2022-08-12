/* AA : AA Main dashboard : list app : prod */ 
SELECT
   `People`.`subject_identifier` AS `SubjectID`,
   `opportunity_candidates`.`id` AS `id`,
   `opportunity_candidates`.`interested` AS `interested`,
   `o`.`fulfillment`,
   `People`.`email` AS `email`
FROM
   `opportunity_candidates`
   LEFT JOIN `opportunities` `o` on `opportunity_candidates`.`opportunity_id` = `o`.`id`
   LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
   LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
   LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
WHERE
   (
      `opportunity_candidates`.`interested` IS NOT NULL
      AND `Person Flags - Person`.`opportunity_crawler` = FALSE
      AND `Opportunity Members - Opportunity`.`poster` = TRUE
      AND (
         NOT (lower(`People`.`username`) like '%test%')
         OR `People`.`username` IS NULL
      )
      AND `People`.`subject_identifier` IS NOT NULL
      AND (`opportunity_candidates`.`interested` >= date(now(6))
            AND `opportunity_candidates`.`interested` < date(date_add(now(6), INTERVAL 1 day)))
   )