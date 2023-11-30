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
    INSERT INTO users (
        user_id,
        First_name,
        Last_name,
        Email,
        password,
        phone_number,
        user_type,
        House_no,
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
        INSERT INTO SHIPPER (shipper_id, carrier)
        VALUES (v_user_id, p_first_name);
    END IF;

    COMMIT;
END insert_user;
/
GRANT EXECUTE ON  insert_user TO shipper_role;
GRANT EXECUTE ON  insert_user TO seller_role;
GRANT EXECUTE ON insert_user TO customer_role;


