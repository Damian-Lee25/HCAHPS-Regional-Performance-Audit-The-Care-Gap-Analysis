-- 1. Reliability Gate Check
SELECT 
  is_reliable, 
  footnote_category, 
  COUNT(*) as record_count
FROM `healthcareanalysis-479317.new_analysis.new_analysis_view`
GROUP BY 1, 2
ORDER BY 1;

-- 2. Score Range & Null Audit
SELECT
  measure_group,
  MIN(score) as min_score,
  MAX(score) as max_score,
  COUNTIF(score IS NULL AND is_reliable = 1) as missing_reliable_scores
FROM `healthcareanalysis-479317.new_analysis.new_analysis_view`
GROUP BY 1;

-- 3. The "California Concentration" Verification
SELECT 
  state, 
  COUNT(*) as total_records,
  ROUND(AVG(is_reliable) * 100, 2) as percent_reliable
FROM `healthcareanalysis-479317.new_analysis.new_analysis_view`
GROUP BY 1
ORDER BY total_records DESC;

-- 4. Measure ID Mapping Integrity
SELECT 
  measure_id, 
  measure_group 
FROM `healthcareanalysis-479317.new_analysis.new_analysis_view`
WHERE measure_group = 'Other'
GROUP BY 1, 2;

-- 5. Category Performance Gap
SELECT 
  measure_group,
  ROUND(MAX(avg_score) - MIN(avg_score), 2) as state_performance_gap,
  ROUND(AVG(avg_score), 2) as national_avg
FROM (
  SELECT state, measure_group, AVG(score) as avg_score
  FROM `healthcareanalysis-479317.new_analysis.new_analysis_view`
  WHERE is_reliable = 1 AND measure_group != 'Other'
  GROUP BY 1, 2
)
GROUP BY 1
ORDER BY state_performance_gap DESC;
