"""@bruin
name: ingestion.trips
type: python
image: python:3.11
connection: duckdb-default

materialization:
  type: table
  strategy: append

columns:
  - name: taxi_type
    type: string
    description: "Source taxi type (yellow or green)"
    checks:
      - name: not_null
      - name: accepted_values
        value: ["yellow", "green"]
  - name: extracted_at
    type: timestamp
    description: "Timestamp when the data was extracted"
    checks:
      - name: not_null

@bruin"""

import os
import json
from io import BytesIO
from datetime import datetime

import pandas as pd
import requests
from dateutil.relativedelta import relativedelta


BASE_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/"


def materialize():
    start_date = os.environ.get("BRUIN_START_DATE")
    end_date = os.environ.get("BRUIN_END_DATE")
    bruin_vars = json.loads(os.environ.get("BRUIN_VARS", "{}"))
    taxi_types = bruin_vars.get("taxi_types", ["yellow"])

    start = datetime.strptime(start_date, "%Y-%m-%d")
    end = datetime.strptime(end_date, "%Y-%m-%d")
    extracted_at = datetime.utcnow()

    all_dfs = []
    current = start.replace(day=1)
    while current < end:
        year_month = current.strftime("%Y-%m")
        for taxi_type in taxi_types:
            url = f"{BASE_URL}{taxi_type}_tripdata_{year_month}.parquet"
            print(f"Fetching {url}")
            response = requests.get(url, timeout=120)
            if response.status_code == 200:
                df = pd.read_parquet(BytesIO(response.content))
                df["taxi_type"] = taxi_type
                df["extracted_at"] = extracted_at
                all_dfs.append(df)
            else:
                print(f"Warning: {url} returned status {response.status_code}, skipping")
        current += relativedelta(months=1)

    if all_dfs:
        result = pd.concat(all_dfs, ignore_index=True)
        # Ensure both tpep/lpep columns exist for schema consistency
        for col in ["tpep_pickup_datetime", "tpep_dropoff_datetime",
                     "lpep_pickup_datetime", "lpep_dropoff_datetime"]:
            if col not in result.columns:
                result[col] = pd.NaT
        return result

    return pd.DataFrame()
