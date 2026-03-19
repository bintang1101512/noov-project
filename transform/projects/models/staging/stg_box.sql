{{
    config(
        materialized='incremental',
        unique_key='ta_id',
        schema='staging',
        partition_by={
            "field": "updated_at",
            "data_type": "timestamp",
            "granularity": "day"
        },
        cluster_by=['ta_id'],
        incremental_predicates=[
            "DBT_INTERNAL_DEST.updated_at >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)"
        ]
    )
}}

with source as(
    select *
    from {{ source('source', 'raw_api') }}

    {% if is_incremental() %}
    where ingested_at >= timestamp_sub(current_timestamp(), interval 2 hour)
    
    {% endif %}
),

flatten as(
     SELECT
    JSON_VALUE(payload, '$._id') AS _id,
    JSON_VALUE(payload, '$.TA_ID') AS ta_id,
    JSON_VALUE(b, '$.name') AS box_name,
    JSON_VALUE(b, '$.internal_id') AS internal_id,
    JSON_VALUE(b, '$.address') AS address,
    JSON_VALUE(b, '$.city') AS city,
    JSON_VALUE(b, '$.postcode') AS postcode,
    JSON_VALUE(b, '$.region') AS region,
    SAFE_CAST(JSON_VALUE(b, '$.location.latitude') AS FLOAT64) AS latitude,
    SAFE_CAST(JSON_VALUE(b, '$.location.longitude') AS FLOAT64) AS longitude,
    JSON_VALUE(b, '$.group') AS group_id,
    TIMESTAMP(JSON_VALUE(payload, '$.createdAt')) AS created_at,
    TIMESTAMP(JSON_VALUE(payload, '$.updatedAt')) AS updated_at,
    ingested_at
  FROM source,
  UNNEST(JSON_QUERY_ARRAY(payload, '$.box')) AS b
),

dedup as(
    select *, row_number() over(
        partition by ta_id
        ORDER BY updated_at DESC
    ) as rn
    from flatten
)

select * except(rn)
from dedup
where rn = 1