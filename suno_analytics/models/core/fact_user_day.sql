with events as (
    select * from {{ ref('stg_events') }}
),

users as (
    select * from {{ ref('stg_users') }}
),

daily_events as (
    select
        user_id,
        event_date,
        count(case when event_type = 'song_generated' then 1 end) as songs_generated,
        count(case when event_type = 'song_exported' then 1 end) as songs_exported,
        count(case when event_type = 'song_extended' then 1 end) as songs_extended,
        count(distinct song_id) as unique_songs,
        count(distinct session_id) as unique_sessions,
        sum(case when event_type = 'song_generated' then duration_sec else 0 end) as total_duration_sec
    from events
    group by user_id, event_date
)

select
    de.user_id,
    de.event_date,
    u.signup_date,
    de.songs_generated,
    de.songs_exported,
    de.songs_extended,
    de.unique_songs,
    de.unique_sessions,
    de.total_duration_sec
from daily_events de
left join users u
    on de.user_id = u.user_id

