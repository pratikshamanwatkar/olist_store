create database sqlproject;

use sqlproject;

select * from olist_customers_dataset;
select * from olist_order_items_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;
select * from olist_order_reviews_dataset;
select * from olist_sellers_dataset;
select * from product_category_name_translation;
select * from olist_geolocation_dataset;
select * from olist_order_payments_dataset;


-- Question 1 - Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT
    CASE WHEN DAYOFWEEK(order_purchase_timestamp) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS DayType,
    -- COUNT(*) AS NumberOfOrders,
    -- SUM(payment_value) AS TotalPayment,
    -- AVG(payment_value) AS AveragePayment,
    round(SUM(payment_value) / (SELECT SUM(payment_value) FROM olist_order_payments_dataset)* 100,2) AS PaymentPercentage
FROM
    olist_orders_dataset od join olist_order_payments_dataset op on
    od.order_id = op.order_id
GROUP BY DayType;

-- Question 2 - Number of Orders with review score 5 and payment type as credit card.

    SELECT review_score AS review_score, count(D1.order_id) AS Number_of_Orders,
payment_type AS payment_type
FROM olist_order_reviews_dataset D1 INNER JOIN olist_order_payments_dataset D2
ON D1.order_id = D2.order_id
WHERE review_score = 5
and payment_type = "credit_card";
    
    
    -- Question 3 - Average number of days taken for order_delivered_customer_date for pet_shop

    select product_category_name, round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) as Noofdays
    from olist_orders_dataset od 
    join (select op.product_id,ord.order_id,op.product_category_name from 
    olist_products_dataset op join olist_order_items_dataset ord 
    on ord.product_id=op.product_id) oorp on od.order_id=oorp.order_id
    WHERE
    product_category_name = 'pet_shop'
    AND order_delivered_customer_date IS NOT NULL;
    
    
-- Question 4 - Average price and payment values from customers of sao paulo city

select customer_city, round(avg(price),2) as "Average Price", round(avg(payment_value),2) as "Average Payment Value" 
from olist_order_payments_dataset opd
inner join olist_order_items_dataset oid
on opd.order_id=oid.order_id
inner join olist_orders_dataset od
on oid.order_id=od.order_id
inner join olist_customers_dataset cd
on od.customer_id=cd.customer_id
where customer_city="sao paulo";


-- Question 5 - Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select oord.review_score,
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) as ShippingAvgDays
from olist_orders_dataset ood join olist_order_reviews_dataset oord
on ood.order_id=oord.order_id
group by oord.review_score order by  oord.review_score;

