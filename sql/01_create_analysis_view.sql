/*
=============================================================================
FILE: 01_new_analysis_view.sql
DESCRIPTION: 
    This script builds the primary analysis view for the HCAHPS project.
    Key transformations include:
    1. Standardizing footnotes into 4 reliability categories.
    2. Mapping Measure IDs to human-readable Measure Groups.
    3. Implementing a 'Reliability Flag' (is_reliable) for filtered analysis.
=============================================================================
*/

CREATE OR REPLACE VIEW `healthcareanalysis-479317.new_analysis.patient_final_view` AS
WITH parsed AS (
  SELECT
    -- raw fields (exact column names from your table)
    Provider_ID,
    Hospital_Name,
    State,
    City,
    Measure_ID,
    Question,
    Answer_Description,
    Patient_Survey_Star_Rating,
    Patient_Survey_Star_Rating_Footnote,
    Answer_Percent,
    Answer_Percent_Footnote,
    Linear_Mean_Value,
    Number_of_Completed_Surveys,
    Number_of_Completed_Surveys_Footnote,
    Survey_Response_Rate_Percent,
    Survey_Response_Rate_Percent_Footnote,
    Measure_Start_Date,
    Measure_End_Date,
    Location,

    -- extract numeric footnote codes (one column per footnote field)
    SAFE_CAST(REGEXP_EXTRACT(Patient_Survey_Star_Rating_Footnote, r'^(\d+)') AS INT64) AS star_rating_footnote_code,
    SAFE_CAST(REGEXP_EXTRACT(Answer_Percent_Footnote, r'^(\d+)') AS INT64) AS answer_percent_footnote_code,
    SAFE_CAST(REGEXP_EXTRACT(Number_of_Completed_Surveys_Footnote, r'^(\d+)') AS INT64) AS completed_surveys_footnote_code,
    SAFE_CAST(REGEXP_EXTRACT(Survey_Response_Rate_Percent_Footnote, r'^(\d+)') AS INT64) AS response_rate_footnote_code

  FROM `healthcareanalysis-479317.new_analysis.survey_data`
),

combined AS (
  SELECT
    *,
    -- Combine the per-column codes into one representative code (first non-null)
    COALESCE(
      star_rating_footnote_code,
      answer_percent_footnote_code,
      completed_surveys_footnote_code,
      response_rate_footnote_code
    ) AS footnote_code
  FROM parsed
),

categorized AS (
  SELECT
    *,
    CASE
      WHEN star_rating_footnote_code IN (1,2)
        OR answer_percent_footnote_code IN (1,2)
        OR completed_surveys_footnote_code IN (1,2)
        OR response_rate_footnote_code IN (1,2)
      THEN 'Insufficient Sample Size'

      WHEN star_rating_footnote_code = 3
        OR answer_percent_footnote_code = 3
        OR completed_surveys_footnote_code = 3
        OR response_rate_footnote_code = 3
      THEN 'Less than Full-Year Data'

      WHEN star_rating_footnote_code IN (4,5,10,11)
        OR answer_percent_footnote_code IN (4,5,10,11)
        OR completed_surveys_footnote_code IN (4,5,10,11)
        OR response_rate_footnote_code IN (4,5,10,11)
      THEN 'Data Suppressed / Not Reliable'

      WHEN footnote_code IS NULL THEN 'No Footnote'
      ELSE 'Other Footnote'
    END AS footnote_category,

    CASE
      WHEN star_rating_footnote_code IN (1,2)
        OR answer_percent_footnote_code IN (1,2)
        OR completed_surveys_footnote_code IN (1,2)
        OR response_rate_footnote_code IN (1,2)
        OR star_rating_footnote_code = 3
        OR answer_percent_footnote_code = 3
        OR completed_surveys_footnote_code = 3
        OR response_rate_footnote_code = 3
        OR star_rating_footnote_code IN (4,5,10,11)
        OR answer_percent_footnote_code IN (4,5,10,11)
        OR completed_surveys_footnote_code IN (4,5,10,11)
        OR response_rate_footnote_code IN (4,5,10,11)
      THEN 0
      ELSE 1
    END AS is_reliable
  FROM combined
),

measure_mapped AS (
  SELECT
    -- alias to friendlier column names
    Provider_ID        AS hospital_id,
    Hospital_Name      AS hospital_name,
    State              AS state,
    City               AS city,
    Measure_ID         AS measure_id,
    -- choose score: prefer Answer_Percent, else Linear_Mean_Value
    COALESCE(Answer_Percent, Linear_Mean_Value) AS score,
    Number_of_Completed_Surveys                 AS sample_size,
    Measure_Start_Date                           AS survey_start_date,
    Measure_End_Date                             AS survey_end_date,
    footnote_category,
    is_reliable,

    -- map measure groups (adjust to your actual Measure_ID values if needed)
    CASE
      WHEN Measure_ID IN ('H_COMP_1_A_P','H_COMP_1_L_P') THEN 'Nurse Communication'
      WHEN Measure_ID IN ('H_COMP_2_A_P','H_COMP_2_L_P') THEN 'Doctor Communication'
      WHEN Measure_ID IN ('H_COMP_3_A_P') THEN 'Staff Responsiveness'
      WHEN Measure_ID IN ('H_CLEAN_HSP_A_P') THEN 'Cleanliness'
      WHEN Measure_ID IN ('H_QUIET_HSP_A_P') THEN 'Quietness'
      WHEN Measure_ID IN ('H_COMP_5_A_P') THEN 'Communication About Medicines'
      WHEN Measure_ID IN ('H_COMP_6_A_P') THEN 'Discharge Information'
      WHEN Measure_ID IN ('H_RECMND_HSP_A_P') THEN 'Likelihood to Recommend'
      WHEN Measure_ID IN ('H_HSP_RATING_A_P') THEN 'Overall Hospital Rating'
      ELSE 'Other'
    END AS measure_group

  FROM categorized
)

SELECT
  hospital_id,
  hospital_name,
  state,
  city,
  measure_id,
  measure_group,
  score,
  sample_size,
  footnote_category,
  is_reliable,
  survey_start_date,
  survey_end_date
FROM measure_mapped;

SELECT * FROM `healthcareanalysis-479317.new_analysis.patient_final_view`





