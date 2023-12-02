SET SERVEROUTPUT ON;

BEGIN

--WEBADMIN.add_product('Product_name', 'Product_desc', price, quantity, category_id, brand_id, seller_id)

  WEBADMIN.add_product('Mac Book', 'Apple Macbook M3 chip 8GB RAM 512 GB SSD', 2000, 30, 1, 1, 6);

  WEBADMIN.add_product('Puffer Jacket', 'High quality woolen jacket', 40, 15, 2, 2, 7);
  
  WEBADMIN.add_product('Trimmer', 'High quality Trimmer ', 70, 20, 3, 3, 10);
  
  WEBADMIN.add_product('Shades Galsses', 'High quality Shades ', 10, 100, 5, 4, 9);
  
END;
/
