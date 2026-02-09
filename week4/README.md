# Module 4 Homework

## Question 1

### Question

Given a dbt project with the following structure:

```
models/
├── staging/
│   ├── stg_green_tripdata.sql
│   └── stg_yellow_tripdata.sql
└── intermediate/
    └── int_trips_unioned.sql (depends on stg_green_tripdata & stg_yellow_tripdata)
```

If you run `dbt run --select int_trips_unioned`, what models will be built?

- `stg_green_tripdata`, `stg_yellow_tripdata`, and `int_trips_unioned` (upstream dependencies)
- Any model with upstream and downstream dependencies to `int_trips_unioned`
- `int_trips_unioned` only
- `int_trips_unioned`, `int_trips`, and `fct_trips` (downstream dependencies)

### Solution

When you run `dbt run --select int_trips_unioned`, it only builds the `int_trips_unioned`. You need to add the modifier (`+`) to build `dbt run --select int_trips_unioned` with upstream and/or downstream dependencies.


**Answer**: `int_trips_unioned` only

## Question 2 

### Question

You've configured a generic test like this in your `schema.yml`:

```yaml
columns:
  - name: payment_type
    data_tests:
      - accepted_values:
          arguments:
            values: [1, 2, 3, 4, 5]
```

Your model `fct_trips` has been running successfully for months. A new value `6` now appears in the source data.

What happens when you run `dbt test --select fct_trips`?

- dbt will skip the test because the model didn't change
- dbt will fail the test, returning a non-zero exit code
- dbt will pass the test with a warning about the new value
- dbt will update the configuration to include the new value

### Solution

When you run `dbt test --select fct_trips`, it will execute the `accepted_values` test against the current data in the `fct_trips` model and find rows with `payment_type = 6` which is not included in the `accepted_values`. Then it will fail the test, returning a non-zero exit code. 

**Answer**: dbt will fail the test, returning a non-zero exit code

## Question 3

### Question 

After running your dbt project, query the `fct_monthly_zone_revenue` model.

What is the count of records in the `fct_monthly_zone_revenue` model?

- 12,998
- 14,120
- 12,184
- 15,421

### Solution

```sql
SELECT COUNT(*)
FROM prod.fct_monthly_zone_revenue
``` 

**Answer**: 12,184

## Question 4

### Question

Using the `fct_monthly_zone_revenue` table, find the pickup zone with the **highest total revenue** (`revenue_monthly_total_amount`) for **Green** taxi trips in 2020.

Which zone had the highest revenue?

- East Harlem North
- Morningside Heights
- East Harlem South
- Washington Heights South

### Solution

```sql
SELECT pickup_zone, SUM(revenue_monthly_total_amount) total_revenue 
FROM prod.fct_monthly_zone_revenue
WHERE CAST(revenue_month AS VARCHAR) LIKE '2020-%'
  AND service_type = 'Green'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
```
**Answer**: East Harlem North

## Question 5

### Question

Using the `fct_monthly_zone_revenue` table, what is the **total number of trips** (`total_monthly_trips`) for Green taxis in October 2019?

- 500,234
- 350,891
- 384,624
- 421,509

### Solution

```sql
SELECT SUM(total_monthly_trips) total_trips
FROM prod.fct_monthly_zone_revenue
WHERE CAST(revenue_month AS VARCHAR) LIKE '2019-10-%'
  AND service_type = 'Green'
```

**Answer**: 384,624

## Question 6

### Question

Create a staging model for the **For-Hire Vehicle (FHV)** trip data for 2019.

1. Load the [FHV trip data for 2019](https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv) into your data warehouse
2. Create a staging model `stg_fhv_tripdata` with these requirements:
   - Filter out records where `dispatching_base_num IS NULL`
   - Rename fields to match your project's naming conventions (e.g., `PUlocationID` → `pickup_location_id`)

What is the count of records in `stg_fhv_tripdata`?

- 42,084,899
- 43,244,696
- 22,998,722
- 44,112,187

### Solution

```sql
SELECT COUNT(*)
FROM prod.stg_fhv_tripdata
```

**Answer**: 43,244,693