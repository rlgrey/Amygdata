# src/data_preprocessing.py

import os
import pandas as pd
from .config import DATA_RAW_PATH, DATA_CLEAN_PATH, FEATURE_COLS, TARGET_COL


def load_raw() -> pd.DataFrame:
    """Load raw mental health dataset from CSV."""
    if not os.path.exists(DATA_RAW_PATH):
        raise FileNotFoundError(f"Raw data not found at: {DATA_RAW_PATH}")
    df = pd.read_csv(DATA_RAW_PATH)
    return df


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Basic cleaning:
    - keep only selected feature columns + target
    - drop rows with missing values in these columns
    - cast to numeric
    """
    cols = FEATURE_COLS + [TARGET_COL]
    df = df[cols].copy()

    # usuwamy wiersze z brakami w kluczowych kolumnach
    df = df.dropna(subset=cols)

    # rzutujemy na float (na wszelki wypadek)
    for c in cols:
        df[c] = pd.to_numeric(df[c], errors="coerce")
    df = df.dropna(subset=cols)

    return df


def save_clean(df: pd.DataFrame) -> None:
    """Save cleaned dataset to CSV."""
    os.makedirs(os.path.dirname(DATA_CLEAN_PATH), exist_ok=True)
    df.to_csv(DATA_CLEAN_PATH, index=False)


def load_and_clean() -> pd.DataFrame:
    """Convenience function: load raw data, clean it, save & return."""
    df_raw = load_raw()
    df_clean = clean_data(df_raw)
    save_clean(df_clean)
    return df_clean
