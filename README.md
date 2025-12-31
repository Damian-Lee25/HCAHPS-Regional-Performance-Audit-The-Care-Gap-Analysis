# HCAHPS Regional Performance Audit: The Care Gap Analysis

## 1. Executive Summary
This project identifies a critical **"Care Gap"** in the U.S. healthcare system: the disparity between standardized clinical excellence and volatile environmental quality. By processing **30,949 raw records** through a custom Google BigQuery pipeline, I isolated a high-integrity cohort of **28,499 reliable records** across 7 states. The analysis reveals that while Doctor and Nurse communication is consistently high, environmental factors like "Quietness" vary by as much as **18%** across regions, representing a significant operational opportunity for healthcare leadership.

---

## 2. Business Problem
Healthcare executives often struggle to answer a fundamental question: *Is low patient satisfaction caused by our people or our facilities?* * **The Noise in the Data:** "Short-Year" reporting and data suppression often mask true regional performance, leading to "Information Blackouts."
* **The Strategic Dilemma:** Organizations risk over-investing in staff communication training (which has hit a performance ceiling) while ignoring the volatile "Atmosphere" metrics that actually drive regional dissatisfaction.

---

## 3. Technical Stack & Project Architecture

This project utilizes an **Event-Driven Data Pipeline** to automate the flow of healthcare data from local ingestion to cloud-based analytics.

![Data Architecture Diagram](https://res.cloudinary.com/ducikqiyg/image/upload/v1767158527/data_flow_diagram_ag7vut.png)

### **The Data Pipeline Flow:**
1.  **Local Ingestion:** Processed raw healthcare data via **Python** in a Jupyter Notebook environment.
2.  **Cloud Storage (GCS):** Automated the upload of cleaned CSVs to **Google Cloud Storage** buckets using the `google-cloud-storage` library.
3.  **Event-Driven Automation:** Configured a **Google Cloud Run Function** to monitor the GCS bucket. 
4.  **Auto-Load to BigQuery:** Every time a new file is uploaded, the Cloud Run Function is triggered, automatically extracting the file and loading it into a **BigQuery** staging table.
5.  **Analytics Layer:** Final data transformation and "Reliability Gate" filtering performed in BigQuery for consumption in **Looker Studio** and **Seaborn**.

### **Cloud Components:**
* **Language:** Python (Pandas, GCS Client Library)
* **Storage:** Google Cloud Storage (GCS)
* **Compute:** Google Cloud Run Functions (Serverless trigger-based ingestion)
* **Warehouse:** Google BigQuery

---

## 4. Methodology

The project was executed in four distinct phases, moving from local data preparation to a fully automated cloud pipeline and executive-level visualization.

### **Phase 1: Local Ingestion & Pre-Processing**
* **Environment:** Developed a specialized **Python** script within a Jupyter Notebook to handle initial data cleaning.
* **Cleaning Logic:** Standardized naming conventions, handled missing values, and prepared the CSV for cloud ingestion.
* **Automation:** Integrated the `google-cloud-storage` library to automatically push the finalized dataset to a designated GCS bucket.

### **Phase 2: Event-Driven Cloud Engineering**
* **Trigger Mechanism:** Configured a **Google Cloud Run Function** to listen for `finalize/create` events in the Cloud Storage bucket.
* **Serverless Extraction:** Upon file upload, the Cloud Run Function triggers automatically, extracting the CSV data and loading it into a staging table in **BigQuery**.
* **Scalability:** This architecture ensures that any future HCAHPS data updates are ingested instantly without manual intervention.

### **Phase 3: The SQL Reliability Gate**
* **Advanced Transformation:** Built a BigQuery SQL View to parse complex footnotes using **Regex**.
* **Feature Engineering:** Created the `is_reliable` flag to filter out "Short-Year" and suppressed records, narrowing the 30,949 raw records down to a high-integrity cohort of 28,499.
* **Aggregation:** Mapped 10+ specific healthcare metrics into 6 high-level "Measure Groups" for cross-category benchmarking.

### **Phase 4: Statistical Analysis & BI**
* **Python Deep-Dive:** Connected the BigQuery View back to a Jupyter Notebook for variance analysis, producing the regional performance heatmap.
* **Executive Dashboarding:** Developed a multi-page **Looker Studio** report to visualize the "Care Gap," specifically contrasting clinical benchmarks against environmental volatility.

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