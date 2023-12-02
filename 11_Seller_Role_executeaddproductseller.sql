SET SERVEROUTPUT ON;

BEGIN
  WEBADMIN.add_product('Mac Book', 'Apple Macbook M3 chip 8GB RAM 512 GB SSD', 2000, 30, 1, 1, 6);

  WEBADMIN.add_product('Puffer Jacket', 'High quality woolen jacket', 70, 15, 2, 2, 7);
  
  WEBADMIN.add_product('Trimmer', 'High quality Trimmer ', 70, 20, 3, 3, 10);
  
  WEBADMIN.add_product('Shades Galsses', 'High quality Shades ', 10, 100, 5, 4, 9);
  
  WEBADMIN.add_product('Bathroom Cleaner', 'High quality bathroom Cleaner', 12, 15, 4, 5, 10);
END;
/
