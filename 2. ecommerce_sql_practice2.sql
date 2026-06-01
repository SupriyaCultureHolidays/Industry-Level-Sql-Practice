-- =========================================
-- LEVEL 2 — FILTERING & AGGREGATION (Q31–Q70)
-- =========================================
select * from reviews where product_id=601;
-- Q31 Count total orders per order_status, sorted by count descending
select order_status, count(order_status) from orders group by order_status order by order_status desc;
-- Q32 Find the total revenue from all successfully paid orders
select sum(total_amount) as total_revenue from orders where payment_status="paid" group by payment_status;
-- Q33 Calculate the average product rating per product using the reviews table
select product_id, avg(rating) from reviews group by product_id;
select p.title, product_id, avg(rating), COUNT(*) AS review_count from reviews as r join products as p on p.id = r.product_id group by product_id;
-- Q34 Show the number of products listed by each vendor, sorted highest first
select vendor_id, count(vendor_id) as totalProducts from products group by vendor_id order by totalProducts desc;
-- Q35 Find total orders placed per month in 2024

-- Q36 Calculate total sales amount (SUM of total_price) per product

-- Q37 Find the top 5 categories by number of active products
select * from products where status="active" limit 5;

-- Q38 Show the average order value per user (only users with 3+ orders)


-- Q39 Count failed payments per payment_gateway


-- Q40 Find all vendors who have more than 50 products listed


-- Q41 Calculate the total refund amount issued across all payments


-- Q42 Show the number of reviews per rating value (1 through 5)


-- Q43 Find the total shipping cost per courier_partner


-- Q44 List products where the discount % is greater than 30%


-- Q45 Count abandoned carts per user — show only users with 2+ abandoned carts


-- Q46 Calculate total revenue per vendor for delivered orders only


-- Q47 Find the month with the highest number of new user registrations


-- Q48 Show products that have been reviewed more than 10 times


-- Q49 Calculate the payment success rate per payment_method


-- Q50 Find the average delivery time in days for delivered orders


-- Q51 Show number of orders placed per day of the week


-- Q52 Find the top 10 products by total quantity sold


-- Q53 Calculate cart abandonment rate as a percentage


-- Q54 Show total revenue and order count grouped by order_status


-- Q55 Find vendors whose average product price exceeds ₹5,000


-- Q56 Count total products per category including sub-categories


-- Q57 Show number of shipments per shipping_method


-- Q58 Find all orders where discount_amount > 500 and payment_status = 'paid'


-- Q59 Calculate the average vendor rating from reviews (through products)


-- Q60 Show total and average order value per quarter for the past year


-- Q61 Find products per vendor that are currently out of stock


-- Q62 List payment failure reasons with their frequency count


-- Q63 Show the percentage of orders that used a coupon_code


-- Q64 Find users who placed orders but never wrote a review


-- Q65 Calculate total tax collected per month


-- Q66 Show the top 5 vendor cities by total revenue


-- Q67 Find the average number of items per order


-- Q68 Count orders by both order_status and payment_status as a matrix


-- Q69 Show vendors ranked by commission_rate, highest first


-- Q70 Calculate total inventory value (quantity_in_stock × price) per category


