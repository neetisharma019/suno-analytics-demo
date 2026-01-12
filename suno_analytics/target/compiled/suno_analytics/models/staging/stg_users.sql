with source as (
    select * from read_csv('../data/raw_users.csv', header=true, auto_detect=true)
),

renamed as (
    select
        user_id,
        cast(signup_timestamp as timestamp) as signup_timestamp,
        region,
        acquisition_channel,
        cast(is_creator as boolean) as is_creator,
        platform,
        cast(signup_timestamp as date) as signup_date
    from source
)

select * from renamed