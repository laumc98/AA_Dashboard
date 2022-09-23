/* AA : AA Main dashboard : weekly hires by type of service : prod */
SELECT
    str_to_date(concat(yearweek(general.hiring_date), 'Monday'),'%X%V %W') AS date,
    sum(
        if(
            general.fulfillment LIKE '%prime%',
            or general.fulfillment LIKE '%agile%',
            or general.fulfillment LIKE '%ats%',
            or general.fulfillment LIKE '%self_service%',
            or general.fulfillment LIKE '%essentials%',
            or general.fulfillment  like '%staff_augmentation%',
            or general.fulfillment  like '%pro%',
            general.hires,
            0
        )
    ) AS general_hires,
    sum(
        if(
            (general.fulfillment LIKE '%prime%' or general.fulfillment LIKE '%agile%' or general.fulfillment  like '%staff_augmentation%'),
            general.hires,
            0
        )
    ) AS prime_hires,
    sum(
        if(
            general.fulfillment LIKE '%ats%',
            general.hires,
            0
        )
    ) AS ats_hires,
    sum(
        if(
            (general.fulfillment LIKE '%self_service%' or general.fulfillment LIKE '%essentials%'),
            general.hires,
            0
        )
    ) AS ss_hires
FROM
(
        SELECT
            date(ooh.hiring_date) AS hiring_date,
            o.fulfillment,
            count(distinct ooh.opportunity_candidate_id) AS hires
        FROM
            opportunity_operational_hires ooh
            INNER JOIN opportunities o ON ooh.opportunity_id = o.id
        WHERE
            ooh.hiring_date IS NOT NULL
            AND ooh.hiring_date > '2021-7-18'
            AND ooh.opportunity_id IN (
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
            date(ooh.hiring_date),
            o.fulfillment
    ) AS general
GROUP BY
    str_to_date(concat(yearweek(general.hiring_date), ' Sunday'),'%X%V %W')