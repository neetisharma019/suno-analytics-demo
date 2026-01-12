
  
    
    

    create  table
      "suno_analytics"."main"."stg_subscriptions__dbt_tmp"
  
    as (
      with source as (
    select * from read_csv('../data/raw_subscriptions.csv', header=true, auto_detect=true)
),

renamed as (
    select
        user_id,
        plan,
        cast(subscription_start as date) as subscription_start,
        cast(subscription_end as date) as subscription_end,
        cast(is_trial as boolean) as is_trial,
        cast(converted_to_paid as boolean) as converted_to_paid,
        cast(conversion_timestamp as timestamp) as conversion_timestamp
    from source
)

select * from renamed
    );
  
  