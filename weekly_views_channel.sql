SELECT
    (CAST(date_trunc('week',CAST(("snowplow"."events"."collector_tstamp" + (INTERVAL '1 day')) AS timestamp)) AS timestamp) + (INTERVAL '-1 day')) AS "date",
    SUBSTRING("snowplow"."events"."page_urlpath",7,8) as "Alfa ID",
    "snowplow"."events"."mkt_medium" AS "UTM",
    count(distinct "snowplow"."events"."domain_userid") AS "weekly_views_notifications"
FROM
    "snowplow"."events"
WHERE
    (
        "snowplow"."events"."event" = 'page_view'
        AND (
            lower("snowplow"."events"."page_url") like '%post%'
        )
        AND (
            lower("snowplow"."events"."page_urlpath") like '%post%'
        )
    )
GROUP BY
    (CAST(date_trunc('week',CAST(("snowplow"."events"."collector_tstamp" + (INTERVAL '1 day')) AS timestamp)) AS timestamp) + (INTERVAL '-1 day')),
    SUBSTRING("snowplow"."events"."page_urlpath",7,8),
    "snowplow"."events"."mkt_medium"
ORDER BY
    (CAST(date_trunc('week',CAST(("snowplow"."events"."collector_tstamp" + (INTERVAL '1 day')) AS timestamp)) AS timestamp) + (INTERVAL '-1 day')) ASC