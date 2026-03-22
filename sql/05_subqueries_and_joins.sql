-- USE kcslmubu_practice_database
# 1.0 
# 1.0 (5 points)
/* USING GROUP_CONCAT function, show the Product Name, total sales, and the regions where this product is sold 
from the table office_supplies.  The regions must be on the same line and the final result should be sorted by the 
total sales amount from the highest to the lowest. An example of the output is shown below.  
How would a decision maker use this information?
+---------------------------------------------------------------------------------+-------------+----------------------------+
| Product Name                                                                    | total_sales | regions                    |
+---------------------------------------------------------------------------------+-------------+----------------------------+
| Canon imageCLASS 2200 Advanced Copier                                           |  61599.8240 | Central, East, West        |
| Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind     |  27453.3840 | Central, East, South, West |
| Cisco TelePresence System EX90 Videoconferencing Unit                           |  22638.4800 | South                      |
| HON 5400 Series Task Chairs for Big and Tall                                    |  21870.5760 | Central, East, South, West |
| GBC DocuBind TL300 Electric Binding System                                      |  19823.4790 | Central, East, South       |
| Hewlett Packard LaserJet 3310 Copier                                            |  18839.6860 | Central, East, South, West |
| HP Designjet T520 Inkjet Large Format Printer - 24" Color                       |  18374.8950 | East, South                |
| GBC DocuBind P400 Electric Binding System                                       |  17965.0680 | Central, East, South, West |
| High Speed Automatic Electric Letter Opener                                     |  17030.3120 | Central, West              |
|+----------------------------------------------------------------------------------------------------------------------------
*/
select * from office_supplies;

select `Product Name`, SUM(Sales) as total_sales,
	group_concat(distinct Region order by Region separator ', ') as regions
FROM office_supplies
group by `Product Name`
order by total_sales DESC;

-- USE kcslmubu_specialy_food
# 2.0
/* Write the SQL to get the customer ID, customer name, country they are from, the total amount of order placed
   by each and the order as percentage of the grand total from the kcslmubu_specialty_food database. */

select * from kcslmubu_specialty_food;
USE kcslmubu_specialty_food;

SELECT 
    c.CustomerID, 
    c.CustomerName, 
    c.Country, 
    SUM(o.OrderAmount) AS total_order_amount,
    ROUND(SUM(o.OrderAmount) / (SELECT SUM(OrderAmount) FROM Orders) * 100, 2) AS order_percentage
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.CustomerID, c.CustomerName, c.Country
ORDER BY 
    total_order_amount DESC;


# 3.0 
/* Using JOIN write the sql to get the following information: 
total number of orders and revenue coming from each city and country combination. The result should be ordered by the
country and then by city within each country */
select * from kcslmubu_employeesdepartments;


#4.0 -- USE kcslmubu_employees
/* Using JOIN and/or subqueries, create a list of the employees who never held a managerial position.  The list should show
their names, department name, and the tenure in each department (start date and end date).  Use kala_sample_employee
table instead of the employee table to make the query go faster (the employee table is very large).*/


-- USE kcslmubu_bsan_6060_sakila
# 5.0 
/* Using JOIN and/or subqueries, write the sql to get the following information: 
customer names, the film title that they rented, the rental date, return date and the amount paid 
by each customer in the sakila database */


