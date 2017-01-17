-- T R I G G E R  F U N C T I O N S
--
-- populate created at
CREATE OR REPLACE FUNCTION complete_created_at() RETURNS TRIGGER AS $$
  declare
  time_now timestamp;

  BEGIN
    SELECT now() into time_now;
    new.created_at = time_now;
    new.updated_at = time_now;
    return new;
        END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION complete_updated_at() RETURNS TRIGGER AS $$
  declare
  time_now timestamp;

  BEGIN
    SELECT now() into time_now;
    new.updated_at = time_now;
    return new;
        END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION complete_updated_at() RETURNS TRIGGER AS $$
  declare
  time_now timestamp;

  BEGIN
    SELECT now() into time_now;
    new.updated_at = time_now;
    return new;
        END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION hash_user_passwd() RETURNS TRIGGER AS $$
    BEGIN
        new.user_pwd = crypt(new.encrypted_password, gen_salt('bf', 8));
        return new;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_hash_password_trigger BEFORE INSERT OR UPDATE OF encrypted_password ON users
    FOR EACH ROW EXECUTE PROCEDURE encrypt_user_passwd();


-- U T I L S
-- dynamic query runner

CREATE OR REPLACE FUNCTION exec_query(qry varchar) RETURNS VOID AS $$
  BEGIN
   EXECUTE qry;
   end
$$ LANGUAGE plpgsql;

-- ADD TRIGGER TO ALL TABLES
SELECT exec_query( 'CREATE TRIGGER '
       || 'public_populate_created_at_on_'|| tab_name
       || ' BEFORE INSERT ON ' || tab_name_q
       || ' FOR EACH ROW EXECUTE PROCEDURE complete_created_at();') AS trigger_creation_query,
      exec_query( 'CREATE TRIGGER '
        || 'public_populate_updated_at_on_'|| tab_name
        || ' BEFORE UPDATE ON ' || tab_name_q
        || ' FOR EACH ROW EXECUTE PROCEDURE complete_updated_at();') AS trigger_creation_query
      exec_query('CREATE TRIGGER '
        || 'public_add_audit_trigger_on_'|| tab_name
        || ' AFTER INSERT OR UPDATE OR DELETE ON ' || tab_name_q
        || ' FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func();') as trigger_for_audit
FROM (
    SELECT
        quote_ident(table_schema) || '.' || quote_ident(table_name) as tab_name_q,
        quote_ident(table_schema) || '_' || quote_ident(table_name) as tab_name
    FROM
        information_schema.tables
    WHERE
        table_schema NOT IN ('pg_catalog', 'information_schema')
        AND table_schema NOT LIKE 'pg_toast%'
) as all_tables;


