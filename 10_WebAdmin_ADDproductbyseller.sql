set serveroutput on;
DECLARE
  v_seq_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'PRODUCT_ID_SEQ';

  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE product_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;
END;
/

-- Create a stored procedure for adding products
CREATE OR REPLACE PROCEDURE add_product(
  p_product_name VARCHAR2,
  p_description VARCHAR2,
  p_price NUMBER,
  p_quantity NUMBER,
  p_category_id NUMBER,
  p_brand_id NUMBER,
  p_seller_id NUMBER
) IS
  v_product_id NUMBER;
BEGIN
  -- Get the next value from the sequence
  SELECT product_id_seq.NEXTVAL INTO v_product_id FROM DUAL;

  -- Insert the new product into the product table
  INSERT INTO product (
    product_id,
    product_name,
    description,
    price,
    quantity,
    category_ID,
    brand_id,
    seller_id
  ) VALUES (
    v_product_id,
    p_product_name,
    p_description,
    p_price,
    p_quantity,
    p_category_id,
    p_brand_id,
    p_seller_id
  );

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Product added successfully. Product ID: ' || v_product_id || '   Product Name: ' || p_product_name);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error adding product: ' || SQLERRM);
END;
/


GRANT EXECUTE ON add_product TO seller_role;

--select * from users;
--select * from brand;
--select * from category;
--select * from product;