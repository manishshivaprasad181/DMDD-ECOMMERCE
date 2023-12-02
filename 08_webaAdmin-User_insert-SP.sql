SET serveroutput ON;

CREATE OR REPLACE PROCEDURE WEBADMIN.insert_user(
    p_first_name VARCHAR2,
    p_last_name VARCHAR2,
    p_email VARCHAR2,
    p_password VARCHAR2,
    p_phone_number VARCHAR2,
    p_user_type VARCHAR2,
    p_house_no VARCHAR2,
    p_street_address VARCHAR2,
    p_city VARCHAR2,
    p_state VARCHAR2,
    p_zipcode VARCHAR2
)
AS
    v_user_id NUMBER; -- Declare the variable for user_id
BEGIN
    -- Validation: Check if the specified 'first_name' and 'last_name' for the given 'user_type' already exist
    FOR existing_user IN (SELECT 1 FROM users WHERE first_name = p_first_name AND last_name = p_last_name AND user_type = p_user_type)
    LOOP
        DBMS_OUTPUT.PUT_LINE('User ' || p_first_name || ' ' || p_last_name || ' of type ' || p_user_type || ' already exists.');
        RETURN; -- Exit the procedure if the user already exists
    END LOOP;

    -- If the user doesn't exist, proceed with the insertion
    INSERT INTO users (
        user_id,
        first_name,
        last_name,
        email,
        password,
        phone_number,
        user_type,
        house_no,
        street_address,
        city,
        state,
        zipcode
    )
    VALUES (
        user_id_seq.NEXTVAL,
        p_first_name,
        p_last_name,
        p_email,
        p_password,
        p_phone_number,
        p_user_type,
        p_house_no,
        p_street_address,
        p_city,
        p_state,
        p_zipcode
    ) RETURNING user_id INTO v_user_id; -- Capture the generated user_id

    IF p_user_type = 'Shipper' THEN
        -- Insert into the 'SHIPPER' table
        INSERT INTO shipper (shipper_id, carrier)
        VALUES (v_user_id, p_first_name);
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('User ' || p_first_name || ' ' || p_last_name || ' of type ' || p_user_type || ' inserted successfully.');
END insert_user;
/

GRANT EXECUTE ON insert_user TO shipper_role;
GRANT EXECUTE ON insert_user TO seller_role;
GRANT EXECUTE ON insert_user TO customer_role;
