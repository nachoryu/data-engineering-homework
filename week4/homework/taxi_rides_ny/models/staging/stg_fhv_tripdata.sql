with source as (
    select * from {{ source('raw', 'fhv_tripdata') }}
),

renamed as (
    select
        -- identifiers
        cast(dispatching_base_num as integer) as dispatching_base_num,
        cast(PUlocationID as integer) as pickup_location_id,
        cast(DOlocationID as integer) as dropoff_location_id,

        -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,  -- lpep = Licensed Passenger Enhancement Program (green taxis)
        cast(dropOff_datetime as timestamp) as dropoff_datetime,

        -- trip info
        cast(SR_Flag as varchar) as sr_flag,
        cast(Affiliated_base_number as varchar) as affiliated_base_number 
    from source
    where dispatching_base_num is not null
)

select * from renamed
