/* AA : AA Main dashboard : notified users from matches - users info : prod */ 
SELECT
   date("snowplow"."com_torrelabs_match_distributed_3"."root_tstamp") AS "notification_date",
   "snowplow"."com_torrelabs_match_distributed_3"."model" AS "model",
   "snowplow"."com_torrelabs_match_distributed_3"."opportunity_ref" AS "AlfaID",
   "snowplow"."com_torrelabs_match_distributed_3"."subject_id" AS "subject_id"
FROM
   "snowplow"."com_torrelabs_match_distributed_3"
WHERE
   "snowplow"."com_torrelabs_match_distributed_3"."root_tstamp" >= timestamp with time zone '2022-08-02 00:00:00.000Z'