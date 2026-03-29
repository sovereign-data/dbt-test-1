-- Cost price should not exceed unit price
select
    product_id,
    product_name,
    unit_price,
    cost_price

from {{ ref('stg_products') }}

where cost_price > unit_price
