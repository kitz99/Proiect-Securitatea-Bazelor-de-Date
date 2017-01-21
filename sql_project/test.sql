INSERT INTO users (email, encrypted_password) values ("bogdan5@test.com", "159789")

INSERT INTO users (email, encrypted_password) VALUES ('user_de_test@emai.com','asdf');
UPDATE users set encrypted_password = 'this is new passwd' where email = 'user_de_test@emai.com';
DELETE FROM users where email = 'user_de_test@emai.com';

SELECT * FROM audit.logged_actions;

INSERT into orders values (5, 'cache', 'curier');
INSERT into orders values (6, 'card', 'posta');
INSERT into orders values (7, 'card', 'curier');
INSERT into orders values (8, 'cache', 'Ridicare personala');

INSERT into users_orders values (2, 5, 35.45, 'strada 1');
INSERT into users_orders values (9, 6, 85, 'strada 2');
INSERT into users_orders values (11, 7, 925.65, 'Home address');
INSERT into users_orders values (14, 8, 1585, 'not aplicable');


INSERT into products(name, description, price, image_url) values ('Apple watch', 'Lorem ipsum', '3600', 'http://ceas.jpg');
INSERT into products(name, description, price, image_url) values ('iphone', 'Lorem ipsum', '2100', 'http://iphone.jpg');
INSERT into products(name, description, price, image_url) values ('laptop', 'Lorem ipsum', '4400', 'http://laptop.jpg');
INSERT into products(name, description, price, image_url) values ('drona', 'Lorem ipsum', '1600', 'http://drona.jpg');
INSERT into products(name, description, price, image_url) values ('pix', 'Lorem ipsum', '15', 'http://pix.jpg');

SELECT apply_functions('avg');
SELECT apply_functions('sum');
SELECT apply_functions('count');



-- SQL INJECTION TESTS
-- Gain access without password
SELECT login_vn('g@h.com'';--','la la la');
-- Dump all users 
SELECT login_vn('g@h.com'' OR 1=1;--','la la la');

-- safe login
SELECT login_safe('bogdan5@test.com', '159789');


-- gain access to users payment method from search method:
SELECT cauta_produs_vuln('watch%'' UNION SELECT users.id::text || ''-->'' ||payment::text as payment from users where payment is not null;--''');
