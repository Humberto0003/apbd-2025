
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
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2),

    CONSTRAINT fk_customer_zip FOREIGN KEY (zip_code_prefix)
        REFERENCES geolocation(geolocation_zip_code_prefix)
);


-- TABELA: orders

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_aproved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,

    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
        REFERENCES order_customer(customer_id)
);


-- TABELA: products

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
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
    seller_id VARCHAR(50) PRIMARY KEY,
    zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2),

    CONSTRAINT fk_seller_zip FOREIGN KEY (zip_code_prefix)
        REFERENCES geolocation(geolocation_zip_code_prefix)
);


-- TABELA: order_items
-- (PK composta: order_id + order_item_id)

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),

    PRIMARY KEY (order_id, order_item_id),

    CONSTRAINT fk_item_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_item_product FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_item_seller FOREIGN KEY (seller_id)
        REFERENCES order_sellers(seller_id)
);


-- TABELA: order_payments
-- (PK composta: order_id + payment_sequential)

CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC(10,2),

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payment_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- TABELA: order_reviews

CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_create_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    CONSTRAINT fk_review_order FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);
