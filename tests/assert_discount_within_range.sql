-- Discount percentage must be between 0 and 100
select
    order_id,
    discount_pct

from {{ ref('stg_orders') }}

where discount_pct < 0 or discount_pct > 100
