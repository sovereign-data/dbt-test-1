with source as (

    select * from {{ ref('customers') }}

),

cleaned as (

    select
        cast(customer_id as integer)        as customer_id,
        trim(first_name)                    as first_name,
        trim(last_name)                     as last_name,
        lower(trim(email))                  as email,
        trim(city)                          as city,
        upper(trim(country))                as country_code,
        lower(trim(segment))                as segment,
        cast(created_at as date)            as created_at,
        case
            when lower(is_active) = 'true' then true
            else false
        end                                 as is_active

    from source

)

select * from cleaned
