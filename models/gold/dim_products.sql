with products as (

    select * from {{ ref('stg_products') }}

),

order_stats as (

    select
        product_id,
        count(*)                             as times_ordered,
        sum(quantity)                        as total_units_sold,
        sum(line_total)                      as total_revenue,
        sum(line_total - line_cost)          as total_profit,
        count(distinct customer_id)          as unique_customers,
        avg(discount_pct)                    as avg_discount_given

    from {{ ref('stg_orders') }}
    group by product_id

),

final as (

    select
        p.product_id,
        p.product_name,
        p.category,
        p.brand,
        p.unit_price,
        p.cost_price,
        p.margin,
        p.weight_kg,
        p.is_available,
        coalesce(os.times_ordered, 0)        as times_ordered,
        coalesce(os.total_units_sold, 0)     as total_units_sold,
        coalesce(os.total_revenue, cast(0 as decimal(10,2)))  as total_revenue,
        coalesce(os.total_profit, cast(0 as decimal(10,2)))   as total_profit,
        coalesce(os.unique_customers, 0)     as unique_customers,
        coalesce(os.avg_discount_given, cast(0 as decimal(5,2))) as avg_discount_given,
        case
            when os.total_units_sold is null then 'no_sales'
            when os.total_units_sold >= 100  then 'best_seller'
            when os.total_units_sold >= 50   then 'popular'
            when os.total_units_sold >= 10   then 'moderate'
            else 'slow_mover'
        end                                  as sales_tier

    from products p
    left join order_stats os
        on p.product_id = os.product_id

)

select * from final
