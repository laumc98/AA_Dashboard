/* AA : AA Main dashboard : mm by app date by type of service : prod */ 
SELECT
    str_to_date(concat(yearweek(general.mutual_date), 'Monday'),'%X%V %W') as date,
    sum(
        if(
            general.fulfillment LIKE '%prime%'
            or general.fulfillment LIKE '%agile%'
            or general.fulfillment LIKE '%ats%'
            or general.fulfillment LIKE '%self_service%'
            or general.fulfillment LIKE '%essentials%'
            or general.fulfillment  like '%staff_augmentation%'
            or general.fulfillment  like '%pro%',
            general.mutual_matches,
            0
        )
    ) AS general_mm_appdate,
    sum(
        if(
            (general.fulfillment LIKE '%prime%' or general.fulfillment LIKE '%agile%' or general.fulfillment  like '%staff_augmentation%'),
            general.mutual_matches,
            0
        )
    ) AS prime_mm__appdate,
    sum(
        if(
            general.fulfillment LIKE '%ats%',
            general.mutual_matches,
            0
        )
    ) AS ats_mm__appdate,
    sum(
        if(
            general.fulfillment LIKE '%self_service%'
            or general.fulfillment LIKE '%essentials%',
            general.mutual_matches,
            0
        )
    ) AS ss_mm__appdate
FROM
    (
        SELECT
            date(oca.interested) AS mutual_date,
            o.fulfillment,
            count(distinct oca.id) AS mutual_matches
        FROM
            opportunity_candidates oca
            INNER JOIN opportunities o ON oca.opportunity_id = o.id
            LEFT JOIN opportunity_candidate_column_history occh ON oca.id = occh.candidate_id
            LEFT JOIN opportunity_columns oc ON occh.to = oc.id
        WHERE
            oca.interested IS NOT NULL
            AND oc.name = 'mutual matches'
            AND occh.created IS NOT NULL
            AND oca.interested > '2021-7-18'
            AND o.objective NOT LIKE '**%'
            AND oca.application_step IS NOT NULL
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
        GROUP BY
            date(oca.interested),
            o.fulfillment
    ) AS general
GROUP BY
    str_to_date(concat(yearweek(general.mutual_date), ' Sunday'),'%X%V %W')