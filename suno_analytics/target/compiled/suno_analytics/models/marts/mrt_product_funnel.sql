with users as (
    select * from "suno_analytics"."main"."dim_user"
),

events as (
    select * from "suno_analytics"."main"."stg_events"
),

user_events as (
    select
        user_id,
        min(case when event_type = 'song_generated' then event_timestamp end) as first_generate_ts,
        min(case when event_type = 'song_downloaded' then event_timestamp end) as first_download_ts,
        min(case when event_type = 'song_published' then event_timestamp end) as first_publish_ts
    from events
    group by user_id
),

funnel_with_times as (
    select
        u.user_id,
        u.signup_timestamp,
        ue.first_generate_ts,
        ue.first_download_ts,
        ue.first_publish_ts,
        case when ue.first_generate_ts is not null then 1 else 0 end as has_generated_song,
        case when ue.first_download_ts is not null then 1 else 0 end as has_downloaded_song,
        case when ue.first_publish_ts is not null then 1 else 0 end as has_published_song,
        case 
            when ue.first_generate_ts is not null 
            then (epoch_ms(ue.first_generate_ts) - epoch_ms(u.signup_timestamp)) / 1000.0
            else null
        end as time_to_first_song,
        case 
            when ue.first_download_ts is not null and ue.first_publish_ts is not null
            then (epoch_ms(ue.first_publish_ts) - epoch_ms(ue.first_download_ts)) / 1000.0
            else null
        end as download_to_publish_seconds
    from users u
    left join user_events ue
        on u.user_id = ue.user_id
),

funnel_with_buckets as (
    select
        *,
        case 
            when time_to_first_song is null then null
            when time_to_first_song < 300 then '<5m'
            when time_to_first_song < 1800 then '5-30m'
            when time_to_first_song < 86400 then '30m-24h'
            else '>24h'
        end as activation_window_bucket,
        case
            when first_publish_ts is not null then 'publisher'
            when first_download_ts is not null then 'downloader_only'
            when first_generate_ts is not null then 'generator_only'
            else 'viewer'
        end as user_segment
    from funnel_with_times
)

select * from funnel_with_buckets