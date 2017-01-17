INSERT INTO users (email, encrypted_password) values ("bogdan5@test.com", "159789")

INSERT INTO users (email, encrypted_password) VALUES ('user_de_test@emai.com','asdf');
UPDATE users set encrypted_password = 'this is new passwd' where email = 'user_de_test@emai.com';
DELETE FROM users where email = 'user_de_test@emai.com';
SELECT * FROM audit.logged_actions;