/* AA : Users segmentation: skills kratos: prod */ 
SELECT
    terms.id as 'Skill ID',
    terms.term as 'Skills name'
FROM
    terms
    INNER JOIN term_types ON terms.id = term_types.term_id
WHERE
    term_types.type = 'SUPRA_SKILL'
    AND terms.status = 'APPROVED'