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

-- Consulta 6: (Mal otimizada)
SELECT
    o.order_id,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    (o.order_delivered_customer_date - o.order_estimated_delivery_date) AS atraso
FROM orders o
WHERE 
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
    AND o.order_purchase_timestamp BETWEEN '2018-01-01' AND '2018-01-31'
    AND (o.order_delivered_customer_date > o.order_estimated_delivery_date)
ORDER BY atraso DESC
LIMIT 10;

-- Consulta 7: (Mal otimizada)
SELECT 
    oc.customer_unique_id,
    SUM(op.payment_value) AS total_gasto
FROM order_payments op
JOIN orders o 
    ON op.order_id = o.order_id
JOIN order_customer oc
    ON o.customer_id = oc.customer_id
GROUP BY oc.customer_unique_id
ORDER BY total_gasto DESC
LIMIT 10;

-- Consulta 8: (Mal otimizada)
SELECT
    oc.customer_state,
    AVG(o.order_delivered_customer_date - o.order_delivered_carrier_date) AS tempo_medio_entrega
FROM orders o
JOIN order_customer oc
    ON o.customer_id = oc.customer_id
WHERE 
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_delivered_carrier_date IS NOT NULL
GROUP BY oc.customer_state
ORDER BY tempo_medio_entrega DESC;

-- Consulta 9: (Mal otimizada)
SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    g.geolocation_lat AS lat_seller,
    g.geolocation_lng AS lon_seller,

    (
        6371 * acos(
            cos(radians(-23.5505)) 
            * cos(radians(g.geolocation_lat)) 
            * cos(radians(g.geolocation_lng) - radians(-46.6333))
            + sin(radians(-23.5505)) 
            * sin(radians(g.geolocation_lat))
        )
    ) AS distancia_km

FROM order_sellers s
JOIN geolocation g
    ON s.zip_code_prefix = g.geolocation_zip_code_prefix

WHERE 
    (
        6371 * acos(
            cos(radians(-23.5505)) 
            * cos(radians(g.geolocation_lat)) 
            * cos(radians(g.geolocation_lng) - radians(-46.6333))
            + sin(radians(-23.5505)) 
            * sin(radians(g.geolocation_lat))
        )
    ) <= 50

ORDER BY distancia_km;








