USE project_pertama;

-- =========================================================================
-- PHASE 3: DATA PROFILING
-- =========================================================================

-- =========================================================================
-- 1. Table: sellers
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM sellers;

-- Check Duplicates
SELECT
    seller_id,
    COUNT(*) AS total_duplicate
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- =========================================================================
-- 2. Table: orders
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase_time,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_approved_at,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_carrier_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_customer_date,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated_date
FROM orders;

-- Check Duplicates
SELECT
    order_id,
    COUNT(*) AS total_duplicate
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- =========================================================================
-- 3. Table: products
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category_name,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_name_length,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_desc_length,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_photos_qty,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_weight,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS null_length,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_height,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_width
FROM products;

-- Check Duplicates
SELECT
    product_id,
    COUNT(*) AS total_duplicate
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Check Anomalies
SELECT
    product_id,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    CASE
        WHEN product_name_lenght < 1 THEN 'Error: Product Name'
        WHEN product_description_lenght < 1 THEN 'Error: Product Description'
        WHEN product_photos_qty < 1 THEN 'Error: Product Photos'
        WHEN product_weight_g < 1 THEN 'Error: Product Weight'
        WHEN product_length_cm < 1 THEN 'Error: Product Length'
        WHEN product_height_cm < 1 THEN 'Error: Product Height'
        WHEN product_width_cm < 1 THEN 'Error: Product Width'
    END AS data_aneh
FROM products
WHERE
    product_name_lenght < 1
    OR product_description_lenght < 1
    OR product_photos_qty < 1
    OR product_weight_g < 1
    OR product_length_cm < 1
    OR product_height_cm < 1
    OR product_width_cm < 1;


-- =========================================================================
-- 4. Table: customers
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM customers;

-- Check Duplicates
SELECT
    customer_id,
    COUNT(*) AS total_duplicate
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- =========================================================================
-- 5. Table: geolocation
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,
    SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS null_lat,
    SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS null_lng,
    SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM geolocation;


-- =========================================================================
-- 6. Table: order_items
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS null_item_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS null_shipping_limit,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight
FROM order_items;

-- Check Anomalies
SELECT order_id, price 
FROM order_items
WHERE price < 0 OR freight_value < 0; 


-- =========================================================================
-- 7. Table: order_reviews
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS null_review_id,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS null_score,
    SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS null_message,
    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS null_creation_date,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS null_answer_time
FROM order_reviews;

-- Check Duplicates
SELECT review_id, COUNT(*) 
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- Check Anomalies
SELECT order_id, review_score 
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5; 


-- =========================================================================
-- 8. Table: payment
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS null_sequential,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS null_type,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS null_installments,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_value
FROM payment;

-- Check Duplicates
SELECT order_id, COUNT(*) 
FROM payment
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT payment_sequential, COUNT(*) 
FROM payment
GROUP BY payment_sequential
HAVING COUNT(*) > 1;

-- Check Anomalies
SELECT 
    order_id, 
    payment_sequential, 
    payment_installments, 
    payment_value,
    CASE
        WHEN payment_sequential < 0 THEN 'Error Sequential'
        WHEN payment_installments < 0 THEN 'Error Installments'
        WHEN payment_value < 0 THEN 'Error Payment Value'
    END AS data_aneh
FROM payment
WHERE
    payment_sequential < 0
    OR payment_installments < 0
    OR payment_value < 0;


-- =========================================================================
-- 9. Table: product_category_translation
-- =========================================================================

-- Check Null Values
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN product_category_name_english IS NULL THEN 1 ELSE 0 END) AS null_category_en
FROM product_category_translation;

-- Check Duplicates 
SELECT product_category_name, COUNT(*) 
FROM product_category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;
