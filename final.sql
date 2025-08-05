select count(*) from retail_sales
-- checking null values
select * from retail_sales
where sale_date is null

select * from retail_sales
where sale_time is null or customer_id is null or gender is null or age is null 
or category is null or quantiy is null or cogs is null or total_sale is null or price_per_unit is null

-- deleting the null values/records
delete from retail_sales
where sale_time is null or customer_id is null or gender is null or age is null 
or category is null or quantiy is null or cogs is null or total_sale is null or price_per_unit is null

-- total distinct customers
select count(distinct customer_id) from retail_sales

-- total distinct categories
select count(distinct category) from retail_sales
select distinct(category) from retail_sales

-- show all columns for date 2022-11-06
select * from retail_sales
where sale_date = '2022-11-05'

-- show all columns where category is clothing and quantity sold is more than 10 for Nov 2022
select * from retail_sales
where category = 'Clothing' and quantiy >= 4 and to_char(sale_date,'YYYY-MM') = '2022-11'

-- show total sales for each cateogry
select sum(total_sale) as total_sales_category,category
from retail_sales
group by category

-- show average age of customer for "Beauty" category
select round(avg(age)) as average_age
from retail_sales
where category = 'Beauty'

-- show all transactions where total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000

-- total number of transactions made by each gender in each category
select count(*),category,gender from retail_sales
group by gender, category

-- average sale of each month, best selling month in each month
select * from (select 
				round(avg(total_sale)) as average_sale, 
				Extract(Month from sale_date) as month,
				extract(year from sale_date) as year,
				rank() over(partition by extract(year from sale_date) order by round(avg(total_sale)) desc)
		from retail_sales
		group by 2,3
)
where rank = 1

-- top 5 customers with highest total sales
select 
	customer_id,
	sum(total_sale) as total_spending
from retail_sales
group by customer_id
order by total_spending desc
limit 5

-- number of unique customers for each category
select 
	category,
	count(distinct(customer_id)) as unique_customers
from retail_sales
group by 1

-- create morning,afternoon and evening shift and show total orders in each shift
with hourly_sale as (
select *,
	case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales	 )
 select shift, count(*) as total_orders
 from hourly_sale 
 group by shift
	