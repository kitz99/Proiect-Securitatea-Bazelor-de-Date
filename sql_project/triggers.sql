-- T R I G G E R  F U N C T I O N S
--
-- populate created at
-- set of triggers to populate created_at and updated at ---> audint changes in the table.
CREATE OR REPLACE FUNCTION complete_created_at() RETURNS TRIGGER AS $$
  declare
  time_now timestamp;

  BEGIN
    SELECT now() into time_now;
    new."created_at" = time_now;
    new."updated_at" = time_now;
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



-- trigger that hashes user's password for secure storage

CREATE OR REPLACE FUNCTION hash_user_passwd() RETURNS TRIGGER AS $$
    BEGIN
        new.encrypted_password = crypt(new.encrypted_password, gen_salt('bf', 8));
        return new;
    END;
$$ LANGUAGE plpgsql;

-- Create trigger to encrypt user's payment card number
-- card number will be encrypted with blow-fish-cbc with padding for secure storage
CREATE OR REPLACE FUNCTION encrypt_user_payment() RETURNS TRIGGER AS $$
  DECLARE
  enc bytea;
  BEGIN
    SELECT encrypt(new.payment::bytea, new.encrypted_password::bytea, 'bf-cbc/pad:pkcs'::text) into enc;
    new.payment = enc;
    return new;
  END
$$ LANGUAGE plpgsql;
ALTER TABLE users ADD COLUMN payment varchar(255);
CREATE TRIGGER users_encrypt_payment_trigger_bf BEFORE UPDATE OF payment ON users
  FOR EACH ROW EXECUTE PROCEDURE encrypt_user_payment();


-- create function to decrypt payment method for user
CREATE OR REPLACE FUNCTION decrypt_user_payment(user_id integer) RETURNS TEXT AS $$
  BEGIN
    return (SELECT decrypt(payment::bytea, users.encrypted_password::bytea, 'bf-cbc/pad:pkcs'::text) FROM USERS where id = user_id);
  END
$$ LANGUAGE plpgsql;



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
        || ' FOR EACH ROW EXECUTE PROCEDURE complete_updated_at();') AS trigger_creation_query,
      exec_query('CREATE TRIGGER '
        || 'public_add_audit_trigger_on_'|| tab_name
        || ' AFTER INSERT OR UPDATE OR DELETE ON ' || tab_name_q
        || ' FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func();') as trigger_for_audit,
      exec_query('CREATE TRIGGER '
        || 'public_add_audit__root_trigger_on_'|| tab_name
        || ' AFTER INSERT OR UPDATE OR DELETE ON ' || tab_name_q
        || ' FOR EACH ROW EXECUTE PROCEDURE audit.root_actions();') as trigger_for_audit
FROM (
    SELECT
        quote_ident(table_schema) || '.' || quote_ident(table_name) as tab_name_q,
        quote_ident(table_schema) || '_' || quote_ident(table_name) as tab_name
    FROM
        information_schema.tables
    WHERE
        table_schema NOT IN ('pg_catalog', 'information_schema, audit')
        AND table_schema NOT LIKE 'pg_toast%'
) as all_tables;


