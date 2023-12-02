set serveroutput on;
--Top 5 Highest Spent Customers:
CREATE OR REPLACE VIEW top_spent_customers AS
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    SUM(o.order_price) AS total_spent
FROM
    users u
JOIN
    orders o ON u.user_id = o.user_id
GROUP BY
    u.user_id, u.first_name, u.last_name
ORDER BY
    total_spent DESC
FETCH FIRST 5 ROWS ONLY;



--Top Selling Products:
CREATE OR REPLACE VIEW top_selling_products AS
SELECT
    p.product_id,
    p.product_name,
    p.description,
    COUNT(oi.product_id) AS total_sold
FROM
    product p
JOIN
    order_item oi ON p.product_id = oi.product_id
GROUP BY
    p.product_id, p.product_name, p.description
ORDER BY
    total_sold DESC;


--Orders Shipped by Each Shipper:
CREATE OR REPLACE VIEW shipper_order_count AS
SELECT
    s.shipper_id,
    s.carrier,
    COUNT(o.order_id) AS total_orders_shipped
FROM
    shipper s
JOIN
    orders o ON s.shipper_id = o.shipper_id
GROUP BY
    s.shipper_id, s.carrier
ORDER BY
    total_orders_shipped DESC;


--Total Sales per Category:

CREATE OR REPLACE VIEW total_sales_per_category AS
SELECT
    c.category_id,
    c.category_name,
    SUM(p.price) AS total_sales
FROM
    category c
JOIN
    product p ON c.category_id = p.category_id
JOIN
    order_item oi ON p.product_id = oi.product_id
JOIN
    orders o ON oi.order_id = o.order_id
GROUP BY
    c.category_id, c.category_name
ORDER BY
    total_sales DESC;


  --Average Ratings per Product:
  CREATE OR REPLACE VIEW average_ratings_per_product AS
SELECT
    p.product_id,
    p.product_name,
    AVG(r.rating) AS average_rating
FROM
    product p
LEFT JOIN
    ratings r ON p.product_id = r.product_id
GROUP BY
    p.product_id, p.product_name
HAVING
    AVG(r.rating) IS NOT NULL
ORDER BY
    average_rating DESC;


--Orders Placed by Each User:

CREATE OR REPLACE VIEW orders_per_customer AS
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(o.order_id) AS total_orders_placed
FROM
    users u
LEFT JOIN
    orders o ON u.user_id = o.user_id
WHERE
    u.user_type = 'Customer'
GROUP BY
    u.user_id, u.first_name, u.last_name
ORDER BY
    total_orders_placed DESC;


    --Pending Orders:


    CREATE OR REPLACE VIEW pending_orders AS
SELECT
    order_id,
    user_id,
    order_date,
    order_status
FROM
    orders
WHERE
    order_status = 'Pending';


--Products with Low Stock:
CREATE OR REPLACE VIEW low_stock_products AS
SELECT
    product_id,
    product_name,
    quantity
FROM
    product
WHERE
    quantity < 20;
    
    
    
SELECT * FROM top_spent_customers;
SELECT * FROM top_selling_products;
SELECT * FROM shipper_order_count;
SELECT * FROM total_sales_per_category;
SELECT * FROM average_ratings_per_product;
SELECT * FROM orders_per_customer;
SELECT * FROM pending_orders;
SELECT * FROM low_stock_products;



--select * from users;