CREATE TRIGGER trg_audit_geolocation
AFTER INSERT OR UPDATE OR DELETE ON geolocation
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_order_customer
AFTER INSERT OR UPDATE OR DELETE ON order_customer
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_products
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_order_sellers
AFTER INSERT OR UPDATE OR DELETE ON order_sellers
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_order_items
AFTER INSERT OR UPDATE OR DELETE ON order_items
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_order_payments
AFTER INSERT OR UPDATE OR DELETE ON order_payments
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_order_reviews
AFTER INSERT OR UPDATE OR DELETE ON order_reviews
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();

CREATE TRIGGER trg_audit_product_category_name_translation
AFTER INSERT OR UPDATE OR DELETE ON product_category_name_translation
FOR EACH ROW EXECUTE FUNCTION audit.fn_generic_audit();
