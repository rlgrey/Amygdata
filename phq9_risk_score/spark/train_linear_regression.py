import os
import sys

from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.ml.feature import VectorAssembler, StandardScaler
from pyspark.ml.regression import LinearRegression
from pyspark.ml import Pipeline
from pyspark.ml.evaluation import RegressionEvaluator

# pozwalamy na import src.config
CURRENT_DIR = os.path.dirname(__file__)
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
sys.path.append(PROJECT_ROOT)

from src.config import DATA_RAW_PATH, FEATURE_COLS, TARGET_COL, MODEL_OUTPUT_PATH  # noqa: E402


def main():
    # 1. Spark session
    spark = (
        SparkSession.builder
        .appName("Amygdata_PHQ9_Spark_LR")
        .master("local[*]")
        .getOrCreate()
    )

    print(f"Reading data from: {DATA_RAW_PATH}")
    df = (
        spark.read
        .option("header", True)
        .option("inferSchema", True)
        .csv(DATA_RAW_PATH)
    )

    # 2. Upewniamy się, że wszystkie używane kolumny istnieją
    needed_cols = FEATURE_COLS + [TARGET_COL]
    missing = [c for c in needed_cols if c not in df.columns]
    if missing:
        raise ValueError(f"Missing columns in Spark dataframe: {missing}")

    # 3. Rzutujemy na typ Double i dropujemy null’e
    for c in needed_cols:
        df = df.withColumn(c, col(c).cast("double"))

    df = df.na.drop(subset=needed_cols)

    print("Data count after cleaning:", df.count())

    # 4. Train / test split
    train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)

    # 5. Spark ML pipeline: assembler -> scaler -> linear regression
    assembler = VectorAssembler(
        inputCols=FEATURE_COLS,
        outputCol="features_raw"
    )

    scaler = StandardScaler(
        inputCol="features_raw",
        outputCol="features",
        withMean=True,
        withStd=True
    )

    lr = LinearRegression(
        featuresCol="features",
        labelCol=TARGET_COL,
        predictionCol="prediction"
    )

    pipeline = Pipeline(stages=[assembler, scaler, lr])

    # 6. Trening modelu
    print("Training Spark Linear Regression model...")
    model = pipeline.fit(train_df)

    # 7. Predykcje i ewaluacja
    preds = model.transform(test_df)

    evaluator_rmse = RegressionEvaluator(
        labelCol=TARGET_COL,
        predictionCol="prediction",
        metricName="rmse",
    )
    evaluator_r2 = RegressionEvaluator(
        labelCol=TARGET_COL,
        predictionCol="prediction",
        metricName="r2",
    )

    rmse = evaluator_rmse.evaluate(preds)
    r2 = evaluator_r2.evaluate(preds)

    print("\nSpark model performance:")
    print(f"RMSE: {rmse:.3f}")
    print(f"R²:   {r2:.3f}")

    # 8. Zapis modelu (artifacts/)
    output_path = MODEL_OUTPUT_PATH
    print(f"\nSaving Spark model to: {output_path}")
    # tworzymy katalog nadrzędny jeśli trzeba
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    model.write().overwrite().save(output_path)

    spark.stop()


if __name__ == "__main__":
    main()
