/* AA : AA Main dashboard : weekly mm by type of service : prod */
SELECT
    str_to_date(concat(yearweek(general.mutual_date), ' Sunday'),'%X%V %W') AS date,
    sum(if(
            general.fulfillment LIKE '%prime%'
            or general.fulfillment LIKE '%ats%'
            or general.fulfillment LIKE '%self_service%',
            general.mutuals,
            0
        )
    ) AS general_mm,
    sum(
        if(
            (general.fulfillment LIKE '%prime%' or general.fulfillment LIKE '%agile%'),
            general.mutuals,
            0
        )
    ) AS prime_mm,
    sum(
        if(
            general.fulfillment LIKE '%ats%',
            general.mutuals,
            0
        )
    ) AS ats_mm,
    sum(
        if(
            general.fulfillment LIKE '%self_service%',
            general.mutuals,
            0
        )
    ) AS ss_mm
FROM
    (
        SELECT
            date(occh.created) AS mutual_date,
            o.fulfillment,
            count(distinct occh.candidate_id) AS mutuals
        FROM
            opportunity_candidate_column_history occh
            INNER JOIN opportunity_columns oc ON occh.to = oc.id
            INNER JOIN opportunities o ON oc.opportunity_id = o.id
            LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
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
                    o.reviewed >= '2021/01/01'
                    AND o.objective NOT LIKE '**%'
                    AND o.review = 'approved'
            )
        GROUP BY
            date(occh.created),
            o.fulfillment
    ) AS general
GROUP BY
    str_to_date(concat(yearweek(general.mutual_date), ' Sunday'),'%X%V %W')