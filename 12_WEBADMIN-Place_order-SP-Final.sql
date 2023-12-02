
set serveroutput on;

-- Check if the sequence exists before creating it
DECLARE
  v_sequence_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_sequence_exists FROM user_sequences WHERE sequence_name = 'PAYMENT_ID_SEQ';
  
  IF v_sequence_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE payment_id_seq START WITH 1 INCREMENT BY 1';
  END IF;
END;
/

-- Check if the trigger exists before creating it
DECLARE
  v_trigger_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_trigger_exists FROM user_triggers WHERE trigger_name = 'UPDATE_PRODUCT_QUANTITY_TRIGGER';
  
  IF v_trigger_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE OR REPLACE TRIGGER update_product_quantity_trigger
      AFTER INSERT ON order_item
      FOR EACH ROW
      BEGIN
        UPDATE product
        SET quantity = quantity - :NEW.quantity
        WHERE product_id = :NEW.product_id;
      END;';
  END IF;
END;
/

-- Check if the trigger exists before creating it
DECLARE
  v_trigger_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_trigger_exists FROM user_triggers WHERE trigger_name = 'SET_PRODUCT_QUANTITY_TO_ZERO_TRIGGER';
  
  IF v_trigger_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE OR REPLACE TRIGGER set_product_quantity_to_zero_trigger
      BEFORE INSERT ON order_item
      FOR EACH ROW
      DECLARE
        v_product_quantity NUMBER;
      BEGIN
        SELECT quantity INTO v_product_quantity
        FROM product
        WHERE product_id = :NEW.product_id;

        IF (:NEW.quantity > v_product_quantity) THEN
          UPDATE product
          SET quantity = 0
          WHERE product_id = :NEW.product_id;
        END IF;
      END;';
  END IF;
END;
/

-- PL/SQL stored procedure to place an order
CREATE OR REPLACE PROCEDURE place_order(
    p_user_id IN NUMBER,
    p_product_id IN NUMBER,
    p_quantity IN NUMBER,
    p_order_date IN DATE,
    p_order_status IN VARCHAR2,
    p_house_no IN VARCHAR2,
    p_street IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_shipper_id IN NUMBER,
    p_payment_method IN VARCHAR2 -- Added payment_method as a parameter
) AS
  v_order_id NUMBER;
  v_subtotal NUMBER;
  v_payment_id NUMBER;
  v_product_quantity NUMBER;
BEGIN
  -- Check if product quantity is sufficient
  SELECT quantity INTO v_product_quantity
  FROM product
  WHERE product_id = p_product_id;

  IF v_product_quantity < p_quantity THEN
    -- Raise an exception if the product quantity is insufficient
    DBMS_OUTPUT.PUT_LINE('Inventory Out of Stock ');
    RETURN;
  END IF;

  -- Insert into orders table
  INSERT INTO orders (
    order_id,
    user_id,
    order_date,
    order_status,
    order_price,
    payment_ID,
    payment_method, -- Use the provided payment_method parameter
    house_no,
    street,
    city,
    state,
    shipper_id
  ) VALUES (
    order_id_seq.NEXTVAL,
    p_user_id,
    p_order_date,
    p_order_status,
    NULL, -- Set order_price to NULL initially
    payment_id_seq.NEXTVAL, -- Use sequence to generate payment_id
    p_payment_method, -- Set payment_method from the parameter
    p_house_no,
    p_street,
    p_city,
    p_state,
    p_shipper_id
  ) RETURNING order_id INTO v_order_id;

  -- Calculate subtotal for the order item
  SELECT (price * p_quantity) INTO v_subtotal
  FROM product
  WHERE product_id = p_product_id;

  -- Insert into order_item table with SUBTOTAL
  INSERT INTO order_item (
    order_id,
    product_id,
    quantity,
    subtotal,
    return_status,
    return_reason,
    return_quantity,
    refund_amount
  ) VALUES (
    v_order_id,
    p_product_id,
    p_quantity,
    v_subtotal, -- Set SUBTOTAL based on product price and quantity
    NULL, -- Set return_status to NULL initially
    NULL, -- Set return_reason to NULL initially
    NULL, -- Set return_quantity to NULL initially
    NULL  -- Set refund_amount to NULL initially
  );

  -- Update order_price in orders table based on the calculated subtotal
  UPDATE orders
  SET order_price = v_subtotal
  WHERE order_id = v_order_id;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Order placed successfully');
EXCEPTION
  WHEN OTHERS THEN
    -- Handle other exceptions here, if needed
    -- You can log the error or perform other actions
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END place_order;
/


GRANT EXECUTE ON place_order TO customer_role;

--Select * from order_item;
--select * from product;