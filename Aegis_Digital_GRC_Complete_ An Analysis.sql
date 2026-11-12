SELECT
    r.risk_id,
    r.risk_description,
    r.inherent_risk_score,
    c.control_id,
    c.control_name,
    c.evidence_status AS control_status,
    c.assessment_result,
    e.evidence_id,
    e.evidence_description,
    e.evidence_status AS request_status
FROM risks r
INNER JOIN controls c
    ON r.risk_id = c.related_risk_id
LEFT JOIN evidence_request e
    ON c.control_id = e.control_id
ORDER BY r.risk_id, c.control_id;

-- KPI 1: Evidence Status Distribution
SELECT
    evidence_status,
    COUNT(*) AS total_evidence
FROM evidence_request
GROUP BY evidence_status
ORDER BY evidence_status;

-- KPI 2: Evidence Completion Rate
SELECT
    COUNT(*) FILTER (
        WHERE LOWER(evidence_status) = 'received'
    ) * 100.0 / NULLIF(COUNT(*), 0)
    AS evidence_completion_rate
FROM evidence_request;

-- KPI 3: Control Effectiveness
SELECT
    assessment_result,
    COUNT(*) AS total_controls
FROM controls
GROUP BY assessment_result
ORDER BY assessment_result;

-- KPI 4: Risk Exposure
SELECT
    inherent_risk_score,
    COUNT(*) AS total_risks
FROM risks
GROUP BY inherent_risk_score
ORDER BY inherent_risk_score DESC;

