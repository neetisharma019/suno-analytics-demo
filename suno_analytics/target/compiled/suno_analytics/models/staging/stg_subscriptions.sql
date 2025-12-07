with source as (
    select * from read_csv('../data/raw_subscriptions.csv', header=true, auto_detect=true)
),

renamed as (
    select
        user_id,
        plan_tier,
        cast(is_active as boolean) as is_active,
        cast(current_period_start as date) as current_period_start,
        cast(current_period_end as date) as current_period_end
    from source
)

select * from renamed