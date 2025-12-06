CREATE OR REPLACE FUNCTION audit.fn_generic_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        EXECUTE format(
            'INSERT INTO audit.%I (operation, new_data, changed_by) VALUES ($1, $2, current_user)',
            TG_TABLE_NAME
        )
        USING 'I', to_jsonb(NEW);

    ELSIF TG_OP = 'UPDATE' THEN
        EXECUTE format(
            'INSERT INTO audit.%I (operation, old_data, new_data, changed_by) VALUES ($1, $2, $3, current_user)',
            TG_TABLE_NAME
        )
        USING 'U', to_jsonb(OLD), to_jsonb(NEW);

    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE format(
            'INSERT INTO audit.%I (operation, old_data, changed_by) VALUES ($1, $2, current_user)',
            TG_TABLE_NAME
        )
        USING 'D', to_jsonb(OLD);
    END IF;

    RETURN NULL;
END;
