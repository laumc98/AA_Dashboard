/* AA : AA Main dashboard : awareness : prod */ 
SELECT
    `metrics_users`.`id` AS `SubjectID`,
    `metrics_users`.`awareness_answer` AS `answer`,
    `metrics_users`.`locale` as `locale`
FROM
    `metrics_users`
WHERE
    `metrics_users`.`awareness_answer` <> 'unknown'