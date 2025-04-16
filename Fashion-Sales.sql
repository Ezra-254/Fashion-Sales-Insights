-- Step 2: Perform the Following Analysis
-- A. Sales Analysis

-- identify the top 5 selling products

select category,
		sum(revenue) as total_revenue
from fashion 
group by category 
order by total_revenue DESC
limit 5;


-- Determine the monthly trend of total sales.

select to_char(extract(year from delivery_date),'9999') as year,
	to_char(delivery_date, 'month') as month,
	extract(month from delivery_date) as month_number,
	sum(revenue) as total_sales
from fashion
group by year,month,month_number
order by year,month_number;





-- Analyze sales distribution by day of the week.

select 
    to_char(order_date, 'FMDay') as day_of_week,  -- Get the full name of the day of the week, without trailing spaces
    count(order_date) as total_orders,  -- Count the number of orders per day of the week
    sum(revenue) as total_sales
from fashion
group by day_of_week  -- Group by the day of the week
order by day_of_week;  -- Order by day of the week starting from Monday

--B. Customer Insights

--1.List the top 10 customers by revenue.

select 
    distinct(customer_name), 
    sum(revenue) as total_revenue
from fashion
group by distinct(customer_name)
order by total_revenue  desc
limit 10;

--2.Compare the number of repeat vs new customers
 
select 
    count(distinct case when order_count = 1 then customer_email end) as new_customers,
    count(distinct case when order_count > 1 then customer_email end) as repeat_customers
from (
    select 
        customer_email,
        COUNT(*) AS order_count
    from fashion
    group by customer_email
) as customer_orders;

--3. Identify locations with most active buyers(if applicable)

select shop_outlet, count(*) as total_orders
from fashion
group by shop_outlet 
order by total_orders desc;

--C. Time-Based Analysis

--1.Compare sales btwn weekdays and weekends.

select 
    case 
        when extract(DOW from order_date) in (0, 6) then 'Weekend'  -- 0 = Sunday, 6 = Saturday
        else 'Weekday'  -- Monday to Friday
    end as day_type,
    SUM(revenue) as total_sales,
    count(*) as total_orders
from fashion
group by day_type
order by day_type;

--2. Find peak shopping hours(if timestamp is available)


-- no time stamp

--D.Inventory insights
--1.Identify low stock items
select 
    category,
    clothing_type,
    count(*) as total_orders,
    sum(revenue) as total_revenue
from fashion
group by category, clothing_type
order by total_orders asc
limit 10;--we assumed that low orders means low stocked.

--Find items that are frequently restocked.
select 
    category,
    clothing_type,
    count(*) as frequent_orders,
    sum(revenue) as total_revenue
from fashion
group by category, clothing_type
order by frequent_orders  desc
limit 10;--we assumed that items that have high orders are restocked frequently.

--Category offering the highest average discount
select 
    category,
    avg(discount):: numeric(4,1) as avg_discount
from fashion
group by category
order by avg_discount desc
limit 5;







    








