-- VIP customers must have at least 20 orders
select
    customer_id,
    full_name,
    total_orders,
    customer_tier

from {{ ref('dim_customers') }}

where customer_tier = 'vip' and total_orders < 20
