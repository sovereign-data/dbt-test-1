with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

final as (

    select
        o.order_id,
        o.order_date,
        o.order_year,
        o.order_month,
        o.status,
        o.customer_id,
        c.first_name || ' ' || c.last_name  as customer_name,
        c.segment                            as customer_segment,
        c.country_code,
        c.city,
        o.product_id,
        o.quantity,
        o.discount_pct,
        o.shipping_cost,
        o.unit_price,
        o.cost_price,
        o.line_total,
        o.line_cost,
        o.line_total - o.line_cost           as line_profit

    from orders o
    left join customers c
        on o.customer_id = c.customer_id

)

select * from final
