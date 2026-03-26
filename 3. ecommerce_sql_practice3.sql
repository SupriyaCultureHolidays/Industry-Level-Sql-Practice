-- ==============================
-- LEVEL 3 — JOINS (Q71–Q110)
-- ==============================

-- Q71 Join users, vendors, and products — show vendor name, store name, product count


-- Q72 Get all orders with customer name, email, order_number, and total_amount


-- Q73 List all order_items with product title, vendor store name, quantity, unit_price


-- Q74 Show all reviews with reviewer name, product title, rating, and review body


-- Q75 Join orders, payments, users — show orders with payment method and status


-- Q76 Retrieve all shipments with order_number, customer name, courier, and status


-- Q77 Show abandoned carts with customer name, total_amount, and product titles in cart


-- Q78 List products with category name, sub-category name, vendor name, and stock level


-- Q79 Join order_items and products to find revenue per product with vendor info


-- Q80 Show each vendor's total orders, total revenue, and average order value


-- Q81 Get all users who have never placed an order (use LEFT JOIN + NULL check)


-- Q82 List all products that are in active carts but have never been ordered


-- Q83 Show all orders with their shipment tracking number and estimated delivery date


-- Q84 Find customers who placed orders but have not yet received them


-- Q85 Join products and product_inventory to list items below reorder_level


-- Q86 Show all reviews with vendor replies, including product and vendor name


-- Q87 List all orders containing products from more than one vendor


-- Q88 Find products where the vendor is suspended but the product is still active


-- Q89 Show product title, vendor name, category, and revenue for featured products


-- Q90 Get the full order lifecycle: order → payment → shipment in one query


-- Q91 Show each category with count of active products and average price


-- Q92 List users who have purchased from at least 3 different product categories


-- Q93 Show the vendor with the highest-rated products (avg rating + product count)


-- Q94 Join carts and cart_items to find total active cart value per user


-- Q95 Show multi-item orders with a breakdown of items, vendors, and per-item totals


-- Q96 Verify that all reviews belong to actually purchased products


-- Q97 Show order totals alongside payment amounts to detect discrepancies


-- Q98 List all vendors with their approved_at date and orders received since then


-- Q99 Get users with role name, total orders, total spent, and account status


-- Q100 Find categories that have no products currently listed


-- Q101 Show all products with inventory status: in-stock / low-stock / out-of-stock


-- Q102 List shipments delivered earlier than estimated_delivery_date


-- Q103 Show customers who ordered, reviewed, and also have an active cart


-- Q104 Find orders that are paid but not yet shipped


-- Q105 Retrieve all vendors and the date of their most recent sale


-- Q106 Show order_items with return_status NOT NULL


-- Q107 Find the most popular product in each category


-- Q108 List all payments with refund_amount > 0


-- Q109 Join users, carts, cart_items to find average cart value per role


-- Q110 Show all products sold by inactive or suspended vendors



-- ==================================
-- LEVEL 4 — BUSINESS ANALYTICS (Q111–Q140)
-- ==================================

-- Q111 Calculate monthly revenue for the past 12 months with month-over-month growth %


-- Q112 Build a vendor performance report


-- Q113 Rank products within each category by total units sold — show top 3 per category


-- Q114 Calculate the total lost revenue from abandoned carts


-- Q115 Calculate refund rate per vendor and flag those above 10%


-- Q116 Identify top-selling categories by revenue


-- Q117 Find returning customers (users with 2+ orders)


-- Q118 Detect inventory alerts


-- Q119 Track average time between order status transitions


-- Q120 Calculate payment failure rate per gateway per month


-- Q121 Identify delayed shipments


-- Q122 Build a fraud detection query


-- Q123 Calculate customer lifetime value


-- Q124 Compute a rating score per product


-- Q125 Show a monthly cohort


-- Q126 Find products with high review volume but low average rating


-- Q127 Calculate average time between a user's registration and their first order


-- Q128 Identify peak shopping hours


-- Q129 Show the top 10 customers by GMV in the last 90 days


-- Q130 Calculate vendor commission earned per month


-- Q131 Show cart-to-order conversion rate by month


-- Q132 Identify products that were sold but are now inactive or deleted


-- Q133 Find customers who ordered, then went inactive for 90+ days


-- Q134 Show seasonal trends


-- Q135 Calculate ROI per category


-- Q136 Segment users into bronze / silver / gold tiers


-- Q137 Show daily unique buyers for the last 30 days


-- Q138 Compute first-order vs repeat-order revenue split


-- Q139 Find products with zero sales in the last 60 days


-- Q140 Show vendor growth: current month revenue vs same month last year


