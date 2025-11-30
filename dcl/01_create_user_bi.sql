-- Criação de usuário
CREATE USER bi_user WITH PASSWORD 'TroqueParaUmaSenhaForte123!';

-- Permitir somente SELECT nas tabelas do schema public
GRANT SELECT ON public.geolocation TO bi_user;
GRANT SELECT ON public.orders TO bi_user;
GRANT SELECT ON public.order_customer TO bi_user;
GRANT SELECT ON public.order_payments TO bi_user;
GRANT SELECT ON public.order_items TO bi_user;
GRANT SELECT ON public.order_sellers TO bi_user;
GRANT SELECT ON public.order_reviews TO bi_user;
GRANT SELECT ON public.products TO bi_user;
GRANT SELECT ON public.product_category_name_translation TO bi_user;
