USE project_pertama;

-- =========================================================================
-- PHASE 4 : EXPLORATORY DATA ANALYSIS (EDA)
-- =========================================================================

-- =========================================================================
-- DATA OVERVIEW
-- =========================================================================

-- Total Customers
SELECT COUNT(DISTINCT customer_unique_id) AS total_customer
FROM customers;

-- Total Sellers
SELECT COUNT(DISTINCT seller_id) AS total_seller
FROM sellers;

-- Total Products
SELECT COUNT(DISTINCT product_id) AS total_product
FROM products;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_order
FROM orders;

-- Total Payments
SELECT COUNT(payment_sequential) AS total_payment
FROM payment;

-- Total Reviews
SELECT COUNT(review_id) AS total_review
FROM order_reviews;


-- =========================================================================
-- DISTRIBUTION ANALYSIS
-- =========================================================================

-- Payment Type Distribution
SELECT
    payment_type,
    COUNT(*) AS total_payment
FROM payment
GROUP BY payment_type
ORDER BY COUNT(*) DESC;

-- Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS jumlah
FROM orders
GROUP BY order_status
ORDER BY COUNT(*) DESC;

-- Review Score Distribution
SELECT
    review_score,
    COUNT(*) AS jumlah
FROM order_reviews
GROUP BY review_score
ORDER BY COUNT(*) DESC;

-- Customer Distribution by State
SELECT
    customer_state,
    COUNT(*) AS jumlah
FROM customers
GROUP BY customer_state
ORDER BY COUNT(*) DESC;

-- Seller Distribution by State
SELECT
    seller_state,
    COUNT(*) AS jumlah
FROM sellers
GROUP BY seller_state
ORDER BY COUNT(*) DESC;

-- Total Product Categories
SELECT
    COUNT(DISTINCT product_category_name) AS total_kategori
FROM products;


-- =========================================================================
-- NUMERICAL STATISTICS
-- =========================================================================

-- Most Expensive Order
SELECT
    order_id,
    price
FROM order_items
ORDER BY price DESC
LIMIT 1;

-- Cheapest Order
SELECT
    order_id,
    price
FROM order_items
ORDER BY price ASC
LIMIT 1;

-- Average Product Price
SELECT
    AVG(price) AS avg_price
FROM order_items;

-- Total Revenue
SELECT
    SUM(price) AS total_penghasilan
FROM order_items;

-- Revenue by Payment Type
SELECT
    payment_type,
    SUM(payment_value) AS total_penghasilan
FROM payment
GROUP BY payment_type;


-- =========================================================================
-- TOP 10 ANALYSIS
-- =========================================================================

-- Top 10 Sellers
SELECT
    seller_id AS top_10_seller,
    COUNT(order_item_id) AS product_terjual
FROM order_items
GROUP BY seller_id
ORDER BY COUNT(order_item_id) DESC
LIMIT 10;

-- Top 10 Product Categories
SELECT
    product_category_name,
    COUNT(*) AS total_terjual
FROM products
GROUP BY product_category_name
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Top 10 Most Purchased Orders
SELECT
    order_id,
    COUNT(*) AS total_terjual
FROM order_items
GROUP BY order_id
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Top 10 Customers
SELECT
    customer_unique_id,
    COUNT(customer_id) AS total_belanja
FROM customers
GROUP BY customer_unique_id
ORDER BY COUNT(customer_id) DESC
LIMIT 10;

-- Top 10 Customer States
SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Top 10 Seller States
SELECT
    seller_state,
    COUNT(*) AS total_seller
FROM sellers
GROUP BY seller_state
ORDER BY COUNT(*) DESC
LIMIT 10;


-- =========================================================================
-- BOTTOM 10 ANALYSIS
-- =========================================================================

-- Bottom 10 Sellers
SELECT
    seller_id AS bottom_10_seller,
    COUNT(order_item_id) AS product_terjual
FROM order_items
GROUP BY seller_id
ORDER BY COUNT(order_item_id) ASC
LIMIT 10;

-- Bottom 10 Product Categories
SELECT
    product_category_name,
    COUNT(*) AS total_terjual
FROM products
GROUP BY product_category_name
ORDER BY COUNT(*) ASC
LIMIT 10;

-- Bottom 10 Least Purchased Orders
SELECT
    order_id,
    COUNT(*) AS total_terjual
FROM order_items
GROUP BY order_id
ORDER BY COUNT(*) ASC
LIMIT 10;

-- Bottom 10 Customers
SELECT
    customer_unique_id,
    COUNT(customer_id) AS total_belanja
FROM customers
GROUP BY customer_unique_id
ORDER BY COUNT(customer_id) ASC
LIMIT 10;

-- Bottom 10 Customer States
SELECT
    customer_state,
    COUNT(*) AS total_belanja
FROM customers
GROUP BY customer_state
ORDER BY COUNT(*) ASC
LIMIT 10;

-- Bottom 10 Seller States
SELECT
    seller_state,
    COUNT(*) AS total_belanja
FROM sellers
GROUP BY seller_state
ORDER BY COUNT(*) ASC
LIMIT 10;


-- =========================================================================
-- TIME ANALYSIS
-- =========================================================================

-- Total Orders by Year
SELECT
    YEAR(order_purchase_timestamp) AS tahun,
    COUNT(order_id) AS jumlah_order
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY COUNT(order_id) DESC;

-- Total Orders by Month
SELECT
    YEAR(order_purchase_timestamp) AS tahun,
    MONTH(order_purchase_timestamp) AS bulan,
    MONTHNAME(order_purchase_timestamp) AS nama_bulan,
    COUNT(order_id) AS jumlah_order
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp),
    MONTHNAME(order_purchase_timestamp)
ORDER BY
    tahun ASC,
    bulan ASC;

-- Total Orders by Day
SELECT
    DAYNAME(order_purchase_timestamp) AS hari,
    COUNT(order_id) AS jumlah_order
FROM orders
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY COUNT(order_id) DESC;

-- Peak Order Hour
SELECT
    HOUR(order_purchase_timestamp) AS jam_beli,
    COUNT(order_id) AS jumlah_order
FROM orders
GROUP BY jam_beli
ORDER BY jumlah_order DESC;


-- =========================================================================
-- RELATIONSHIP ANALYSIS
-- =========================================================================

-- Top 10 Customers by Revenue
SELECT
    ors.customer_id,
    SUM(payment_value) AS total_spending
FROM customers c
INNER JOIN orders ors
    ON c.customer_id = ors.customer_id
INNER JOIN payment pt
    ON ors.order_id = pt.order_id
GROUP BY ors.customer_id
ORDER BY SUM(payment_value) DESC
LIMIT 10;

-- Orders with Highest Purchase Frequency
SELECT
    COUNT(order_id) AS jumlah_order_id,
    price,
    freight_value
FROM order_items
GROUP BY
    price,
    freight_value
ORDER BY jumlah_order_id DESC;

-- Jumlah Seller Aktif per Bulan
SELECT 
    COUNT(DISTINCT(seller_id)) AS jumlah_seller, 
    YEAR(shipping_limit_date) AS tahun, 
    MONTH(shipping_limit_date) AS bulan, 
    LAG(COUNT(DISTINCT seller_id), 1) OVER (ORDER BY MONTH(shipping_limit_date) ASC) AS seller_bulan_lalu
FROM order_items
WHERE YEAR(shipping_limit_date) = 2017
GROUP BY bulan, tahun
ORDER BY bulan ASC;

-- Total Revenue Berdasarkan Payment Type
SELECT 
    payment_type, 
    SUM(payment_value) AS total_revenue 
FROM payment 
GROUP BY payment_type;