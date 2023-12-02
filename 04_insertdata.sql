set serveroutput on;


-- Procedure to insert data into 'BRAND' table
CREATE OR REPLACE PROCEDURE insert_brand (
  p_brand_name VARCHAR2
) AS
  brand_count NUMBER;
BEGIN
  -- Check if p_brand_name already exists in 'BRAND' table
  SELECT COUNT(*) INTO brand_count FROM brand WHERE brand_name = p_brand_name;
  IF brand_count = 0 THEN
    INSERT INTO brand (brand_name) VALUES (p_brand_name);
  ELSE
    DBMS_OUTPUT.PUT_LINE(p_brand_name || ' already exists in BRAND table. Skipping insertion.');
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -955 THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ELSE
      RAISE;
    END IF;
END;
/



-- Procedure to insert data into 'CATEGORY' table
CREATE OR REPLACE PROCEDURE insert_category (
  p_category_name VARCHAR2,
  p_parent_category NUMBER
) AS
  category_count NUMBER;
BEGIN
  -- Check if p_category_name already exists in 'CATEGORY' table
  SELECT COUNT(*) INTO category_count FROM category WHERE category_name = p_category_name;
  IF category_count = 0 THEN
    BEGIN
      INSERT INTO category (category_name, parent_category) VALUES (p_category_name, p_parent_category);
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
          DBMS_OUTPUT.PUT_LINE('Parent category not present');
        ELSE
          RAISE;
        END IF;
    END;
  ELSE
    DBMS_OUTPUT.PUT_LINE(p_category_name || ' already exists in CATEGORY table. Skipping insertion.');
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -955 THEN
      RAISE;
    END IF;
END;
/

-- Call the 'insert_category' procedure with user input values
BEGIN
  --insert_brand('Brand_name');
  insert_brand('Apple');
  insert_brand('Zara');
  insert_brand('Kirkland');
  insert_brand('Philips');
  --(category, parent_category_Id) (Main categories will have NULL as the parent category)
  insert_category('Electronics', NULL);
  insert_category('Clothing', NULL);
  insert_category('Household', NULL);
  
  insert_category('Laptops', 1);
  insert_category('Jackets', 2);
  insert_category('Detergents', 3);
  insert_category('Vaaccum cleaners', 3);
END;
/


--select * from brand;
--select * from category;