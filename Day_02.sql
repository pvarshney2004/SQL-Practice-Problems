-- 11. Display orders along with the total value of each order.
select o.OrderID, sum(oi.UnitPrice * oi.Quantity) as total_value from Orders o
join OrderItems oi on o.OrderID = oi.OrderID
group by o.OrderID

-- 12. Retrieve the top 5 highest selling products.
select top 5 p.ProductID, p.ProductName, sum(oi.Quantity) as total_Quantity from Products p
join OrderItems oi on p.ProductID = oi.ProductID
group by p.ProductID, p.ProductName
order by total_Quantity desc

-- 13. Find the total revenue generated per city.
 select c.City, sum(oi.Quantity * oi.UnitPrice) as total_revenue 
 from customers c
 join Orders o on c.CustomerID = o.CustomerID
 join OrderItems oi on o.OrderID = oi.OrderID
 group by c.City

-- 14. Show customers who placed orders in more than one city.
SELECT c.FirstName, c.LastName, COUNT(DISTINCT c.City) AS CityCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(DISTINCT c.City) > 1;

-- 15. Find the employee who processed the highest number of orders.
select top 1 e.EmployeeID, e.FirstName, count(o.OrderID) as total_orders from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName
order by total_orders desc

-- 16. Calculate monthly revenue for the last 24 months.
SELECT FORMAT(o.OrderDate, 'yyyy-MM') AS Month, SUM(oi.Quantity * oi.UnitPrice) AS MonthlyRevenue
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderDate >= DATEADD(MONTH, -24, GETDATE())
GROUP BY FORMAT(o.OrderDate, 'yyyy-MM')
ORDER BY Month DESC;

-- 17. Show products that have never been ordered.
SELECT p.ProductID, p.ProductName, p.Category
FROM Products p
LEFT JOIN OrderItems oi ON p.ProductID = oi.ProductID
WHERE oi.ProductID IS NULL;

-- 18. Find orders containing more than 3 different products.
SELECT oi.OrderID FROM OrderItems oi
GROUP BY oi.OrderID
HAVING COUNT(DISTINCT oi.ProductID) > 3;

-- 19. Retrieve customers who ordered products from at least 3 categories.
select c.CustomerID, c.FirstName from Customers c
join Orders o on c.CustomerID = o.CustomerID
join OrderItems oi on o.OrderID = oi.OrderID
join Products p on oi.ProductID = p.ProductID
group by c.CustomerID, c.FirstName
having count(distinct p.Category)>=3

-- 20. List the most recent order for each customer.
WITH RankedOrders AS (
    SELECT c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.Status,
        ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate DESC) AS OrderRank
    FROM dbo.Customers c
    JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
)
SELECT 
    FirstName, LastName, OrderID, OrderDate, Status
FROM RankedOrders
WHERE OrderRank = 1;