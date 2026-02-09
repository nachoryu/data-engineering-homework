/* @bruin
name: reports.trips_report
type: duckdb.sql

depends:
  - staging.trips

materialization:
  type: table
  strategy: time_interval
  incremental_key: pickup_date
  time_granularity: date

columns:
  - name: pickup_date
    type: date
    description: "Trip date (derived from pickup_datetime)"
    primary_key: true
    checks:
      - name: not_null
  - name: taxi_type
    type: string
    description: "Taxi type (yellow or green)"
    primary_key: true
    checks:
      - name: not_null
      - name: accepted_values
        value: ["yellow", "green"]
  - name: payment_type_name
    type: string
    description: "Payment type description"
    primary_key: true
    checks:
      - name: not_null
  - name: trip_count
    type: integer
    description: "Number of trips"
    checks:
      - name: positive
  - name: total_revenue
    type: float
    description: "Sum of total_amount"
    checks:
      - name: not_null
  - name: avg_trip_distance
    type: float
    description: "Average trip distance in miles"
    checks:
      - name: non_negative
  - name: avg_fare_amount
    type: float
    description: "Average fare amount"
  - name: total_tip_amount
    type: float
    description: "Sum of tip amounts"
    checks:
      - name: not_null

@bruin */

SELECT
    CAST(pickup_datetime AS DATE) AS pickup_date,
    taxi_type,
    COALESCE(payment_type_name, 'unknown') AS payment_type_name,
    COUNT(*) AS trip_count,
    SUM(total_amount) AS total_revenue,
    AVG(trip_distance) AS avg_trip_distance,
    AVG(fare_amount) AS avg_fare_amount,
    SUM(tip_amount) AS total_tip_amount
FROM staging.trips
WHERE pickup_datetime >= '{{ start_datetime }}'
  AND pickup_datetime < '{{ end_datetime }}'
GROUP BY 1, 2, 3
