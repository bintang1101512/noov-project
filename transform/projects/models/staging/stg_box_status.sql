{{
    config(
        materialized='incremental',
        unique_key='box_id',
        schema='staging',
        partition_by={
            "field": "updatedat",
            "data_type": "timestamp",
            "granularity": "day"
        }
    )
}}

with source as(
    select *
    from {{ source('source', 'raw_api_box') }}

    {% if is_incremental() %}
    where ingested_at >= timestamp_sub(current_timestamp(), interval 1 day)
    
    {% endif %}
),

flatten as(
    SELECT
      JSON_VALUE(payload, '$.id') AS box_id,
      JSON_VALUE(payload, '$.name') AS name,
      JSON_VALUE(payload, '$.model') AS model,
      JSON_VALUE(payload, '$.status') AS status,
      CAST(JSON_VALUE(payload, '$.gpsLatitude') AS FLOAT64) AS gpsLatitude,
      CAST(JSON_VALUE(payload, '$.gpsLongitude') AS FLOAT64) AS gpsLongitude,
      CAST(JSON_VALUE(payload, '$.lUCOHold') AS FLOAT64) AS ucohold,
      CAST(JSON_VALUE(payload, '$.lSlopsHold') AS FLOAT64) AS slopshold,
      TIMESTAMP(JSON_VALUE(payload, '$.createdAt')) AS createdat,
      TIMESTAMP(JSON_VALUE(payload, '$.updatedAt')) AS updatedat,
      CAST(JSON_VALUE(payload, '$.chamberTemp') AS FLOAT64) AS chambertemp,
      CAST(JSON_VALUE(payload, '$.capacity.uco') AS FLOAT64) AS capacity_uco,
      CAST(JSON_VALUE(payload, '$.capacity.slops') AS FLOAT64) AS capacity_slops,
      CAST(JSON_VALUE(payload, '$.capacity.uco_limit') AS FLOAT64) AS capacity_limit,
      JSON_VALUE(payload, '$.address') AS address,
      CAST(JSON_VALUE(payload, '$.dashCollectionPoint') AS BOOL) AS dashcollectionpoint,
      CAST(JSON_VALUE(payload, '$.isOpen') AS BOOL) AS isopen,
      JSON_VALUE(payload, '$.group') AS group_id,
      JSON_VALUE(payload, '$.group_name') AS group_name,
      JSON_VALUE(payload, '$.internal_id') AS internal_id,
      CAST(JSON_VALUE(payload, '$.number') AS FLOAT64) AS number,
      TIMESTAMP(JSON_VALUE(payload, '$.lastUsed')) AS lastused,
      CAST(JSON_VALUE(payload, '$.leakage') AS BOOL) AS leakage,
      JSON_VALUE(payload, '$.city') AS city,
      JSON_VALUE(payload, '$.region') AS region,
      JSON_VALUE(payload, '$.postcode') AS postcode,
      JSON_VALUE(payload, '$.box_state') AS box_state

    from source
),

dedup as(
    select
        *,
        row_number() over(
            partition by box_id
            order by updatedat desc
        ) as rn
    from flatten
)

select * except(rn)
from dedup
where rn = 1