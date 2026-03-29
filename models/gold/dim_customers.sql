with customers as (

    select * from {{ ref('stg_customers') }}

),

order_stats as (

    select
        customer_id,
        count(*)                             as total_orders,
        sum(line_total)                      as total_revenue,
        sum(line_total - line_cost)          as total_profit,
        min(order_date)                      as first_order_date,
        max(order_date)                      as last_order_date,
        avg(line_total)                      as avg_order_value,
        sum(quantity)                        as total_items_purchased

    from {{ ref('stg_orders') }}
    group by customer_id

),

final as (

    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.first_name || ' ' || c.last_name  as full_name,
        c.email,
        c.city,
        c.country_code,
        c.segment,
        c.created_at,
        c.is_active,
        coalesce(os.total_orders, 0)         as total_orders,
        coalesce(os.total_revenue, cast(0 as decimal(10,2)))  as total_revenue,
        coalesce(os.total_profit, cast(0 as decimal(10,2)))   as total_profit,
        os.first_order_date,
        os.last_order_date,
        coalesce(os.avg_order_value, cast(0 as decimal(10,2))) as avg_order_value,
        coalesce(os.total_items_purchased, 0) as total_items_purchased,
        case
            when os.total_orders is null then 'inactive'
            when os.total_orders >= 20 then 'vip'
            when os.total_orders >= 10 then 'loyal'
            when os.total_orders >= 3  then 'regular'
            else 'new'
        end                                  as customer_tier

    from customers c
    left join order_stats os
        on c.customer_id = os.customer_id

)

select * from final
