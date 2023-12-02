SET SERVEROUTPUT ON;
BEGIN
    WEBADMIN.rate_product(p_user_id => 2, p_product_id => 4, p_rating => 3, p_order_id => 1);
  --WEBADMIN.rate_product(p_user_id => 5, p_product_id => 1, p_rating => 1, p_order_id => 2);
  
END;
/
