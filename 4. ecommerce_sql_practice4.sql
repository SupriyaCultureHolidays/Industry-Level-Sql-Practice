
-- =================================
-- LEVEL 5 — ADVANCED SQL (Q141–Q170)
-- =================================

-- Q141 Use ROW_NUMBER() to find the single most recent order per user


-- Q142 Use RANK() to rank products by revenue within each category


-- Q143 Use LAG() to compare each month's revenue to the previous month


-- Q144 Use LEAD() to show each order and the timestamp of the same user's next order


-- Q145 Write a CTE to find users who placed orders in both Q1 and Q4 of the same year


-- Q146 Use a recursive CTE to traverse the full category hierarchy


-- Q147 Write a correlated subquery to find each product's revenue rank within its vendor's catalog


-- Q148 Use DENSE_RANK() to identify top-3 vendors by monthly revenue


-- Q149 Use conditional aggregation to pivot payment statuses into columns per month


-- Q150 Write a CTE chain to calculate the 7-day rolling average revenue per vendor


-- Q151 Use NTILE(4) to segment customers into revenue quartiles


-- Q152 Write a query using EXISTS to find products in both an active cart and a pending order


-- Q153 Use window functions to calculate the running total of revenue per vendor


-- Q154 Use FIRST_VALUE() to show the first product ever listed in each category


-- Q155 Write a correlated subquery to verify each order's total matches its order_items sum


-- Q156 Use PERCENT_RANK() to show where each product falls in the overall price distribution


-- Q157 Write a CTE + window function for the 3-month moving average of orders per category


-- Q158 Use CASE WHEN inside an aggregation to flag users as at-risk


-- Q159 Write a pivot-style query showing product revenue by month


-- Q160 Use a self-join on orders to find orders from the same user placed within 5 minutes


-- Q161 Write a query using multiple CTEs to build a funnel


-- Q162 Use window SUM to calculate each order's contribution % to user's lifetime spend


-- Q163 Write a NOT EXISTS subquery to find vendors with no orders in the last 30 days


-- Q164 Use ROW_NUMBER with PARTITION BY to keep only one review per user per product


-- Q165 Write a query to detect duplicate payments


-- Q166 Use CUME_DIST() to find the top 20% of customers by total spend


-- Q167 Write a CTE to calculate monthly churn


-- Q168 Use a subquery in FROM to pre-aggregate order_items


-- Q169 Write a query with a derived table to get the top 2 products sold per vendor


-- Q170 Use conditional aggregation to show order counts by status per vendor



-- =================================
-- LEVEL 6 — HARD PRODUCTION QUERIES (Q171–Q200)
-- =================================

-- Q171 Build a full cohort retention table


-- Q172 Detect payment fraud


-- Q173 Reconcile order totals


-- Q174 Build a real-time inventory dashboard


-- Q175 Build a vendor payout report


-- Q176 Detect fake review patterns


-- Q177 Build an order funnel query


-- Q178 Calculate LTV prediction


-- Q179 Identify flash sale abuse


-- Q180 Build a product co-purchase query


-- Q181 Write a multi-CTE vendor health score


-- Q182 Build an RFM segmentation query


-- Q183 Build a customer segmentation query using RFM


-- Q184 Detect products experiencing demand surge


-- Q185 Build a dynamic pricing signal query


-- Q186 Audit price integrity


-- Q187 Build an SLA breach report


-- Q188 Build a chargeback risk model


-- Q189 Detect inventory shrinkage


-- Q190 Build a demand forecast baseline


-- Q191 Detect account sharing


-- Q192 Analyze payment gateway_response JSON error codes


-- Q193 Build a supplier performance scorecard


-- Q194 Write an alert query for vendor SLA violations


-- Q195 Build a smart reorder suggestion query


-- Q196 Write a weekly active user (WAU) trend query


-- Q197 Identify revenue leakage


-- Q198 Build new vs returning customer revenue split


-- Q199 Rank vendors by composite performance score


-- Q200 Build the ultimate platform health-check query

