-- 1. LIMPEZA DE DADOS PROBLEMÁTICOS ANTES DAS FKs
DELETE FROM order_customer
WHERE zip_code_prefix NOT IN (
    SELECT geolocation_zip_code_prefix FROM geolocation
);

DELETE FROM orders
WHERE customer_id NOT IN (
    SELECT customer_id FROM order_customer
);

DELETE FROM order_items
WHERE order_id NOT IN (SELECT order_id FROM orders)
   OR product_id NOT IN (SELECT product_id FROM products)
   OR seller_id NOT IN (SELECT seller_id FROM order_sellers);

DELETE FROM order_reviews
WHERE order_id NOT IN (SELECT order_id FROM orders);

DELETE FROM order_payments
WHERE order_id NOT IN (SELECT order_id FROM orders);



-- 2. Criando indices unicos

CREATE INDEX idx_orders_customer_id
ON orders (customer_id);

CREATE INDEX idx_items_order_id
ON order_items (order_id);

CREATE INDEX idx_items_product_id
ON order_items (product_id);

CREATE INDEX idx_items_seller_id
ON order_items (seller_id);

CREATE INDEX idx_payments_order_id
ON order_payments (order_id);

CREATE INDEX idx_reviews_order_id
ON order_reviews (order_id);


-- 3. Resgrigindo valores negativos
ALTER TABLE products
ADD CONSTRAINT chk_product_weight_non_negative
CHECK (product_weight_g >= 0);

ALTER TABLE order_items
ADD CONSTRAINT chk_price_non_negative
CHECK (price >= 0);

ALTER TABLE order_items
ADD CONSTRAINT chk_freight_non_negative
CHECK (freight_value >= 0);

ALTER TABLE order_payments
ADD CONSTRAINT chk_payment_value_non_negative
CHECK (payment_value >= 0);

-- 4. Adicionando as FKs nas tabelas
-- order_customer -> gelocation
ALTER TABLE order_customer
ADD CONSTRAINT fk_order_customer_zip
FOREIGN KEY (zip_code_prefix)
REFERENCES geolocation (geolocation_zip_code_prefix)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- orders -> order-customer
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES order_customer (customer_id)
ON UPDATE CASCADE
ON DELETE SET NULL;


-- order_items -> orders
ALTER TABLE order_items
ADD CONSTRAINT fk_items_order
FOREIGN KEY (order_id)
REFERENCES orders (order_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- order_items -> products
ALTER TABLE order_items
ADD CONSTRAINT fk_items_product
FOREIGN KEY (product_id)
REFERENCES products (product_id)
ON UPDATE CASCADE
ON DELETE SET NULL;


-- order_items -> order_sellers
ALTER TABLE order_items
ADD CONSTRAINT fk_items_seller
FOREIGN KEY (seller_id)
REFERENCES order_sellers (seller_id)
ON UPDATE CASCADE
ON DELETE SET NULL;

-- order_payments -> orders
ALTER TABLE order_payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id)
REFERENCES orders (order_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- order_reviews -> orders
ALTER TABLE order_reviews
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id)
REFERENCES orders (order_id)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- procucts -> product_category_name_translation
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_name_translation (product_category_name)
ON UPDATE CASCADE
ON DELETE SET NULL;


