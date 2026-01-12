with events as (
    select * from "suno_analytics"."main"."stg_events"
),

users as (
    select * from "suno_analytics"."main"."stg_users"
),

daily_events as (
    select
        user_id,
        event_date,
        count(case when event_type = 'song_generated' then 1 end) as generated_cnt,
        count(case when event_type = 'song_downloaded' then 1 end) as downloaded_cnt,
        count(case when event_type = 'song_published' then 1 end) as published_cnt,
        count(case when event_type = 'song_extended' then 1 end) as extend_cnt,
        count(case when event_type = 'song_remixed' then 1 end) as remix_cnt,
        count(case when event_type = 'lyric_ai_used' then 1 end) as lyric_ai_cnt,
        count(case when event_type = 'app_opened' then 1 end) as effects_cnt
    from events
    group by user_id, event_date
)

select
    de.user_id,
    de.event_date,
    u.signup_date,
    case when de.generated_cnt > 0 
            or de.downloaded_cnt > 0 
            or de.published_cnt > 0 
            or de.extend_cnt > 0 
            or de.remix_cnt > 0 
            or de.lyric_ai_cnt > 0 
            or de.effects_cnt > 0 
        then true 
        else false 
    end as active_flag,
    de.generated_cnt,
    de.downloaded_cnt,
    de.published_cnt,
    de.extend_cnt,
    de.remix_cnt,
    de.lyric_ai_cnt,
    de.effects_cnt
from daily_events de
left join users u
    on de.user_id = u.user_id