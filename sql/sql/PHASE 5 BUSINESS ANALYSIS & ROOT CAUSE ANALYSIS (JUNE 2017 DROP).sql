-- =========================================================================
-- PHASE 5: BUSINESS ANALYSIS & ROOT CAUSE ANALYSIS (JUNE 2017 DROP)
-- =========================================================================

-- 1. Total Revenue Per Tahun
SELECT 
    YEAR(shipping_limit_date) AS Tahun, 
    SUM(price) AS total_revenue 
FROM order_items
GROUP BY Tahun
ORDER BY Tahun ASC;


-- 2. Total Revenue Per Bulan Tahun 2017 (Melihat Trend MoM)
SELECT 
    Bulan,
    bulan_lalu,
    total_revenue,
    (total_revenue - bulan_lalu) AS selisih_revenue
FROM (
    SELECT 
        MONTH(shipping_limit_date) AS Bulan, 
        SUM(price) AS total_revenue,
        LAG(SUM(price), 1) OVER (ORDER BY MONTH(shipping_limit_date)) AS bulan_lalu
    FROM order_items
    WHERE YEAR(shipping_limit_date) = 2017
    GROUP BY MONTH(shipping_limit_date)
) AS tabel_bantu
ORDER BY Bulan ASC;

-- FINDING: Terjadi Penurunan Drastis Pada Bulan 6 (Juni 2017)


-- =========================================================================
-- DRILL DOWN 1: SELLER ANALYSIS
-- =========================================================================

-- Jumlah Seller Aktif Per Bulan (Tahun 2017)
SELECT 
    MONTH(shipping_limit_date) AS bulan, 
    LAG(COUNT(DISTINCT seller_id), 1) OVER (ORDER BY MONTH(shipping_limit_date) ASC) AS seller_bulan_lalu, 
    COUNT(DISTINCT seller_id) AS jumlah_seller
FROM order_items
WHERE YEAR(shipping_limit_date) = 2017
GROUP BY bulan
ORDER BY bulan ASC;

-- FINDING: Terjadi Penurunan Seller Aktif pada Bulan 6


-- =========================================================================
-- DRILL DOWN 2: GEOGRAPHIC ANALYSIS (CUSTOMER STATE)
-- =========================================================================

-- Total Revenue Per State (Bulan 5 vs Bulan 6 Tahun 2017)
WITH revenue_mei_juni AS (
    SELECT 
        c.customer_state,
        MONTH(oi.shipping_limit_date) AS bulan,
        SUM(oi.price) AS total_revenue
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE YEAR(oi.shipping_limit_date) = 2017 
      AND MONTH(oi.shipping_limit_date) IN (5, 6)
    GROUP BY c.customer_state, MONTH(oi.shipping_limit_date)
),
revenue_dengan_lag AS (
    SELECT 
        customer_state,
        bulan,
        total_revenue AS revenue_bulan_ini,
        LAG(total_revenue, 1) OVER (
            PARTITION BY customer_state 
            ORDER BY bulan ASC
        ) AS revenue_bulan_lalu
    FROM revenue_mei_juni
)
SELECT 
    customer_state,
    revenue_bulan_lalu AS omset_mei,
    revenue_bulan_ini AS omset_juni,
    (revenue_bulan_ini - revenue_bulan_lalu) AS selisih_penurunan,
    ROUND(((revenue_bulan_ini - revenue_bulan_lalu) / revenue_bulan_lalu) * 100, 2) AS persen_perubahan
FROM revenue_dengan_lag
WHERE bulan = 6
ORDER BY selisih_penurunan ASC; 

-- FINDING: Penurunan paling drastis di wilayah PR (-$13.381,59) dan SC (-$11.176,56)


-- =========================================================================
-- DRILL DOWN 3: PRODUCT CATEGORY ANALYSIS
-- =========================================================================

-- Total Revenue Per Kategori (Overall)
SELECT 
    product_category_name, 
    SUM(price) AS total_revenue 
FROM products p
INNER JOIN order_items ors ON p.product_id = ors.product_id
GROUP BY product_category_name
ORDER BY total_revenue DESC;


-- Total Revenue Per Kategori (Bulan 5 vs Bulan 6 Tahun 2017)
WITH revenue_mei_juni AS (
    SELECT 
        p.product_category_name,
        MONTH(oi.shipping_limit_date) AS bulan,
        SUM(oi.price) AS total_revenue
    FROM products p
    INNER JOIN order_items oi ON p.product_id = oi.product_id
    INNER JOIN orders o ON oi.order_id = o.order_id
    WHERE YEAR(oi.shipping_limit_date) = 2017 
      AND MONTH(oi.shipping_limit_date) IN (5, 6)
    GROUP BY p.product_category_name, MONTH(oi.shipping_limit_date)
),
revenue_dengan_lag AS (
    SELECT 
        product_category_name,
        bulan,
        total_revenue AS revenue_bulan_ini,
        LAG(total_revenue, 1) OVER (
            PARTITION BY product_category_name 
            ORDER BY bulan ASC
        ) AS revenue_bulan_lalu
    FROM revenue_mei_juni
)
SELECT 
    product_category_name,
    revenue_bulan_lalu AS omset_mei,
    revenue_bulan_ini AS omset_juni,
    (revenue_bulan_ini - revenue_bulan_lalu) AS selisih_penurunan,
    ROUND(((revenue_bulan_ini - revenue_bulan_lalu) / revenue_bulan_lalu) * 100, 2) AS persen_perubahan
FROM revenue_dengan_lag
WHERE bulan = 6
ORDER BY selisih_penurunan ASC;

-- FINDING: Kategori 'ferramentas_jardim' paling anjlok (-$11.700,91 / -43%) dan 'eletronicos' (-70%)


-- =========================================================================
-- DRILL DOWN 4: ORDER VOLUME & PRODUCT UNITS
-- =========================================================================

-- Total Volume Orderan Per Bulan (Tahun 2017)
SELECT 
    MONTH(shipping_limit_date) AS bulan, 
    COUNT(order_id) AS jumlah_order, 
    LAG(COUNT(order_id), 1) OVER (ORDER BY MONTH(shipping_limit_date) ASC) AS bulan_lalu 
FROM order_items
WHERE YEAR(shipping_limit_date) = 2017
GROUP BY bulan
ORDER BY bulan ASC;

-- FINDING: Penurunan Volume Orderan pada bulan 6 sebesar 9%


-- Penurunan Orderan Berdasarkan Kategori Produk (Mei vs Juni 2017)
SELECT 
    p.product_category_name,
    COUNT(CASE WHEN MONTH(oi.shipping_limit_date) = 5 THEN oi.order_id END) AS orderan_mei,
    COUNT(CASE WHEN MONTH(oi.shipping_limit_date) = 6 THEN oi.order_id END) AS orderan_juni,
    COUNT(CASE WHEN MONTH(oi.shipping_limit_date) = 6 THEN oi.order_id END) - 
    COUNT(CASE WHEN MONTH(oi.shipping_limit_date) = 5 THEN oi.order_id END) AS selisih_penurunan
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE YEAR(oi.shipping_limit_date) = 2017
GROUP BY p.product_category_name
ORDER BY selisih_penurunan ASC;

-- FINDING: Kategori 'esporte' (-71) dan 'telefonia' (-58) menurun drastis


-- Seller Aktif Per Bulan (Tahun 2017) - FIXED: Ditambahkan DISTINCT
SELECT 
    MONTH(shipping_limit_date) AS bulan, 
    COUNT(DISTINCT seller_id) AS jumlah_seller_aktif 
FROM order_items
WHERE YEAR(shipping_limit_date) = 2017
GROUP BY bulan
ORDER BY bulan ASC;

-- FINDING: Terjadi Penurunan seller aktif sebanyak 349 pada bulan 6


-- Penurunan Customer Per State (Mei vs Juni 2017) - FIXED: Ditambahkan Filter Tahun 2017
SELECT 
    customer_state,
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 5 THEN customer_unique_id END) AS customer_mei,
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 6 THEN customer_unique_id END) AS customer_juni,
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 6 THEN customer_unique_id END) - 
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 5 THEN customer_unique_id END) AS selisih_customer
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
WHERE YEAR(order_purchase_timestamp) = 2017
GROUP BY customer_state
ORDER BY selisih_customer ASC;

-- FINDING: State SP (São Paulo) menjadi wilayah dengan penurunan customer terbanyak


-- =========================================================================
-- DRILL DOWN 5: LOGISTICS PERFORMANCE & SATISFACTION (ROOT CAUSE)
-- =========================================================================

-- Analisis Rata-Rata Keterlambatan Pengiriman Per Bulan (Tahun 2017) - FIXED: Pake DATEDIFF
SELECT 
    MONTH(order_purchase_timestamp) AS bulan, 
    AVG(DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date)) AS rata_rata_keterlambatan_hari
FROM orders
WHERE YEAR(order_purchase_timestamp) = 2017
  AND order_delivered_customer_date IS NOT NULL
GROUP BY bulan
ORDER BY bulan ASC;


-- Analisis Rata-Rata Rating Per Bulan
SELECT 
    MONTH(order_purchase_timestamp) AS bulan, 
    AVG(review_score) AS rata_rata_rating 
FROM orders o
INNER JOIN order_reviews ors ON o.order_id = ors.order_id
WHERE YEAR(order_purchase_timestamp) = 2017
GROUP BY bulan
ORDER BY bulan ASC;


-- Analisis Kepuasan Customer Berdasarkan Waktu Pengiriman - FIXED: Pake DATEDIFF
SELECT 
    review_score, 
    COUNT(review_score) AS jumlah_rating, 
    AVG(DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date))as rata_keterlambatan_hari 
FROM orders
INNER JOIN order_reviews ON order_reviews.order_id = orders.order_id 
WHERE YEAR(order_delivered_customer_date) = 2017
  AND order_delivered_customer_date IS NOT NULL
GROUP BY review_score
ORDER BY review_score ASC;

-- FINDING: Rating 1 didominasi oleh pesanan yang rata-rata pengirimannya ngaret melebihi waktu estimasi


-- =========================================================================
-- DRILL DOWN 6: PAYMENT METHOD ANALYSIS
-- =========================================================================

-- Payment Type Distribution (Overall)
SELECT 
    payment_type, 
    COUNT(*) AS total_transactions 
FROM payment
GROUP BY payment_type;


-- Perubahan Payment Type (Mei vs Juni 2017) - FIXED: Ditambahkan Filter Tahun 2017
SELECT 
    payment_type,
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 5 THEN payment_type END) AS payment_mei,
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 6 THEN payment_type END) AS payment_juni,
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 6 THEN payment_type END) - 
    COUNT(CASE WHEN MONTH(order_purchase_timestamp) = 5 THEN payment_type END) AS selisih
FROM payment
INNER JOIN orders ON payment.order_id = orders.order_id
WHERE YEAR(order_purchase_timestamp) = 2017
GROUP BY payment_type
ORDER BY selisih ASC;

-- FINDING: Transaksi Credit Card turun drastis (-1.074) dibanding bulan lalu


-- =========================================================================
-- EXECUTIVE SUMMARY & CONCLUSION
-- =========================================================================
/*
 MENGAPA PERFORMA BISNIS MENURUN PADA MEI - JUNI 2017?

 1. Penyebab Utama (Logistik & Customer Satisfaction):
    - Waktu pengiriman paket yang mengalami keterlambatan melebihi batas estimasi.
    - Keterlambatan pengiriman ini berkorelasi langsung dengan pemberian Rating 1 oleh customer.

 2. Dampak Lanjutan (Market Impact):
    - Penurunan jumlah seller aktif (drop 349 seller di bulan Juni).
    - Penurunan jumlah customer transaksi (terutama di Wilayah SP, PR, dan SC).
    - Kategori produk paling terdampak: 'ferramentas_jardim', 'eletronicos', 'esporte', dan 'telefonia'.
    - Penurunan metode pembayaran Credit Card hingga -1.074 transaksi.

 3. Rekomendasi Solusi Business:
    - Meningkatkan SLA dan koordinasi dengan mitra kurir logistik agar pengiriman tepat waktu.
    - Memberikan insentif/program retensi bagi seller agar tidak pasif/churn.
*/