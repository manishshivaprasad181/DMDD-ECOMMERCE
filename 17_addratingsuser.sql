SET SERVEROUTPUT ON;
BEGIN
    WEBADMIN.rate_product(p_user_id => 1, p_product_id => 3, p_rating => 3, p_order_id => 1);
    WEBADMIN.rate_product(p_user_id => 2, p_product_id => 4, p_rating => 4, p_order_id => 2);
    WEBADMIN.rate_product(p_user_id => 3, p_product_id => 2, p_rating => 3, p_order_id => 3);
    WEBADMIN.rate_product(p_user_id => 4, p_product_id => 5, p_rating => 5, p_order_id => 4);
    WEBADMIN.rate_product(p_user_id => 5, p_product_id => 1, p_rating => 1, p_order_id => 5);
END;
/
