-- Monthly gross revenue should not be negative
select
    order_year,
    order_month,
    country_code,
    gross_revenue

from {{ ref('agg_monthly_revenue') }}

where gross_revenue < 0
