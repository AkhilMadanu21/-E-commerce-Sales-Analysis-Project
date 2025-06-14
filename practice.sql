#1.	What is the total revenue generated overall and by each product category?
select p.Category, Sum(o.TotalAmount) as Totalrevenue
from ecom_products as p
left join
ecom_orders as o
on p.ProductID = o.ProductID
group by Category 
order by Totalrevenue;



#2. Which products are the top 10 revenue generators?
select p.ProductName,sum(o.TotalAmount) as Totalrevenue
from ecom_orders as o
Inner join
ecom_products as p
on p.ProductID = p.ProductID
group by ProductName
order by Totalrevenue Desc
limit 10;


#3.	What is the monthly revenue trend?
SELECT 
    DATE_FORMAT(OrderDate, '%m') AS MonthNum,
    MONTHNAME(OrderDate) AS MonthName,
    round(SUM(TotalAmount),0) AS Revenue
FROM 
    ecom_orders
GROUP BY 
    MonthNum, MonthName
ORDER BY 
    MonthNum;



#4.	What is the average order value?
select p.Category,avg(o.TotalAmount) as Ordervalue
from ecom_orders as o
inner join 
ecom_products as p
on o.ProductID = p.ProductID
group by p.Category
order by Ordervalue Desc;




#5.	How many new vs. repeat customers placed orders?
select 
sum(case when OrderCount = 1 then 1 else 0 end) as Newcustomers,
sum(case when OrderCount > 1 then 1 else 0 end ) as Repeatcustomers
from
(SELECT 
        CustomerID,
        COUNT(*) AS OrderCount
    FROM 
        ecom_orders
    GROUP BY 
        CustomerID) AS Customerordercounts;



#6.	Which customers generated the highest revenue?
select c.CustomerID,c.CustomerName,round(sum(o.TotalAmount)) as Revenue
from ecom_customers as c
left join 
ecom_orders as o
on c.CustomerID = o.CustomerID
group by c.CustomerName,c.CustomerID
order by Revenue Desc
limit 10;



#7.	What is the average number of orders per customer?
SELECT c.CustomerID, c.CustomerName, ROUND(AVG(o.Quantity), 2) AS AVG_orders
FROM ecom_orders AS o
INNER JOIN ecom_customers AS c 
ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY AVG_orders DESC;


#8.	Which products have the highest and lowest return/cancellation rates?
SELECT p.ProductID, p.ProductName, 
round(sum(case when o.OrderStatus in ('Cancelled','Returned')then o.Quantity else 0 End)/
nullif(sum(case when  o.OrderStatus = 'Delivered' then o.Quantity else 0 end),0),2) as 'ReturnorCancel_Rates'
FROM ecom_products AS p 
INNER JOIN ecom_orders AS o 
ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY ReturnorCancel_Rates DESC;






#9.	What is the most commonly used payment method?
select PaymentMethod,count(*) as Frequent_Payment_method
from ecom_orders
group by PaymentMethod
order by Frequent_Payment_method Desc
Limit 1;



#10.	What are the most frequently sold product categories?
select p.Category,sum(o.Quantity) as Frequently_sold
from ecom_orders as o 
right join
ecom_products as p
on p.ProductID = o.ProductID
group by p.Category
order by  Frequently_sold Desc
limit 3 ;



