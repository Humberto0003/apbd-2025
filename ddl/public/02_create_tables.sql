
-- TABELA: geolocation

CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10) PRIMARY KEY,
    geolocation_lat NUMERIC(10,6),
    geolocation_lng NUMERIC(10,6),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);


-- TABELA: order_customer

CREATE TABLE order_customer (
    customer_id CHAR(32) PRIMARY KEY,
    customer_unique_id CHAR(32),
    zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)

);


-- TABELA: orders

CREATE TABLE orders (
    order_id CHAR(32) PRIMARY KEY,
    customer_id CHAR(32),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP

);


-- TABELA: products

CREATE TABLE products (
    product_id CHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);


-- TABELA: order_sellers

CREATE TABLE order_sellers (
    seller_id CHAR(32) PRIMARY KEY,
    zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)

);


-- TABELA: order_items

CREATE TABLE order_items (
    order_id CHAR(32),
    order_item_id INT,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)

);


-- TABELA: order_payments

CREATE TABLE order_payments (
    order_id CHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
    
);


-- TABELA: order_reviews

CREATE TABLE order_reviews (
    review_id CHAR(32) PRIMARY KEY,
    order_id CHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_create_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
 
);
