USE ECOMMERCE;

-- ============================================================
-- LEVEL 1 — BASIC QUERIES (Q1 – Q30)
-- ============================================================

-- Q1: List all users who registered in the last 30 days.
SELECT *
FROM users
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Q2: Find all products with a price greater than ₹10,000.
SELECT *
FROM products
WHERE price > 10000;

-- Q3: Retrieve all orders currently in 'delivered' status.
SELECT *
FROM orders
WHERE order_status = 'delivered';

-- Q4: Show all vendors whose status is 'active'.
SELECT *
FROM vendors
WHERE status = 'active';

-- Q5: List all product categories along with their parent category name.
SELECT
    c.id,
    c.name        AS category_name,
    p.name        AS parent_category_name
FROM categories c
LEFT JOIN categories p ON c.parent_id = p.id;

-- Q6: Find all customers (role = 'customer') who have verified their email.
SELECT u.*
FROM users u
JOIN roles r ON u.role_id = r.id
WHERE r.name = 'customer'
  AND u.is_email_verified = 1;

-- Q7: Retrieve all products that belong to the 'Electronics' category.
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- Q8: Show all orders placed by a specific user (user_id = 300).
SELECT *
FROM orders
WHERE user_id = 300;

-- Q9: List all cart items for a specific cart (cart_id = 50).
SELECT *
FROM cart_items
WHERE cart_id = 50;

-- Q10: Find all reviews with a 5-star rating.
SELECT *
FROM reviews
WHERE rating = 5;

-- Q11: Retrieve all payments that failed.
SELECT *
FROM payments
WHERE status = 'failed';

-- Q12: List all shipments handled by courier_partner = 'Delhivery'.
SELECT *
FROM shipments
WHERE courier_partner = 'Delhivery';

-- Q13: Find all products whose sale_price is NOT NULL (currently on discount).
SELECT *
FROM products
WHERE sale_price IS NOT NULL;

-- Q14: Show all users who have been banned.
SELECT *
FROM users
WHERE status = 'banned';

-- Q15: List all orders that used a coupon_code.
SELECT *
FROM orders
WHERE coupon_code IS NOT NULL;

-- Q16: Retrieve the 10 most recently created products.
SELECT *
FROM products
ORDER BY created_at DESC
LIMIT 10;

-- Q17: Find all vendors located in the city 'Bangalore'.
SELECT *
FROM vendors
WHERE city = 'Bangalore';

-- Q18: Show all order_items for a specific order (order_id = 200).
SELECT *
FROM order_items
WHERE order_id = 200;

-- Q19: List all products in the 'Smartphones' sub-category.
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Smartphones';

-- Q20: Retrieve all shipments currently in 'in_transit' status.
SELECT *
FROM shipments
WHERE status = 'in_transit';

-- Q21: Show all reviews that are pending moderation (status = 'pending').
SELECT *
FROM reviews
WHERE status = 'pending';

-- Q22: Find all products marked as featured (is_featured = 1).
SELECT *
FROM products
WHERE is_featured = 1;

-- Q23: List all orders where payment_status = 'paid'.
SELECT *
FROM orders
WHERE payment_status = 'paid';

-- Q24: Retrieve all carts marked as 'abandoned'.
SELECT *
FROM carts
WHERE status = 'abandoned';

-- Q25: Show the total count of products in the database.
SELECT COUNT(*) AS total_products
FROM products;

-- Q26: Find all users whose phone number is NULL.
SELECT *
FROM users
WHERE phone IS NULL;

-- Q27: List all products with quantity_in_stock = 0 in the inventory table.
SELECT p.*
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
WHERE pi.quantity_in_stock = 0;

-- Q28: Show all orders created in the year 2024.
SELECT *
FROM orders
WHERE YEAR(created_at) = 2024;

-- Q29: Retrieve all payments made via the 'upi' payment method.
SELECT *
FROM payments
WHERE payment_method = 'upi';

-- Q30: List all products belonging to vendors with vendor_id between 10 and 20.
SELECT *
FROM products
WHERE vendor_id BETWEEN 10 AND 20;


-- ============================================================
-- LEVEL 2 — FILTERING & AGGREGATION (Q31 – Q70)
-- ============================================================

-- Q31: Count total orders per order_status, sorted by count descending.
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Q32: Calculate total revenue from all orders with payment_status = 'paid'.
SELECT
    SUM(total_amount) AS total_revenue
FROM orders
WHERE payment_status = 'paid';

-- Q33: Find the average product rating per product (using the reviews table).
SELECT
    product_id,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*)              AS review_count
FROM reviews
GROUP BY product_id
ORDER BY avg_rating DESC;

-- Q34: Show the number of products listed by each vendor, sorted highest first.
SELECT
    vendor_id,
    COUNT(*) AS product_count
FROM products
GROUP BY vendor_id
ORDER BY product_count DESC;

-- Q35: Find total orders placed per month in 2024.
SELECT
    MONTH(created_at)                    AS month_number,
    DATE_FORMAT(created_at, '%b %Y')     AS month_label,
    COUNT(*)                             AS total_orders
FROM orders
WHERE YEAR(created_at) = 2024
GROUP BY MONTH(created_at), DATE_FORMAT(created_at, '%b %Y')
ORDER BY month_number;

-- Q36: Calculate total sales amount (SUM of total_price) per product from order_items.
SELECT
    product_id,
    SUM(total_price) AS total_sales_amount
FROM order_items
GROUP BY product_id
ORDER BY total_sales_amount DESC;

-- Q37: Find the top 5 categories by number of active products.
SELECT
    c.id,
    c.name            AS category_name,
    COUNT(p.id)       AS active_product_count
FROM categories c
JOIN products p ON c.id = p.category_id
WHERE p.status = 'active'
GROUP BY c.id, c.name
ORDER BY active_product_count DESC
LIMIT 5;

-- Q38: Show average order value per user — only users with 3 or more orders.
SELECT
    user_id,
    COUNT(*)                     AS order_count,
    ROUND(AVG(total_amount), 2)  AS avg_order_value
FROM orders
GROUP BY user_id
HAVING order_count >= 3
ORDER BY avg_order_value DESC;

-- Q39: Count failed payments per payment_gateway.
SELECT
    payment_gateway,
    COUNT(*) AS failed_count
FROM payments
WHERE status = 'failed'
GROUP BY payment_gateway
ORDER BY failed_count DESC;

-- Q40: Find all vendors who have listed more than 50 products.
SELECT
    vendor_id,
    COUNT(*) AS product_count
FROM products
GROUP BY vendor_id
HAVING product_count > 50
ORDER BY product_count DESC;

-- Q41: Calculate the total refund_amount issued across all payments.
SELECT
    SUM(refund_amount) AS total_refund_amount
FROM payments;

-- Q42: Show the number of reviews per rating value (1 through 5).
SELECT
    rating,
    COUNT(*) AS review_count
FROM reviews
GROUP BY rating
ORDER BY rating;

-- Q43: Find the total shipping_cost per courier_partner.
SELECT
    courier_partner,
    SUM(shipping_cost) AS total_shipping_cost
FROM shipments
GROUP BY courier_partner
ORDER BY total_shipping_cost DESC;

-- Q44: List products where discount percentage exceeds 30%.
SELECT
    id,
    title,
    price,
    sale_price,
    ROUND((price - sale_price) / price * 100, 2) AS discount_pct
FROM products
WHERE sale_price IS NOT NULL
  AND (price - sale_price) / price * 100 > 30
ORDER BY discount_pct DESC;

-- Q45: Count abandoned carts per user — show only users with 2 or more abandoned carts.
SELECT
    user_id,
    COUNT(*) AS abandoned_count
FROM carts
WHERE status = 'abandoned'
GROUP BY user_id
HAVING abandoned_count >= 2
ORDER BY abandoned_count DESC;

-- Q46: Calculate total revenue per vendor for delivered orders only.
SELECT
    oi.vendor_id,
    SUM(oi.total_price) AS total_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
WHERE o.order_status = 'delivered'
GROUP BY oi.vendor_id
ORDER BY total_revenue DESC;

-- Q47: Find the month with the highest number of new user registrations.
SELECT
    DATE_FORMAT(created_at, '%b %Y') AS month_label,
    COUNT(*)                          AS registrations
FROM users
GROUP BY DATE_FORMAT(created_at, '%b %Y'), YEAR(created_at), MONTH(created_at)
ORDER BY registrations DESC
LIMIT 1;

-- Q48: Show products that have been reviewed more than 10 times.
SELECT
    product_id,
    COUNT(*) AS review_count
FROM reviews
GROUP BY product_id
HAVING review_count > 10
ORDER BY review_count DESC;

-- Q49: Calculate the payment success rate (success / total) per payment_method.
SELECT
    payment_method,
    COUNT(*)                                                          AS total_payments,
    SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END)             AS successful,
    ROUND(
        SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2)                                          AS success_rate_pct
FROM payments
GROUP BY payment_method
ORDER BY success_rate_pct DESC;

-- Q50: Find the average delivery time in days for all delivered orders.
SELECT
    ROUND(AVG(DATEDIFF(delivered_at, created_at)), 2) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND delivered_at IS NOT NULL;

-- Q51: Show the number of orders placed per day of the week (Mon–Sun).
SELECT
    DAYOFWEEK(created_at)                   AS day_number,
    DAYNAME(created_at)                     AS day_name,
    COUNT(*)                                AS order_count
FROM orders
GROUP BY DAYOFWEEK(created_at), DAYNAME(created_at)
ORDER BY day_number;

-- Q52: Find the top 10 products by total quantity sold.
SELECT
    product_id,
    SUM(quantity) AS total_qty_sold
FROM order_items
GROUP BY product_id
ORDER BY total_qty_sold DESC
LIMIT 10;

-- Q53: Calculate cart abandonment rate: abandoned carts ÷ total carts × 100.
SELECT
    COUNT(*)                                                         AS total_carts,
    SUM(CASE WHEN status = 'abandoned' THEN 1 ELSE 0 END)          AS abandoned_carts,
    ROUND(
        SUM(CASE WHEN status = 'abandoned' THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2)                                         AS abandonment_rate_pct
FROM carts;

-- Q54: Show total revenue and order count grouped by order_status.
SELECT
    order_status,
    COUNT(*)              AS order_count,
    SUM(total_amount)     AS total_revenue
FROM orders
GROUP BY order_status
ORDER BY total_revenue DESC;

-- Q55: Find vendors whose average product price exceeds ₹5,000.
SELECT
    vendor_id,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY vendor_id
HAVING avg_price > 5000
ORDER BY avg_price DESC;

-- Q56: Count total products per category including sub-categories.
SELECT
    c.id,
    c.name             AS category_name,
    COUNT(p.id)        AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC;

-- Q57: Show number of shipments per shipping_method.
SELECT
    shipping_method,
    COUNT(*) AS shipment_count
FROM shipments
GROUP BY shipping_method
ORDER BY shipment_count DESC;

-- Q58: Find all orders where discount_amount > 500 and payment_status = 'paid'.
SELECT *
FROM orders
WHERE discount_amount > 500
  AND payment_status = 'paid';

-- Q59: Calculate the average vendor rating from reviews (joined through products).
SELECT
    p.vendor_id,
    ROUND(AVG(r.rating), 2) AS avg_vendor_rating,
    COUNT(r.id)             AS total_reviews
FROM reviews r
JOIN products p ON r.product_id = p.id
GROUP BY p.vendor_id
ORDER BY avg_vendor_rating DESC;

-- Q60: Show total and average order value per quarter for the past year.
SELECT
    QUARTER(created_at)                   AS quarter,
    COUNT(*)                              AS order_count,
    SUM(total_amount)                     AS total_revenue,
    ROUND(AVG(total_amount), 2)           AS avg_order_value
FROM orders
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
GROUP BY QUARTER(created_at)
ORDER BY quarter;

-- Q61: Find products per vendor that are currently out of stock (quantity_in_stock = 0).
SELECT
    p.vendor_id,
    COUNT(*) AS out_of_stock_count
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
WHERE pi.quantity_in_stock = 0
GROUP BY p.vendor_id
ORDER BY out_of_stock_count DESC;

-- Q62: List payment failure reasons with their frequency count.
SELECT
    failure_reason,
    COUNT(*) AS frequency
FROM payments
WHERE status = 'failed'
  AND failure_reason IS NOT NULL
GROUP BY failure_reason
ORDER BY frequency DESC;

-- Q63: Show the percentage of orders that used a coupon_code.
SELECT
    COUNT(*)                                                         AS total_orders,
    SUM(CASE WHEN coupon_code IS NOT NULL THEN 1 ELSE 0 END)       AS coupon_orders,
    ROUND(
        SUM(CASE WHEN coupon_code IS NOT NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2)                                         AS coupon_usage_pct
FROM orders;

-- Q64: Find users who have placed orders but never written a review.
SELECT DISTINCT o.user_id
FROM orders o
LEFT JOIN reviews r ON o.user_id = r.user_id
WHERE r.user_id IS NULL;

-- Q65: Calculate total tax collected per month.
SELECT
    DATE_FORMAT(created_at, '%b %Y') AS month_label,
    SUM(tax_amount)                   AS total_tax
FROM orders
GROUP BY DATE_FORMAT(created_at, '%b %Y'), YEAR(created_at), MONTH(created_at)
ORDER BY YEAR(created_at), MONTH(created_at);

-- Q66: Show the top 5 vendor cities by total revenue.
SELECT
    v.city,
    SUM(oi.total_price) AS total_revenue
FROM order_items oi
JOIN vendors v ON oi.vendor_id = v.id
GROUP BY v.city
ORDER BY total_revenue DESC
LIMIT 5;

-- Q67: Find the average number of items per order.
SELECT
    ROUND(AVG(item_count), 2) AS avg_items_per_order
FROM (
    SELECT order_id, COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
) AS order_item_counts;

-- Q68: Count orders by both order_status and payment_status as a cross-tab matrix.
SELECT
    order_status,
    SUM(CASE WHEN payment_status = 'pending'              THEN 1 ELSE 0 END) AS pay_pending,
    SUM(CASE WHEN payment_status = 'paid'                 THEN 1 ELSE 0 END) AS pay_paid,
    SUM(CASE WHEN payment_status = 'failed'               THEN 1 ELSE 0 END) AS pay_failed,
    SUM(CASE WHEN payment_status = 'refunded'             THEN 1 ELSE 0 END) AS pay_refunded,
    SUM(CASE WHEN payment_status = 'partially_refunded'   THEN 1 ELSE 0 END) AS pay_partial_refunded,
    COUNT(*)                                                                   AS row_total
FROM orders
GROUP BY order_status
ORDER BY order_status;

-- Q69: Show vendors ranked by commission_rate, highest first.
SELECT
    id,
    store_name,
    commission_rate
FROM vendors
ORDER BY commission_rate DESC;

-- Q70: Calculate total inventory value (quantity_in_stock × price) per category.
SELECT
    c.id,
    c.name                                     AS category_name,
    SUM(pi.quantity_in_stock * p.price)        AS total_inventory_value
FROM categories c
JOIN products p   ON c.id = p.id
JOIN product_inventory pi ON p.id = pi.product_id
GROUP BY c.id, c.name
ORDER BY total_inventory_value DESC;


-- ============================================================
-- LEVEL 3 — JOINS (Q71 – Q110)
-- ============================================================

-- Q71: Join users, vendors, and products — show vendor name, store name, and product count.
SELECT
    u.name          AS vendor_user_name,
    v.store_name,
    COUNT(p.id)     AS product_count
FROM vendors v
JOIN users u    ON v.user_id   = u.id
JOIN products p ON v.id        = p.vendor_id
GROUP BY v.id, u.name, v.store_name
ORDER BY product_count DESC;

-- Q72: Get all orders with customer name, email, order_number, and total_amount.
SELECT
    u.name          AS customer_name,
    u.email,
    o.order_number,
    o.total_amount
FROM orders o
JOIN users u ON o.user_id = u.id
ORDER BY o.created_at DESC;

-- Q73: List all order_items with product title, vendor store name, quantity, and unit_price.
SELECT
    p.title         AS product_title,
    v.store_name    AS vendor_store_name,
    oi.quantity,
    oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN vendors  v ON oi.vendor_id  = v.id;

-- Q74: Show all reviews with reviewer name, product title, rating, and review body.
SELECT
    u.name          AS reviewer_name,
    p.title         AS product_title,
    r.rating,
    r.body          AS review_body
FROM reviews r
JOIN users    u ON r.user_id    = u.id
JOIN products p ON r.product_id = p.id;

-- Q75: Join orders, payments, and users — show order with payment method and status.
SELECT
    u.name              AS customer_name,
    o.order_number,
    o.total_amount,
    py.payment_method,
    py.status           AS payment_status
FROM orders o
JOIN users    u  ON o.user_id  = u.id
JOIN payments py ON py.order_id = o.id;

-- Q76: Retrieve all shipments with order_number, customer name, courier, and current status.
SELECT
    o.order_number,
    u.name              AS customer_name,
    s.courier_partner,
    s.status            AS shipment_status
FROM shipments s
JOIN orders o ON s.order_id  = o.id
JOIN users  u ON o.user_id   = u.id;

-- Q77: Show abandoned carts with customer name, total_amount, and product titles in the cart.
SELECT
    u.name              AS customer_name,
    c.total_amount,
    GROUP_CONCAT(p.title SEPARATOR ' | ') AS products_in_cart
FROM carts c
JOIN users      u  ON c.user_id    = u.id
JOIN cart_items ci ON ci.cart_id   = c.id
JOIN products   p  ON ci.product_id = p.id
WHERE c.status = 'abandoned'
GROUP BY c.id, u.name, c.total_amount;

-- Q78: List products with category name, sub-category name, vendor name, and current stock level.
SELECT
    p.title                 AS product_title,
    parent.name             AS category_name,
    cat.name                AS sub_category_name,
    v.store_name            AS vendor_name,
    pi.quantity_in_stock
FROM products p
JOIN categories     cat    ON p.category_id   = cat.id
LEFT JOIN categories parent ON cat.parent_id  = parent.id
JOIN vendors         v     ON p.vendor_id     = v.id
JOIN product_inventory pi  ON p.id            = pi.product_id;

-- Q79: Join order_items and products to find revenue per product with vendor info.
SELECT
    p.id            AS product_id,
    p.title         AS product_title,
    v.store_name    AS vendor_name,
    SUM(oi.total_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN vendors  v ON p.vendor_id   = v.id
GROUP BY p.id, p.title, v.store_name
ORDER BY total_revenue DESC;

-- Q80: Show each vendor's total orders, total revenue, and average order value.
SELECT
    v.id            AS vendor_id,
    v.store_name,
    COUNT(DISTINCT oi.order_id)      AS total_orders,
    SUM(oi.total_price)              AS total_revenue,
    ROUND(SUM(oi.total_price) / COUNT(DISTINCT oi.order_id), 2) AS avg_order_value
FROM vendors v
JOIN order_items oi ON v.id = oi.vendor_id
GROUP BY v.id, v.store_name
ORDER BY total_revenue DESC;

-- Q81: Get all users who have never placed an order (LEFT JOIN with NULL check).
SELECT
    u.id,
    u.name,
    u.email
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;

-- Q82: List all products that are in active carts but have never been ordered.
SELECT DISTINCT
    p.id,
    p.title
FROM cart_items ci
JOIN carts   c  ON ci.cart_id    = c.id
JOIN products p ON ci.product_id = p.id
LEFT JOIN order_items oi ON p.id = oi.product_id
WHERE c.status  = 'active'
  AND oi.id IS NULL;

-- Q83: Show all orders with their shipment tracking number and estimated delivery date.
SELECT
    o.order_number,
    s.tracking_number,
    s.estimated_delivery_date
FROM orders o
JOIN shipments s ON o.id = s.order_id;

-- Q84: Find customers who placed orders but have not yet received them.
SELECT DISTINCT
    u.id,
    u.name,
    u.email,
    o.order_number,
    o.order_status
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.order_status NOT IN ('delivered','cancelled','refunded');

-- Q85: Join products and product_inventory to list items below reorder_level.
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock,
    pi.reorder_level
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
WHERE pi.quantity_in_stock <= pi.reorder_level
ORDER BY pi.quantity_in_stock;

-- Q86: Show all reviews that have vendor replies, including product and vendor name.
SELECT
    r.id            AS review_id,
    p.title         AS product_title,
    v.store_name    AS vendor_name,
    r.rating,
    r.body,
    r.reply
FROM reviews r
JOIN products p ON r.product_id = p.id
JOIN vendors  v ON p.vendor_id  = v.id
WHERE r.reply IS NOT NULL;

-- Q87: List all orders that contain products from more than one vendor.
SELECT
    oi.order_id,
    COUNT(DISTINCT oi.vendor_id) AS vendor_count
FROM order_items oi
GROUP BY oi.order_id
HAVING vendor_count > 1
ORDER BY vendor_count DESC;

-- Q88: Find products where the vendor is suspended but the product is still active.
SELECT
    p.id,
    p.title,
    v.store_name,
    v.status AS vendor_status
FROM products p
JOIN vendors v ON p.vendor_id = v.id
WHERE v.status  = 'suspended'
  AND p.status  = 'active';

-- Q89: Show product title, vendor name, category, and total revenue for featured products only.
SELECT
    p.title             AS product_title,
    v.store_name        AS vendor_name,
    c.name              AS category_name,
    SUM(oi.total_price) AS total_revenue
FROM products p
JOIN vendors     v  ON p.vendor_id   = v.id
JOIN categories  c  ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id     = oi.product_id
WHERE p.is_featured = 1
GROUP BY p.id, p.title, v.store_name, c.name
ORDER BY total_revenue DESC;

-- Q90: Get the full order lifecycle in one query: order → payment → shipment.
SELECT
    o.order_number,
    o.order_status,
    py.payment_method,
    py.status        AS payment_status,
    s.courier_partner,
    s.status         AS shipment_status,
    s.tracking_number
FROM orders o
LEFT JOIN payments  py ON o.id = py.order_id
LEFT JOIN shipments s  ON o.id = s.order_id;

-- Q91: Show each category with count of active products and average price.
SELECT
    c.id,
    c.name              AS category_name,
    COUNT(p.id)         AS active_product_count,
    ROUND(AVG(p.price), 2) AS avg_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id AND p.status = 'active'
GROUP BY c.id, c.name
ORDER BY active_product_count DESC;

-- Q92: List users who have purchased from at least 3 different product categories.
SELECT
    o.user_id,
    COUNT(DISTINCT p.category_id) AS category_count
FROM orders o
JOIN order_items oi ON o.id  = oi.order_id
JOIN products    p  ON oi.product_id = p.id
GROUP BY o.user_id
HAVING category_count >= 3
ORDER BY category_count DESC;

-- Q93: Show the vendor with the highest-rated products (avg rating + product count).
SELECT
    v.id,
    v.store_name,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(DISTINCT p.id)    AS product_count
FROM vendors v
JOIN products p ON v.id = p.vendor_id
JOIN reviews  r ON p.id = r.product_id
GROUP BY v.id, v.store_name
ORDER BY avg_rating DESC, product_count DESC
LIMIT 10;

-- Q94: Join carts and cart_items to find total active cart value per user.
SELECT
    c.user_id,
    SUM(ci.unit_price * ci.quantity) AS total_cart_value
FROM carts c
JOIN cart_items ci ON c.id = ci.cart_id
WHERE c.status = 'active'
GROUP BY c.user_id
ORDER BY total_cart_value DESC;

-- Q95: Show multi-item orders with item breakdown, vendor names, and per-item totals.
SELECT
    o.order_number,
    p.title         AS product_title,
    v.store_name    AS vendor_name,
    oi.quantity,
    oi.unit_price,
    oi.total_price
FROM orders o
JOIN order_items oi ON o.id         = oi.order_id
JOIN products    p  ON oi.product_id = p.id
JOIN vendors     v  ON oi.vendor_id  = v.id
WHERE o.id IN (
    SELECT order_id
    FROM order_items
    GROUP BY order_id
    HAVING COUNT(*) > 1
)
ORDER BY o.order_number, oi.id;

-- Q96: Verify that all reviews belong to actually purchased products (reviews → order_items).
SELECT
    r.id            AS review_id,
    r.user_id,
    r.product_id,
    r.order_id
FROM reviews r
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.order_id   = r.order_id
      AND oi.product_id = r.product_id
);

-- Q97: Show order totals alongside payment amounts to detect discrepancies.
SELECT
    o.order_number,
    o.total_amount      AS order_total,
    py.amount           AS payment_amount,
    CASE
        WHEN py.amount IS NULL        THEN 'No payment found'
        WHEN o.total_amount = py.amount THEN 'Match'
        ELSE 'Mismatch'
    END AS reconciliation_status
FROM orders o
LEFT JOIN payments py ON o.id = py.order_id
ORDER BY reconciliation_status DESC;

-- Q98: List all vendors with their approved_at date and orders received since then.
SELECT
    v.id,
    v.store_name,
    v.approved_at,
    COUNT(DISTINCT oi.order_id) AS orders_since_approval
FROM vendors v
LEFT JOIN order_items oi ON v.id = oi.vendor_id
LEFT JOIN orders      o  ON oi.order_id = o.id
    AND o.created_at >= v.approved_at
GROUP BY v.id, v.store_name, v.approved_at
ORDER BY orders_since_approval DESC;

-- Q99: Get users with role name, total orders, total spent, and account status.
SELECT
    u.id,
    u.name,
    r.name              AS role_name,
    u.status            AS account_status,
    COUNT(o.id)         AS total_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM users u
JOIN roles r         ON u.role_id = r.id
LEFT JOIN orders o   ON u.id      = o.user_id
GROUP BY u.id, u.name, r.name, u.status
ORDER BY total_spent DESC;

-- Q100: Find categories that have no products currently listed.
SELECT
    c.id,
    c.name
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
WHERE p.id IS NULL;

-- Q101: Show all products with inventory status: in-stock / low-stock / out-of-stock.
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock,
    pi.reorder_level,
    CASE
        WHEN pi.quantity_in_stock = 0                         THEN 'out-of-stock'
        WHEN pi.quantity_in_stock <= pi.reorder_level         THEN 'low-stock'
        ELSE                                                        'in-stock'
    END AS inventory_status
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
ORDER BY inventory_status, p.title;

-- Q102: List shipments that were delivered earlier than estimated_delivery_date.
SELECT
    s.id,
    s.tracking_number,
    s.estimated_delivery_date,
    s.actual_delivery_date,
    DATEDIFF(s.estimated_delivery_date, s.actual_delivery_date) AS days_early
FROM shipments s
WHERE s.actual_delivery_date IS NOT NULL
  AND s.actual_delivery_date < s.estimated_delivery_date;

-- Q103: Show customers who ordered, reviewed, and also have an active cart.
SELECT DISTINCT u.id, u.name, u.email
FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.id
)
AND EXISTS (
    SELECT 1 FROM reviews r WHERE r.user_id = u.id
)
AND EXISTS (
    SELECT 1 FROM carts c WHERE c.user_id = u.id AND c.status = 'active'
);

-- Q104: Find orders that are paid but not yet shipped.
SELECT
    o.id,
    o.order_number,
    o.order_status,
    o.payment_status
FROM orders o
LEFT JOIN shipments s ON o.id = s.order_id
WHERE o.payment_status = 'paid'
  AND (s.id IS NULL OR s.status = 'pending')
  AND o.order_status NOT IN ('cancelled','refunded');

-- Q105: Retrieve all vendors and the date of their most recent sale.
SELECT
    v.id,
    v.store_name,
    MAX(o.created_at) AS last_sale_date
FROM vendors v
LEFT JOIN order_items oi ON v.id = oi.vendor_id
LEFT JOIN orders      o  ON oi.order_id = o.id
GROUP BY v.id, v.store_name
ORDER BY last_sale_date DESC;

-- Q106: Show order_items with return_status NOT NULL, with customer name and reason.
SELECT
    u.name              AS customer_name,
    o.order_number,
    p.title             AS product_title,
    oi.return_status,
    oi.return_reason
FROM order_items oi
JOIN orders   o  ON oi.order_id   = o.id
JOIN users    u  ON o.user_id     = u.id
JOIN products p  ON oi.product_id = p.id
WHERE oi.return_status IS NOT NULL;

-- Q107: Find the most popular product in each category by total units sold.
SELECT
    c.name              AS category_name,
    p.title             AS product_title,
    SUM(oi.quantity)    AS total_units_sold
FROM order_items oi
JOIN products    p ON oi.product_id = p.id
JOIN categories  c ON p.category_id = c.id
WHERE (p.category_id, SUM(oi.quantity)) IN (
    SELECT p2.category_id, MAX(sub.total_qty)
    FROM (
        SELECT product_id, SUM(quantity) AS total_qty
        FROM order_items
        GROUP BY product_id
    ) sub
    JOIN products p2 ON sub.product_id = p2.id
    GROUP BY p2.category_id
)
GROUP BY c.name, p.id, p.title
ORDER BY total_units_sold DESC;

-- Q108: List all payments with refund_amount > 0, with order and user details.
SELECT
    u.name          AS customer_name,
    o.order_number,
    py.transaction_id,
    py.amount,
    py.refund_amount,
    py.refunded_at
FROM payments py
JOIN orders o ON py.order_id = o.id
JOIN users  u ON py.user_id  = u.id
WHERE py.refund_amount > 0
ORDER BY py.refund_amount DESC;

-- Q109: Join users, carts, and cart_items to find average cart value per role.
SELECT
    r.name              AS role_name,
    ROUND(AVG(ci.unit_price * ci.quantity), 2) AS avg_cart_item_value
FROM users u
JOIN roles      r  ON u.role_id    = r.id
JOIN carts      c  ON u.id         = c.user_id
JOIN cart_items ci ON c.id         = ci.cart_id
GROUP BY r.name;

-- Q110: Show all products sold by inactive or suspended vendors.
SELECT
    p.id,
    p.title,
    v.store_name,
    v.status AS vendor_status
FROM products p
JOIN vendors v ON p.vendor_id = v.id
WHERE v.status IN ('inactive', 'suspended');


-- ============================================================
-- LEVEL 4 — BUSINESS ANALYTICS (Q111 – Q140)
-- ============================================================

-- Q111: Calculate monthly revenue for the past 12 months with month-over-month growth %.
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    SUM(total_amount)                 AS revenue,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(created_at, '%Y-%m')))
        / LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(created_at, '%Y-%m')) * 100
    , 2) AS mom_growth_pct
FROM orders
WHERE payment_status = 'paid'
  AND created_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month;

-- Q112: Build a vendor performance report: revenue, order count, avg rating, return rate, speed.
SELECT
    v.id                                AS vendor_id,
    v.store_name,
    SUM(oi.total_price)                 AS total_revenue,
    COUNT(DISTINCT oi.order_id)         AS total_orders,
    ROUND(AVG(r.rating), 2)             AS avg_rating,
    ROUND(
        SUM(CASE WHEN oi.return_status IS NOT NULL THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2)            AS return_rate_pct,
    ROUND(AVG(DATEDIFF(s.delivered_at, o.created_at)), 1) AS avg_fulfillment_days
FROM vendors v
LEFT JOIN order_items oi ON v.id          = oi.vendor_id
LEFT JOIN orders      o  ON oi.order_id   = o.id
LEFT JOIN products    p  ON oi.product_id = p.id
LEFT JOIN reviews     r  ON p.id          = r.product_id
LEFT JOIN shipments   s  ON o.id          = s.order_id AND s.vendor_id = v.id
GROUP BY v.id, v.store_name
ORDER BY total_revenue DESC;

-- Q113: Rank products within each category by units sold — show top 3 per category.
SELECT *
FROM (
    SELECT
        c.name              AS category_name,
        p.title             AS product_title,
        SUM(oi.quantity)    AS units_sold,
        RANK() OVER (
            PARTITION BY p.category_id
            ORDER BY SUM(oi.quantity) DESC
        ) AS rnk
    FROM order_items oi
    JOIN products   p ON oi.product_id = p.id
    JOIN categories c ON p.category_id = c.id
    GROUP BY p.category_id, c.name, p.id, p.title
) ranked
WHERE rnk <= 3;

-- Q114: Calculate total lost revenue from items sitting in abandoned carts.
SELECT
    SUM(ci.unit_price * ci.quantity) AS lost_revenue
FROM carts c
JOIN cart_items ci ON c.id = ci.cart_id
WHERE c.status = 'abandoned';

-- Q115: Calculate refund rate per vendor and flag those above 10%.
SELECT
    v.id,
    v.store_name,
    COUNT(DISTINCT oi.order_id)     AS total_orders,
    SUM(py.refund_amount)           AS total_refunded,
    SUM(oi.total_price)             AS total_revenue,
    ROUND(SUM(py.refund_amount) / NULLIF(SUM(oi.total_price), 0) * 100, 2) AS refund_rate_pct,
    CASE WHEN SUM(py.refund_amount) / NULLIF(SUM(oi.total_price), 0) * 100 > 10
         THEN 'FLAGGED' ELSE 'OK' END AS flag
FROM vendors v
JOIN order_items oi ON v.id          = oi.vendor_id
JOIN orders      o  ON oi.order_id   = o.id
JOIN payments    py ON o.id          = py.order_id
GROUP BY v.id, v.store_name
ORDER BY refund_rate_pct DESC;

-- Q116: Identify top-selling categories by revenue and their % of platform total.
SELECT
    c.name                          AS category_name,
    SUM(oi.total_price)             AS category_revenue,
    ROUND(
        SUM(oi.total_price)
        / SUM(SUM(oi.total_price)) OVER () * 100
    , 2)                            AS pct_of_total
FROM order_items oi
JOIN products   p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
GROUP BY c.id, c.name
ORDER BY category_revenue DESC;

-- Q117: Find returning customers: 2+ orders, retention period, and total lifetime spend.
SELECT
    user_id,
    COUNT(*)                                          AS order_count,
    MIN(created_at)                                   AS first_order,
    MAX(created_at)                                   AS last_order,
    DATEDIFF(MAX(created_at), MIN(created_at))        AS retention_days,
    ROUND(SUM(total_amount), 2)                       AS lifetime_spend
FROM orders
GROUP BY user_id
HAVING order_count >= 2
ORDER BY lifetime_spend DESC;

-- Q118: Detect inventory alerts: products at or below reorder_level with days-to-stockout.
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock,
    pi.reorder_level,
    COALESCE(
        ROUND(pi.quantity_in_stock / NULLIF(
            (SELECT SUM(oi2.quantity)
             FROM order_items oi2
             WHERE oi2.product_id = p.id
               AND oi2.order_id IN (
                   SELECT id FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
               )
            ) / 30.0
        , 0), 0)
    , 999) AS days_to_stockout
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
WHERE pi.quantity_in_stock <= pi.reorder_level
ORDER BY days_to_stockout;

-- Q119: Track average time between each order status transition.
-- (Using confirmed_at and delivered_at as available transition timestamps)
SELECT
    ROUND(AVG(DATEDIFF(confirmed_at, created_at)), 2)  AS avg_days_pending_to_confirmed,
    ROUND(AVG(DATEDIFF(delivered_at, confirmed_at)), 2) AS avg_days_confirmed_to_delivered
FROM orders
WHERE confirmed_at IS NOT NULL
  AND delivered_at IS NOT NULL;

-- Q120: Calculate payment failure rate per gateway per month.
SELECT
    payment_gateway,
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed,
    ROUND(
        SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2) AS failure_rate_pct
FROM payments
GROUP BY payment_gateway, DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month, payment_gateway;

-- Q121: Identify delayed shipments: dispatched 7+ days ago and still not delivered.
SELECT
    s.id,
    s.tracking_number,
    s.courier_partner,
    s.dispatched_at,
    s.status,
    DATEDIFF(NOW(), s.dispatched_at) AS days_since_dispatch
FROM shipments s
WHERE s.status NOT IN ('delivered','returned','lost')
  AND s.dispatched_at IS NOT NULL
  AND DATEDIFF(NOW(), s.dispatched_at) >= 7
ORDER BY days_since_dispatch DESC;

-- Q122: Fraud detection: users with 3+ failed payments in the last 7 days.
SELECT
    user_id,
    COUNT(*) AS failed_payment_count
FROM payments
WHERE status = 'failed'
  AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY user_id
HAVING failed_payment_count >= 3
ORDER BY failed_payment_count DESC;

-- Q123: Calculate customer lifetime value: total spend with tenure in months.
SELECT
    u.id,
    u.name,
    ROUND(SUM(o.total_amount), 2)                AS lifetime_spend,
    TIMESTAMPDIFF(MONTH, u.created_at, NOW())    AS tenure_months,
    ROUND(
        SUM(o.total_amount)
        / NULLIF(TIMESTAMPDIFF(MONTH, u.created_at, NOW()), 0)
    , 2)                                          AS avg_monthly_spend
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.payment_status = 'paid'
GROUP BY u.id, u.name, u.created_at
ORDER BY lifetime_spend DESC;

-- Q124: Compute a rating quality score per product: % 5-star minus % 1-2 star reviews.
SELECT
    product_id,
    COUNT(*)                                                         AS total_reviews,
    ROUND(SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_5star,
    ROUND(SUM(CASE WHEN rating <= 2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_1_2star,
    ROUND(
        SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) / COUNT(*) * 100 -
        SUM(CASE WHEN rating <= 2 THEN 1 ELSE 0 END) / COUNT(*) * 100
    , 2) AS quality_score
FROM reviews
GROUP BY product_id
ORDER BY quality_score DESC;

-- Q125: Monthly cohort: for each registration month, how many users ordered within 30 days.
SELECT
    DATE_FORMAT(u.created_at, '%Y-%m')  AS cohort_month,
    COUNT(DISTINCT u.id)                 AS total_registered,
    COUNT(DISTINCT o.user_id)            AS ordered_within_30d,
    ROUND(
        COUNT(DISTINCT o.user_id) / COUNT(DISTINCT u.id) * 100
    , 2)                                 AS conversion_rate_pct
FROM users u
LEFT JOIN orders o
    ON u.id = o.user_id
   AND DATEDIFF(o.created_at, u.created_at) BETWEEN 0 AND 30
GROUP BY DATE_FORMAT(u.created_at, '%Y-%m')
ORDER BY cohort_month;

-- Q126: Find products with high review volume but low rating (>20 reviews, avg < 3.0).
SELECT
    product_id,
    COUNT(*)            AS review_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM reviews
GROUP BY product_id
HAVING review_count > 20
   AND avg_rating < 3.0
ORDER BY avg_rating;

-- Q127: Calculate average time between user registration and their very first order.
SELECT
    ROUND(AVG(DATEDIFF(first_order.first_order_date, u.created_at)), 2) AS avg_days_to_first_order
FROM users u
JOIN (
    SELECT user_id, MIN(created_at) AS first_order_date
    FROM orders
    GROUP BY user_id
) first_order ON u.id = first_order.user_id;

-- Q128: Identify peak shopping hours: count orders per hour of day.
SELECT
    HOUR(created_at)    AS hour_of_day,
    COUNT(*)            AS order_count
FROM orders
GROUP BY HOUR(created_at)
ORDER BY order_count DESC;

-- Q129: Show the top 10 customers by GMV in the last 90 days.
SELECT
    u.id,
    u.name,
    u.email,
    ROUND(SUM(o.total_amount), 2) AS gmv_90d
FROM orders o
JOIN users u ON o.user_id = u.id
WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 90 DAY)
  AND o.payment_status = 'paid'
GROUP BY u.id, u.name, u.email
ORDER BY gmv_90d DESC
LIMIT 10;

-- Q130: Calculate vendor commission earned per month (revenue × rate ÷ 100).
SELECT
    v.id,
    v.store_name,
    DATE_FORMAT(o.created_at, '%Y-%m')      AS month,
    SUM(oi.total_price)                     AS gross_revenue,
    v.commission_rate,
    ROUND(SUM(oi.total_price) * v.commission_rate / 100, 2) AS commission_earned
FROM vendors v
JOIN order_items oi ON v.id        = oi.vendor_id
JOIN orders      o  ON oi.order_id = o.id
WHERE o.payment_status = 'paid'
GROUP BY v.id, v.store_name, DATE_FORMAT(o.created_at, '%Y-%m'), v.commission_rate
ORDER BY month, commission_earned DESC;

-- Q131: Show cart-to-order conversion rate by month.
SELECT
    DATE_FORMAT(c.created_at, '%Y-%m')      AS month,
    COUNT(DISTINCT c.id)                    AS total_carts,
    COUNT(DISTINCT CASE WHEN c.status = 'converted' THEN c.id END) AS converted_carts,
    ROUND(
        COUNT(DISTINCT CASE WHEN c.status = 'converted' THEN c.id END)
        / COUNT(DISTINCT c.id) * 100
    , 2) AS conversion_rate_pct
FROM carts c
GROUP BY DATE_FORMAT(c.created_at, '%Y-%m')
ORDER BY month;

-- Q132: Identify products that were sold but are now inactive or deleted.
SELECT DISTINCT
    p.id,
    p.title,
    p.status AS product_status
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE p.status IN ('inactive','deleted');

-- Q133: Find customers who ordered, then went inactive for 90+ days.
SELECT
    user_id,
    MAX(created_at) AS last_order_date,
    DATEDIFF(NOW(), MAX(created_at)) AS days_inactive
FROM orders
GROUP BY user_id
HAVING days_inactive >= 90
ORDER BY days_inactive DESC;

-- Q134: Show seasonal trends: compare Q1 vs Q2 vs Q3 vs Q4 revenue.
SELECT
    YEAR(created_at) AS year,
    SUM(CASE WHEN QUARTER(created_at) = 1 THEN total_amount ELSE 0 END) AS Q1,
    SUM(CASE WHEN QUARTER(created_at) = 2 THEN total_amount ELSE 0 END) AS Q2,
    SUM(CASE WHEN QUARTER(created_at) = 3 THEN total_amount ELSE 0 END) AS Q3,
    SUM(CASE WHEN QUARTER(created_at) = 4 THEN total_amount ELSE 0 END) AS Q4
FROM orders
WHERE payment_status = 'paid'
GROUP BY YEAR(created_at)
ORDER BY year;

-- Q135: Calculate ROI per category: total revenue vs total cost_price of sold items.
SELECT
    c.name                          AS category_name,
    SUM(oi.total_price)             AS total_revenue,
    SUM(p.cost_price * oi.quantity) AS total_cost,
    ROUND(
        (SUM(oi.total_price) - SUM(p.cost_price * oi.quantity))
        / NULLIF(SUM(p.cost_price * oi.quantity), 0) * 100
    , 2)                            AS roi_pct
FROM order_items oi
JOIN products   p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
WHERE p.cost_price IS NOT NULL
GROUP BY c.id, c.name
ORDER BY roi_pct DESC;

-- Q136: Segment users into Bronze / Silver / Gold tiers by total spend.
SELECT
    u.id,
    u.name,
    ROUND(SUM(o.total_amount), 2) AS total_spend,
    CASE
        WHEN SUM(o.total_amount) >= 100000 THEN 'Gold'
        WHEN SUM(o.total_amount) >= 30000  THEN 'Silver'
        ELSE                                    'Bronze'
    END AS tier
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.payment_status = 'paid'
GROUP BY u.id, u.name
ORDER BY total_spend DESC;

-- Q137: Show daily unique buyers (distinct users who placed an order) for the last 30 days.
SELECT
    DATE(created_at)              AS order_date,
    COUNT(DISTINCT user_id)       AS unique_buyers
FROM orders
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(created_at)
ORDER BY order_date;

-- Q138: Compute first-order vs repeat-order revenue split.
SELECT
    SUM(CASE WHEN rn = 1 THEN total_amount ELSE 0 END) AS first_order_revenue,
    SUM(CASE WHEN rn > 1 THEN total_amount ELSE 0 END) AS repeat_order_revenue
FROM (
    SELECT
        total_amount,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS rn
    FROM orders
    WHERE payment_status = 'paid'
) ranked;

-- Q139: Find products with zero sales in 60 days but still active and in stock.
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
WHERE p.status = 'active'
  AND pi.quantity_in_stock > 0
  AND p.id NOT IN (
      SELECT DISTINCT oi.product_id
      FROM order_items oi
      JOIN orders o ON oi.order_id = o.id
      WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 60 DAY)
  );

-- Q140: Show vendor growth: this month's revenue vs same month last year.
SELECT
    v.id,
    v.store_name,
    SUM(CASE
        WHEN YEAR(o.created_at) = YEAR(NOW())
         AND MONTH(o.created_at) = MONTH(NOW())
        THEN oi.total_price ELSE 0 END) AS this_month_revenue,
    SUM(CASE
        WHEN YEAR(o.created_at) = YEAR(NOW()) - 1
         AND MONTH(o.created_at) = MONTH(NOW())
        THEN oi.total_price ELSE 0 END) AS same_month_last_year,
    ROUND(
        (SUM(CASE
             WHEN YEAR(o.created_at) = YEAR(NOW())
              AND MONTH(o.created_at) = MONTH(NOW())
             THEN oi.total_price ELSE 0 END)
        - SUM(CASE
              WHEN YEAR(o.created_at) = YEAR(NOW()) - 1
               AND MONTH(o.created_at) = MONTH(NOW())
              THEN oi.total_price ELSE 0 END))
        / NULLIF(SUM(CASE
              WHEN YEAR(o.created_at) = YEAR(NOW()) - 1
               AND MONTH(o.created_at) = MONTH(NOW())
              THEN oi.total_price ELSE 0 END), 0) * 100
    , 2) AS yoy_growth_pct
FROM vendors v
JOIN order_items oi ON v.id        = oi.vendor_id
JOIN orders      o  ON oi.order_id = o.id
WHERE o.payment_status = 'paid'
GROUP BY v.id, v.store_name
ORDER BY yoy_growth_pct DESC;


-- ============================================================
-- LEVEL 5 — ADVANCED SQL (Q141 – Q170)
-- ============================================================

-- Q141: Use ROW_NUMBER() to find the single most recent order per user.
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) AS rn
    FROM orders
) ranked
WHERE rn = 1;

-- Q142: Use RANK() to rank products by revenue within each category, showing all ties.
SELECT
    c.name              AS category_name,
    p.title             AS product_title,
    SUM(oi.total_price) AS revenue,
    RANK() OVER (
        PARTITION BY p.category_id
        ORDER BY SUM(oi.total_price) DESC
    ) AS revenue_rank
FROM order_items oi
JOIN products   p ON oi.product_id = p.id
JOIN categories c ON p.category_id = c.id
GROUP BY p.category_id, c.name, p.id, p.title;

-- Q143: Use LAG() to compare each month's revenue to the previous month.
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        SUM(total_amount)                 AS revenue
    FROM orders
    WHERE payment_status = 'paid'
    GROUP BY DATE_FORMAT(created_at, '%Y-%m')
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100
    , 2) AS mom_change_pct
FROM monthly_revenue
ORDER BY month;

-- Q144: Use LEAD() to show each order and the same user's next order timestamp.
SELECT
    id              AS order_id,
    user_id,
    order_number,
    created_at      AS order_date,
    LEAD(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS next_order_date
FROM orders
ORDER BY user_id, created_at;

-- Q145: Write a CTE to find users who placed orders in both Q1 and Q4 of the same year.
WITH q1_orders AS (
    SELECT DISTINCT user_id, YEAR(created_at) AS yr
    FROM orders
    WHERE QUARTER(created_at) = 1
),
q4_orders AS (
    SELECT DISTINCT user_id, YEAR(created_at) AS yr
    FROM orders
    WHERE QUARTER(created_at) = 4
)
SELECT q1.user_id, q1.yr AS year
FROM q1_orders q1
JOIN q4_orders q4 ON q1.user_id = q4.user_id AND q1.yr = q4.yr
ORDER BY q1.yr, q1.user_id;

-- Q146: Use a recursive CTE to traverse the full category hierarchy.
WITH RECURSIVE category_tree AS (
    SELECT
        id, parent_id, name, 0 AS depth,
        CAST(name AS CHAR(1000)) AS path
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT
        c.id, c.parent_id, c.name, ct.depth + 1,
        CONCAT(ct.path, ' > ', c.name)
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT id, depth, path
FROM category_tree
ORDER BY path;

-- Q147: Write a correlated subquery to rank each product within its vendor's catalog by revenue.
SELECT
    p.id            AS product_id,
    p.title,
    p.vendor_id,
    (
        SELECT SUM(oi2.total_price)
        FROM order_items oi2
        WHERE oi2.product_id = p.id
    ) AS product_revenue,
    (
        SELECT COUNT(*) + 1
        FROM products p2
        WHERE p2.vendor_id = p.vendor_id
          AND (
              SELECT SUM(oi3.total_price) FROM order_items oi3 WHERE oi3.product_id = p2.id
          ) > (
              SELECT SUM(oi4.total_price) FROM order_items oi4 WHERE oi4.product_id = p.id
          )
    ) AS vendor_rank
FROM products p
ORDER BY p.vendor_id, vendor_rank;

-- Q148: Use DENSE_RANK() to identify the top-3 vendors by monthly revenue for the last 6 months.
SELECT *
FROM (
    SELECT
        v.id            AS vendor_id,
        v.store_name,
        DATE_FORMAT(o.created_at, '%Y-%m') AS month,
        SUM(oi.total_price) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY DATE_FORMAT(o.created_at, '%Y-%m')
            ORDER BY SUM(oi.total_price) DESC
        ) AS rnk
    FROM vendors v
    JOIN order_items oi ON v.id        = oi.vendor_id
    JOIN orders      o  ON oi.order_id = o.id
    WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
      AND o.payment_status = 'paid'
    GROUP BY v.id, v.store_name, DATE_FORMAT(o.created_at, '%Y-%m')
) ranked
WHERE rnk <= 3
ORDER BY month, rnk;

-- Q149: Use conditional aggregation to pivot payment statuses into columns per month.
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    SUM(CASE WHEN status = 'pending'            THEN 1 ELSE 0 END) AS pending,
    SUM(CASE WHEN status = 'success'            THEN 1 ELSE 0 END) AS success,
    SUM(CASE WHEN status = 'failed'             THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN status = 'refunded'           THEN 1 ELSE 0 END) AS refunded,
    SUM(CASE WHEN status = 'partially_refunded' THEN 1 ELSE 0 END) AS partially_refunded
FROM payments
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month;

-- Q150: Write a CTE chain to calculate the 7-day rolling average revenue per vendor.
WITH daily_vendor_revenue AS (
    SELECT
        oi.vendor_id,
        DATE(o.created_at)  AS sale_date,
        SUM(oi.total_price) AS daily_revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.payment_status = 'paid'
    GROUP BY oi.vendor_id, DATE(o.created_at)
)
SELECT
    vendor_id,
    sale_date,
    daily_revenue,
    ROUND(AVG(daily_revenue) OVER (
        PARTITION BY vendor_id
        ORDER BY sale_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_7d_avg
FROM daily_vendor_revenue
ORDER BY vendor_id, sale_date;

-- Q151: Use NTILE(4) to segment customers into revenue quartiles.
SELECT
    user_id,
    ROUND(SUM(total_amount), 2) AS total_spend,
    NTILE(4) OVER (ORDER BY SUM(total_amount)) AS quartile
FROM orders
WHERE payment_status = 'paid'
GROUP BY user_id
ORDER BY quartile DESC, total_spend DESC;

-- Q152: Write a query using EXISTS to find products in both an active cart and a pending order.
SELECT DISTINCT p.id, p.title
FROM products p
WHERE EXISTS (
    SELECT 1
    FROM cart_items ci
    JOIN carts c ON ci.cart_id = c.id
    WHERE ci.product_id = p.id AND c.status = 'active'
)
AND EXISTS (
    SELECT 1
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE oi.product_id = p.id AND o.order_status = 'pending'
);

-- Q153: Use window SUM to calculate running total of revenue per vendor month-by-month.
WITH monthly AS (
    SELECT
        oi.vendor_id,
        DATE_FORMAT(o.created_at, '%Y-%m') AS month,
        SUM(oi.total_price)                 AS monthly_revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.payment_status = 'paid'
    GROUP BY oi.vendor_id, DATE_FORMAT(o.created_at, '%Y-%m')
)
SELECT
    vendor_id,
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        PARTITION BY vendor_id
        ORDER BY month
        ROWS UNBOUNDED PRECEDING
    ) AS running_total
FROM monthly
ORDER BY vendor_id, month;

-- Q154: Use FIRST_VALUE() to show the first product ever listed in each category.
SELECT DISTINCT
    category_id,
    FIRST_VALUE(title) OVER (
        PARTITION BY category_id
        ORDER BY created_at
    ) AS first_product_listed,
    FIRST_VALUE(created_at) OVER (
        PARTITION BY category_id
        ORDER BY created_at
    ) AS listed_at
FROM products
ORDER BY category_id;

-- Q155: Write a correlated subquery to check each order's total matches its order_items sum.
SELECT
    o.id            AS order_id,
    o.order_number,
    o.total_amount  AS order_total,
    (
        SELECT SUM(oi.total_price)
        FROM order_items oi
        WHERE oi.order_id = o.id
    )               AS items_sum,
    CASE
        WHEN ABS(o.total_amount - (
            SELECT SUM(oi2.total_price) FROM order_items oi2 WHERE oi2.order_id = o.id
        )) < 1 THEN 'Match'
        ELSE 'Mismatch'
    END AS status
FROM orders o
ORDER BY status DESC;

-- Q156: Use PERCENT_RANK() to show where each product falls in the overall price distribution.
SELECT
    id,
    title,
    price,
    ROUND(PERCENT_RANK() OVER (ORDER BY price) * 100, 2) AS price_percentile
FROM products
WHERE status = 'active'
ORDER BY price_percentile DESC;

-- Q157: Write a CTE + window function for 3-month moving average of orders per category.
WITH monthly_category_orders AS (
    SELECT
        p.category_id,
        DATE_FORMAT(o.created_at, '%Y-%m') AS month,
        COUNT(DISTINCT o.id)               AS order_count
    FROM order_items oi
    JOIN orders   o ON oi.order_id   = o.id
    JOIN products p ON oi.product_id = p.id
    GROUP BY p.category_id, DATE_FORMAT(o.created_at, '%Y-%m')
)
SELECT
    category_id,
    month,
    order_count,
    ROUND(AVG(order_count) OVER (
        PARTITION BY category_id
        ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3m
FROM monthly_category_orders
ORDER BY category_id, month;

-- Q158: Flag users as 'at risk' using CASE WHEN if their last order was 60+ days ago.
SELECT
    user_id,
    MAX(created_at) AS last_order_date,
    DATEDIFF(NOW(), MAX(created_at)) AS days_since_last_order,
    CASE
        WHEN DATEDIFF(NOW(), MAX(created_at)) >= 60 THEN 'At Risk'
        ELSE 'Active'
    END AS user_segment
FROM orders
GROUP BY user_id
ORDER BY days_since_last_order DESC;

-- Q159: Write a pivot-style query showing product revenue by month (Jan–Dec) as separate columns.
SELECT
    oi.product_id,
    SUM(CASE WHEN MONTH(o.created_at) =  1 THEN oi.total_price ELSE 0 END) AS Jan,
    SUM(CASE WHEN MONTH(o.created_at) =  2 THEN oi.total_price ELSE 0 END) AS Feb,
    SUM(CASE WHEN MONTH(o.created_at) =  3 THEN oi.total_price ELSE 0 END) AS Mar,
    SUM(CASE WHEN MONTH(o.created_at) =  4 THEN oi.total_price ELSE 0 END) AS Apr,
    SUM(CASE WHEN MONTH(o.created_at) =  5 THEN oi.total_price ELSE 0 END) AS May,
    SUM(CASE WHEN MONTH(o.created_at) =  6 THEN oi.total_price ELSE 0 END) AS Jun,
    SUM(CASE WHEN MONTH(o.created_at) =  7 THEN oi.total_price ELSE 0 END) AS Jul,
    SUM(CASE WHEN MONTH(o.created_at) =  8 THEN oi.total_price ELSE 0 END) AS Aug,
    SUM(CASE WHEN MONTH(o.created_at) =  9 THEN oi.total_price ELSE 0 END) AS Sep,
    SUM(CASE WHEN MONTH(o.created_at) = 10 THEN oi.total_price ELSE 0 END) AS Oct,
    SUM(CASE WHEN MONTH(o.created_at) = 11 THEN oi.total_price ELSE 0 END) AS Nov,
    SUM(CASE WHEN MONTH(o.created_at) = 12 THEN oi.total_price ELSE 0 END) AS Decm
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
WHERE o.payment_status = 'paid'
GROUP BY oi.product_id
ORDER BY oi.product_id;

-- Q160: Use a self-join on orders to find orders from the same user placed within 5 minutes.
SELECT
    a.id            AS order_1,
    b.id            AS order_2,
    a.user_id,
    a.created_at    AS time_1,
    b.created_at    AS time_2,
    ABS(TIMESTAMPDIFF(SECOND, a.created_at, b.created_at)) AS seconds_apart
FROM orders a
JOIN orders b
    ON a.user_id = b.user_id
   AND a.id      < b.id
   AND ABS(TIMESTAMPDIFF(SECOND, a.created_at, b.created_at)) <= 300
ORDER BY seconds_apart;

-- Q161: Write multiple CTEs to build a funnel: carts → orders → paid payments.
WITH carts_cte AS (
    SELECT COUNT(*) AS total_carts FROM carts
),
orders_cte AS (
    SELECT COUNT(*) AS total_orders FROM orders
),
paid_cte AS (
    SELECT COUNT(*) AS paid_orders FROM orders WHERE payment_status = 'paid'
),
shipped_cte AS (
    SELECT COUNT(DISTINCT order_id) AS shipped_orders FROM shipments WHERE status != 'pending'
)
SELECT
    c.total_carts,
    o.total_orders,
    p.paid_orders,
    s.shipped_orders,
    ROUND(o.total_orders / c.total_carts * 100, 2)   AS cart_to_order_pct,
    ROUND(p.paid_orders  / o.total_orders * 100, 2)  AS order_to_paid_pct,
    ROUND(s.shipped_orders / p.paid_orders * 100, 2) AS paid_to_shipped_pct
FROM carts_cte c, orders_cte o, paid_cte p, shipped_cte s;

-- Q162: Use window SUM to calculate each order's % contribution to user's total lifetime spend.
SELECT
    user_id,
    id          AS order_id,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY user_id) AS lifetime_spend,
    ROUND(total_amount / SUM(total_amount) OVER (PARTITION BY user_id) * 100, 2) AS pct_of_lifetime
FROM orders
WHERE payment_status = 'paid'
ORDER BY user_id, pct_of_lifetime DESC;

-- Q163: Write a NOT EXISTS subquery to find vendors with no orders in the last 30 days.
SELECT
    v.id,
    v.store_name
FROM vendors v
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE oi.vendor_id = v.id
      AND o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
);

-- Q164: Use ROW_NUMBER with PARTITION BY to keep only one review per user per product.
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY user_id, product_id
            ORDER BY created_at DESC
        ) AS rn
    FROM reviews
) deduped
WHERE rn = 1;

-- Q165: Detect duplicate payments: same order_id, same amount, within 10 minutes.
SELECT
    a.id            AS payment_1,
    b.id            AS payment_2,
    a.order_id,
    a.amount,
    a.created_at    AS time_1,
    b.created_at    AS time_2,
    ABS(TIMESTAMPDIFF(MINUTE, a.created_at, b.created_at)) AS minutes_apart
FROM payments a
JOIN payments b
    ON a.order_id = b.order_id
   AND a.amount   = b.amount
   AND a.id       < b.id
   AND ABS(TIMESTAMPDIFF(MINUTE, a.created_at, b.created_at)) <= 10;

-- Q166: Use CUME_DIST() to find the top 20% of customers by total spend.
SELECT *
FROM (
    SELECT
        user_id,
        ROUND(SUM(total_amount), 2) AS total_spend,
        CUME_DIST() OVER (ORDER BY SUM(total_amount)) AS cume_dist_val
    FROM orders
    WHERE payment_status = 'paid'
    GROUP BY user_id
) dist
WHERE cume_dist_val >= 0.80
ORDER BY total_spend DESC;

-- Q167: Write a CTE to calculate monthly churn: ordered last month but not this month.
WITH last_month AS (
    SELECT DISTINCT user_id
    FROM orders
    WHERE YEAR(created_at)  = YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH))
      AND MONTH(created_at) = MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH))
),
this_month AS (
    SELECT DISTINCT user_id
    FROM orders
    WHERE YEAR(created_at)  = YEAR(NOW())
      AND MONTH(created_at) = MONTH(NOW())
)
SELECT
    lm.user_id,
    'Churned' AS status
FROM last_month lm
LEFT JOIN this_month tm ON lm.user_id = tm.user_id
WHERE tm.user_id IS NULL;

-- Q168: Use a derived table in FROM to pre-aggregate order_items before joining to orders.
SELECT
    o.order_number,
    o.total_amount      AS order_total,
    oi_agg.items_subtotal,
    oi_agg.item_count
FROM orders o
JOIN (
    SELECT
        order_id,
        SUM(total_price) AS items_subtotal,
        COUNT(*)         AS item_count
    FROM order_items
    GROUP BY order_id
) oi_agg ON o.id = oi_agg.order_id
ORDER BY o.id;

-- Q169: Use a derived table to get the top 2 products sold per vendor.
SELECT *
FROM (
    SELECT
        vendor_id,
        product_id,
        total_qty_sold,
        ROW_NUMBER() OVER (
            PARTITION BY vendor_id
            ORDER BY total_qty_sold DESC
        ) AS rn
    FROM (
        SELECT vendor_id, product_id, SUM(quantity) AS total_qty_sold
        FROM order_items
        GROUP BY vendor_id, product_id
    ) product_sales
) ranked
WHERE rn <= 2
ORDER BY vendor_id, rn;

-- Q170: Use conditional aggregation to show order counts by status per vendor in one row.
SELECT
    vendor_id,
    SUM(CASE WHEN o.order_status = 'pending'    THEN 1 ELSE 0 END) AS pending,
    SUM(CASE WHEN o.order_status = 'confirmed'  THEN 1 ELSE 0 END) AS confirmed,
    SUM(CASE WHEN o.order_status = 'processing' THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN o.order_status = 'shipped'    THEN 1 ELSE 0 END) AS shipped,
    SUM(CASE WHEN o.order_status = 'delivered'  THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN o.order_status = 'cancelled'  THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN o.order_status = 'refunded'   THEN 1 ELSE 0 END) AS refunded,
    COUNT(DISTINCT oi.order_id)                                      AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
GROUP BY oi.vendor_id
ORDER BY total_orders DESC;


-- ============================================================
-- LEVEL 6 — HARD PRODUCTION QUERIES (Q171 – Q200)
-- ============================================================

-- Q171: Build a full cohort retention table: for each monthly cohort show retention % for months 1–6.
WITH cohorts AS (
    SELECT
        user_id,
        DATE_FORMAT(MIN(created_at), '%Y-%m') AS cohort_month
    FROM orders
    GROUP BY user_id
),
cohort_orders AS (
    SELECT
        c.cohort_month,
        c.user_id,
        TIMESTAMPDIFF(MONTH,
            STR_TO_DATE(CONCAT(c.cohort_month, '-01'), '%Y-%m-%d'),
            o.created_at
        ) AS month_number
    FROM cohorts c
    JOIN orders o ON c.user_id = o.user_id
)
SELECT
    cohort_month,
    COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END) AS m0,
    COUNT(DISTINCT CASE WHEN month_number = 1 THEN user_id END) AS m1,
    COUNT(DISTINCT CASE WHEN month_number = 2 THEN user_id END) AS m2,
    COUNT(DISTINCT CASE WHEN month_number = 3 THEN user_id END) AS m3,
    COUNT(DISTINCT CASE WHEN month_number = 4 THEN user_id END) AS m4,
    COUNT(DISTINCT CASE WHEN month_number = 5 THEN user_id END) AS m5,
    COUNT(DISTINCT CASE WHEN month_number = 6 THEN user_id END) AS m6,
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 1 THEN user_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 0) * 100, 1) AS ret_m1_pct,
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 3 THEN user_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 0) * 100, 1) AS ret_m3_pct,
    ROUND(COUNT(DISTINCT CASE WHEN month_number = 6 THEN user_id END)
        / NULLIF(COUNT(DISTINCT CASE WHEN month_number = 0 THEN user_id END), 0) * 100, 1) AS ret_m6_pct
FROM cohort_orders
GROUP BY cohort_month
ORDER BY cohort_month;

-- Q172: Detect payment fraud: orders with 2+ payment attempts using different methods within 1 hour.
SELECT
    a.order_id,
    a.id            AS payment_1,
    b.id            AS payment_2,
    a.payment_method AS method_1,
    b.payment_method AS method_2,
    a.created_at    AS attempt_1,
    b.created_at    AS attempt_2,
    ABS(TIMESTAMPDIFF(MINUTE, a.created_at, b.created_at)) AS minutes_apart
FROM payments a
JOIN payments b
    ON a.order_id        = b.order_id
   AND a.id              < b.id
   AND a.payment_method != b.payment_method
   AND ABS(TIMESTAMPDIFF(MINUTE, a.created_at, b.created_at)) <= 60;

-- Q173: Reconcile order totals: find orders where total ≠ subtotal + shipping − discount + tax.
SELECT
    id,
    order_number,
    total_amount,
    ROUND(subtotal + shipping_amount - discount_amount + tax_amount, 2) AS expected_total,
    ROUND(total_amount - (subtotal + shipping_amount - discount_amount + tax_amount), 2) AS discrepancy
FROM orders
WHERE ABS(total_amount - (subtotal + shipping_amount - discount_amount + tax_amount)) > 1
ORDER BY ABS(discrepancy) DESC;

-- Q174: Build a real-time inventory dashboard: stock, reserved, available, days-to-stockout per product.
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock,
    pi.reserved_quantity,
    pi.quantity_in_stock - pi.reserved_quantity AS available_stock,
    COALESCE(ROUND(
        pi.quantity_in_stock / NULLIF(
            (SELECT SUM(oi.quantity) FROM order_items oi
             JOIN orders o ON oi.order_id = o.id
             WHERE oi.product_id = p.id
               AND o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            ) / 30.0
        , 0)
    , 0), 9999) AS days_to_stockout,
    CASE
        WHEN pi.quantity_in_stock = 0                        THEN 'OUT OF STOCK'
        WHEN pi.quantity_in_stock <= pi.reorder_level        THEN 'REORDER NOW'
        WHEN pi.quantity_in_stock <= pi.reorder_level * 2    THEN 'LOW STOCK'
        ELSE 'HEALTHY'
    END AS stock_status
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
WHERE p.status = 'active'
ORDER BY days_to_stockout;

-- Q175: Build a vendor payout report: gross sales, platform commission, net payout per vendor/month.
SELECT
    v.id,
    v.store_name,
    DATE_FORMAT(o.created_at, '%Y-%m')         AS month,
    ROUND(SUM(oi.total_price), 2)              AS gross_sales,
    v.commission_rate,
    ROUND(SUM(oi.total_price) * v.commission_rate / 100, 2) AS platform_commission,
    ROUND(SUM(oi.total_price) * (1 - v.commission_rate / 100), 2) AS net_payout
FROM vendors v
JOIN order_items oi ON v.id        = oi.vendor_id
JOIN orders      o  ON oi.order_id = o.id
WHERE o.payment_status = 'paid'
GROUP BY v.id, v.store_name, DATE_FORMAT(o.created_at, '%Y-%m'), v.commission_rate
ORDER BY month, net_payout DESC;

-- Q176: Detect fake review patterns: users who submitted 5+ reviews in a single day.
SELECT
    user_id,
    DATE(created_at)  AS review_date,
    COUNT(*)          AS review_count
FROM reviews
GROUP BY user_id, DATE(created_at)
HAVING review_count >= 5
ORDER BY review_count DESC;

-- Q177: Build an order funnel: cart created → order placed → payment success → shipment dispatched.
WITH funnel AS (
    SELECT
        (SELECT COUNT(*) FROM carts)                                              AS step1_carts,
        (SELECT COUNT(*) FROM orders)                                             AS step2_orders,
        (SELECT COUNT(*) FROM orders WHERE payment_status = 'paid')              AS step3_paid,
        (SELECT COUNT(DISTINCT order_id) FROM shipments WHERE status != 'pending') AS step4_dispatched
)
SELECT
    step1_carts,
    step2_orders,
    step3_paid,
    step4_dispatched,
    ROUND(step2_orders     / step1_carts       * 100, 2) AS cart_to_order_pct,
    ROUND(step3_paid       / step2_orders      * 100, 2) AS order_to_paid_pct,
    ROUND(step4_dispatched / step3_paid        * 100, 2) AS paid_to_dispatched_pct
FROM funnel;

-- Q178: Calculate LTV prediction: average monthly spend × estimated remaining customer lifetime.
SELECT
    u.id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.created_at, NOW())          AS tenure_months,
    ROUND(SUM(o.total_amount), 2)                       AS lifetime_spend,
    ROUND(SUM(o.total_amount) / NULLIF(TIMESTAMPDIFF(MONTH, u.created_at, NOW()), 0), 2) AS avg_monthly_spend,
    24                                                  AS estimated_remaining_months,
    ROUND(
        (SUM(o.total_amount) / NULLIF(TIMESTAMPDIFF(MONTH, u.created_at, NOW()), 0)) * 24
    , 2)                                                AS predicted_ltv
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.payment_status = 'paid'
GROUP BY u.id, u.name, u.created_at
ORDER BY predicted_ltv DESC;

-- Q179: Identify flash sale abuse: same product bought 3+ times in 24 hours by the same user.
SELECT
    o.user_id,
    oi.product_id,
    DATE(o.created_at) AS order_date,
    SUM(oi.quantity)   AS total_qty_ordered
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
GROUP BY o.user_id, oi.product_id, DATE(o.created_at)
HAVING total_qty_ordered >= 3
ORDER BY total_qty_ordered DESC;

-- Q180: Build a product co-purchase query: top 5 product pairs ordered together most often.
SELECT
    a.product_id AS product_a,
    b.product_id AS product_b,
    COUNT(*)     AS times_bought_together
FROM order_items a
JOIN order_items b
    ON a.order_id  = b.order_id
   AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_bought_together DESC
LIMIT 5;

-- Q181: Write a multi-CTE vendor health score using revenue trend, return rate, rating, speed.
WITH vendor_revenue AS (
    SELECT
        oi.vendor_id,
        SUM(oi.total_price) AS total_revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.payment_status = 'paid'
    GROUP BY oi.vendor_id
),
vendor_returns AS (
    SELECT
        vendor_id,
        ROUND(
            SUM(CASE WHEN return_status IS NOT NULL THEN 1 ELSE 0 END)
            / COUNT(*) * 100, 2) AS return_rate
    FROM order_items
    GROUP BY vendor_id
),
vendor_ratings AS (
    SELECT
        p.vendor_id,
        ROUND(AVG(r.rating), 2) AS avg_rating
    FROM reviews r
    JOIN products p ON r.product_id = p.id
    GROUP BY p.vendor_id
),
vendor_speed AS (
    SELECT
        s.vendor_id,
        ROUND(AVG(DATEDIFF(s.delivered_at, o.created_at)), 1) AS avg_days
    FROM shipments s
    JOIN orders o ON s.order_id = o.id
    WHERE s.delivered_at IS NOT NULL
    GROUP BY s.vendor_id
)
SELECT
    v.id,
    v.store_name,
    COALESCE(vr.total_revenue, 0)   AS total_revenue,
    COALESCE(ret.return_rate, 0)    AS return_rate,
    COALESCE(rat.avg_rating, 0)     AS avg_rating,
    COALESCE(spd.avg_days, 99)      AS avg_delivery_days,
    ROUND(
        (COALESCE(rat.avg_rating, 0) / 5 * 40)
        + ((1 - COALESCE(ret.return_rate, 0) / 100) * 30)
        + (GREATEST(0, (14 - COALESCE(spd.avg_days, 14))) / 14 * 30)
    , 2) AS health_score
FROM vendors v
LEFT JOIN vendor_revenue vr  ON v.id = vr.vendor_id
LEFT JOIN vendor_returns ret ON v.id = ret.vendor_id
LEFT JOIN vendor_ratings rat ON v.id = rat.vendor_id
LEFT JOIN vendor_speed   spd ON v.id = spd.vendor_id
ORDER BY health_score DESC;

-- Q182: Build an RFM segmentation query: score all customers on Recency, Frequency, Monetary.
WITH rfm_base AS (
    SELECT
        user_id,
        DATEDIFF(NOW(), MAX(created_at))    AS recency_days,
        COUNT(*)                            AS frequency,
        ROUND(SUM(total_amount), 2)         AS monetary
    FROM orders
    WHERE payment_status = 'paid'
    GROUP BY user_id
)
SELECT
    user_id,
    recency_days,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency)         AS f_score,
    NTILE(5) OVER (ORDER BY monetary)          AS m_score
FROM rfm_base
ORDER BY m_score DESC, f_score DESC, r_score DESC;

-- Q183: Combine RFM scores into named tiers: Champions, Loyal, At Risk, Lost.
WITH rfm_base AS (
    SELECT
        user_id,
        DATEDIFF(NOW(), MAX(created_at)) AS recency_days,
        COUNT(*)                         AS frequency,
        SUM(total_amount)                AS monetary
    FROM orders
    WHERE payment_status = 'paid'
    GROUP BY user_id
),
rfm_scored AS (
    SELECT
        user_id,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency)         AS f_score,
        NTILE(5) OVER (ORDER BY monetary)          AS m_score
    FROM rfm_base
)
SELECT
    user_id,
    r_score, f_score, m_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
        WHEN f_score >= 3 AND m_score >= 3                  THEN 'Loyal'
        WHEN r_score <= 2 AND f_score >= 2                  THEN 'At Risk'
        WHEN r_score = 1  AND f_score = 1                   THEN 'Lost'
        ELSE 'Potential Loyalist'
    END AS rfm_tier
FROM rfm_scored
ORDER BY rfm_tier, m_score DESC;

-- Q184: Find products with demand surge: 3× more orders than their 30-day average in last 7 days.
SELECT
    product_id,
    recent_qty,
    avg_daily_30d,
    ROUND(recent_qty / NULLIF(avg_daily_30d * 7, 0), 2) AS surge_multiplier
FROM (
    SELECT
        oi.product_id,
        SUM(CASE WHEN o.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)  THEN oi.quantity ELSE 0 END) AS recent_qty,
        SUM(CASE WHEN o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) THEN oi.quantity ELSE 0 END) / 30.0 AS avg_daily_30d
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    GROUP BY oi.product_id
) demand
WHERE recent_qty >= avg_daily_30d * 7 * 3
  AND avg_daily_30d > 0
ORDER BY surge_multiplier DESC;

-- Q185: Build a dynamic pricing signal: products in top 10% demand but fewer than 20 units in stock.
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock,
    demand.units_sold_30d,
    PERCENT_RANK() OVER (ORDER BY demand.units_sold_30d) AS demand_pct_rank
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
JOIN (
    SELECT oi.product_id, SUM(oi.quantity) AS units_sold_30d
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY oi.product_id
) demand ON p.id = demand.product_id
WHERE pi.quantity_in_stock < 20
  AND (
      SELECT COUNT(*) FROM (
          SELECT product_id, SUM(quantity) AS qty
          FROM order_items oi2
          JOIN orders o2 ON oi2.order_id = o2.id
          WHERE o2.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
          GROUP BY product_id
      ) sub WHERE sub.qty > demand.units_sold_30d
  ) / (
      SELECT COUNT(DISTINCT product_id)
      FROM order_items oi3
      JOIN orders o3 ON oi3.order_id = o3.id
      WHERE o3.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
  ) <= 0.10
ORDER BY units_sold_30d DESC;

-- Q186: Audit price integrity: order_items where unit_price differs from current price by > 20%.
SELECT
    oi.id           AS order_item_id,
    oi.order_id,
    oi.product_id,
    oi.unit_price   AS sold_price,
    p.price         AS current_price,
    ROUND(ABS(oi.unit_price - p.price) / p.price * 100, 2) AS price_drift_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE ABS(oi.unit_price - p.price) / p.price * 100 > 20
ORDER BY price_drift_pct DESC;

-- Q187: Build an SLA breach report: confirmed 2+ days ago, shipment still in 'pending'.
SELECT
    o.id,
    o.order_number,
    o.confirmed_at,
    s.status AS shipment_status,
    DATEDIFF(NOW(), o.confirmed_at) AS days_since_confirmation
FROM orders o
LEFT JOIN shipments s ON o.id = s.order_id
WHERE o.confirmed_at IS NOT NULL
  AND DATEDIFF(NOW(), o.confirmed_at) >= 2
  AND (s.id IS NULL OR s.status = 'pending')
  AND o.order_status NOT IN ('cancelled','refunded')
ORDER BY days_since_confirmation DESC;

-- Q188: Build a chargeback risk model: refund_amount > 50% of total spend in last 90 days.
SELECT
    u.id,
    u.name,
    SUM(o.total_amount)     AS total_spend_90d,
    SUM(py.refund_amount)   AS total_refunded_90d,
    ROUND(SUM(py.refund_amount) / NULLIF(SUM(o.total_amount), 0) * 100, 2) AS refund_ratio_pct
FROM users u
JOIN orders   o  ON u.id      = o.user_id
JOIN payments py ON o.id      = py.order_id
WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY u.id, u.name
HAVING refund_ratio_pct > 50
ORDER BY refund_ratio_pct DESC;

-- Q189: Detect inventory shrinkage: total sold + current stock vs total restocked.
-- (Approximation: last_restocked_at and reorder_quantity used as proxy for inbound stock)
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock               AS current_stock,
    COALESCE(sold.total_sold, 0)       AS total_sold,
    pi.quantity_in_stock + COALESCE(sold.total_sold, 0) AS accounted_for,
    pi.reorder_quantity                AS last_reorder_qty,
    (pi.quantity_in_stock + COALESCE(sold.total_sold, 0)) - pi.reorder_quantity AS shrinkage_estimate
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
LEFT JOIN (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM order_items
    GROUP BY product_id
) sold ON p.id = sold.product_id
WHERE (pi.quantity_in_stock + COALESCE(sold.total_sold, 0)) < pi.reorder_quantity
ORDER BY shrinkage_estimate;

-- Q190: Build a demand forecast baseline: 12-month sales history → projected next month demand.
WITH monthly_sales AS (
    SELECT
        oi.product_id,
        DATE_FORMAT(o.created_at, '%Y-%m') AS month,
        SUM(oi.quantity)                    AS monthly_qty
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
    GROUP BY oi.product_id, DATE_FORMAT(o.created_at, '%Y-%m')
)
SELECT
    product_id,
    ROUND(AVG(monthly_qty), 0)                                   AS avg_monthly_demand,
    MAX(monthly_qty)                                             AS peak_demand,
    ROUND(AVG(monthly_qty) * 1.10, 0)                           AS projected_next_month
FROM monthly_sales
GROUP BY product_id
ORDER BY projected_next_month DESC;

-- Q191: Detect account sharing: different shipping addresses from same user in the same hour.
SELECT
    o1.user_id,
    COUNT(DISTINCT o1.id)   AS orders_in_hour,
    COUNT(DISTINCT o1.shipping_address) AS distinct_addresses
FROM orders o1
JOIN orders o2
    ON o1.user_id = o2.user_id
   AND o1.id      < o2.id
   AND ABS(TIMESTAMPDIFF(MINUTE, o1.created_at, o2.created_at)) <= 60
WHERE o1.shipping_address != o2.shipping_address
  AND o1.shipping_address IS NOT NULL
  AND o2.shipping_address IS NOT NULL
GROUP BY o1.user_id
HAVING distinct_addresses > 1
ORDER BY distinct_addresses DESC;

-- Q192: Use JSON_EXTRACT to analyze payment gateway_response error codes.
SELECT
    payment_gateway,
    JSON_UNQUOTE(JSON_EXTRACT(gateway_response, '$.error_code'))    AS error_code,
    JSON_UNQUOTE(JSON_EXTRACT(gateway_response, '$.error_message')) AS error_message,
    COUNT(*)                                                          AS frequency
FROM payments
WHERE status = 'failed'
  AND gateway_response IS NOT NULL
GROUP BY payment_gateway,
         JSON_EXTRACT(gateway_response, '$.error_code'),
         JSON_EXTRACT(gateway_response, '$.error_message')
ORDER BY frequency DESC;

-- Q193: Build a supplier scorecard: on-time delivery %, returned shipments %, order volume.
SELECT
    s.courier_partner,
    COUNT(*)                                                             AS total_shipments,
    ROUND(
        SUM(CASE WHEN s.actual_delivery_date <= s.estimated_delivery_date THEN 1 ELSE 0 END)
        / NULLIF(COUNT(CASE WHEN s.actual_delivery_date IS NOT NULL THEN 1 END), 0) * 100
    , 2)                                                                 AS on_time_delivery_pct,
    ROUND(
        SUM(CASE WHEN s.status = 'returned' THEN 1 ELSE 0 END)
        / COUNT(*) * 100
    , 2)                                                                 AS return_rate_pct
FROM shipments s
GROUP BY s.courier_partner
ORDER BY on_time_delivery_pct DESC;

-- Q194: Write an alert query: vendor has not updated shipment status in 48 hours post-confirmation.
SELECT
    v.id            AS vendor_id,
    v.store_name,
    o.order_number,
    o.confirmed_at,
    s.status        AS shipment_status,
    s.created_at    AS shipment_created_at,
    DATEDIFF(NOW(), o.confirmed_at) AS hours_since_confirmation
FROM vendors v
JOIN order_items oi ON v.id       = oi.vendor_id
JOIN orders      o  ON oi.order_id = o.id
LEFT JOIN shipments s ON o.id     = s.order_id AND s.vendor_id = v.id
WHERE o.confirmed_at IS NOT NULL
  AND TIMESTAMPDIFF(HOUR, o.confirmed_at, NOW()) >= 48
  AND (s.id IS NULL OR s.status = 'pending')
  AND o.order_status NOT IN ('cancelled','refunded','delivered')
ORDER BY hours_since_confirmation DESC;

-- Q195: Build smart reorder suggestions: (30-day velocity × 14) > current stock.
WITH velocity AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity) / 30.0 AS daily_velocity
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.id
    WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY oi.product_id
)
SELECT
    p.id,
    p.title,
    pi.quantity_in_stock,
    ROUND(v.daily_velocity, 2)              AS daily_velocity,
    ROUND(v.daily_velocity * 14, 0)         AS units_needed_14d,
    ROUND(v.daily_velocity * 14 - pi.quantity_in_stock, 0) AS reorder_qty_suggestion
FROM products p
JOIN product_inventory pi ON p.id = pi.product_id
JOIN velocity v            ON p.id = v.product_id
WHERE v.daily_velocity * 14 > pi.quantity_in_stock
  AND p.status = 'active'
ORDER BY reorder_qty_suggestion DESC;

-- Q196: Write a weekly active user (WAU) trend query for the past 12 weeks.
SELECT
    YEAR(created_at)                 AS yr,
    WEEK(created_at, 1)              AS week_number,
    MIN(DATE(created_at))            AS week_start,
    COUNT(DISTINCT user_id)          AS weekly_active_users
FROM orders
WHERE created_at >= DATE_SUB(NOW(), INTERVAL 12 WEEK)
GROUP BY YEAR(created_at), WEEK(created_at, 1)
ORDER BY yr, week_number;

-- Q197: Identify revenue leakage: delivered orders with no matching payment record.
SELECT
    o.id,
    o.order_number,
    o.total_amount,
    o.order_status,
    o.payment_status
FROM orders o
LEFT JOIN payments py ON o.id = py.order_id
WHERE o.order_status  = 'delivered'
  AND py.id IS NULL
ORDER BY o.total_amount DESC;

-- Q198: Build a new vs returning customer revenue split per month.
WITH first_orders AS (
    SELECT user_id, MIN(created_at) AS first_order_date
    FROM orders
    GROUP BY user_id
)
SELECT
    DATE_FORMAT(o.created_at, '%Y-%m') AS month,
    SUM(CASE
        WHEN DATE_FORMAT(o.created_at, '%Y-%m') = DATE_FORMAT(fo.first_order_date, '%Y-%m')
        THEN o.total_amount ELSE 0 END) AS new_customer_revenue,
    SUM(CASE
        WHEN DATE_FORMAT(o.created_at, '%Y-%m') != DATE_FORMAT(fo.first_order_date, '%Y-%m')
        THEN o.total_amount ELSE 0 END) AS returning_customer_revenue,
    COUNT(DISTINCT CASE
        WHEN DATE_FORMAT(o.created_at, '%Y-%m') = DATE_FORMAT(fo.first_order_date, '%Y-%m')
        THEN o.user_id END) AS new_customers,
    COUNT(DISTINCT CASE
        WHEN DATE_FORMAT(o.created_at, '%Y-%m') != DATE_FORMAT(fo.first_order_date, '%Y-%m')
        THEN o.user_id END) AS returning_customers
FROM orders o
JOIN first_orders fo ON o.user_id = fo.user_id
WHERE o.payment_status = 'paid'
GROUP BY DATE_FORMAT(o.created_at, '%Y-%m')
ORDER BY month;

-- Q199: Rank vendors by composite score: (revenue×0.4)+(rating×0.3)+(fulfillment_speed×0.3).
WITH vendor_stats AS (
    SELECT
        v.id,
        v.store_name,
        SUM(oi.total_price)             AS total_revenue,
        ROUND(AVG(r.rating), 2)         AS avg_rating,
        ROUND(AVG(DATEDIFF(s.delivered_at, o.created_at)), 1) AS avg_fulfillment_days
    FROM vendors v
    LEFT JOIN order_items oi ON v.id          = oi.vendor_id
    LEFT JOIN orders      o  ON oi.order_id   = o.id
    LEFT JOIN products    p  ON oi.product_id = p.id
    LEFT JOIN reviews     r  ON p.id          = r.product_id
    LEFT JOIN shipments   s  ON o.id          = s.order_id AND s.vendor_id = v.id
    WHERE o.payment_status = 'paid'
    GROUP BY v.id, v.store_name
),
normalized AS (
    SELECT
        id, store_name, total_revenue, avg_rating, avg_fulfillment_days,
        (total_revenue - MIN(total_revenue) OVER ()) /
            NULLIF(MAX(total_revenue) OVER () - MIN(total_revenue) OVER (), 0) AS rev_score,
        avg_rating / 5.0 AS rat_score,
        1 - (avg_fulfillment_days - MIN(avg_fulfillment_days) OVER ()) /
            NULLIF(MAX(avg_fulfillment_days) OVER () - MIN(avg_fulfillment_days) OVER (), 0) AS speed_score
    FROM vendor_stats
    WHERE avg_fulfillment_days IS NOT NULL
)
SELECT
    id, store_name, total_revenue, avg_rating, avg_fulfillment_days,
    ROUND(rev_score * 0.4 + rat_score * 0.3 + speed_score * 0.3, 4) AS composite_score
FROM normalized
ORDER BY composite_score DESC;

-- Q200: Build the platform health-check CTE: GMV, AOV, take rate, refund rate,
--       abandonment rate, new vs returning — current vs last month.
WITH current_month AS (
    SELECT
        SUM(total_amount)       AS gmv,
        COUNT(*)                AS order_count,
        AVG(total_amount)       AS aov,
        SUM(discount_amount)    AS total_discount,
        SUM(tax_amount)         AS total_tax
    FROM orders
    WHERE payment_status = 'paid'
      AND YEAR(created_at)  = YEAR(NOW())
      AND MONTH(created_at) = MONTH(NOW())
),
last_month AS (
    SELECT
        SUM(total_amount)       AS gmv,
        COUNT(*)                AS order_count,
        AVG(total_amount)       AS aov
    FROM orders
    WHERE payment_status = 'paid'
      AND YEAR(created_at)  = YEAR(DATE_SUB(NOW(), INTERVAL 1 MONTH))
      AND MONTH(created_at) = MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH))
),
refund_stats AS (
    SELECT SUM(refund_amount) AS total_refunds
    FROM payments
    WHERE YEAR(created_at)  = YEAR(NOW())
      AND MONTH(created_at) = MONTH(NOW())
),
cart_stats AS (
    SELECT
        COUNT(*) AS total_carts,
        SUM(CASE WHEN status = 'abandoned' THEN 1 ELSE 0 END) AS abandoned_carts
    FROM carts
    WHERE YEAR(created_at)  = YEAR(NOW())
      AND MONTH(created_at) = MONTH(NOW())
),
new_vs_returning AS (
    SELECT
        COUNT(DISTINCT CASE WHEN first_order_month = current_order_month THEN user_id END) AS new_customers,
        COUNT(DISTINCT CASE WHEN first_order_month != current_order_month THEN user_id END) AS returning_customers
    FROM (
        SELECT
            user_id,
            DATE_FORMAT(created_at, '%Y-%m') AS current_order_month,
            DATE_FORMAT(MIN(created_at) OVER (PARTITION BY user_id), '%Y-%m') AS first_order_month
        FROM orders
        WHERE payment_status = 'paid'
          AND YEAR(created_at) = YEAR(NOW()) AND MONTH(created_at) = MONTH(NOW())
    ) sub
)
SELECT
    ROUND(cm.gmv, 2)                                            AS current_gmv,
    ROUND(lm.gmv, 2)                                            AS last_month_gmv,
    ROUND((cm.gmv - lm.gmv) / NULLIF(lm.gmv, 0) * 100, 2)    AS gmv_growth_pct,
    ROUND(cm.aov, 2)                                            AS current_aov,
    ROUND(lm.aov, 2)                                            AS last_month_aov,
    ROUND(rs.total_refunds / NULLIF(cm.gmv, 0) * 100, 2)       AS refund_rate_pct,
    ROUND(cs.abandoned_carts / NULLIF(cs.total_carts, 0) * 100, 2) AS cart_abandonment_pct,
    nvr.new_customers,
    nvr.returning_customers,
    ROUND(nvr.new_customers / NULLIF(nvr.new_customers + nvr.returning_customers, 0) * 100, 2) AS new_customer_pct
FROM current_month cm
CROSS JOIN last_month lm
CROSS JOIN refund_stats rs
CROSS JOIN cart_stats cs
CROSS JOIN new_vs_returning nvr;