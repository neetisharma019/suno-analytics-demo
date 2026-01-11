with users as (
    select * from "suno_analytics"."main"."stg_users"
),

subscriptions as (
    select * from "suno_analytics"."main"."stg_subscriptions"
),

first_song_events as (
    select
        user_id,
        min(event_timestamp) as first_song_timestamp
    from "suno_analytics"."main"."stg_events"
    where event_type = 'song_generated'
    group by user_id
)

select
    u.user_id,
    u.signup_timestamp,
    u.signup_date,
    u.marketing_channel,
    u.region,
    u.is_creator,
    fse.first_song_timestamp,
    s.plan_tier,
    s.is_active as subscription_is_active,
    s.current_period_start,
    s.current_period_end
from users u
left join first_song_events fse
    on u.user_id = fse.user_id
left join subscriptions s
    on u.user_id = s.user_id