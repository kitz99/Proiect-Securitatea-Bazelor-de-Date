-- F U N C T I O N S

-- Vulnerable function to verify login
CREATE OR REPLACE function login_v(em varchar, passwd varchar) RETURNS users AS $$
  declare
    cu users;
  BEGIN
  select * into cu
  from users where (email = em AND encrypted_password = crypt(passwd, encrypted_password));
  return cu::users;
  END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE function login_v(em varchar, passwd varchar) RETURNS integer AS $$
  declare
    cu integer;
    qry varchar;
    rez integer;
  BEGIN
  raise notice 'Value: %', em;
  qry = 'SELECT count(*) from users where email = ''' || em || ' '' AND encrypted_password = ' || 'crypt(' || passwd || ', encrypted_password);';
  raise notice 'Value: %', qry;
  EXECUTE qry;
  return cu;
  END
$$ LANGUAGE plpgsql;


'ELEARN_student2''--','Parola2')