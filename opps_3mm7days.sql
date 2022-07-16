/* AA : AA Main dashboard : opps with 3+mm 7 days : prod */ 
SELECT
    str_to_date(concat(yearweek(dt.reviewed), ' Sunday'),'%X%V %W') AS date,
    wk.opportunities AS opps_3mm_weekly_7days
FROM
    (
        SELECT
            YEAR(reviewed_date) AS year,
            WEEK(reviewed_date) AS week,
            DATE(reviewed_date) AS reviewed,
            COUNT(*) AS opportunities
        FROM
            (
                SELECT
                    opportunity_id,
                    created AS match_date,
                    reviewed AS reviewed_date
                FROM
                    (
                        SELECT
                            matches.*,
                            IF(
                                @index <> matches.opportunity_id,
                                @sum := 1,
                                @sum := @sum + 1
                            ) AS match_sum,
                            IF(
                                @index <> matches.opportunity_id,
                                @index := matches.opportunity_id,
                                @index := @index
                            ) AS idd
                        FROM
                            (
                                SELECT
                                    oc.opportunity_id,
                                    occh.created,
                                    o.reviewed,
                                    oc.name
                                FROM
                                    opportunity_candidate_column_history occh
                                    INNER JOIN opportunity_columns oc ON occh.to = oc.id
                                    INNER JOIN opportunities o ON oc.opportunity_id = o.id
                                WHERE
                                    oc.name = 'mutual matches'
                                    AND occh.created >= '2021-01-01'
                                    AND datediff(date(occh.created), date(o.reviewed)) <= 7
                                    AND date(o.reviewed) <= date(date_add(now(6), INTERVAL -7 day))
                                    AND o.objective NOT LIKE '**%'
                                    AND o.id NOT IN (
                                        SELECT
                                            DISTINCT opportunity_id
                                        FROM
                                            opportunity_organizations oorg
                                        WHERE
                                            oorg.organization_id = '748404'
                                            AND oorg.active
                                    )
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
                                ORDER BY
                                    opportunity_id,
                                    o.reviewed
                            ) AS matches
                            CROSS JOIN (
                                SELECT
                                    @sum := 0,
                                    @index := 0
                            ) counter
                    ) numbered
                WHERE
                    match_sum = 3
            ) groupped
        GROUP BY
            year,
            week,
            reviewed
    ) AS dt
    INNER JOIN (
        SELECT
            YEAR(reviewed_date) AS year,
            WEEK(reviewed_date) AS week,
            COUNT(*) AS opportunities
        FROM
            (
                SELECT
                    opportunity_id,
                    created AS match_date,
                    reviewed AS reviewed_date
                FROM
                    (
                        SELECT
                            matches.*,
                            IF(
                                @index <> matches.opportunity_id,
                                @sum := 1,
                                @sum := @sum + 1
                            ) AS match_sum,
                            IF(
                                @index <> matches.opportunity_id,
                                @index := matches.opportunity_id,
                                @index := @index
                            ) AS idd
                        FROM
                            (
                                SELECT
                                    oc.opportunity_id,
                                    occh.created,
                                    o.reviewed,
                                    oc.name
                                FROM
                                    opportunity_candidate_column_history occh
                                    INNER JOIN opportunity_columns oc ON occh.to = oc.id
                                    INNER JOIN opportunities o ON oc.opportunity_id = o.id
                                WHERE
                                    oc.name = 'mutual matches'
                                    AND occh.created >= '2021-01-01'
                                    AND datediff(date(occh.created), date(o.reviewed)) <= 7
                                    AND date(o.reviewed) <= date(date_add(now(6), INTERVAL -7 day))
                                    AND o.objective NOT LIKE '**%'
                                    AND o.id NOT IN (
                                        SELECT
                                            DISTINCT opportunity_id
                                        FROM
                                            opportunity_organizations oorg
                                        WHERE
                                            oorg.organization_id = '748404'
                                            AND oorg.active
                                    )
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
                                ORDER BY
                                    opportunity_id,
                                    o.reviewed
                            ) AS matches
                            CROSS JOIN (
                                SELECT
                                    @sum := 0,
                                    @index := 0
                            ) counter
                    ) numbered
                WHERE
                    match_sum = 3
            ) groupped
        GROUP BY
            year,
            week
    ) AS wk ON wk.year = dt.year
    AND wk.week = dt.week;