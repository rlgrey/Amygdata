import sys
import os

# pozwala importować moduły z ../src
CURRENT_DIR = os.path.dirname(__file__)
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
sys.path.append(PROJECT_ROOT)

import matplotlib.pyplot as plt
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

from src.data_preprocessing import load_and_clean
from src.config import FEATURE_COLS, TARGET_COL


def main():
    # 1. ETL: wczytanie i czyszczenie danych
    print("Loading and cleaning data...")
    df = load_and_clean()
    print("Data shape after cleaning:", df.shape)
    print(df.head())

    # 2. Proste statystyki opisowe
    print("\nDescriptive statistics:")
    print(df.describe())

    # 3. Rozdział na cechy i target
    X = df[FEATURE_COLS]
    y = df[TARGET_COL]

    # 4. Train / test split
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    # 5. Model regresji liniowej
    print("\nTraining Linear Regression model...")
    model = LinearRegression()
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)

    mse = mean_squared_error(y_test, y_pred)
    rmse = mse ** 0.5
    r2 = r2_score(y_test, y_pred)

    print("\nModel performance:")
    print(f"RMSE: {rmse:.3f}")
    print(f"R²:   {r2:.3f}")

    coeffs = dict(zip(FEATURE_COLS, model.coef_))
    print("\nCoefficients:")
    for feat, coef in coeffs.items():
        print(f"{feat:15s} -> {coef: .4f}")

    # 6. Proste wykresy (opcjonalnie)
    # histogram PHQ9
    plt.figure()
    df[TARGET_COL].hist(bins=20)
    plt.title("PHQ-9 score distribution")
    plt.xlabel("PHQ9")
    plt.ylabel("Count")
    plt.tight_layout()
    plt.show()

    # scatter GAD7 vs PHQ9 (jeśli GAD7 jest w feature_cols)
    if "GAD7" in FEATURE_COLS:
        plt.figure()
        plt.scatter(df["GAD7"], df[TARGET_COL], alpha=0.6)
        plt.xlabel("GAD7")
        plt.ylabel("PHQ9")
        plt.title("GAD7 vs PHQ9")
        plt.tight_layout()
        plt.show()


if __name__ == "__main__":
    main()
