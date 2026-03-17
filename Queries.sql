

--Q1. Total revenue genrated each month

CREATE VIEW monthly_revenue AS
select
    DATE_TRUNC('month',o.order_purchase_timestamp::timestamp) as month,
	ROUND(sum(p.payment_value)::numeric,2) as revenue
from orders o
join order_payments p on o.order_id=p.order_id
where order_status='delivered'
group by month


--Q2. Yearly revenue growth from 2016-2018

CREATE VIEW yearly_revenue AS
WITH yearly_revneue as(
select
	DATE_TRUNC('year',o.order_purchase_timestamp::timestamp) as years,
	ROUND(sum(p.payment_value)::numeric,2) as revenue
from orders o
join order_payments p on o.order_id=p.order_id
where order_status='delivered'
group by years
)
select
	years,
	revenue,
	ROUND(
	((revenue-lag(revenue) over(order by years))
	/lag(revenue) over (order by years))*100,2) as revenue_growth
from yearly_revneue
order by years

CREATE OR REPLACE VIEW yearly_revenue AS
WITH yearly_revenue AS (
    SELECT
        DATE_TRUNC('year', o.order_purchase_timestamp::timestamp) AS years,
        ROUND(SUM(p.payment_value)::numeric, 2) AS revenue
    FROM orders o
    JOIN order_payments p 
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY years
)
SELECT
    years,
    revenue,
    COALESCE(
        ROUND(
            ((revenue - LAG(revenue) OVER (ORDER BY years))
            / LAG(revenue) OVER (ORDER BY years)) * 100,
        2),
    0) AS revenue_growth
FROM yearly_revenue
ORDER BY years;



--Q3. which month generates the hightest revenue

select
    DATE_TRUNC('month',o.order_purchase_timestamp::timestamp) as month,
	ROUND(sum(p.payment_value)::numeric,2) as revenue
from orders o
join order_payments p on o.order_id=p.order_id
where order_status='delivered'
group by month
order by revenue desc
limit 1

--Q4 Which top 10 product categories generate the highest revenue?

CREATE VIEW category_revenue AS
select 
	pc.product_category_name,
	ROUND(sum(i.price+i.freight_value)::numeric,2) as value
from order_items i
join products pc on 
	i.product_id=pc.product_id
join orders o on
	i.order_id=o.order_id
where order_status='delivered'
group by pc.product_category_name
order by value desc
limit 10

--Q5. Which categories have the lowest average review score?

select
	product_category_name,
	ROUND(avg(review_score)::numeric,2) as review
From(
select DISTINCT
	o.order_id,
	pc.product_category_name,
	r.review_score
from orders o
join order_reviews r on o.order_id=r.order_id
join order_items i on o.order_id=i.order_id	
join products pc on i.product_id=pc.product_id	
) t
group by product_category_name
order by review
limit 10

--Q6. Which categories have the highest cancellation rate?

select
	pc.product_category_name, round(count(distinct o.order_id) filter (where o.order_status='canceled')::numeric/count(distinct o.order_id)*100,2) as cancelation_rate
from orders o
join order_items i on o.order_id=i.order_id
join products pc on i.product_id=pc.product_id
where product_category_name IS NOT NULL 
group by pc.product_category_name
having count(DISTINCT o.order_id) filter(where o.order_status='canceled')>0
order by cancelation_rate desc 


--Q7.How many unique customers purchase each month

CREATE VIEW monthly_unique_customers AS
select
	DATE_TRUNC('month',order_purchase_timestamp::timestamp) as Month,
	count(distinct customer_id) as unique_customer
from orders
where order_status='delivered'
group by Month
order by Month

--Q8. What is the repeat purchase rate

CREATE VIEW repeat_purchase_rate_view AS
SELECT
    COUNT(*) FILTER (WHERE order_count > 1)::numeric
    /
    COUNT(*)::numeric * 100 AS repeat_purchase_rate
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM orders o
    JOIN customers c 
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_orders;
	


--Q9.Which states generate the highest revenue?

CREATE VIEW state_revenue AS
select 
	c.customer_state,
	round(sum(payment_value)::numeric,2) as total_revenue
from orders o
join customers c on o.customer_id=c.customer_id
join order_payments p on o.order_id=p.order_id
where order_status='delivered'
group by customer_state
order by total_revenue desc

--Q10.Which sellers generate highest revenue

SELECT
    i.seller_id,
	round(sum(i.price+i.freight_value)::numeric,2) as revenue
FROM order_items i
JOIN orders o
    ON i.order_id = o.order_id
where order_status='delivered'
GROUP BY i.seller_id
ORDER BY revenue desc

--Q11.Which sellers have lowest review scores

SELECT
    i.seller_id,
	ROUND(AVG(r.review_score)::numeric, 2) AS review_score
FROM order_items i
JOIN order_reviews r
ON i.order_id = r.order_id
GROUP BY i.seller_id
ORDER BY review_score  


--Q12.What % of orders were delivered after estimated delivery date?

CREATE VIEW delivery_delay_percentage AS
select
	count(order_id) filter(where order_delivered_customer_date>order_estimated_delivery_date)::numeric
	/count(order_id)::numeric*100 as percentage_delay
from orders
where order_status='delivered'


--13.Which states have the longest delivery time?

CREATE VIEW state_delivery_time_ AS
select 
	c.customer_state as state,
	avg(o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp) as delivery_time
from customers c
join orders o on c.customer_id=o.customer_id
where order_status='delivered'
group by state
order by delivery_time desc


--Q14. Do delayed orders have lower review scores?

SELECT
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,
    ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score
FROM orders o
JOIN order_reviews r 
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;


