--1 List all customers who have placed at least one order
select distinct c.CustomerID, c.FirstName+' '+c.LastName as FullName from Customers c
JOIN Orders o on c.CustomerID = o.CustomerID

--2 Retrieve all orders placed in the last 30 days
SELECT * FROM Orders 
WHERE DATEDIFF(day, OrderDate, GETDATE()) < 30;

--3 Find the total number of orders placed by each customer.
select c.CustomerID, (c.FirstName+' '+c.LastName) as FullName, count(o.OrderID) as total_orders from Orders o
join Customers c on o.CustomerID=c.CustomerID
group by c.CustomerID, (c.FirstName+' '+c.LastName)

--4 Show the top 10 customers by total number of orders
SELECT TOP 10 c.CustomerID, (c.FirstName+' '+c.LastName) as FullName, COUNT(o.OrderID) AS total_orders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, (c.FirstName+' '+c.LastName)
ORDER BY total_orders DESC;

--5 Display the total revenue generated for each product.
select p.ProductID, p.ProductName, SUM(o.Quantity * o.UnitPrice) as total_revenue from Products p
join OrderItems o on p.ProductID = o.ProductID
group by p.ProductID, p.ProductName


--6 Find customers who have never placed any orders.
select c.CustomerID, c.FirstName, count(o.OrderID) as total_orders from Customers c
left join Orders o on c.CustomerID = o.CustomerID
group by c.CustomerID, c.FirstName
having count(o.OrderID) = 0

select c.CustomerID, c.FirstName from Customers c
left join Orders o on c.CustomerID = o.CustomerID
where o.OrderID is null

--7 Retrieve the most expensive product in each category.
select p.ProductID, p.ProductName, p.Price as max_price, p.Category from Products p
where p.Price = (
	select max(p2.price) from Products p2
	where p2.Category = p.Category
)

--8 Show the total quantity sold for each product.
select p.ProductID, p.ProductName, sum(o.Quantity) as total_quantity_sold from Products p
join OrderItems o on o.ProductID = p.ProductID
group by p.ProductID, p.ProductName


--9 List employees who have handled more than 50 orders.
select e.EmployeeID, e.FirstName, count(o.OrderID) from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
group by e.EmployeeID, e.FirstName
having count(o.OrderID) > 50;


--10 Find the average order value for each customer.
SELECT 
    c.CustomerID,
    c.FirstName,
    AVG(OrderTotal) AS AvgOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN (
    SELECT 
        OrderID,
        SUM(Quantity * UnitPrice) AS OrderTotal
    FROM OrderItems
    GROUP BY OrderID
) ot ON o.OrderID = ot.OrderID
GROUP BY c.CustomerID, c.FirstName;