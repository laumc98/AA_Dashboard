/* AA : Users segmentation: users starrgate : prod */ 
SELECT
    `users_user`.`id` AS `id`,
    `users_user`.`date_joined` AS `date_signed_up`
FROM `users_user`
WHERE 
    (`users_user`.`date_joined` >= date(date_add(now(6), INTERVAL -300 day))
       AND `users_user`.`date_joined` < date(date_add(now(6), INTERVAL 1 day)))