-- Every order in fct_orders should have a customer name (no failed joins)
select
    order_id,
    customer_id

from {{ ref('fct_orders') }}

where customer_name is null
