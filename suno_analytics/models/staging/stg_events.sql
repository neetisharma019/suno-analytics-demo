with source as (
    select * from read_csv('../data/raw_events.csv', header=true, auto_detect=true)
),

renamed as (
    select
        event_id,
        cast(event_timestamp as timestamp) as event_timestamp,
        user_id,
        session_id,
        song_id,
        event_type,
        prompt_text,
        model_version,
        platform,
        country,
        properties,
        cast(event_timestamp as date) as event_date
    from source
),

parsed as (
    select
        *,
        json_extract(properties, '$.duration_sec')::int as duration_sec,
        json_extract(properties, '$.genre')::varchar as genre,
        json_extract(properties, '$.mood')::varchar as mood
    from renamed
)

select * from parsed

