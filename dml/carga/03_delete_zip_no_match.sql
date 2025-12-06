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
