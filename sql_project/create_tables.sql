﻿CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE EXTENSION pgcrypto;

SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

-- C R E A T E  T A B L E  U S E R S
-- ---------------------------------

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
CREATE SEQUENCE users_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE users_id_seq OWNED BY users.id;
ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


-- C R E A T E  T A B L E  R O L E S
-- ---------------------------------

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY roles ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
CREATE SEQUENCE roles_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE roles_id_seq OWNED BY roles.id;
ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);
CREATE INDEX index_roles_on_name ON roles USING btree (name);


-- C R E A T E  T A B L E  U S E R _ R O L E S
-- -------------------------------------------

CREATE TABLE users_roles (
    user_id integer,
    role_id integer
);
ALTER TABLE users_roles ADD CONSTRAINT compose_pk PRIMARY KEY(user_id, role_id);
CREATE INDEX index_users_roles_on_user_id_and_role_id ON users_roles USING btree (user_id, role_id);

-- C R E A T E  T A B L E  P R O D U C T S
-- ---------------------------------------

CREATE TABLE products (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    price double precision NOT NULL,
    image_url character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY products ADD CONSTRAINT products_pkey PRIMARY KEY (id);
CREATE SEQUENCE products_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE products_id_seq OWNED BY products.id;
ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);



-- C R E A T E  T A B L E  P R O D U C T S
-- ----------------------------------------

CREATE TABLE carts (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY carts ADD CONSTRAINT carts_pkey PRIMARY KEY (id);
CREATE SEQUENCE carts_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE carts_id_seq OWNED BY carts.id;
ALTER TABLE ONLY carts ALTER COLUMN id SET DEFAULT nextval('carts_id_seq'::regclass);


-- C R E A T E  T A B L E  U S E R S _ C A R T S
-- ----------------------------------------------
CREATE TABLE users_carts (
   user_id integer,
   cart_id integer
);
ALTER TABLE users_carts ADD CONSTRAINT compose_pk_users_carts PRIMARY KEY(user_id, cart_id);
CREATE INDEX index_users_carts_on_user_id_and_cart_id ON users_roles USING btree (user_id, cart_id);


-- C R E A T E  T A B L E  O R D E R S
--------------------------------------
CREATE TABLE orders (
    id integer NOT NULL,
    pay_type text,
    delivery_method text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
CREATE SEQUENCE orders_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE orders_id_seq OWNED BY orders.id;
ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


CREATE TABLE users_orders (
    user_id integer NOT NULL,
    order_id integer NOT NULL,
    total_price double precision NOT NULL,
    delivery_address text NOT NULL,
    delivered boolean default FALSE
);
ALTER TABLE ONLY users_orders ADD CONSTRAINT users_orders_pkey PRIMARY KEY (user_id, order_id);
CREATE INDEX index_users_orders_on_user_id_and_order_id ON users_orders USING btree (user_id, order_id);

-- C R E A T E  T A B L E  C A R T _ L I N E S
-- ----------------------------------------------
CREATE TABLE cart_lines (
    id integer NOT NULL,
    product_id integer,
    cart_id integer,
    quantity integer DEFAULT 1,
    order_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY cart_lines ADD CONSTRAINT cart_lines_pkey PRIMARY KEY (id);
ALTER TABLE ONLY cart_lines ALTER COLUMN id SET DEFAULT nextval('cart_lines_id_seq'::regclass);
CREATE SEQUENCE cart_lines_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE cart_lines_id_seq OWNED BY cart_lines.id;


CREATE TABLE order_lines (
    id integer NOT NULL,
    product_id integer,
    order_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
ALTER TABLE ONLY order_lines ADD CONSTRAINT order_lines_pkey PRIMARY KEY (id);
CREATE SEQUENCE order_lines_id_seq START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER TABLE ONLY order_lines ALTER COLUMN id SET DEFAULT nextval('orderlines_id_seq'::regclass);
ALTER SEQUENCE order_lines_id_seq OWNED BY order_lines.id;

GRANT INSERT ON products TO root;
GRANT DELETE ON products TO root;
GRANT UPDATE on products TO root;


REVOKE INSERT ON products FROM client;
REVOKE DELETE ON products FROM client;
REVOKE UPDATE on products FROM client;


