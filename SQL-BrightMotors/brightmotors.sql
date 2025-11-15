--Query to obtain an overview of data

SELECT * FROM car_analysis;

--Query to determine the lowest and highest selling price for cars sold

SELECT min(selling_price) AS lowest_sale_price, max(selling_price) AS highest_selling_price
FROM car_analysis;

--Query to determine lowest and highest car mileage
SELECT min(mileage) AS lowest_mileage, max(mileage) AS highest_mileage
FROM car_analysis;

-- Query to detect and replace missing values with 'None'
WITH car_analysis_new AS (
  SELECT sale_id,
  IFNULL(year,'None') AS year,
  IFNULL(make,'None') AS make,
  IFNULL(model,'None') AS model,
  IFNULL(body,'None') AS body,
  IFNULL(state,'None') AS state,
  IFNULL(color,'None') AS color,
  IFNULL(interior,'None') AS interior,
  IFNULL(mileage,'0') AS mileage,
  IFNULL(cost_of_sales,'None') AS cost_of_sales,
  IFNULL(selling_price,'0') AS selling_price,
  IFNULL(sale_date,'None')
  FROM car_analysis
  GROUP BY ALL
)
SELECT * FROM car_analysis;

-- Query to determine the relationship between price, mileage and manufacture year of car units sold

SELECT year AS manufacture_year,
COUNT(sale_id) AS total_sales,
round(AVG(selling_price),2) AS avg_price,
round(AVG(mileage),2) AS avg_mileage
FROM car_analysis
GROUP BY manufacture_year
ORDER BY manufacture_year DESC;

-- Query to detemine revenue by car make
SELECT make,
       model,
       SUM(selling_price) AS revenue
FROM car_analysis
GROUP BY make,model
ORDER BY revenue DESC;

--Query to determine revenue by car make
SELECT make, SUM(selling_price) AS revenue
FROM car_analysis
GROUP BY make
ORDER BY revenue DESC;

--Query to determine total units sold by location/state
SELECT state, COUNT(sale_id) AS total_units_sold
FROM car_analysis
GROUP BY state
ORDER BY total_units_sold DESC;

-- Query to determine revenue by model
SELECT DISTINCT make,model, 
       SUM(selling_price) AS revenue
FROM car_analysis
GROUP BY make,model
ORDER BY revenue DESC;

--to determine the earliest and most recent sale date
SELECT MIN(sale_date) AS earliest_sale_date, MAX(sale_date) AS recent_sale_date
FROM car_analysis;

SELECT * FROM car_analysis;

--to determine total revenue by state
SELECT DISTINCT make, ifnull(make,'Unknown'),
       state, ifnull(state,'Unknown'),
       SUM(selling_price) AS total_revenue
FROM car_analysis
GROUP BY make, state
ORDER BY total_revenue DESC;


--query to count the number of sales in each state
SELECT state,
COUNT(*),
ifnull(state,'Unknown')
FROM car_analysis
GROUP BY state;

--to count sales per make and model
SELECT make,model,
COUNT(*),
ifnull(make,'Unknown'),
ifnull(model,'Unknown')
FROM car_analysis
GROUP BY make,model
ORDER BY COUNT(*) DESC;

--query to determine average selling price by state

SELECT state,
 round(AVG(selling_price),2) AS avg_selling_price,
ifnull(state,'Unknown')
FROM car_analysis
GROUP BY state
ORDER BY avg_selling_price ASC;

--to extract the year, monthname and dayname from sale date
SELECT sale_date,
 YEAR(sale_date) AS year,
 MONTHNAME(sale_date) AS month,
 DAYNAME(sale_date) AS day
FROM car_analysis;

--to determine sales over time monthly
SELECT state,make,
 COUNT(*),
 year(sale_date) AS sale_year,
 monthname(sale_date) AS sale_month,
 round(avg(selling_price),2) AS average_selling_price
 FROM car_analysis
 GROUP BY state,make, sale_year, sale_month
 ORDER BY average_selling_price DESC;

-- to create a new table for revenue per make and model

--to create a new table for profit margin
SELECT state, make, round(sum(selling_price-cost_of_sales)/sum(selling_price)*100,2) as profit_margin,
year(sale_date) AS sale_year, monthname(sale_date) AS sale_month
FROM car_analysis
GROUP BY state, make, sale_year, sale_month
ORDER BY profit_margin DESC;

--Query for car price categorization

SELECT sale_id, make, model, selling_price,
CASE 
    WHEN selling_price < 25000 THEN 'Budget (<$25K)'
    WHEN selling_price BETWEEN 25000 AND 45000 THEN 'Mid-range ($25K-$45K)'
    WHEN selling_price BETWEEN 45000 AND 75000 THEN 'Premium ($45K-$75K)'
    ELSE 'Luxury (>$75K)'
  END AS price_category
FROM car_analysis
GROUP BY ALL
ORDER BY selling_price DESC;
