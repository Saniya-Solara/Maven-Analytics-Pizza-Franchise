---------------------------------------------------------
-- Inspect tables to ensure correct creation and data integrity
---------------------------------------------------------
SELECT * FROM pizza_types;
SELECT * FROM pizzas;
SELECT * FROM orders;
SELECT * FROM order_details;

---------------------------------------------------------
-- TOPLINE METRICS
---------------------------------------------------------
-- Count total orders:
SELECT COUNT(*) AS total_orders
FROM orders;

-- Calculate total revenue:
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id;

-- Find the most expensive pizza: 
SELECT TOP 1 *
FROM pizzas
ORDER BY price DESC;

-- Determine most common pizza size:
SELECT TOP 1 size, COUNT(*) AS size_count
FROM pizzas
GROUP BY size
ORDER BY size_count DESC;

-- Top 5 pizzas by quantity: 
SELECT TOP 5 
    pt.name AS pizza_type, 
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC;

---------------------------------------------------------
-- CATEGORY & TIME ANALYTICS
---------------------------------------------------------
-- Distribution of orders by hour of the day:
SELECT 
DATEPART(HOUR, time) AS hour_of_day, 
COUNT(*) AS order_count
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY hour_of_day;

-- Category-wise distribution of pizzas:
SELECT pt.category AS pizza_category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- Average number of pizzas ordered per day:
SELECT date, AVG(total_quantity) AS average_pizzas_ordered_per_day
FROM (
    SELECT o.date, SUM(od.quantity) AS total_quantity
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.date
) AS daily_pizza_quantities
GROUP BY date;

--Top 3 most ordered pizza types based on revenue:
SELECT TOP 3
    pt.name AS pizza_type,
    SUM(od.quantity * p.price) AS revenue
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id
JOIN 
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 
    pt.name
ORDER BY 
    revenue DESC;

---------------------------------------------------------
--REVENUE & PERFORMANCE INSIGHTS
---------------------------------------------------------
-- Percentage contribution of each pizza type to total revenue:
SELECT pt.name AS pizza_type, 
       SUM(od.quantity * p.price) AS revenue,
       SUM(od.quantity * p.price) / 
       (SELECT SUM(od.quantity * p.price) FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id) * 100 AS percentage_contribution
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC;

-- Cumulative revenue over time:
WITH DailyRevenue AS (
    SELECT 
        CAST(o.date AS DATE) AS order_date,
        SUM(p.price * od.quantity) AS daily_sales
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY CAST(o.date AS DATE)
)
SELECT 
    order_date,
    daily_sales,
    SUM(daily_sales) OVER (ORDER BY order_date) AS cumulative_revenue
FROM DailyRevenue
ORDER BY order_date;

-- Top 3 pizzas by revenue within each category:
WITH PizzaRevenue AS (
    SELECT 
        pt.category AS pizza_category,
        pt.name AS pizza_type,
        SUM(od.quantity * p.price) AS revenue,
        ROW_NUMBER() OVER (PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS type_rank
    FROM 
        order_details od
    JOIN 
        pizzas p ON od.pizza_id = p.pizza_id
    JOIN 
        pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY 
        pt.category, pt.name
)
SELECT 
    pizza_category,
    pizza_type,
    revenue
FROM 
    PizzaRevenue
WHERE 
    type_rank <= 3;
