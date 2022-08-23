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
   LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
   LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
   LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
   LEFT JOIN `opportunity_operational_hires` ON `opportunity_candidates`.`id` = `opportunity_operational_hires`.`opportunity_candidate_id`
WHERE
   (
      `opportunity_operational_hires`.`hiring_date` IS NOT NULL
      AND `Person Flags - Person`.`opportunity_crawler` = FALSE
      AND `Opportunity Members - Opportunity`.`poster` = TRUE
      AND (
         NOT (lower(`People`.`username`) like '%test%')
         OR `People`.`username` IS NULL
      )
      AND `People`.`subject_identifier` IS NOT NULL
      AND (`opportunity_operational_hires`.`hiring_date` >= '2021-08-21'
         )
   )