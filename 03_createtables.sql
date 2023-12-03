-- Create sequences
SET SERVEROUTPUT ON;
DECLARE
  v_seq_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'USER_ID_SEQ';
  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE user_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;

  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'BRAND_ID_SEQ';
  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE brand_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;

  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'CATEGORY_ID_SEQ';
  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE category_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;

  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'PRODUCT_ID_SEQ';
  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE product_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;

  


  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'RATING_ID_SEQ';
  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE rating_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;

  SELECT COUNT(*) INTO v_seq_exists FROM user_sequences WHERE sequence_name = 'ORDER_ID_SEQ';
  IF v_seq_exists = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE order_id_seq START WITH 1 INCREMENT BY 1 MAXVALUE 1000000000';
  END IF;
END;
/

-- Create tables
DECLARE
  v_table_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'USERS';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE users (
        user_id NUMBER DEFAULT user_id_seq.NEXTVAL PRIMARY KEY,
        First_name VARCHAR(100),
        Last_name VARCHAR(100),
        Email VARCHAR(100),
        password VARCHAR(100),
        phone_number VARCHAR(100),
        user_type VARCHAR(100),
        House_no VARCHAR(100),
        street_address VARCHAR(100),
        city VARCHAR(100),
        state VARCHAR(100),
        zipcode VARCHAR(100),
        CONSTRAINT email_check CHECK (REGEXP_LIKE(Email, ''^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'')),
        CONSTRAINT phone_number_check CHECK (LENGTH(phone_number) = 10)
      )';
  END IF;

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'BRAND';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE brand (
        brand_id NUMBER DEFAULT brand_id_seq.NEXTVAL PRIMARY KEY,
        brand_name VARCHAR(100)
      )';
  END IF;

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'CATEGORY';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE category (
        category_ID NUMBER DEFAULT category_id_seq.NEXTVAL PRIMARY KEY,
        category_name VARCHAR(100),
        parent_category NUMBER(4),
        CONSTRAINT fk_parent_category
          FOREIGN KEY (parent_category)
          REFERENCES category(category_ID)
      )';
  END IF;

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'PRODUCT';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE product (
        product_id NUMBER DEFAULT product_id_seq.NEXTVAL PRIMARY KEY,
        product_name VARCHAR(100),
        description VARCHAR(100),
        price NUMBER(4),
        quantity NUMBER(4),
        category_ID NUMBER(4),
        brand_id NUMBER(4),
        seller_id NUMBER(4),
        CONSTRAINT fk_category_ID FOREIGN KEY(category_ID) REFERENCES category(category_ID),
        CONSTRAINT fk_brand_id FOREIGN KEY(brand_id) REFERENCES brand(brand_id),
        CONSTRAINT fk_seller_id FOREIGN KEY(seller_id) REFERENCES users(user_id)
      )';
  END IF;

 

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'SHIPPER';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE shipper (
        shipper_id NUMBER PRIMARY KEY,
        carrier VARCHAR(100)
      )';
  END IF;

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'RATINGS';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE ratings (
        rating_id NUMBER DEFAULT rating_id_seq.NEXTVAL PRIMARY KEY,
        product_id NUMBER,
        user_id NUMBER,
        rating NUMBER,
        CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(product_id),
        CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id)
      )';
  END IF;

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'ORDERS';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE orders (
        order_id NUMBER DEFAULT order_id_seq.NEXTVAL PRIMARY KEY,
        user_id NUMBER,
        order_date DATE,
        order_status VARCHAR(100),
        order_price NUMBER,
        payment_ID NUMBER,
        payment_method VARCHAR(100),
        house_no NUMBER,
        street VARCHAR(100),
        city VARCHAR(100),
        state VARCHAR(100),
        shipper_id NUMBER,
        CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
      )';
  END IF;

  SELECT COUNT(*) INTO v_table_exists FROM user_tables WHERE table_name = 'ORDER_ITEM';
  IF v_table_exists = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE TABLE order_item (
        order_id NUMBER,
        product_id NUMBER,
        quantity NUMBER,
        subtotal NUMBER,
        return_status VARCHAR(100),
        return_reason VARCHAR(100),
        return_quantity NUMBER,
        refund_amount NUMBER,
        CONSTRAINT fk_product_order_item FOREIGN KEY(product_id) REFERENCES product(product_id),
        CONSTRAINT fk_order_order_item FOREIGN KEY(order_id) REFERENCES orders(order_id)
      )';
  END IF;
END;
/

