/* AA : AA Main dashboard : weekly ats mm per channel : prod */ 
SELECT
    str_to_date(concat(yearweek(mutual_matches.created), ' Sunday'),'%X%V %W') AS 'date',
    mutual_matches.opportunity_id AS 'ID',
    mutual_matches.fulfillment AS 'fulfillment',
    mutual_matches.utm_medium AS 'Tracking Codes__utm_medium',
    count(*) AS 'weekly_mm_channel_ats'
FROM
(
    SELECT 
        occh.candidate_id,
        oca.opportunity_id,
        o.fulfillment,
        tc.utm_medium,
        MIN(occh.created) AS created
    FROM
        opportunity_candidate_column_history occh
        INNER JOIN opportunity_columns oc ON occh.to = oc.id
        INNER JOIN opportunities o ON oc.opportunity_id = o.id
        LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
        LEFT JOIN tracking_code_candidates tcc ON oca.id = tcc.candidate_id
        LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
    WHERE
        oc.name = 'mutual matches'
        AND occh.created >= '2021-07-18'
        AND oca.interested IS NOT NULL 
        AND o.objective NOT LIKE '**%'
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
                date(coalesce(null, o.first_reviewed, o.last_reviewed)) >= '2021-07-18'
                AND o.objective NOT LIKE '**%'
                AND o.review = 'approved'
        )
    GROUP BY
        occh.candidate_id,
        oca.opportunity_id,
        o.fulfillment,
        tc.utm_medium
) AS mutual_matches
GROUP BY 
    str_to_date(concat(yearweek(mutual_matches.created), ' Sunday'),'%X%V %W'),
    mutual_matches.opportunity_id,
    mutual_matches.fulfillment,
    mutual_matches.utm_medium