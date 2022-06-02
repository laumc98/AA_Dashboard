SELECT
    str_to_date(concat(yearweek(`source`.`created`), ' Sunday'),'%X%V %W') AS `date`,
    `source`.`Tracking Codes__utm_medium` AS `Tracking Codes__utm_medium`,
    count(distinct `source`.`id`) AS `weekly_incomplete_app_channel`
FROM
    (
        SELECT
            `opportunity_candidates`.`application_step` AS `application_step`,
            `opportunity_candidates`.`id` AS `id`,
            `opportunity_candidates`.`interested` AS `interested`,
            `opportunity_candidates`.`opportunity_id` AS `opportunity_id`,
            `Tracking Codes`.`utm_medium` AS `Tracking Codes__utm_medium`,
            `Opportunities`.`fulfillment` AS `Opportunities__fulfillment`
        FROM
            `opportunity_candidates`
            LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates` ON `opportunity_candidates`.`id` = `Tracking Code Candidates`.`candidate_id`
            LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates`.`tracking_code_id` = `Tracking Codes`.`id`
            LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
            LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
            LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
            LEFT JOIN `opportunities` `Opportunities` ON `opportunity_candidates`.`opportunity_id` = `Opportunities`.`id`
        WHERE
            (
                `Person Flags - Person`.`opportunity_crawler` = FALSE
                AND `Opportunity Members - Opportunity`.`poster` = TRUE
                AND (
                    NOT (lower(`People`.`username`) like '%test%')
                    OR `People`.`username` IS NULL
                )
                AND `opportunity_candidates`.`retracted` IS NULL
            )
    ) `source`
WHERE
    (
        `source`.`created` > "2021-7-18"
        AND `source`.`created` < date(date_add(now(6), INTERVAL 1 day))
        AND `source`.`interested` IS NULL
    )
GROUP BY
    str_to_date(concat(yearweek(`source`.`created`), ' Sunday'),'%X%V %W'),
    `source`.`Tracking Codes__utm_medium`
ORDER BY
    str_to_date(concat(yearweek(`source`.`created`), ' Sunday'),'%X%V %W') ASC,
    `source`.`Tracking Codes__utm_medium` ASC