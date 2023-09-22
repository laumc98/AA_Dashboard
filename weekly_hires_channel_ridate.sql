/* AA : AA Main dashboard : weekly hires per channel by ready for interview date : prod */ 
SELECT
    str_to_date(concat(yearweek(occh.created),' Sunday'),'%X%V %W') AS 'date',
    o.id AS 'ID',
    o.fulfillment AS 'fulfillment',
    tc.utm_medium AS 'Tracking Codes__utm_medium',
    count(distinct all_hires.candidate_id) AS 'weekly_hires_channel_ridate'
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
            )
        GROUP BY
            occh.candidate_id
    ) AS all_hires
    INNER JOIN opportunity_candidate_column_history occh ON all_hires.candidate_id = occh.candidate_id
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunity_candidates ocan ON all_hires.candidate_id = ocan.id
    INNER JOIN opportunities o ON ocan.opportunity_id = o.id
    LEFT JOIN tracking_code_candidates tcc ON ocan.id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE
    oc.funnel_tag = 'ready_for_interview'
    AND occh.created >= '2021-7-18'
    AND ocan.application_step IS NOT NULL
    AND date(all_hires.hire_date) <= date(occh.created) + 7
    AND o.id IN (
        SELECT
            DISTINCT o.id AS opportunity_id
        FROM
            opportunities o
            INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
            AND omp.poster = TRUE
            INNER JOIN person_flags pf ON pf.person_id = omp.person_id
            AND pf.opportunity_crawler = FALSE
        WHERE
            date(coalesce(null, o.first_reviewed, o.last_reviewed)) >= '2021/01/01'
            AND o.objective NOT LIKE '**%'
            AND o.review = 'approved'
        )
    AND o.crawled = FALSE
GROUP BY 
    str_to_date(concat(yearweek(occh.created),' Sunday'),'%X%V %W'),
    tc.utm_medium,
    o.fulfillment,
    o.id