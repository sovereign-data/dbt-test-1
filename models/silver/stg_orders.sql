with source as (

    select * from {{ ref('orders') }}

),

cleaned as (

    select
        cast(order_id as integer)           as order_id,
        cast(customer_id as integer)        as customer_id,
        cast(product_id as integer)         as product_id,
        cast(quantity as integer)            as quantity,
        cast(order_date as date)            as order_date,
        lower(trim(status))                 as status,
        cast(discount_pct as decimal(5,2))  as discount_pct,
        cast(shipping_cost as decimal(8,2)) as shipping_cost

    from source

),

enriched as (

    select
        o.*,
        year(o.order_date)                  as order_year,
        month(o.order_date)                 as order_month,
        day_of_week(o.order_date)           as order_day_of_week,
        p.unit_price,
        p.cost_price,
        cast(o.quantity as decimal(10,2))
            * p.unit_price
            * (1 - o.discount_pct / 100)    as line_total,
        cast(o.quantity as decimal(10,2))
            * p.cost_price                   as line_cost

    from cleaned o
    left join {{ ref('stg_products') }} p
        on o.product_id = p.product_id

)

select * from enriched
