with events as (
    select * from {{ ref('stg_events') }}
),

song_generated as (
    select
        song_id,
        user_id,
        min(event_timestamp) as first_generated_at,
        min(model_version) as model_version,
        min(prompt_category) as prompt_category
    from events
    where event_type = 'song_generated'
        and song_id is not null
    group by song_id, user_id
)

select * from song_generated
