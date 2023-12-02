SET SERVEROUTPUT ON;
DECLARE
    v_order_id NUMBER := 1; -- replace with the actual order ID
    v_shipper_id NUMBER := 12; -- replace with the actual shipper ID
    v_shipper_assigned BOOLEAN;
BEGIN
    v_shipper_assigned := WEBADMIN.order_mgmt_pkg.is_shipper_assigned(v_order_id, v_shipper_id);

    IF v_shipper_assigned THEN
        DECLARE
            v_order_id NUMBER := 1; -- replace with the actual order ID
            v_shipper_id NUMBER := 12; -- replace with the actual shipper ID
            v_new_status VARCHAR2(100) := 'Delivered'; -- replace with the new status
        BEGIN
            WEBADMIN.order_mgmt_pkg.update_order_status(v_order_id, v_shipper_id, v_new_status);
            --WEBADMIN.order_mgmt_pkg.update_order_status(2, 11, 'Delivered');
        END;


    ELSE
        DBMS_OUTPUT.PUT_LINE('Shipper is not assigned to this order.');
    END IF;
END;
/
