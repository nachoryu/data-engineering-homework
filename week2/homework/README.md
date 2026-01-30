# Module 2 Homework

## Question 1

### Question

Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?
- 128.3 MiB
- 134.5 MiB
- 364.7 MiB
- 692.6 MiB

### Solution

I added `stat -c "%s" {{render(vars.file)}}` to the commands of the `extract` task, which gave me 134481400 bytes (= 128.3 MiB)

**Answer**: 128.3 MiB

## Question 2 

### Question 

What is the rendered value of the variable `file` when the inputs `taxi` is set to `green`, `year` is set to `2020`, and `month` is set to `04` during execution?
- `{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv` 
- `green_tripdata_2020-04.csv`
- `green_tripdata_04_2020.csv`
- `green_tripdata_2020.csv`

### Solution 
The `file` variable is rendered by substituting the inputs into the template. With `taxi = green`, `year = 2020`, and `month = 04`, the rendered value will be `green_tripdata_2020-04.csv`.

**Answer**: `green_tripdata_2020-04.csv`

## Question 3

### Question

How many rows are there for the `Yellow` Taxi data for all CSV files in the year 2020?
- 13,537.299
- 24,648,499
- 18,324,219
- 29,430,127

### Solution 

```sql
SELECT COUNT(*)
FROM yellow_tripdata
WHERE filename LIKE 'yellow_tripdata_2020-%'
```

**Answer**: 24,648,499

## Question 4

### Question

How many rows are there for the `Green` Taxi data for all CSV files in the year 2020?
- 5,327,301
- 936,199
- 1,734,051
- 1,342,034

### Solution 
```sql
SELECT COUNT(*)
FROM green_tripdata
WHERE filename LIKE 'green_tripdata_2020-%'
```

**Answer**: 1,734,051

## Question 5

### Question

How many rows are there for the `Yellow` Taxi data for the March 2021 CSV file?
- 1,428,092
- 706,911
- 1,925,152
- 2,561,031

### Solution 
```sql
SELECT COUNT(*)
FROM yellow_tripdata
WHERE filename LIKE 'yellow_tripdata_2021-03%'
```

**Answer**: 1,925,152

## Question 6

### Question

How would you configure the timezone to New York in a Schedule trigger?
- Add a `timezone` property set to `EST` in the `Schedule` trigger configuration  
- Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration
- Add a `timezone` property set to `UTC-5` in the `Schedule` trigger configuration
- Add a `location` property set to `New_York` in the `Schedule` trigger configuration  

### Solution

In Kestra, it is recommended to set the trigger timezone using an IANA timezone name. Therefore, I would add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration. 

**Answer**: Add a `timezone` property set to `America/New_York` in the `Schedule` trigger configuration