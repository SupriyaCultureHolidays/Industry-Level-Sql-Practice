USE ECOMMERCE;
show tables;
-- ===============================
-- LEVEL 1 — BASIC QUERIES (Q1–Q30)
-- ===============================
select * from users;
select * from products;
-- Q1 List all users who registered in the last 30 days

select now();
select * from users where created_at >= now() - interval 30 day;

-- Q2 Find all products with a price greater than ₹10,000
select * from products where price >= 10000;

-- Q3 Retrieve all orders that are in delivered status
select * from orders where order_status = "delivered";

-- Q4 Show all vendors whose status is active
select * from users where status = "active";


-- Q5 List all product categories along with their parent category name
select * from products;
select * from categories;
select c.name, p.category_id from categories as c left join products as p on c.parent_id = p.category_id;


-- Q6 Find all customers (role = customer) who have verified their email
select u.* from users u join roles r on u.role_id = r.id where r.name = "customer" and u.is_email_verified = 1;

-- Q7 Retrieve all products that belong to the Electronics category
select p.* from products p join categories c on p.category_id = c.id where c.name='Electronics';

-- Q8 Show all orders placed by user_id = 300
select * from orders where user_id = 300;

-- Q9 List all cart items for cart_id = 501
select * from cart_items where cart_id=501;

-- Q10 Find all reviews with a rating of 5
select * from reviews where rating=5;

-- Q11 Retrieve all payments that failed
select * from payments where status="failed";

-- Q12 List all shipments handled by courier_partner = 'Delhivery'
select * from shipments where courier_partner = 'Delhivery';

-- Q13 Find all products whose sale_price is NOT NULL (currently on sale)
select * from products where sale_price is not null;

-- Q14 Show all users who have been banned
select * from users where status="banned";

-- Q15 List all orders that used a coupon_code
select * from orders where coupon_code is not null;

-- Q16 Retrieve the 10 most recently created products
select * from products order by created_at limit 10;

-- Q17 Find all vendors located in Bangalore
select * from vendors where city = "Bangalore";

-- Q18 Show all order_items for order_id = 200
select * from order_items where order_id = 200;

-- Q19 List all products in the Smartphones sub-category
select * from products p join categories c on c.id = p.category_id where c.name = 'Smartphones';

-- Q20 Retrieve all shipments currently in in_transit status
select * from shipments where status="in_transit";

-- Q21 Show all reviews that are pending moderation
select * from reviews where status = "pending";

-- Q22 Find all products marked as featured (is_featured = 1)


-- Q23 List all orders where payment_status = 'paid'


-- Q24 Retrieve all carts marked as abandoned


-- Q25 Show the total number of products in the database


-- Q26 Find all users whose phone number is NULL


-- Q27 List all products with quantity_in_stock = 0


-- Q28 Show all orders created in the year 2024


-- Q29 Retrieve all payments made via UPI


-- Q30 List all products belonging to vendors with vendor_id between 10 and 20




