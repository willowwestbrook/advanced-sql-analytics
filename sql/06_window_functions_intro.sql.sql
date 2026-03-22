/* Using WINDOW function, find the total stock value (unit in stock*unit price in products) for each product from each supplier
(Supplier Name) and also the percenatge of the stock value of all the products supplied by each of the individual suppliers in the 
kcslmubu_specialty_food database (10 points)*/

/* partial example output
+ ---------------- + ------------- + ---------------------- + ------------------------- + ----------------------------- +
| ProductName      | supplier      | total_stock_value      | total_supplier_value      | product_stock_percentage      |
+ ---------------- + ------------- + ---------------------- + ------------------------- + ----------------------------- +
| Chartreuse verte | Aux joyeux ecclésiastiques | 1242.00   | 5721.50                   | 0.217076                      |
| Côte de Blaye    | Aux joyeux ecclésiastiques | 4479.50   | 5721.50                   | 0.782924                      |
| Laughing Lumberjack Lager | Bigfoot Breweries | 728.00    | 2642.00                   | 0.275549                      |
*/
# your query---


/* Using CTE and/or WINDOW functions, find the top 3 customers for each of the rental agencies in the kcslmubu_car_rental
database (15 points)*/
# your query ---


/* Using CTE and/or WINDOW functions, find the YoY percentage change in revenue for each rental agency,*/
# your query ---

#question 1
WITH ProductStock AS (
    SELECT 
        p.ProductName,
        s.CompanyName AS supplier,
        p.UnitsInStock * p.UnitPrice AS total_stock_value
    FROM kcslmubu_specialty_food.Products p
    JOIN kcslmubu_specialty_food.Suppliers s ON p.SupplierID = s.SupplierID
),
SupplierTotal AS (
    SELECT 
        supplier,
        SUM(total_stock_value) AS total_supplier_value
    FROM ProductStock
    GROUP BY supplier
)
SELECT 
    ps.ProductName,
    ps.supplier,
    ps.total_stock_value,
    st.total_supplier_value,
    ps.total_stock_value / NULLIF(st.total_supplier_value, 0) AS product_stock_percentage
FROM ProductStock ps
JOIN SupplierTotal st ON ps.supplier = st.supplier
ORDER BY ps.supplier, ps.total_stock_value DESC;

#question 2, car is linked to rental_agency via agency_id
WITH CustomerRevenue AS (
    SELECT 
        c.customer_id,
        CONCAT(c.customer_first_name, ' ', c.customer_last_name) AS customer_name,
        ra.agency_id AS rental_agency_id,
        ra.agency_name,
        SUM(p.amount) AS total_spent,
        RANK() OVER (PARTITION BY ra.agency_id ORDER BY SUM(p.amount) DESC) AS ranking
    FROM kcslmubu_car_rental.rental r
    JOIN kcslmubu_car_rental.customer c ON r.customer_id = c.customer_id
    JOIN kcslmubu_car_rental.car car ON r.car_VIN = car.VIN 
    JOIN kcslmubu_car_rental.rental_agency ra ON car.agency_id = ra.agency_id
    JOIN kcslmubu_car_rental.payment p ON r.rental_id = p.rental_id  
    GROUP BY c.customer_id, c.customer_first_name, c.customer_last_name, ra.agency_id, ra.agency_name
)
SELECT rental_agency_id, agency_name, customer_id, customer_name, total_spent, ranking
FROM CustomerRevenue
WHERE ranking <= 3
ORDER BY rental_agency_id, ranking;




#question 3
WITH RevenueByYear AS (
    SELECT 
        ra.agency_id AS rental_agency_id,
        ra.agency_name,
        YEAR(r.rental_date) AS year,
        SUM(p.amount) AS yearly_revenue
    FROM kcslmubu_car_rental.rental r
    JOIN kcslmubu_car_rental.car car ON r.car_VIN = car.VIN  
    JOIN kcslmubu_car_rental.rental_agency ra ON car.agency_id = ra.agency_id
    JOIN kcslmubu_car_rental.payment p ON r.rental_id = p.rental_id  
    GROUP BY ra.agency_id, ra.agency_name, YEAR(r.rental_date)
),
RevenueChange AS (
    SELECT 
        rental_agency_id,
        agency_name,
        year,
        yearly_revenue,
        LAG(yearly_revenue) OVER (PARTITION BY rental_agency_id ORDER BY year) AS prev_year_revenue
    FROM RevenueByYear
)
SELECT 
    rental_agency_id,
    agency_name,
    year,
    yearly_revenue,
    (yearly_revenue - prev_year_revenue) / NULLIF(prev_year_revenue, 0) * 100 AS yoy_percentage_change
FROM RevenueChange
ORDER BY rental_agency_id, year;
#confirmed car.agency_id as the link to rental_agency