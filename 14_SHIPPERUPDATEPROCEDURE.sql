SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE order_mgmt_pkg AS
    FUNCTION is_shipper_assigned(p_order_id IN NUMBER, p_shipper_id IN NUMBER) RETURN BOOLEAN;
    PROCEDURE update_order_status(p_order_id IN NUMBER, p_shipper_id IN NUMBER, p_new_status IN VARCHAR2);
END order_mgmt_pkg;
/

CREATE OR REPLACE PACKAGE BODY order_mgmt_pkg AS
    FUNCTION is_shipper_assigned(p_order_id IN NUMBER, p_shipper_id IN NUMBER) RETURN BOOLEAN IS
        v_shipper_assigned NUMBER;
    BEGIN
        SELECT 1
        INTO v_shipper_assigned
        FROM orders
        WHERE order_id = p_order_id
            AND shipper_id = p_shipper_id;

        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END is_shipper_assigned;

    PROCEDURE update_order_status(p_order_id IN NUMBER, p_shipper_id IN NUMBER, p_new_status IN VARCHAR2) IS
        v_user_id NUMBER;
    BEGIN
        IF is_shipper_assigned(p_order_id, p_shipper_id) THEN
            -- Shipper is assigned to the order, update the status
            UPDATE orders
            SET order_status = p_new_status
            WHERE order_id = p_order_id;

            DBMS_OUTPUT.PUT_LINE('Order status updated successfully.');
            COMMIT;
        ELSE
            -- Shipper is not assigned to the order
            DBMS_OUTPUT.PUT_LINE('Shipper is not assigned to this order.');
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Order not found.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END update_order_status;
END order_mgmt_pkg;
/
GRANT EXECUTE ON order_mgmt_pkg TO shipper_role;
--select * from orders;
--select * from users;

--select * from order_item;