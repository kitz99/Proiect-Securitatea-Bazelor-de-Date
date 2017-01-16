INSERT INTO users (email, encrypted_password) values ("bogdan5@test.com", "159789")

select login_v('bogdan5@test.com', '159789');