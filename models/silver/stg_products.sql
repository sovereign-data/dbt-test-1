with source as (

    select * from {{ ref('products') }}

),

cleaned as (

    select
        cast(product_id as integer)         as product_id,
        trim(product_name)                  as product_name,
        lower(trim(category))               as category,
        trim(brand)                         as brand,
        cast(unit_price as decimal(10,2))   as unit_price,
        cast(cost_price as decimal(10,2))   as cost_price,
        cast(weight_kg as decimal(8,2))     as weight_kg,
        case
            when lower(is_available) = 'true' then true
            else false
        end                                 as is_available,
        cast(unit_price as decimal(10,2))
            - cast(cost_price as decimal(10,2)) as margin

    from source

)

select * from cleaned
