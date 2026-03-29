with orders as (

    select * from {{ ref('fct_orders') }}
    where status not in ('cancelled', 'returned')

),

monthly as (

    select
        order_year,
        order_month,
        country_code,
        customer_segment,
        count(distinct order_id)             as num_orders,
        count(distinct customer_id)          as num_customers,
        sum(quantity)                        as total_items,
        sum(line_total)                      as gross_revenue,
        sum(line_cost)                       as total_cost,
        sum(line_total - line_cost)          as gross_profit,
        sum(shipping_cost)                   as total_shipping,
        avg(line_total)                      as avg_order_value,
        avg(discount_pct)                    as avg_discount_pct

    from orders
    group by
        order_year,
        order_month,
        country_code,
        customer_segment

)

select
    *,
    case
        when gross_revenue > 0
            then cast(gross_profit as double) / cast(gross_revenue as double) * 100
        else 0
    end as profit_margin_pct

from monthly
order by order_year, order_month, country_code, customer_segment
