# HCAHPS Regional Performance Audit: The Care Gap Analysis

## 1. Executive Summary
This project identifies a critical **"Care Gap"** in the U.S. healthcare system: the disparity between standardized clinical excellence and volatile environmental quality. By processing **30,949 raw records** through a custom Google BigQuery pipeline, I isolated a high-integrity cohort of **28,499 reliable records** across 7 states. The analysis reveals that while Doctor and Nurse communication is consistently high, environmental factors like "Quietness" vary by as much as **18%** across regions, representing a significant operational opportunity for healthcare leadership.

---

## 2. Business Problem
Healthcare executives often struggle to answer a fundamental question: *Is low patient satisfaction caused by our people or our facilities?* * **The Noise in the Data:** "Short-Year" reporting and data suppression often mask true regional performance, leading to "Information Blackouts."
* **The Strategic Dilemma:** Organizations risk over-investing in staff communication training (which has hit a performance ceiling) while ignoring the volatile "Atmosphere" metrics that actually drive regional dissatisfaction.

---

## 3. Technical Stack & Project Architecture

![Data Architecture Diagram](https://res.cloudinary.com/ducikqiyg/image/upload/v1767158527/data_flow_diagram_ag7vut.png)
* **Cloud Data Warehouse:** Google BigQuery
* **Data Transformation:** SQL (Views, Regex footnote parsing, Case Logic)
* **Analysis Environment:** Python (Jupyter Notebooks)
* **Libraries:** Pandas, Seaborn, Matplotlib, Google Cloud BigQuery
* **Business Intelligence:** Looker Studio

---

## 4. Methodology
1. **Data Engineering (BigQuery):** Developed a SQL View to clean raw HCAHPS data. Used Regex to identify suppressed records and created a binary `is_reliable` flag based on reporting period length.
2. **The Reliability Gate:** Filtered the dataset to ensure only "Full-Year" high-integrity records were used for benchmarking.
3. **Statistical Visualization (Python):** Connected the BigQuery View to a Python environment to generate a variance heatmap, identifying the specific "Care Categories" with the highest volatility.
4. **Executive Reporting (Looker Studio):** Designed a comparative dashboard to visualize the "Care Gap" for non-technical stakeholders.

---

## 5. Skills
* **SQL:** Advanced View creation, Data Audit logic, and Feature Engineering.
* **Python:** Automated data extraction from GCP and advanced statistical plotting (Heatmaps).
* **Data Storytelling:** Translating technical variance into actionable business recommendations.
* **Pipeline Architecture:** Building a scalable bridge between a Cloud Warehouse and BI tools.

---

## 6. Results & Business Recommendations

### A. Data Integrity Audit (The Reliability Gate)
![Data Integrity Audit](https://res.cloudinary.com/ducikqiyg/image/upload/v1767154401/Dataintegrity_hca_aincyf.png)
* **The Result:** The audit proved that reporting transparency is not uniform; some states have significantly higher suppression rates than others.
* **Insight:** Decisions made without this "Reliability Gate" risk being based on skewed, incomplete data.

### B. Mapping Operational Fragility (Python Heatmap)
![Python Heatmap](https://res.cloudinary.com/ducikqiyg/image/upload/v1767154381/heatmap_hca_j37yhd.png)
* **The Result:** Clinical Communication is highly standardized (~79-84%). However, "Quietness" is an outlier, showing extreme regional inconsistency.

### C. The Care Gap (Looker Studio Comparison)
![The Care Gap](https://res.cloudinary.com/ducikqiyg/image/upload/v1767154320/thecaregap_dnv4lv.png)
* **The Result:** Even in top-performing states, Quietness scores drop as low as **51%** (CA) and **54%** (CT).
* **Recommendation:** **Shift investment from Staff Training to Facility Management.** Clinical staff have mastered the "Message," but the "Atmosphere" (Quietness) requires localized operational intervention.

---

## 7. Strategic Next Steps: Operationalizing the Audit

This analysis serves as a foundation for a targeted environmental improvement strategy. To move from "data insight" to "hospital impact," the following business-focused initiatives are recommended:

### **A. Targeted Facility Intervention**
* **Localized Noise-Control Pilots:** Launch "Quiet at Night" protocols in lowest-performing regions (CA, CT, AZ) to standardize the environment to the level of top-performing states.
* **Infrastructure Audits:** Conduct physical site audits in high-volatility regions to determine if the "Quietness Gap" is driven by building age, HVAC noise, or high-traffic floor layouts.

### **B. Outcome Correlation & ROI Analysis**
* **HCAHPS to Loyalty Mapping:** Quantify the financial impact of the environment by correlating "Quietness" scores with the **"Likelihood to Recommend"** metric to identify direct revenue risk.
* **Staffing Retention Analysis:** Investigate if high environmental volatility correlates with nurse burnout and turnover rates, determining if physical environment is a hidden driver of staffing costs.

### **C. Precision Performance Benchmarking**
* **Intra-State Deep Dives:** Expand the audit from the State level to individual **Hospital Systems** to identify "Centers of Excellence" whose protocols can be replicated across the region.
* **Reliability-Based Accountability:** Implement the "Reliability Gate" as a standard quarterly audit, ensuring regional directors are evaluated only on high-integrity, full-year performance data.

---

## 8. About the Data: The Reliability Framework

To ensure the integrity of this audit, the raw dataset underwent a rigorous multi-stage cleaning process to move from a general population to a high-integrity analysis cohort.

### **Data Lifecycle & Volume**
* **Raw Dataset:** 30,949 records sourced from the HCAHPS BigQuery Public Dataset.
* **Final Analysis Cohort:** 28,499 records (92.1% of raw data).
* **Excluded Records:** 2,450 records identified as "statistically unreliable."

### **The "Reliability Gate" Logic**
The exclusion of 2,450 records was driven by two primary technical filters implemented in the SQL transformation layer:

1. **Short-Year Reporting (Incomplete Data):** * Records that did not represent a full 12-month reporting period were flagged. 
   * **Technical Justification:** Short-year data is subject to seasonal spikes and does not provide an accurate annualized benchmark for regional comparison.
2. **Data Suppression (Information Blackouts):** * Facilities with fewer than 100 completed surveys often have their scores suppressed by CMS to protect patient privacy and prevent margin-of-error volatility. 
   * **Technical Justification:** Including suppressed or low-volume records introduces statistical noise that can falsely inflate or deflate state-level averages.

### **Data Schema & Transformations**
* **`is_reliable` (Boolean):** A custom feature engineered to distinguish between the 28,499 high-integrity records and the 2,450 excluded data points.
* **Normalization:** All disparate survey measures were mapped into six standardized "Measure Groups" (e.g., Clinical Communication, Environment, Discharge Care) to allow for cross-category variance testing.

---