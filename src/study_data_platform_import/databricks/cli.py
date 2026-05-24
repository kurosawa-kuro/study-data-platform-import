from __future__ import annotations

import argparse
import json
from pathlib import Path

import pandas as pd
from databricks.connect import DatabricksSession
from pyspark.sql import DataFrame
from pyspark.sql.types import (
    DateType,
    IntegerType,
    StringType,
    StructField,
    StructType,
    TimestampType,
)


DEFAULT_DATA_DIR = Path(__file__).resolve().parents[3] / "data"
DEFAULT_DATABASE = "study_import"


CUSTOMERS_SCHEMA = StructType(
    [
        StructField("customer_id", IntegerType(), False),
        StructField("name", StringType(), False),
        StructField("age", IntegerType(), False),
        StructField("prefecture", StringType(), False),
        StructField("signup_date", DateType(), False),
    ]
)

ORDERS_SCHEMA = StructType(
    [
        StructField("order_id", IntegerType(), False),
        StructField("customer_id", IntegerType(), False),
        StructField("amount", IntegerType(), False),
        StructField("ordered_at", TimestampType(), False),
    ]
)

EVENTS_SCHEMA = StructType(
    [
        StructField("event_id", StringType(), False),
        StructField("customer_id", IntegerType(), False),
        StructField("event_type", StringType(), False),
        StructField("page", StringType(), False),
        StructField("timestamp", TimestampType(), False),
    ]
)

PRODUCTS_SCHEMA = StructType(
    [
        StructField("product_id", IntegerType(), False),
        StructField("product_name", StringType(), False),
        StructField("category", StringType(), False),
        StructField("price", IntegerType(), False),
    ]
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Import local sample files into Databricks tables via Databricks Connect."
    )
    parser.add_argument(
        "command",
        choices=["csv", "json", "parquet", "all", "query"],
        help="What to run.",
    )
    parser.add_argument(
        "--data-dir",
        type=Path,
        default=DEFAULT_DATA_DIR,
        help="Directory containing customers.csv, orders.csv, events.json, products.parquet.",
    )
    parser.add_argument(
        "--database",
        default=DEFAULT_DATABASE,
        help="Target database/schema name in Databricks.",
    )
    return parser.parse_args()


def create_spark() -> DatabricksSession:
    return DatabricksSession.builder.getOrCreate()


def ensure_database(spark: DatabricksSession, database: str) -> None:
    spark.sql(f"CREATE DATABASE IF NOT EXISTS {database}")
    spark.sql(f"USE {database}")


def read_customers(data_dir: Path) -> pd.DataFrame:
    df = pd.read_csv(data_dir / "customers.csv", parse_dates=["signup_date"])
    df["signup_date"] = df["signup_date"].dt.date
    return df


def read_orders(data_dir: Path) -> pd.DataFrame:
    return pd.read_csv(data_dir / "orders.csv", parse_dates=["ordered_at"])


def read_events(data_dir: Path) -> pd.DataFrame:
    with (data_dir / "events.json").open(encoding="utf-8") as fp:
        payload = json.load(fp)

    df = pd.DataFrame(payload)
    df["timestamp"] = pd.to_datetime(df["timestamp"])
    return df


def read_products(data_dir: Path) -> pd.DataFrame:
    return pd.read_parquet(data_dir / "products.parquet")


def to_spark_df(spark: DatabricksSession, pdf: pd.DataFrame, schema: StructType) -> DataFrame:
    records = pdf.to_dict(orient="records")
    return spark.createDataFrame(records, schema=schema)


def save_table(df: DataFrame, table_name: str) -> None:
    df.write.mode("overwrite").saveAsTable(table_name)


def import_csv_tables(spark: DatabricksSession, data_dir: Path, database: str) -> None:
    ensure_database(spark, database)

    customers_df = to_spark_df(spark, read_customers(data_dir), CUSTOMERS_SCHEMA)
    orders_df = to_spark_df(spark, read_orders(data_dir), ORDERS_SCHEMA)

    customers_df.createOrReplaceTempView("customers_view")
    orders_df.createOrReplaceTempView("orders_view")

    save_table(customers_df, "customers")
    save_table(orders_df, "orders")

    print("Imported customers and orders tables.")


def import_json_table(spark: DatabricksSession, data_dir: Path, database: str) -> None:
    ensure_database(spark, database)

    events_df = to_spark_df(spark, read_events(data_dir), EVENTS_SCHEMA)
    events_df.createOrReplaceTempView("events_view")
    save_table(events_df, "events")

    print("Imported events table.")


def import_parquet_table(spark: DatabricksSession, data_dir: Path, database: str) -> None:
    ensure_database(spark, database)

    products_df = to_spark_df(spark, read_products(data_dir), PRODUCTS_SCHEMA)
    products_df.createOrReplaceTempView("products_view")
    save_table(products_df, "products")

    print("Imported products table.")


def run_queries(spark: DatabricksSession, database: str) -> None:
    ensure_database(spark, database)

    results = spark.sql(
        """
        SELECT
          c.customer_id,
          c.name,
          c.prefecture,
          COUNT(o.order_id) AS order_count,
          COALESCE(SUM(o.amount), 0) AS total_amount
        FROM customers c
        LEFT JOIN orders o
          ON c.customer_id = o.customer_id
        GROUP BY
          c.customer_id,
          c.name,
          c.prefecture
        ORDER BY total_amount DESC
        """
    )
    results.show()


def main() -> None:
    args = parse_args()
    spark = create_spark()

    if args.command == "csv":
        import_csv_tables(spark, args.data_dir, args.database)
    elif args.command == "json":
        import_json_table(spark, args.data_dir, args.database)
    elif args.command == "parquet":
        import_parquet_table(spark, args.data_dir, args.database)
    elif args.command == "query":
        run_queries(spark, args.database)
    elif args.command == "all":
        import_csv_tables(spark, args.data_dir, args.database)
        import_json_table(spark, args.data_dir, args.database)
        import_parquet_table(spark, args.data_dir, args.database)
        run_queries(spark, args.database)


if __name__ == "__main__":
    main()
