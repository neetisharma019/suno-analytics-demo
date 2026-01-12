with users as (
    select * from {{ ref('stg_users') }}
),

subscriptions as (
    select * from {{ ref('stg_subscriptions') }}
)

select
    u.user_id,
    u.signup_timestamp,
    u.signup_date,
    u.region,
    u.acquisition_channel,
    u.is_creator,
    u.platform,
    s.plan,
    s.subscription_start,
    s.subscription_end,
    s.is_trial,
    s.converted_to_paid,
    s.conversion_timestamp
from users u
left join subscriptions s
    on u.user_id = s.user_id
