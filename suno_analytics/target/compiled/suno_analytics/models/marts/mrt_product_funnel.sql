with users as (
    select * from "suno_analytics"."main"."dim_user"
),

events as (
    select * from "suno_analytics"."main"."stg_events"
),

subscriptions as (
    select * from "suno_analytics"."main"."stg_subscriptions"
),

user_events as (
    select
        user_id,
        min(case when event_type = 'song_generated' then event_timestamp end) as first_song_timestamp,
        min(case when event_type = 'song_exported' then event_timestamp end) as first_export_timestamp
    from events
    group by user_id
),

funnel as (
    select
        u.user_id,
        u.signup_timestamp,
        ue.first_song_timestamp,
        ue.first_export_timestamp,
        s.plan_tier,
        case when s.plan_tier in ('pro', 'premium') then 1 else 0 end as is_paid
    from users u
    left join user_events ue
        on u.user_id = ue.user_id
    left join subscriptions s
        on u.user_id = s.user_id
        and s.is_active = true
)

select
    count(distinct user_id) as total_signups,
    count(distinct case when first_song_timestamp is not null then user_id end) as users_with_first_song,
    count(distinct case when first_export_timestamp is not null then user_id end) as users_with_first_export,
    count(distinct case when is_paid = 1 then user_id end) as paid_users
from funnel