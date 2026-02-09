/* @bruin
name: staging.trips
type: duckdb.sql

depends:
  - ingestion.trips
  - ingestion.payment_lookup

materialization:
  type: table
  strategy: time_interval
  incremental_key: pickup_datetime
  time_granularity: timestamp

columns:
  - name: pickup_datetime
    type: timestamp
    description: "Normalized pickup timestamp (from tpep/lpep)"
    primary_key: true
    checks:
      - name: not_null
  - name: dropoff_datetime
    type: timestamp
    description: "Normalized dropoff timestamp (from tpep/lpep)"
    checks:
      - name: not_null
  - name: taxi_type
    type: string
    description: "Source taxi type"
    primary_key: true
    checks:
      - name: not_null
      - name: accepted_values
        value: ["yellow", "green"]
  - name: payment_type
    type: integer
    description: "Payment type code"
  - name: payment_type_name
    type: string
    description: "Payment type description from lookup"
  - name: pu_location_id
    type: integer
    description: "Pickup location ID"
    primary_key: true
    checks:
      - name: not_null
  - name: do_location_id
    type: integer
    description: "Dropoff location ID"
    primary_key: true
    checks:
      - name: not_null
  - name: trip_distance
    type: float
    description: "Trip distance in miles"
    checks:
      - name: non_negative
  - name: total_amount
    type: float
    description: "Total amount charged"
  - name: fare_amount
    type: float
    description: "Fare amount"
    primary_key: true
    checks:
      - name: not_null

custom_checks:
  - name: no_duplicate_trips
    description: "Verify deduplication removed all duplicates"
    query: |
      SELECT COUNT(*) FROM (
        SELECT pickup_datetime, dropoff_datetime, taxi_type, pu_location_id, do_location_id, fare_amount
        FROM staging.trips
        WHERE pickup_datetime >= '{{ start_datetime }}'
          AND pickup_datetime < '{{ end_datetime }}'
        GROUP BY 1, 2, 3, 4, 5, 6
        HAVING COUNT(*) > 1
      )
    value: 0

@bruin */

SELECT
    t.pickup_datetime,
    t.dropoff_datetime,
    t.taxi_type,
    t.passenger_count,
    t.trip_distance,
    t.pu_location_id,
    t.do_location_id,
    t.payment_type,
    p.payment_type_name,
    t.fare_amount,
    t.extra,
    t.mta_tax,
    t.tip_amount,
    t.tolls_amount,
    t.improvement_surcharge,
    t.total_amount,
    t.congestion_surcharge
FROM (
    SELECT
        COALESCE(tpep_pickup_datetime, lpep_pickup_datetime) AS pickup_datetime,
        COALESCE(tpep_dropoff_datetime, lpep_dropoff_datetime) AS dropoff_datetime,
        taxi_type,
        passenger_count,
        trip_distance,
        pu_location_id,
        do_location_id,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        ROW_NUMBER() OVER (
            PARTITION BY
                taxi_type,
                COALESCE(tpep_pickup_datetime, lpep_pickup_datetime),
                COALESCE(tpep_dropoff_datetime, lpep_dropoff_datetime),
                pu_location_id,
                do_location_id,
                fare_amount
            ORDER BY extracted_at DESC
        ) AS rn
    FROM ingestion.trips
    WHERE COALESCE(tpep_pickup_datetime, lpep_pickup_datetime) >= '{{ start_datetime }}'
      AND COALESCE(tpep_pickup_datetime, lpep_pickup_datetime) < '{{ end_datetime }}'
) t
LEFT JOIN ingestion.payment_lookup p
    ON t.payment_type = p.payment_type_id
WHERE t.rn = 1
  AND t.pickup_datetime IS NOT NULL
  AND t.dropoff_datetime IS NOT NULL
