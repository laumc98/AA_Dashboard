/* AA : AA Main dashboard : weekly hires 15 days by approved date : prod */ 
SELECT
   str_to_date(concat(yearweek(date(coalesce(null, o.first_reviewed, o.last_reviewed))),'Sunday'),'%X%V %W') AS 'date',
   o.fulfillment,
   count(distinct o.id) AS 'opps_hire_weekly_ss14days'
FROM
    (
        SELECT
            DATE(ooh.hiring_date) AS 'hire_date',
            ooh.opportunity_candidate_id AS 'candidate_id'
        FROM 
            opportunity_operational_hires ooh
        WHERE
            ooh.hiring_date > '2021-7-18'
            
        UNION
        
        SELECT
            MIN(occh.created) AS 'hire_date',
            occh.candidate_id AS 'candidate_id'
        FROM
            opportunity_candidate_column_history occh
            INNER JOIN opportunity_candidates ocan ON occh.candidate_id = ocan.id
            INNER JOIN opportunities o ON ocan.opportunity_id = o.id
        WHERE
            occh.created >= '2022-01-01'
            AND occh.to_funnel_tag = 'hired'
            AND (
                o.fulfillment LIKE 'self%'
                OR o.fulfillment LIKE 'essentials%'
                OR o.fulfillment LIKE 'pro%'
                OR o.fulfillment LIKE 'ats%'
                OR o.fulfillment LIKE 'boost%'
            )
        GROUP BY
            occh.candidate_id
    ) AS all_hires
    INNER JOIN opportunity_candidates ocan ON all_hires.candidate_id = ocan.id
    INNER JOIN opportunities o ON ocan.opportunity_id = o.id
WHERE
    datediff(
        date(all_hires.hire_date),
        (date(coalesce(null, o.first_reviewed, o.last_reviewed)))
    ) > 7
    AND datediff(
        date(all_hires.hire_date),
        (date(coalesce(null, o.first_reviewed, o.last_reviewed)))
    ) <= 15
    AND o.crawled = FALSE
GROUP BY
   str_to_date(concat(yearweek(date(coalesce(null, o.first_reviewed, o.last_reviewed))),'Sunday'),'%X%V %W'),
   o.fulfillment
ORDER BY
   str_to_date(concat(yearweek(date(coalesce(null, o.first_reviewed, o.last_reviewed))),'Sunday'),'%X%V %W') ASC