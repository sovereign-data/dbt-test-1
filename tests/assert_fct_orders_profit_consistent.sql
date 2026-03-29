-- line_profit must equal line_total minus line_cost
select
    order_id,
    line_total,
    line_cost,
    line_profit

from {{ ref('fct_orders') }}

where abs(line_profit - (line_total - line_cost)) > 0.01
