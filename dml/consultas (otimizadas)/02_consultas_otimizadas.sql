-- Consultas
-- Consulta 1: (Otimizada)

-- Indices para acelerar a busca
CREATE INDEX idx_order_items_seller ON order_items (seller_id);


CREATE INDEX idx_order_sellers_id ON order_sellers (seller_id);


CREATE INDEX idx_order_items_price ON order_items (price);

explain (analyze, BUFFERS)
WITH vendas AS (
    SELECT
        seller_id,
        price
    FROM order_items
    WHERE price > 0
)
SELECT
    s.seller_id,
    SUM(v.price) AS total_vendas
FROM vendas v
JOIN order_sellers s
    ON v.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_vendas DESC;

-- Consulta 2: (Otimizada)

-- Indices para acelerar a busca
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

CREATE INDEX idx_orders_purchase_timestamp ON orders (order_purchase_timestamp);

CREATE INDEX idx_order_items_order_id ON order_items (order_id);

CREATE INDEX idx_order_customer_unique_id ON order_customer (customer_unique_id);

SELECT 
    oc.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    SUM(oi.price + oi.freight_value) AS total_gasto
FROM orders o
JOIN order_customer oc 
    ON o.customer_id = oc.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp >= :inicio
  AND o.order_purchase_timestamp < :fim
GROUP BY oc.customer_unique_id
ORDER BY total_gasto DESC
LIMIT 10;

-- Consulta 3: (Otimizada)

CREATE INDEX idx_order_items_seller ON order_items (seller_id);

CREATE INDEX idx_order_items_order ON order_items (order_id);

CREATE INDEX idx_order_reviews_order ON order_reviews (order_id);

WITH reviews_por_order AS (
    SELECT 
        order_id,
        review_score
    FROM order_reviews
    WHERE review_score IS NOT NULL
),
vendas_com_reviews AS (
    SELECT
        oi.seller_id,
        r.review_score
    FROM order_items oi
    JOIN reviews_por_order r 
        ON oi.order_id = r.order_id
)
SELECT
    seller_id,
    ROUND(AVG(review_score), 2) AS media_avaliacao
FROM vendas_com_reviews
GROUP BY seller_id
ORDER BY media_avaliacao DESC;

-- Consulta 4: (otimizada)

-- Não foi necessário.
