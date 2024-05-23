
/* Query 1: Design a query to examine the distribution of hardware solution orders by location, 
 * identifying areas with the highest demand for specific products or categories. */
SELECT c.city, pc.name AS category, COUNT(*) AS order_count
FROM client c
JOIN project p ON c.id = p.client_id
JOIN product pr ON p.product_id = pr.id
JOIN product_category pc ON pr.category_id = pc.id
WHERE pc.name = 'Hardware'
GROUP BY c.city, pc.name
ORDER BY order_count DESC;


/* Query 2:	Calculates revenue growth after the project delivery */
WITH before_revenue AS (
    SELECT
        cm.client_id,
        SUM(cm.revenue) initial_revenue,
        MAX(cm.year) AS completion_year
    FROM client_market_share cm
    JOIN project p ON cm.client_id = p.client_id
    WHERE
        CONCAT(cm."year", '-12-31')::date <= p.deadline
    GROUP BY 1
),
final_revenue AS (
    SELECT
        cm.client_id,
        SUM(cm.revenue) AS final_revenue
    FROM client_market_share cm
    JOIN
        project p ON cm.client_id = p.client_id AND p.status = 'completed'
    GROUP BY 1
)
SELECT
    br.client_id,
    (fr.final_revenue - br.initial_revenue) / br.initial_revenue * 100 AS revenue_increase_percentage
FROM before_revenue br
JOIN final_revenue fr ON br.client_id = fr.client_id;

/* Query 3: Tells average client statisfaction by project of each category. Identifying
 * the service that need improvement */
SELECT pc.name AS category,
       ROUND(AVG(r.satisfaction_score), 2) AS avg_satisfaction_score
FROM project p
JOIN product pr ON p.product_id = pr.id
JOIN product_category pc ON pr.category_id = pc.id
LEFT JOIN review r ON p.id = r.project_id
GROUP BY pc.name
ORDER BY 2 DESC;

/* Query 4: Tells number of projects an employee has worked on and how successful are they */
SELECT e.name,
       COUNT(DISTINCT p.id) AS project_count,
       AVG(CASE 
	       WHEN r.satisfaction_score IS NOT NULL 
	       THEN r.satisfaction_score ELSE 0 
	  	END) AS avg_project_satisfaction
FROM employee e
JOIN project_team pt ON e.id = pt.employee_id
JOIN project p ON pt.project_id = p.id
LEFT JOIN review r ON p.id = r.project_id
GROUP BY e.name
ORDER BY avg_project_satisfaction DESC;

/* Query 5: Tells the locations where there are high demand of Aktics services
 * */
SELECT c.city, COUNT(pr) total_project_requests
FROM project_request pr
JOIN client c ON pr.client_id = c.id
GROUP BY c.city
ORDER BY 2 DESC;
