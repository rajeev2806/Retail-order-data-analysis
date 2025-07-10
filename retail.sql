 select *
from df_orders

-- top 10 highest revenue generating products

select  product_id,sum(sale_price) sale
from df_orders
group by product_id
order by sale  desc
limit 10

--top 5 highest selling product in each region

with cte as(
select region,product_id,sum(sale_price) sale
from df_orders
group by product_id,region
order by sale desc
),
 cte2 as(
select region,product_id,sale,row_number() over(partition by region order by sale desc) rn
from cte
)

select *
from cte2
where rn<=5

-- find month over month growth for year 2022 ,2023

with cte as(
select extract(year from order_date) order_year,
		extract(month from order_date) order_month,
		sum(sale_price) sale
from df_orders
group by order_year,order_month
order by order_year,order_month
)

select order_month,sum(case when order_year=2022 then sale else 0 end)  year_2022,
       sum(case when order_year=2023 then sale else 0 end) year_2023
from cte
group by order_month
order by order_month

-- for each category which month has highest sale

with cte as(
select category,TO_CHAR(order_date,'YYYY-MM')order_year_month,sum(sale_price ) sale
from df_orders
group by category , order_year_month
order by category, sale desc
),
cte2 as(
select *, row_number() over(partition by category order by sale desc) rn
from cte
)

select *
from cte2
where rn<=1


--which sub category had highest growth by profit in 2023 compare to 2022

with cte as(
select sub_category,extract(year from order_date) order_year,
		sum(profit) profit
from df_orders
group by order_year,sub_category
order by order_year,sub_category
)
,cte2 as(
select sub_category sub_category,sum(case when order_year=2022 then profit else 0 end)  profit_2022,
       sum(case when order_year=2023 then profit else 0 end) profit_2023
from cte
group by sub_category
order by sub_category
)

select *, round((profit_2023-profit_2022)*100/profit_2022,2) growth_percentage 
from cte2
order by growth_percentage desc
limit 1
