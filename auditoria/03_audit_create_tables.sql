-- geolocation
CREATE TABLE audit.geolocation (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- order_customer
CREATE TABLE audit.order_customer (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- orders
CREATE TABLE audit.orders (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- products
CREATE TABLE audit.products (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- order_sellers
CREATE TABLE audit.order_sellers (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- order_items
CREATE TABLE audit.order_items (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- order_payments
CREATE TABLE audit.order_payments (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- order_reviews
CREATE TABLE audit.order_reviews (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);

-- product_category_name_translation
CREATE TABLE audit.product_category_name_translation (
    audit_id BIGSERIAL PRIMARY KEY,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT NOW(),
    changed_by TEXT,
    old_data JSONB,
    new_data JSONB
);
