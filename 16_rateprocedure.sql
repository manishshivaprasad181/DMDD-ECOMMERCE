SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE rate_product (
    p_user_id NUMBER,
    p_product_id NUMBER,
    p_rating NUMBER,
    p_order_id NUMBER
) AS
    v_order_status VARCHAR2(100);
BEGIN
    -- Check if the user has purchased the product
    SELECT o.order_status
    INTO v_order_status
    FROM orders o
    JOIN order_item oi ON o.order_id = oi.order_id
    WHERE o.user_id = p_user_id
      AND oi.product_id = p_product_id
      AND o.order_id = p_order_id;

    -- Validate if the order is delivered
    IF v_order_status = 'Delivered' THEN
        -- Validate if the rating is between 1 and 5
        IF p_rating >= 1 AND p_rating <= 5 THEN
            -- Insert the rating into the ratings table
            INSERT INTO ratings (product_id, user_id, rating)
            VALUES (p_product_id, p_user_id, p_rating);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Rating added successfully.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid rating. Please provide a rating between 1 and 5.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('You can only rate products from delivered orders.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid user, product, or order information.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END rate_product;
/


GRANT EXECUTE ON rate_product to customer_role;

--select * from orders;
--select * from order_item;