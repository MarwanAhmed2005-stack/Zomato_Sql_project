-- Analysis & Reports 




--Q.1
--write a query to find the top 5 most frequently ordered dishes by customer called 'Ahmed Ali' in the last 1 year.
--
select top 5
o.order_item, count(*) as Total_Orders
from orders o
join customers c
on c.customer_id = o.customer_id
where o.order_date >= DATEADD(year , -1 , GETDATE())
and c.customer_name = 'Ahmed Ali'
group by o.order_item
ORDER BY Total_Orders DESC;

--Q.2 Popular
-- Question:: Identify the time slots during which the most orders are placed.based on 2-hour intervals.
--



--Q.3 Order Value Analysis
--Question:: find the avg order value per customer who has placed more than 10 orders.
--Return customer_name, and aov(avg order value)
select c.customer_name,avg(o.total_amount)as aov
from orders o
join customers c
on c.customer_id = o.customer_id
group by c.customer_name
having count(o.order_id)> 10;


--Q.4 high-value Customers
--Question::List the customers who have spent more than 1000 in total on food orders.
--return customer_name,and customer_id
select c.customer_name,c.customer_id
from customers c
join orders o
on o.customer_id = c.customer_id
group by c.customer_name , c.customer_id
having sum(o.total_amount) > 1000;


--Q.5 Orders without Delivery
--Question:: write a query to find orders that were placed but not delivered.
--Return each restuarant name , city ,number of not delivered orders
SELECT
    r.restaurant_name,
    r.city,
    COUNT(*) AS not_delivered_orders
FROM orders o
LEFT JOIN deliveries d 
    ON d.order_id = o.order_id
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
WHERE d.delivery_id IS NULL
GROUP BY
    r.restaurant_name,
    r.city;


--Q.6
--Restraunt Revenue Ranking:
--Rank Restraunts by their total revenue from the last year  , including their.name
select r.restaurant_name,
sum(o.total_amount) as total_revenue,
RANK() OVER(
order by sum(o.total_amount) desc
)AS rank_name
from restaurants r
join orders o
on r.restaurant_id  = o.restaurant_id
where o.order_date >= DATEADD(year , -1 , GETDATE())
group by r.restaurant_name


------Q.7
------Most Popular Dish by City::
------Identify the most popular dish in each city based on the no.of orders
------order_item , city ,based on no.of orders
select *
from(
    SELECT
        o.order_item,
        r.city,
        COUNT(*) AS total_orders,
        RANK() OVER(
            PARTITION BY r.city
            ORDER BY COUNT(*) DESC
        ) AS Popular_dish
    FROM orders o
    JOIN restaurants r
        ON o.restaurant_id = r.restaurant_id
    GROUP BY r.city, o.order_item)as t1
    where Popular_dish = 1

    --Q.8 Customer Churn:
    --Find customers who havent placed order in 2024 but did in 2023.
    select c.*
    from customers c
     join orders o
     on c.customer_id = o.customer_id
     where EXISTS (
    select order_date 
    from orders
    where year(order_date) = '2023'
    )
     and not EXISTS(
    select order_date 
    from orders
    where year(order_date) = '2024'
     )

     --Q.9 Cancellation Rate Comparison:
     --Calculate and compare the order cancellation rate for each restaurant between the
     --current year and the previous year.

     ---Q.10 Rider Average Delivery Time
     --Determine each riders average delivery time.
     select r.rider_id,
     r.rider_name
     ,avg(DATEDIFF(MINUTE, o.order_time, d.delivery_time))as avg_delivery_time
     from riders r
     join deliveries d
     on r.rider_id = d.rider_id
     join orders o
     on d.order_id = o.order_id
 GROUP BY
    r.rider_id,
    r.rider_name;
    --there is no duration time so iill suppose it always delievered in the same day



    --Q.11 Monthly Restaurant Growth Ratio:
    --Calculate each restaurnats growth ratio based on the total no.of delivered orders since its joining
    select count(d.delivery_id) as total_no_of_delivered_orders ,
        r.restaurant_id, 
                r.restaurant_name
                from deliveries d
                join orders o
                on d.order_id = o.order_id
                join restaurants r
                on r.restaurant_id = o.restaurant_id
                where d.delivery_status = 'Delivered'
            group by r.restaurant_id,
            r.restaurant_name


            --Q.12 Customer Segmentation:
            --Customer Segmentation: segment customers into 'Gold' or 'Silver' groups based on their total spending
            --compared to the avg order value(AOV). if a customers total spending exceeds the AOV,
            --label them as 'Gold'; otherwise,label them as 'Silver'.write an Sql query to determine each segments
            --total number of orders and total revenue
            select segment,
            sum(total_orders),
            sum(total_spend)
            from
           (
            select 
            customer_id,
            sum(total_amount)as total_spend,
            count(order_id) as total_orders,
            CASE WHEN SUM(total_amount)> (SELECT AVG (total_amount) from orders) THEN 'Gold'
            ELSE 'Silver'
            End as segment
            from orders
            group by customer_id
            ) as t1
            group by segment
            

            -- Q.13 Rider Monthly Eearnings:
            --Calculate each riders total monthly earnings, assuming they earn 8% of the order amount.
            select r.rider_id,
            r.rider_name,
            MONTH(o.order_date) as month,
          round  (sum(o.total_amount),2 )* 0.08 AS monthly_earnings
            from riders r
            join deliveries d
            on d.rider_id = r.rider_id
            join orders o
            on o.order_id = d.order_id
            group by r.rider_id ,
            r.rider_name,
            MONTH(o.order_date);

            --Q.14 Rider Ratings Analysis:
            --Find the number of 5-star , 4-star and 3-star ratings each rider has.
            --riders receive this rating based on delivery time
            --if orders are delivered less than 15 minutes of order recevied time the rider get 5 star ratiing,
            -- if they deliver 15 and 20 minute they get 4 star rating 
            --if they deliver after 20 minute they get 3 star rating.
            select r.rider_id,
            r.rider_name,
            COUNT(
            CASE 
            WHEN DATEDIFF(MINUTE,o.order_time,d.delivery_time) <15
            THEN 1
            END
            )AS Five_star,
            COUNT(
            CASE 
            WHEN DATEDIFF(MINUTE, o.order_time, d.delivery_time) BETWEEN 15 AND 20
            THEN 1
            END
            )AS four_star,
            COUNT(
            CASE 
            WHEN DATEDIFF(MINUTE,o.order_time,d.delivery_time) >20
            THEN 1
            END
            )AS Three_star
            from riders r
            join deliveries d
            on d.rider_id = r.rider_id 
            join orders o
            on o.order_id = d.order_id
            group by r.rider_id,
            r.rider_name

            --Q.15 Order Frequency by Day:
            --Analayze order frequency per day of the week and identify the peak day for each restaurant.
            WITH freq_per_day AS(
    SELECT
    r.restaurant_name,
    DATENAME(WEEKDAY, o.order_date) AS day_name,
    COUNT(*) AS total_orders,

    RANK() OVER(
    PARTITION BY r.restaurant_name
    ORDER BY COUNT(*) DESC
    )AS DAY_RANK

FROM orders o
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
GROUP BY
    r.restaurant_name,
    DATENAME(WEEKDAY, o.order_date)
    )
    select 
        restaurant_name,
        day_name,
        total_orders
from freq_per_day
    where DAY_RANK = 1;

    --Q.16 Customer LifeTime value (CLV):
    --Calculate the total revenue generated by each customer over all their orders.
    select  round (sum(o.total_amount) , 2)as total_revenue,
    c.customer_id,c.customer_name
    from orders o
    join customers c
    on o.customer_id = c.customer_id
    group by c.customer_id , c.customer_name

    --Q.17 Monthly orders Trends:
    --Identify orders trends by comparing each months total orders to the previous months.

    WITH MONTHLY_ORDERS AS(
SELECT
YEAR(o.order_date) AS order_year,
MONTH(o.order_date) AS order_month,
COUNT(*) AS total_orders

FROM orders o
GROUP BY YEAR(o.order_date),
MONTH(o.order_date))
SELECT
    order_year,
    order_month, 
    total_orders,
    LAG(total_orders) OVER (
        ORDER BY order_year, order_month
    ) AS previous_month_orders
FROM monthly_orders;

--Q.18 Rider Efficiency:
--Evaluate rider Efficiency by determining avg delivery times and identifying who has  the loswest and highest  avg.
WITH AVG_DEL_TIME AS(
select r.rider_id ,
r.rider_name , 
        AVG(DATEDIFF(MINUTE, o.order_time, d.delivery_time)) AS avg_time
        from deliveries d
join riders r 
on d.rider_id = r.rider_id
join orders o
on d.order_id = o.order_id
group by r.rider_id,
r.rider_name

)
SELECT
    rider_id,
    rider_name,
    avg_time,
    MAX(avg_time) OVER () AS max_time,
    MIN(avg_time) OVER () AS min_time
FROM AVG_DEL_TIME;

--Q.19 Order Item Popularity:
--Track the popularity of specific order item over time and identify seasonal demand spikes.
WITH MonthlyItemORders AS(

select 
       o.order_item,
       YEAR(o.order_date)AS order_year,
       MONTH(o.order_date)AS order_month,
       count(*) as total_orders
    from orders o
       group by
         o.order_item,
        YEAR(o.order_date),
        MONTH(o.order_date)
)
select order_item,
order_year,
order_month,
total_orders,
LAG(total_orders) OVER(
PARTITION BY order_item
ORDER BY order_year,order_month
)AS previous_month_orders
from MonthlyItemORders;

--Q.20 Rank each city based on the total revenue for last year 2023

select sum(o.total_amount) as total_revenue,
r.city,
RANK() OVER(
ORDER BY SUM(o.total_amount) DESC
)AS city_rank
from orders o 
join restaurants r
on o.restaurant_id = r.restaurant_id
WHERE YEAR(o.order_date) = '2023'
group by r.city 
--End of the project



            
          
