# src/config.py

DATA_RAW_PATH = "data/raw/mental_health.csv"
DATA_CLEAN_PATH = "data/clean/mental_health_clean.csv"
MODEL_OUTPUT_PATH = "artifacts/phq9_lr_model"

TARGET_COL = "PHQ9"

FEATURE_COLS = [
    "GAD7",
    "SleepHours",
    "ExerciseFreq",
    "SocialActivity",
    "ScreenTime",
    "AcademicStress",
    "DietQuality",
    "PeerRelationship",
    "FinancialStress",
    "SleepQuality",
    "GPA",
    "FamilySupport",
]
