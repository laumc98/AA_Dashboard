SELECT str_to_date(concat(yearweek(`opportunity_stats_hires`.`hiring_date`), ' Sunday'), '%X%V %W') AS `date`, count(distinct `opportunity_stats_hires`.`opportunity_id`) AS `opps_hire_weekly`
FROM `opportunity_stats_hires`
WHERE (`opportunity_stats_hires`.`hiring_date` >= date(date_add(now(6), INTERVAL -262 day))
   AND `opportunity_stats_hires`.`hiring_date` < date(now(6)))
GROUP BY str_to_date(concat(yearweek(`opportunity_stats_hires`.`hiring_date`), ' Sunday'), '%X%V %W')
ORDER BY str_to_date(concat(yearweek(`opportunity_stats_hires`.`hiring_date`), ' Sunday'), '%X%V %W') ASC