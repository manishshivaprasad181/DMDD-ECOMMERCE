set serveroutput on;

-- PL/SQL script to execute the place_order procedure as a 'customer_role'
DECLARE
  v_user_id NUMBER;
  v_product_id NUMBER;
  v_quantity NUMBER;
  v_order_date DATE;
  v_order_status VARCHAR2(100);
  v_house_no VARCHAR2(100);
  v_street VARCHAR2(100);
  v_city VARCHAR2(100);
  v_state VARCHAR2(100);
  v_shipper_id NUMBER;
  v_payment_method VARCHAR2(100); -- Added payment_method variable
BEGIN
  -- Set user-specific values
  v_user_id := 5; -- Replace with the actual user_id
  v_product_id := 1; -- Replace with the actual product_id
  v_quantity := 1; -- Change quantity to a value greater than the available quantity for testing
  v_order_date := SYSDATE;
  v_order_status := 'Pending';
  v_house_no := '123';
  v_street := 'Main Street';
  v_city := 'Cityville';
  v_state := 'Stateville';
  v_shipper_id := 11; -- Replace with the actual shipper_id
  v_payment_method := 'Cash'; -- Replace with the actual payment method
  
  WEBADMIN.place_order(2, 4, 4, SYSDATE, 'Pending', '67', '11th St', 'Boston', 'MA', 12, 'Cash');
  WEBADMIN.place_order(3, 2, 7, SYSDATE, 'Pending', '433', 'Parker St', 'Huntington', 'NY', 11, 'Debit Card');
  WEBADMIN.place_order(1, 3, 12, SYSDATE, 'Pending', '6', 'Lego Ave', 'Seattle', 'CA', 12, 'Cash');
  WEBADMIN.place_order(4, 1, 25, SYSDATE, 'Pending', '147', 'Peoples Road', 'Arlington', 'TX', 12, 'Credit Card');

  -- Call the place_order procedure
  BEGIN
    WEBADMIN.place_order(
      v_user_id,
      v_product_id,
      v_quantity,
      v_order_date,
      v_order_status,
      v_house_no,
      v_street,
      v_city,
      v_state,
      v_shipper_id,
      v_payment_method -- Pass payment_method as an argument
    );
    
    
  EXCEPTION
    WHEN OTHERS THEN
      -- Handle exceptions here, if needed
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;
END;
/