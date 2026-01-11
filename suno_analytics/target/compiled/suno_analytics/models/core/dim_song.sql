with events as (
    select * from "suno_analytics"."main"."stg_events"
),

song_generated as (
    select
        song_id,
        user_id,
        event_timestamp as created_timestamp,
        event_date as created_date,
        prompt_text,
        model_version,
        platform,
        country,
        duration_sec,
        genre,
        mood
    from events
    where event_type = 'song_generated'
)

select * from song_generated