-- 1. STAGING: geolocation

CREATE TABLE staging.geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat TEXT,
    geolocation_lng TEXT,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- 2. STAGING: order_customer

CREATE TABLE staging.order_customer (
    customer_id TEXT,
    customer_unique_id TEXT,
    zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);

-- 3. STAGING: orders

CREATE TABLE staging.orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_aproved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT
);

-- 4. STAGING: products

CREATE TABLE staging.products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_length TEXT,
    product_description_length TEXT,
    product_photos_qty TEXT,
    product_weight_g TEXT,
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT
);

-- 5. STAGING: order_sellers

CREATE TABLE staging.order_sellers (
    seller_id TEXT,
    zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);

-- 6. STAGING: order_items

CREATE TABLE staging.order_items (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT
);

-- 7. STAGING: order_payments

CREATE TABLE staging.order_payments (
    order_id TEXT,
    payment_sequential TEXT,
    payment_type TEXT,
    payment_installments TEXT,
    payment_value TEXT
);

-- 8. STAGING: order_reviews

CREATE TABLE staging.order_reviews (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_create_date TEXT,
    review_answer_timestamp TEXT
);
