-- WINDOW FUNCTIONS --
/* We are interested in finding the film total by category and title without losing the 
information for either aggregate.  Need to use PARTITION BY */
WITH film_category_sales AS
    (SELECT 
        f.film_id, f.title, c.category_id, c.`name` AS `category`, SUM(`p`.`amount`) AS `total_sales`
      FROM
        (((((`payment` `p`
        JOIN `rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
        JOIN `inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `film` `f` ON ((`i`.`film_id` = `f`.`film_id`)))
        JOIN `film_category` `fc` ON ((`f`.`film_id` = `fc`.`film_id`)))
        JOIN `category` `c` ON ((`fc`.`category_id` = `c`.`category_id`)))
      GROUP BY f.film_id, f.title, c.category_id, c.`name`
      ORDER BY c.name, f.title ASC)
    
    SELECT title, category, total_sales,
      SUM(total_sales) OVER(PARTITION BY category) AS category_sales
    FROM film_category_sales
    ORDER BY category, title;


/* Use of ROW. list the customer orders in sequential order of the order date and create a row indicator to mark the order no.  1 should
be used for the oldest order */
SELECT 
       ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate) as RowNum, 
       OrderID, CustomerID, OrderDate
FROM Orders
WHERE CustomerID IN ('ALFKI', 'ANATR', 'ANTON')
ORDER BY CustomerID, OrderDate;

SELECT 
       ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY ShippedDate) as RowNum, 
       OrderID, CustomerID, OrderDate, ShippedDate, RequiredDate
FROM Orders
WHERE CustomerID IN ('ALFKI', 'ANATR', 'ANTON')
ORDER BY CustomerID, OrderDate;


/* show the ProductName, CategoryID, UnitPrice from specialty_food using with the RANK of each product based on its UnitPrice
Arrange from higher to lower */
SELECT ProductName, CategoryID, UnitPrice,
   RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC)  AS price_rank
FROM Products;

/* show the ProductName, CategoryID, UnitPrice from Specialty_Food using with the DENSE RANK of each product based on its UnitPrice
Arrange from higher to lower */
SELECT ProductName, CategoryID, UnitPrice,
   DENSE_RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice DESC)  AS price_rank
FROM Products;

/* Let us create a calculation where you need to calculate the total amount by customers (companies) and then express 
that as a percentage of the grand total. Use specialty_food database */ 
SELECT 
   CompanyName, 
   Quantity*UnitPrice*(1-Discount) AS order_amount,
   SUM(Quantity*UnitPrice*(1-Discount)) OVER(PARTITION BY CompanyName) AS order_per_company,
   ROUND(SUM(Quantity*UnitPrice*(1-Discount)) OVER(), 2) AS grand_total
   FROM Customers AS c
   JOIN Orders AS o ON c.CustomerID = o.CustomerID
   JOIN OrderDetails AS od ON o.OrderID = od.OrderID;


SELECT 
   CompanyName, 
   Quantity*UnitPrice*(1-Discount) AS order_amount,
   LAG(Quantity*UnitPrice*(1-Discount), 1, 0) OVER(PARTITION BY CompanyName) AS previous_order,
   SUM(Quantity*UnitPrice*(1-Discount)) OVER(PARTITION BY CompanyName) AS order_per_company,
   ROUND(SUM(Quantity*UnitPrice*(1-Discount)) OVER(), 2) AS grand_total
   FROM Customers AS c
   JOIN Orders AS o ON c.CustomerID = o.CustomerID
   JOIN OrderDetails AS od ON o.OrderID = od.OrderID;

-- SUM, AVG, RANK, DENSE_RANK, ROW_NUM(), LAG, LEAD
-- OVER PARTITION BY and ORDER BY.  

SELECT 
   CompanyName, 
   ROUND(Quantity*UnitPrice*(1-Discount), 2) AS order_amount,
   -- LAG(Quantity*UnitPrice*(1-Discount), 1, 0) OVER(PARTITION BY CompanyName) AS previous_order,
   ROUND(SUM(Quantity*UnitPrice*(1-Discount)) OVER(PARTITION BY CompanyName ORDER BY Quantity*UnitPrice*(1-Discount)),2) AS cum_order_by_company,
   ROUND(SUM(Quantity*UnitPrice*(1-Discount)) OVER(ORDER BY Quantity*UnitPrice*(1-Discount)),2) AS cum_running_total
   -- ROUND(SUM(Quantity*UnitPrice*(1-Discount)) OVER(), 2) AS grand_total
   FROM Customers AS c
   JOIN Orders AS o ON c.CustomerID = o.CustomerID
   JOIN OrderDetails AS od ON o.OrderID = od.OrderID;
