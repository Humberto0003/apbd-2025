-- Otimização com Materialized Views
-- 1 Identificação do candidato / 2 Medir o custo (Baseline)


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

-- 3 Criação das MV

CREATE MATERIALIZED VIEW mv_top_clientes_ano AS
SELECT 
    oc.customer_unique_id,
    o.order_purchase_timestamp,
    oi.price,
    oi.freight_value
FROM orders o
JOIN order_customer oc 
    ON o.customer_id = oc.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id;

-- indice para acelerar filtros posteriores:
CREATE INDEX idx_mv_clientes_timestamp
    ON mv_top_clientes_ano(order_purchase_timestamp);

CREATE INDEX idx_mv_clientes_customer
    ON mv_top_clientes_ano(customer_unique_id);


-- 4 Usando a MV para recuperar o TOP 10

SELECT 
    customer_unique_id,
    COUNT(*) AS total_pedidos,
    SUM(price + freight_value) AS total_gasto
FROM mv_top_clientes_ano
WHERE order_purchase_timestamp BETWEEN '2017-01-01' AND '2026-01-01'
GROUP BY customer_unique_id
ORDER BY total_gasto DESC
LIMIT 10;

-- Analisando 

EXPLAIN ANALYZE
SELECT 
    customer_unique_id,
    COUNT(*) AS total_pedidos,
    SUM(price + freight_value) AS total_gasto
FROM mv_top_clientes_ano
WHERE order_purchase_timestamp BETWEEN '2017-01-01' AND '2018-01-01'
GROUP BY customer_unique_id
ORDER BY total_gasto DESC
LIMIT 10;

-- Fazendo o insert

INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
) VALUES (
    '00018f77f2f0320c557190d7a144bdd3',  
    99,                                  
    '00088930e925c41fd95ebfe695fd2655',  
    '001cca7ae9ae17fb1caed9dfb1094831', 
    NOW(),
    100000.90,
    39.90
);

-- Fazendo a atualização manual


REFRESH MATERIALIZED VIEW mv_top_clientes_ano;


SELECT order_id FROM orders LIMIT 2;
SELECT product_id FROM products LIMIT 2;
SELECT seller_id FROM order_sellers LIMIT 2;







