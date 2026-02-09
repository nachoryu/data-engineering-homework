# Module 5 Homework

## Question 1

### Question

In a Bruin project, what are the required files/directories?

- `bruin.yml` and `assets/`
- `.bruin.yml` and `pipeline.yml` (assets can be anywhere)
- `.bruin.yml` and `pipeline/` with `pipeline.yml` and `assets/`
- `pipeline.yml` and `assets/` only

### Solution

A valid Bruin project requires a `.bruin.yml` file at the project root (project-level config), with a `pipeline/` directory that contains `pipeline.yml` (pipeline definition) and `assets/` (your asset definitions)

**Answer**: `.bruin.yml` and `pipeline/` with `pipeline.yml` and `assets/`

## Question 2 

### Question

You're building a pipeline that processes NYC taxi data organized by month based on `pickup_datetime`. Which materialization strategy should you use for the staging layer that deduplicates and cleans the data?

- `append` - always add new rows
- `replace` - truncate and rebuild entirely
- `time_interval` - incremental based on a time column
- `view` - create a virtual table only

### Solution

`time_interval` lets you reprocess only the affected time windows (e.g., the current or late-arriving month) while leaving clean historical data untouched.

**Answer**: `time_interval` - incremental based on a time column

## Question 3

### Question 

You have the following variable defined in `pipeline.yml`:

```yaml
variables:
  taxi_types:
    type: array
    items:
      type: string
    default: ["yellow", "green"]
```

How do you override this when running the pipeline to only process yellow taxis?

- `bruin run --taxi-types yellow`
- `bruin run --var taxi_types=yellow`
- `bruin run --var 'taxi_types=["yellow"]'`
- `bruin run --set taxi_types=["yellow"]`

### Solution

`taxi_types` is defined as an array, so you must override it with a JSON-style array. `--var` is the correct flag for overriding pipeline variables at runtime. Quoting is needed so that the shell does not  mangle the brackets.

**Answer**: `bruin run --var 'taxi_types=["yellow"]'`

## Question 4

### Question

You've modified the `ingestion/trips.py` asset and want to run it plus all downstream assets. Which command should you use?

- `bruin run ingestion.trips --all`
- `bruin run ingestion/trips.py --downstream`
- `bruin run pipeline/trips.py --recursive`
- `bruin run --select ingestion.trips+`

### Solution

`--select` is how you target specific assets in Bruin. `ingestion.trips` refers to the asset (not the file path). The trailing `+` means “run this asset and all of its downstream dependencies.”

**Answer**: `bruin run --select ingestion.trips+`

## Question 5

### Question

You want to ensure the `pickup_datetime` column in your trips table never has NULL values. Which quality check should you add to your asset definition?

- `unique: true`
- `not_null: true`
- `positive: true`
- `accepted_values: [not_null]`

### Solution

`not_null` explicitly enforces that the column cannot contain NULL values. 

**Answer**: `not_null: true`

## Question 6

### Question

After building your pipeline, you want to visualize the dependency graph between assets. Which Bruin command should you use?

- `bruin graph`
- `bruin dependencies`
- `bruin lineage`
- `bruin show`

### Solution

`bruin graph` generates and visualizes the asset dependency DAG, showing how assets relate upstream and downstream. 

**Answer**: `bruin graph`

## Question 7

### Question

You're running a Bruin pipeline for the first time on a new DuckDB database. What flag should you use to ensure tables are created from scratch?

- `--create`
- `--init`
- `--full-refresh`
- `--truncate`

### Solution

`--full-refresh` forces Bruin to drop and recreate all materialized assets, ensuring tables are built from scratch.

**Answer**: `--full-refresh`