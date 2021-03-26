## DW Creation

### Dimensional Modelling 

#### Star by Kimball

<img src="https://github.com/xokcanax/DE-101/blob/main/Module02/img/Conceptual%20model.png" width="500">

<img src="https://github.com/xokcanax/DE-101/blob/main/Module02/img/Physical%20model.png" width="1000">

### SQL queries

[SQL queries](https://github.com/xokcanax/DE-101/tree/main/Module02/SQL%20Queries) for creating data model and retrieving key metrics:

```sql
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
round(sum(sales), 2) as total_sales, 
round(sum(profit), 2) as total_profit
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
```

### Google Data Studio

Connection query:

```sql
select * from dw.sales_fact sf
join dw.shipping_dim s on sf.ship_id = s.ship_id 
join dw.geo_dim g on sf.geo_id = g.geo_id 
join de.product_dim p on p.prod_id = sf.prod_id 
join dw.customer_dim cd on cd.cust_id = sf.cust_id
```

[Google Data Studio dashboard](https://datastudio.google.com/u/0/reporting/16edfb50-cef8-4941-8a3c-ea971948a2dd/page/5xU9B)

<img src="https://github.com/xokcanax/DE-101/blob/main/Module02/img/Google%20Data%20Studio_Sample_Superstore_-_Dashboard.png" width="1000">
