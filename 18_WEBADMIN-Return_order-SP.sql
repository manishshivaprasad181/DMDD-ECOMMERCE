set serveroutput on;

CREATE OR REPLACE PROCEDURE return_order(p_user_id IN NUMBER, p_order_id IN NUMBER, p_return_reason IN VARCHAR2, p_return_quantity IN NUMBER)
IS
  v_product_id NUMBER;
  v_product_price NUMBER;
  v_current_quantity NUMBER;
  v_returned_quantity NUMBER;
  v_ordered_quantity NUMBER;
  v_user_order_count NUMBER;
  v_refund_amount NUMBER;
BEGIN
  -- Initialize variables
  v_product_id := NULL;
  v_product_price := NULL;
  v_current_quantity := NULL;
  v_returned_quantity := NULL;
  v_ordered_quantity := NULL;
  v_refund_amount := NULL;

  -- Check if the user has placed the order
  SELECT COUNT(*)
  INTO v_user_order_count
  FROM orders
  WHERE user_id = p_user_id AND order_id = p_order_id;

  IF v_user_order_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('User ' || p_user_id || ' has not placed Order ' || p_order_id);
    RETURN;
  END IF;

  -- Get the product_id, product price, and ordered quantity from the order_item table
  SELECT oi.product_id, p.price, oi.quantity as ordered_quantity
  INTO v_product_id, v_product_price, v_ordered_quantity
  FROM order_item oi
  JOIN product p ON oi.product_id = p.product_id
  WHERE oi.order_id = p_order_id
  AND ROWNUM = 1; -- Add this line to limit to one row

  -- Check if the product_id is found
  IF v_product_id IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Product not found for Order ' || p_order_id);
    RETURN;
  END IF;

  -- Check if the returned quantity is greater than the ordered quantity
  IF p_return_quantity > v_ordered_quantity THEN
    DBMS_OUTPUT.PUT_LINE('Returned quantity cannot be more than ordered quantity.');
    RETURN;
  END IF;

  -- Get the current quantity of the product in the product table
  SELECT quantity
  INTO v_current_quantity
  FROM product
  WHERE product_id = v_product_id
  AND ROWNUM = 1; -- Add this line to limit to one row

  -- Check if the product quantity is found
  IF v_current_quantity IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Product quantity not found for Product ' || v_product_id);
    RETURN;
  END IF;

  -- Get the total returned quantity for the order
  SELECT NVL(SUM(return_quantity), 0)
  INTO v_returned_quantity
  FROM order_item
  WHERE order_id = p_order_id;

  -- Calculate the refund amount
  v_refund_amount := v_product_price * p_return_quantity;

  -- Disable parallel execution for the following SQL statements
  PRAGMA AUTONOMOUS_TRANSACTION;

  -- Update the quantity in the product table with the returned quantity
  UPDATE /*+ NO_PARALLEL(product) */ product
  SET quantity = v_current_quantity + p_return_quantity
  WHERE product_id = v_product_id;

  -- Insert a new record in order_item for the return
  INSERT INTO order_item (order_id, product_id, quantity, return_status, return_reason, return_quantity, refund_amount)
  VALUES (p_order_id, v_product_id, 0, 'Returned', p_return_reason, p_return_quantity, v_refund_amount);

  -- Commit the transaction
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Order ' || p_order_id || ' returned successfully. Refund Amount: ' || v_refund_amount);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Order ' || p_order_id || ' not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK;
END return_order;
/


GRANT EXECUTE ON return_order TO customer_role;


--select * from ratings;
--select * from product;
--select * from order_item;