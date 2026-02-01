# Module 3 Homework

## Question 1

### Question

What is count of records for the 2024 Yellow Taxi Data?
- 65,623
- 840,402
- 20,332,093
- 85,431,289

### Solution

```sql
SELECT COUNT(*) FROM yellow_taxi_external;
```
**Answer**: 20,332,093

## Question 2 

### Question 

Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.</br> 
What is the **estimated amount** of data that will be read when this query is executed on the External Table and the Table?

- 18.82 MB for the External Table and 47.60 MB for the Materialized Table
- 0 MB for the External Table and 155.12 MB for the Materialized Table
- 2.14 GB for the External Table and 0MB for the Materialized Table
- 0 MB for the External Table and 0MB for the Materialized Table

### Solution 

The query only requires the PULocationID column. As both the external and the materialized tables are columnar, the query optimizer can compute using metadata without scanning the actual data. Hence, the estimated amount of data read is 0 MB for both tables.

**Answer**: 0 MB for the External Table and 0MB for the Materialized Table

## Question 3

### Question

Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?
- BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires 
reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.
- BigQuery duplicates data across multiple storage partitions, so selecting two columns instead of one requires scanning the table twice, 
doubling the estimated bytes processed.
- BigQuery automatically caches the first queried column, so adding a second column increases processing time but does not affect the estimated bytes scanned.
- When selecting multiple columns, BigQuery performs an implicit join operation between them, increasing the estimated bytes processed


### Solution 

BigQuery is a column-oriented data warehouse, which means it only reads the columns explicitly referenced in the query.
Selecting `PULocationID` and `DOLocationID` requires scanning more data than selecting only `PULocationID`, which leads to a higher estimated number of bytes processed.

**Answer**: BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

## Question 4

### Question

How many records have a fare_amount of 0?
- 128,210
- 546,578
- 20,188,016
- 8,333

### Solution 
```sql
SELECT COUNT(*) FROM yellow_taxi_external WHERE fare_amount = 0;
```

**Answer**: 8,333

## Question 5

### Question

What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)
- Partition by tpep_dropoff_datetime and Cluster on VendorID
- Cluster on by tpep_dropoff_datetime and Cluster on VendorID
- Cluster on tpep_dropoff_datetime Partition by VendorID
- Partition by tpep_dropoff_datetime and Partition by VendorID

### Solution 

Partitioning by tpep_dropoff_datetime reduces the amount of data scanned because queries always filter on this column. Clustering by VendorID improves performance when ordering or grouping results by keeping similar values stored together.

**Answer**: Partition by tpep_dropoff_datetime and Cluster on VendorID

## Question 6

### Question

Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime
2024-03-01 and 2024-03-15 (inclusive)</br>

Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? </br>

Choose the answer which most closely matches.</br> 

- 12.47 MB for non-partitioned table and 326.42 MB for the partitioned table
- 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table
- 5.87 MB for non-partitioned table and 0 MB for the partitioned table
- 310.31 MB for non-partitioned table and 285.64 MB for the partitioned table

### Solution

The non-partitioned table scans a much larger amount of data because BigQuery must read data across the entire table to apply the date filter. On the other hand, the partitioned table only scans the partitions that fall between March 1 and March 15, which significantly reduces the amount of data processed.

**Answer**: 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

## Question 7 

### Question

Where is the data stored in the External Table you created?

- Big Query
- Container Registry
- GCP Bucket
- Big Table

### Solution

An external table in BigQuery does not store data in Big Query. Instead, it only storees metadata and schema, while the actual data remains in the GCS Bucket. Big Query reads the data directly from the bucket at query time.

**Answer**: GCP Bucket

## Question 8

### Question

It is best practice in Big Query to always cluster your data:
- True
- False

### Solution

Clustering is not always necessary. It is only useful when queries frequently filter, group, or sort by specific columns. For small tables or tables with unpredictable query patterns, clustering can add unnecessary overhead without improving performance.

**Answer**: False