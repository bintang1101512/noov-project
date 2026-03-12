{{
    config(
        materialized="view"
    )
}}

select 
    a._id,
    a.ta_id,
    a.box_id,
    a.user_id,

    DATETIME(ta_start_time, "Asia/Jakarta") AS ta_start_time_wib,
    DATETIME(ta_end_time, "Asia/Jakarta") AS ta_end_time_wib,

    ROUND(DATETIME_DIFF(
        DATETIME(ta_end_time, "Asia/Jakarta"),
        DATETIME(ta_start_time, "Asia/Jakarta"),
        SECOND
    ) / 60, 2) AS duration_minute,

    a.ta_uco_volume,
    a.ta_slops_volume,
    a.ta_uco_weight,
    a.ta_slops_weight,
    a.uco_approved,
    a.amount,
    a.bonus,
    a.fare,
    a.total_amount,
    a.method,
    a.density,
    a.detail_transaction,
    a.box_brand_partner,
    a.alcohol_level,
    b.box_name,
    b.city AS box_city,
    b.postcode AS box_postcode,
    b.region,
    b.group_id,
    c.full_name,
    c.user_type,
    c.email,
    c.phone_number,
    c.city AS user_city,
    c.postcode AS user_postcode,
    c.region AS user_region,
    c.referral_code,
    c.username,
    d.partner_type_volume_partner as vp_status,
    e.group_name
    
from {{ ref("stg_transaction") }} as a
left join {{ ref("stg_box") }} as b
on a.ta_id = b.ta_id
left join {{ ref("stg_user") }} as c 
on a.ta_id = c.ta_id
left join {{ ref("stg_box_status") }} as d
on a.box_id = d.box_id
left join {{ ref("stg_vp") }} as e
on a.user_id = e.user_id