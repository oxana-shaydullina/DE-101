-- profit ratio per region (calculated as profit / sales in %)
select region, 
round(sum(profit)/sum(sales)*100, 2) as "profit ratio in %"
from dw.sales_fact join dw.geo_dim gd using(geo_id)
group by region
order by 2 desc;

-- sales per state
select state, 
sum(sales) as total
from dw.sales_fact join dw.geo_dim gd using(geo_id)
group by state 
order by state asc;

-- sales and profit per segment
select 
year, 
segment, 
round(sum(sales), 2) as total_sales, 
round(sum(profit), 2) as total_profit 
from dw.sales_fact join dw.calendar_dim on dw.sales_fact.order_date_id = dw.calendar_dim.date_id join dw.product_dim using(prod_id)
group by 1, 2
order by 1;

-- sales and profit per manager
select 
person, 
sum(sales) as total_sales, 
sum(profit) as total_profit
from stg.people join dw.geo_dim on stg.people.region = dw.geo_dim.region join dw.sales_fact using(geo_id)
group by person;

-- some totals
select
round(sum(sales), 2) as total_sales,
round(sum(profit), 2) as total_profit,
trunc(sum(profit)/sum(sales), 2) as profit_ratio,
round(avg(profit), 2) as avg_profit_per_order
from dw.sales_fact;

-- the best customers of 2019 (top-20)
select 
customer_name, 
round(sum(profit), 2) as total_customer_profit
from dw.customer_dim join dw.sales_fact using(cust_id) join dw.calendar_dim on dw.sales_fact.order_date_id = dw.calendar_dim.date_id 
where date between '2019-01-01' and '2020-01-01'
group by customer_name
order by 2 desc 
limit 20;

