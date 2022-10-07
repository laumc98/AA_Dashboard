/* AA : AA Main dashboard : hires value freelancers: prod */ 
SELECT
    date(hiring_date) AS hiring_date,
    hire_id,
    fulfillment,
    utm_campaign AS UTM,
    SUBSTR(currency, 1, 3) AS currency_code,
    CASE
        periodicity
        WHEN 'yearly' THEN value
        WHEN 'monthly' THEN value * 12
        WHEN 'weekly' THEN value * 48
        WHEN 'daily' THEN value * 240
        WHEN 'hourly' THEN value * 1920
        WHEN 'project' THEN value
    END AS yearly_value
FROM
    (
        SELECT
            ooh.id AS hire_id,
            oc.periodicity,
            oc.currency,
            ooh.hiring_date,
            o.fulfillment,
            tc.utm_campaign,
            COALESCE(NULLIF(oc.max_amount,0), oc.min_amount) AS value
        FROM
            opportunity_operational_hires ooh
        INNER JOIN opportunities o ON o.id = ooh.opportunity_id
        INNER JOIN opportunity_compensations oc ON o.id = oc.opportunity_id AND oc.active
        INNER JOIN opportunity_candidates oca ON (oca.opportunity_id = ooh.opportunity_id AND oca.id = ooh.opportunity_candidate_id)
        LEFT JOIN tracking_code_candidates tcc ON tcc.candidate_id = oca.id
        LEFT JOIN tracking_codes tc ON tc.id = tcc.tracking_code_id 
        WHERE
            o.id NOT IN (1861230, 1316677)
            AND o.id NOT IN (
                SELECT
                    DISTINCT opportunity_id
                FROM
                    opportunity_organizations
                WHERE
                    organization_id = 748404
                    AND active
            )
            AND o.objective not like '**%'
            AND tc.utm_campaign in (
                    'jams',
                    'lfrr',
                    'mmam',
                    'cals',
                    'lfpa',
                    'mmor',
                    'smnb',
                    'gco',
                    'mabv',
                    'rrp',
                    'mmag',
                    'jmmg',
                    'dncg',
                    'jngd',
                    'mfp',
                    'admp',
                    'kjem',
                    'mamg',
                    'afdg',
                    'xncs',
                    'fcc',
                    'ana',
                    'erg',
                    'mnmv',
                    'mahp',
                    'npd',
                    'llcg',
                    'lmmg',
                    'mpsm',
                    'jppr',
                    'mbvb',
                    'ago',
                    'bcgt',
                    'DPO',
                    'jdmb',
                    'lfpa_ra',
                    'mmor_ra',
                    'smnb_ra',
                    'gco_ra',
                    'mabv_ra',
                    'rrp_ra',
                    'mmag_ra',
                    'jmmg_ra',
                    'dncg_ra',
                    'jngd_ra',
                    'mfp_ra',
                    'admp_ra',
                    'kjem_ra',
                    'mamg_ra',
                    'afdg_ra',
                    'xncs_ra',
                    'fcc_ra',
                    'ana_ra',
                    'erg_ra',
                    'mnmv_ra',
                    'mahp_ra',
                    'npd_ra',
                    'llcg_ra',
                    'lmmg_ra',
                    'mpsm_ra',
                    'jppr_ra',
                    'mbvb_ra',
                    'ago_ra',
                    'bcgt_ra',
                    'DPO_ra',
                    'jdmb_ra'
                    )
    ) AS compensations