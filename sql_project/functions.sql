-- F U N C T I O N S

-- Vulnerable function to verify login
CREATE OR REPLACE FUNCTION login_vn(em varchar, passwd varchar)
  RETURNS SETOF users AS
$func$
BEGIN
   RETURN QUERY EXECUTE
        'SELECT * FROM   users WHERE  email = ''' || em || ''' AND encrypted_password = crypt(''' || passwd || ''', encrypted_password)'
   USING em;
END
$func$  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION audit_login(user_id integer) RETURNS void AS
$func$
DECLARE
  time_now timestamp;
BEGIN
   SELECT now() into time_now;
   UPDATE users set last_sign_in_at=time_now, 
                    sign_in_count=sign_in_count + 1 
   WHERE id = user_id;
END
$func$  LANGUAGE plpgsql;


CREATE OR REPLACE function login_safe(em varchar, passwd varchar) RETURNS varchar AS $$
DECLARE
  nr_users integer;
  user_id integer;
BEGIN
  SELECT count(users.id), max(users.id) into nr_users, user_id FROM users 
  WHERE email = em AND encrypted_password = crypt(passwd, encrypted_password);

  IF nr_users <> 0 THEN
      EXECUTE audit_login(user_id);
      return 'Login success';
  ELSE
      return 'Login failed';
  END IF;
END
$$ LANGUAGE plpgsql;

SELECT login_safe('bogdan5@test.com', '159789');
SELECT * from users where email = 'bogdan5@test.com';

