# Module 1 Homework: Docker & SQL

## Question 1. Understanding Docker images

### Question 

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

What's the version of `pip` in the image?

- 25.3
- 24.3.1
- 24.2.1
- 23.3.1

### Solution

```bash
docker run -it --rm --entrypoint=bash python:3.13-slim
pip --version
```

**Answer**: 25.3

## Question 2. Understanding Docker networking and docker-compose

### Question

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

If multiple answers are correct, select any 

### Solution

pgadmin and the postgres database are running on the same Docker Compose network, and can find according to their names. Hence, pgadmin should use 'db' as the hostname and '5432' as the port to connect to the postgres database (In '5433:5432', '5432' is the postgres port inside the container.)

**Answer**: db:5432 

## Question 3. Counting short trips

### Question 

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?

- 7,853
- 8,007
- 8,254
- 8,421

### Solution

```sql
SELECT COUNT(*)
FROM public.green_tripdata
WHERE lpep_pickup_datetime >= TIMESTAMP '2025-11-01' 
	AND lpep_pickup_datetime < TIMESTAMP '2025-12-01'
	AND trip_distance <= 1
```

**Answer**: 8,007

## Question 4. Longest trip for each day

### Question 

Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

- 2025-11-14
- 2025-11-20
- 2025-11-23
- 2025-11-25

### Solution

```sql
SELECT lpep_pickup_datetime::DATE
FROM public.green_tripdata
WHERE trip_distance < 100
ORDER BY trip_distance DESC
LIMIT 1
```

**Answer**: 2025-11-14

## Question 5. Biggest pickup zone

### Question

Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?

- East Harlem North
- East Harlem South
- Morningside Heights
- Forest Hills

### Solution
```sql
SELECT z."Zone", SUM(total_amount) total_amount
FROM public.green_tripdata g 
JOIN public.zones z 
ON g."PULocationID" = z."LocationID"
WHERE g.lpep_pickup_datetime >= DATE '2025-11-18'
	AND g.lpep_pickup_datetime < DATE '2025-11-19'
GROUP BY z."Zone"
ORDER BY 2 DESC
LIMIT 1
```

**Answer**: East Harlem North

## Question 6. Largest tip

### Question

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's `tip` , not `trip`. We need the name of the zone, not the ID.

- JFK Airport
- Yorkville West
- East Harlem North
- LaGuardia Airport

### Solution
```sql
SELECT dz."Zone" dropoff_zone
FROM public.green_tripdata g 
JOIN public.zones pz 
ON g."PULocationID" = pz."LocationID"
JOIN public.zones dz
ON g."DOLocationID" = dz."LocationID"
WHERE g.lpep_pickup_datetime >= TIMESTAMP '2025-11-01'
	AND g.lpep_pickup_datetime < TIMESTAMP '2025-12-01' 
	AND pz."Zone" = 'East Harlem North'
ORDER BY g.tip_amount DESC
LIMIT 1
```

**Answer**: Yorkville West

## Question 7. Terraform Workflow

### Question

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

### Solution
'terraform init' downloads the provider plugins and sets up backend.
'terraform apply' generates the proposed changes and '-auto-approve' is the option for auto-executing. 
'terraform destory' removes all resources managed by terraform. 

**Answer** : terraform init, terraform apply -auto-approve, terraform destroy