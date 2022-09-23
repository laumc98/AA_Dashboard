/* AA : AA Main dashboard : weekly app by type of service : prod */
SELECT
    str_to_date(concat(yearweek(general.interested), 'Monday'),'%X%V %W') AS date,
    sum(
        if(
            general.fulfillment LIKE '%prime%'
            or general.fulfillment LIKE '%agile%'
            or general.fulfillment LIKE '%ats%'
            or general.fulfillment LIKE '%self_service%'
            or general.fulfillment LIKE '%essentials%',
            general.applications,
            0
        )
    ) AS general_app,
    sum(
        if(
            general.fulfillment LIKE '%prime%'
            or general.fulfillment LIKE '%agile%',
            general.applications,
            0
        )
    ) AS prime_app,
    sum(
        if(
            general.fulfillment LIKE '%ats%',
            general.applications,
            0
        )
    ) AS ats_app,
    sum(
        if(
            general.fulfillment LIKE '%self_service%'
            or general.fulfillment LIKE '%essentials%',
            general.applications,
            0
        )
    ) AS ss_app
FROM
    (
        SELECT
            date(oc.interested) AS interested,
            o.fulfillment,
            count(DISTINCT oc.id) AS applications
        FROM
            opportunity_candidates oc
            INNER JOIN opportunities o ON oc.opportunity_id = o.id
        WHERE
            oc.interested IS NOT NULL
            AND oc.interested > '2021-7-18'
            AND o.objective NOT LIKE '**%'
            AND oc.application_step IS NOT NULL
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
            date(oc.interested),
            o.fulfillment
    ) AS general
GROUP BY
    str_to_date(concat(yearweek(general.interested), ' Sunday'),'%X%V %W')