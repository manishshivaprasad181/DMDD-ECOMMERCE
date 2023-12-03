BEGIN
  FOR r IN (select sid,serial# from v$session where USERNAME in(
'CUSTOMER_USER'
))
  LOOP
      EXECUTE IMMEDIATE 'alter system kill session ''' || r.sid  || ',' 
        || r.serial# || ''' immediate';
  END LOOP;
END;
/
set serveroutput on
declare
    v_user_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start user cleanup');
   for i in (select USERNAME from all_users
WHERE USERNAME in(
'CUSTOMER_USER'
)
   )
   loop
   dbms_output.put_line('....Drop user '||i.USERNAME);
   begin
       select 'Y' into v_user_exists
       from all_users
       where USERNAME= i.USERNAME;

       v_sql := 'drop user '||i.USERNAME;
       execute immediate v_sql;
       dbms_output.put_line('........User '||i.USERNAME||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........User already dropped');
   end;
   end loop;
   dbms_output.put_line('User cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/




DECLARE
   v_user_exists VARCHAR(1) := 'N'; -- Initialize to 'N'
   v_sql VARCHAR(2000);
BEGIN
   -- Check if the user exists
   BEGIN
      SELECT 'Y' INTO v_user_exists FROM all_users WHERE USERNAME = 'CUSTOMER_ROLE';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         v_user_exists := 'N';
   END;

   -- If the user exists, drop it
   IF v_user_exists = 'Y' THEN
      v_sql := 'DROP USER CUSTOMER_ROLE';
      EXECUTE IMMEDIATE v_sql;
      dbms_output.put_line('User CUSTOMER_ROLE dropped successfully');
   ELSE
      dbms_output.put_line('User CUSTOMER_ROLE does not exist');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      dbms_output.put_line('Failed to execute code: ' || sqlerrm);
END;
/




--Role CLEANUP SCRIPT
set serveroutput on
declare
    v_role_exists varchar(1) := 'Y';
    v_sql varchar(2000);
begin
   dbms_output.put_line('Start role cleanup');
   for i in (select distinct role
from DBA_ROLES
where role in (
'CUSTOMER_USER')
   )
   loop
   dbms_output.put_line('....Drop role '||i.role);
   begin
       select 'Y' into v_role_exists
       from DBA_ROLES
       where role= i.role;

       v_sql := 'drop role '||i.role;
       execute immediate v_sql;
       dbms_output.put_line('........Role '||i.role||' dropped successfully');
       
   exception
       when no_data_found then
           dbms_output.put_line('........Role already dropped');
   end;
   end loop;
   dbms_output.put_line('Role cleanup successfully completed');
exception
   when others then
      dbms_output.put_line('Failed to execute code:'||sqlerrm);
end;
/

-- Create Roles

CREATE ROLE CUSTOMER_USER;

GRANT SELECT ON WEBADMIN.product TO CUSTOMER_USER;
GRANT  INSERT, SELECT, UPDATE ON WEBADMIN.ratings TO CUSTOMER_USER;
GRANT  INSERT, SELECT, UPDATE(First_name, Last_name, Email, password, phone_number, House_no, street_address, city, state, zipcode) ON WEBADMIN.users TO CUSTOMER_USER;
GRANT  INSERT, SELECT, UPDATE(house_no, street, city, state) ON WEBADMIN.orders TO CUSTOMER_USER;
GRANT  INSERT, SELECT, UPDATE(return_status, return_reason, return_quantity) ON WEBADMIN.order_item TO CUSTOMER_USER;








--Create Users

create user customer_role IDENTIFIED BY GCQiRbpWBk1q;
grant CUSTOMER_USER to customer_role;




Grant CREATE SESSION to  customer_role;

