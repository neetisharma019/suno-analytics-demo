with source as (
    select * from read_csv('../data/raw_events.csv', header=true, auto_detect=true)
),

renamed as (
    select
        event_id,
        user_id,
        cast(event_timestamp as timestamp) as event_timestamp,
        session_id,
        event_type,
        song_id,
        model_version,
        prompt_category,
        generation_latency_ms,
        cast(success_flag as boolean) as success_flag,
        cast(event_timestamp as date) as event_date
    from source
)

select * from renamed
