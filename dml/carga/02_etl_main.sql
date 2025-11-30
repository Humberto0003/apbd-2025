-- Tabela: geolocation

INSERT INTO geolocation (
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
WITH dedup AS (
    SELECT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state,
        ROW_NUMBER() OVER (
            PARTITION BY geolocation_zip_code_prefix
            ORDER BY geolocation_lat
        ) AS rn
    FROM staging.geolocation
)
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat::NUMERIC(10,6),
    geolocation_lng::NUMERIC(10,6),
    initcap(translate(regexp_replace(geolocation_city, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc')),
    upper(geolocation_state)
FROM dedup
WHERE rn = 1;

-- Tabela: order_customer

INSERT INTO order_customer (
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    customer_city,
    customer_state
)
WITH dedup AS (
    SELECT
        customer_id,
        customer_unique_id,
        zip_code_prefix,
        customer_city,
        customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY customer_unique_id
        ) AS rn
    FROM staging.order_customer
)
SELECT
    customer_id,
    customer_unique_id,
    LPAD(zip_code_prefix, 5, '0'),
    initcap(
        translate(
            convert_from(convert_to(customer_city, 'LATIN1'), 'UTF8'),
            'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç',
            'AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc'
        )
    ),
    upper(customer_state)
FROM dedup
WHERE rn = 1;

-- Tabela: order_items

INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
WITH dedup AS (
    SELECT
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        ROW_NUMBER() OVER (
            PARTITION BY order_id, order_item_id
            ORDER BY price DESC NULLS LAST
        ) AS rn
    FROM staging.order_items
)
SELECT
    order_id,
    NULLIF(order_item_id, '')::INT,
    product_id,
    seller_id,
    NULLIF(shipping_limit_date, '')::timestamp,
    NULLIF(price, '')::NUMERIC(10,2),
    NULLIF(freight_value, '')::NUMERIC(10,2)
FROM dedup
WHERE rn = 1;

-- Tabela: order_payments

INSERT INTO order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
WITH dedup AS (
    SELECT
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value,
        ROW_NUMBER() OVER (
            PARTITION BY order_id, payment_sequential
            ORDER BY payment_value DESC NULLS LAST
        ) AS rn
    FROM staging.order_payments
)
SELECT
    order_id,
    NULLIF(payment_sequential, '')::INT,
    lower(translate(regexp_replace(payment_type, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc')),
    NULLIF(payment_installments, '')::INT,
    NULLIF(payment_value, '')::NUMERIC(10,2)
FROM dedup
WHERE rn = 1;

-- Tabela order_reviews

INSERT INTO order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_create_date,
    review_answer_timestamp
)
WITH dedup AS (
    SELECT
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_create_date,
        review_answer_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY review_id
            ORDER BY review_create_date DESC NULLS LAST
        ) AS rn
    FROM staging.order_reviews
)
SELECT
    review_id,
    order_id,
    NULLIF(review_score, '')::INT,
    initcap(translate(regexp_replace(review_comment_title, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc')),
    translate(regexp_replace(review_comment_message, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc'),
    NULLIF(review_create_date, '')::timestamp,
    NULLIF(review_answer_timestamp, '')::timestamp
FROM dedup
WHERE rn = 1;

-- Tabela: order_sellers

INSERT INTO order_sellers (
    seller_id,
    zip_code_prefix,
    seller_city,
    seller_state
)
WITH dedup AS (
    SELECT
        seller_id,
        zip_code_prefix,
        seller_city,
        seller_state,
        ROW_NUMBER() OVER (
            PARTITION BY seller_id 
            ORDER BY zip_code_prefix
        ) AS rn
    FROM staging.order_sellers
)
SELECT
    seller_id,
    LPAD(zip_code_prefix, 5, '0'),
    initcap(
        translate(
            regexp_replace(seller_city, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
            'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç',
            'AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc'
        )
    ),
    upper(seller_state)
FROM dedup
WHERE rn = 1;

-- Tabela: orders

INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
WITH dedup AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_aproved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY order_purchase_timestamp
        ) AS rn
    FROM staging.orders
)
SELECT
    order_id,
    customer_id,
    lower(translate(regexp_replace(order_status, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc')),
    NULLIF(order_purchase_timestamp, '')::timestamp,
    NULLIF(order_aproved_at, '')::timestamp,
    NULLIF(order_delivered_carrier_date, '')::timestamp,
    NULLIF(order_delivered_customer_date, '')::timestamp,
    NULLIF(order_estimated_delivery_date, '')::timestamp
FROM dedup
WHERE rn = 1;

-- Tabela: product_category_name_translation

INSERT INTO product_category_name_translation (
    product_category_name,
    product_category_name_english
)
WITH dedup AS (
    SELECT
        product_category_name,
        product_category_name_english,
        ROW_NUMBER() OVER (
            PARTITION BY product_category_name
            ORDER BY product_category_name_english
        ) AS rn
    FROM staging.product_category_name_translation
)
SELECT
    lower(translate(regexp_replace(product_category_name, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc')),
    initcap(translate(regexp_replace(product_category_name_english, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc'))
FROM dedup
WHERE rn = 1;

-- Tabela: products

INSERT INTO products (
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
WITH dedup AS (
    SELECT
        product_id,
        product_category_name,
        product_name_length,
        product_description_length,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY product_name_length DESC NULLS LAST
        ) AS rn
    FROM staging.products
)
SELECT
    product_id,
    lower(translate(regexp_replace(product_category_name, '[^\x20-\x7EÀ-ÿ ]', '', 'g'),
        'ÁÀÃÂáàãâÉÈÊéèêÍÌíìÓÒÕÔóòõôÚÙÜúùüÇç','AAAAaaaaEEEeeeIIiiOOOOooooUUUuuuCc')),
    NULLIF(product_name_length, '')::INT,
    NULLIF(product_description_length, '')::INT,
    NULLIF(product_photos_qty, '')::INT,
    NULLIF(product_weight_g, '')::INT,
    NULLIF(product_length_cm, '')::INT,
    NULLIF(product_height_cm, '')::INT,
    NULLIF(product_width_cm, '')::INT
FROM dedup
WHERE rn = 1;

