-- Orders must have a quantity of at least 1
select
    order_id,
    quantity

from {{ ref('stg_orders') }}

where quantity < 1
