-- Consultas

--Consulta 1: (Mal otimizada)
explain (analyze, BUFFERS)
SELECT
    s.seller_id,
    SUM(oi.price) AS total_vendas
FROM order_items oi
JOIN order_sellers s
    ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_vendas DESC;

-- Consulta 2: (Mal otimizada)
-- É necessário por os parâmetros entre aspas.
SELECT 
    oc.customer_unique_id,
    COUNT(o.order_id) AS total_pedidos,
    SUM(oi.price + oi.freight_value) AS total_gasto
FROM orders o
JOIN order_customer oc 
    ON o.customer_id = oc.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp BETWEEN :inicio AND :fim
GROUP BY oc.customer_unique_id
ORDER BY total_gasto DESC
LIMIT 10;

-- Consulta 3: (Mal otimizada)
SELECT 
    s.seller_id,
    ROUND(AVG(r.review_score), 2) AS media_avaliacao
FROM order_sellers s
JOIN order_items oi 
    ON s.seller_id = oi.seller_id
JOIN order_reviews r 
    ON oi.order_id = r.order_id
GROUP BY s.seller_id
ORDER BY media_avaliacao DESC;

-- Consulta 4: (Mal otimizada)
SELECT 
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM orders o
WHERE o.order_purchase_timestamp 
      BETWEEN :inicio AND :fim;

-- Consulta 5: (Mal otimizada)
SELECT 
    oi.product_id,
    COUNT(*) AS quantidade_vendida
FROM order_items oi
JOIN orders o 
    ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp 
      BETWEEN :inicio AND :fim
GROUP BY oi.product_id
ORDER BY quantidade_vendida DESC
LIMIT 5;










