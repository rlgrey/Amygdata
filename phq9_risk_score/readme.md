
# **PHQ-9 ML Pipeline**

![Python](https://img.shields.io/badge/Python-3.11-blue)
![Pandas](https://img.shields.io/badge/Pandas-Data_Processing-yellow)
![SQL](https://img.shields.io/badge/SQL-Analytics-blueviolet)
![Spark](https://img.shields.io/badge/Apache_Spark-ML_Pipeline-orange)
![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-Linear_Regression-green)
![Data Engineering](https://img.shields.io/badge/Data_Engineering-End_to_End-red)

A complete end-to-end pipeline for analyzing student mental‑health indicators and predicting PHQ‑9 depression scores.  
The project demonstrates a **production‑style** workflow combining:

- Pandas ETL  
- SQL analytical layer  
- scikit‑learn baseline model  
- Apache Spark ML pipeline  
- Clean modular architecture  

Part of the broader *Amygdata* research initiative.

---

# 🧠 **Project Summary**

```
Raw CSV → Pandas ETL → SQL Exploration → ML (sklearn) → Spark ML → Artifacts
```

Shows the ability to move from raw data to scalable machine‑learning pipelines.

---

# 📊 **Dataset Overview**

The dataset contains self‑reported mental‑health and lifestyle metrics from university students:

- PHQ-9 (depressive symptoms)
- GAD-7 (anxiety symptoms)
- SleepHours, ExerciseFreq, DietQuality
- AcademicStress, GPA
- Social & family support
- ScreenTime, OnlineStress  
- Binary mental‑health status label

Target variable:

```
PHQ9
```

Source file:

```
data/raw/mental_health.csv
```

---

# 🏗️ **Architecture Diagram**

```
                       ┌──────────────────────┐
                       │   Raw CSV Dataset    │
                       └──────────┬───────────┘
                                  │
                         Pandas (ETL Cleaning)
                                  │
                       ┌──────────▼───────────┐
                       │   Cleaned Dataset    │
                       └──────────┬───────────┘
                                  │
                    ┌─────────────┼────────────────┐
                    │             │                │
                    ▼             ▼                ▼
           SQL Analytics     Pandas EDA      sklearn Model
         (sql/*.sql)       (01_eda.py)      (baseline LR)
                    │                              │
                    └─────────────┬────────────────┘
                                  │
                                  ▼
                     Spark Machine Learning Pipeline
                (Assembler → Scaler → LinearRegression)
                                  │
                                  ▼
                        Saved Model Artifacts (.model)
```

---

# 📂 **Repository Structure**

```
PHQ-9 ML Pipeline
│
├── data/
│   ├── raw/
│   ├── clean/
│
├── src/
│   ├── config.py
│   ├── data_preprocessing.py
│   └── utils.py
│
├── spark/
│   └── train_linear_regression.py
│
├── sql/
│   ├── create_tables.sql
│   └── exploratory_queries.sql
│
├── notebooks/
│   └── 01_eda_pandas.py
│
├── artifacts/
│   └── phq9_lr_model/
│
└── README.md
```

---

# 🧬 **SQL Table Schema**

## **1️⃣ RAW Table (staging)**

```sql
CREATE TABLE mental_health_raw (
    PHQ9 TEXT,
    GAD7 TEXT,
    SleepHours TEXT,
    ExerciseFreq TEXT,
    SocialActivity TEXT,
    OnlineStress TEXT,
    GPA TEXT,
    FamilySupport TEXT,
    ScreenTime TEXT,
    AcademicStress TEXT,
    DietQuality TEXT,
    SelfEfficacy TEXT,
    PeerRelationship TEXT,
    FinancialStress TEXT,
    SleepQuality TEXT,
    MentalHealthStatus TEXT
);
```

Purpose:

- easy ingestion from CSV  
- no strict types  
- mirrors raw data exactly  

---

## **2️⃣ CLEAN Table (typed & analytical)**

```sql
CREATE TABLE mental_health_clean (
    id SERIAL PRIMARY KEY,
    PHQ9 DOUBLE PRECISION,
    GAD7 DOUBLE PRECISION,
    SleepHours DOUBLE PRECISION,
    ExerciseFreq DOUBLE PRECISION,
    SocialActivity DOUBLE PRECISION,
    OnlineStress DOUBLE PRECISION,
    GPA DOUBLE PRECISION,
    FamilySupport DOUBLE PRECISION,
    ScreenTime DOUBLE PRECISION,
    AcademicStress DOUBLE PRECISION,
    DietQuality DOUBLE PRECISION,
    SelfEfficacy DOUBLE PRECISION,
    PeerRelationship DOUBLE PRECISION,
    FinancialStress DOUBLE PRECISION,
    SleepQuality DOUBLE PRECISION,
    MentalHealthStatus INTEGER
);
```

Purpose:

- strong typing for ML  
- validated analytical dataset  
- consumed by both sklearn and Spark  

---

# 🔍 **Pipeline Components**

## **1. Pandas Data Preprocessing**
- load raw CSV  
- cast to numeric types  
- drop missing values  
- save cleaned dataset → `data/clean/`

## **2. EDA (notebook)**
- PHQ‑9 histogram  
- scatter (GAD‑7 vs PHQ‑9)  
- descriptive stats  
- feature distributions  

## **3. SQL Analytical Layer**
Queries include:

- PHQ‑9 & GAD‑7 descriptive statistics  
- correlations (`corr()`)  
- stressor analysis (Academic, Financial, Online)  
- GPA / SleepHours / ScreenTime buckets  
- top PHQ‑9 scorers  

## **4. sklearn Linear Regression**
Baseline predictive model using classic ML.

## **5. Spark ML Pipeline**
A scalable ML pipeline consisting of:

- `VectorAssembler`  
- `StandardScaler`  
- `LinearRegression`  
- `RegressionEvaluator`  

Model saved to:

```
artifacts/phq9_lr_model/
```

---

# 📈 **Model Performance**

## **Scikit‑Learn Regression**
```
RMSE: ~4.7
R²:    ~0.00
```

## **Spark ML Regression**
```
RMSE: ~4.75
R²:    ~-0.08
```

Interpretation:

- PHQ‑9 is nonlinear and noisy  
- linear regression is intentionally simple  
- purpose is demonstrating full pipeline, not maximizing accuracy  

---

# ▶️ **How to Run the Project**

## **1. Create virtual environment**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## **2. Run data preprocessing & EDA**
```bash
python3 notebooks/01_eda_pandas.py
```

## **3. Run Spark training**
Requires **Java 17**

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
python3 spark/train_linear_regression.py
```

---

# 🧠 **Key Takeaways**

- Complete end‑to‑end ML workflow  
- Strong separation of concerns (ETL → SQL → ML → Spark)  
- Modular, production‑like repository  
- Clean reproducible pipelines  
- Integration of multiple tools used in modern data teams  

---

# 👤 **Author**

**Rafał Bukowski**  
Project developed as part of the *Amygdata* research initiative.

