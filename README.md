# 📊 E-commerce-Sales-Analysis-Project

![72688282-increasing-graph-and-sales-word-on-blueprint-background](https://github.com/user-attachments/assets/3390e08d-a094-4604-9c19-74e8962ccdf8)

I recently completed a project that analyzes e-commerce sales data using SQL for backend analysis and Power BI for interactive dashboards. This project helped me explore critical sales metrics and trends that can drive better decision-making for online retailers.

## Overview

This project focuses on deriving valuable business insights from an e-commerce dataset using MySQL. It demonstrates the use of SQL for data exploration, analysis, and reporting, and covers customer behavior, product performance, revenue trends, and operational metrics.

## 📁 Dataset Overview

The database includes the following key tables:
- ecom_orders – Stores order-level data including quantity, total amount, order status, date, payment method, and customer ID.
- ecom_products – Contains product details like name, category, and product ID.
- ecom_customers – Includes customer information such as ID and name.


## Project structure 
- **Database Setup**: Creation of the `E-commerce sales` database.
- **Importing data**: Importing sample csv file into tables.
- **Business Problems**: Solving 12 specific business problems using SQL queries.

## Database Setup
```sql
CREATE DATABASE `E-commerce sales`;
``` 

## Data Import

## Business Problems Solved

### 1.	What is the total revenue generated overall and by each product category?
```sql
select p.Category, Sum(o.TotalAmount) as Totalrevenue
from ecom_products as p
left join
ecom_orders as o
on p.ProductID = o.ProductID
group by Category 
order by Totalrevenue;
```
### Output:
<img width="187" alt="image" src="https://github.com/user-attachments/assets/139f57f0-b6cd-400c-8804-419a63bc0616" />

### 2. Which products are the top 10 revenue generators?
```sql
select p.ProductName,sum(o.TotalAmount) as Totalrevenue
from ecom_orders as o
Inner join
ecom_products as p
on p.ProductID = p.ProductID
group by ProductName
order by Totalrevenue Desc
limit 10;
```
### Output:
<img width="216" alt="image" src="https://github.com/user-attachments/assets/3a4088d2-3aae-4845-a1d4-dfe1ba49a58b" />

### 3.	What is the monthly revenue trend?
```sql
SELECT DATE_FORMAT(OrderDate, '%m') AS MonthNum, MONTHNAME(OrderDate) AS MonthName,round(SUM(TotalAmount),0) AS Revenue
FROM ecom_orders
GROUP BY  MonthNum, MonthName
ORDER BY MonthNum;
```

### Output:
<img width="191" alt="Screenshot 2025-06-14 at 4 25 36 PM" src="https://github.com/user-attachments/assets/354282c2-a911-4959-8a00-e98b9f05e942" />

### 4.	What is the average order value?
```sql
select p.Category,round(avg(o.TotalAmount),2) as Ordervalue
from ecom_orders as o
inner join 
ecom_products as p
on o.ProductID = p.ProductID
group by p.Category
order by Ordervalue Desc;
```
### Output:
<img width="134" alt="image" src="https://github.com/user-attachments/assets/6583528f-f4ff-4d4d-a09b-97f2592897d1" />

### 5.	How many new vs. repeat customers placed orders?
```sql
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
```

### Output:
<img width="183" alt="image" src="https://github.com/user-attachments/assets/4c30d388-5bfa-4675-b347-92547ae7a085" />

### 6.	Which customers generated the highest revenue?
```sql
select c.CustomerID,c.CustomerName,round(sum(o.TotalAmount)) as Revenue
from ecom_customers as c
left join 
ecom_orders as o
on c.CustomerID = o.CustomerID
group by c.CustomerName,c.CustomerID
order by Revenue Desc
limit 10;
```

###Output:
<img width="224" alt="image" src="https://github.com/user-attachments/assets/5493ee13-cbff-4ee4-bd18-f5bb369b6f61" />

### 7.	What is the average number of orders per customer?
```sql
SELECT c.CustomerID, c.CustomerName, ROUND(AVG(o.Quantity), 2) AS AVG_orders
FROM ecom_orders AS o
INNER JOIN ecom_customers AS c 
ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY AVG_orders DESC;
```
### Output:
<img width="259" alt="image" src="https://github.com/user-attachments/assets/7b93f01a-ed6b-43c6-a334-03fde6be61a8" />,<img width="259" alt="image" src="https://github.com/user-attachments/assets/d9580c09-a753-401a-b3e6-2d4450cb6cf0" />,<img width="259" alt="image" src="https://github.com/user-attachments/assets/3f520a08-a13a-4c3f-bf96-a119040224e8" />,<img width="259" alt="image" src="https://github.com/user-attachments/assets/82845aa9-3862-4f71-85f3-bac98004024c" />

### 8.	Which products have the highest and lowest return/cancellation rates?
```sql
SELECT p.ProductID, p.ProductName, 
round(sum(case when o.OrderStatus in ('Cancelled','Returned')then o.Quantity else 0 End)/
nullif(sum(case when  o.OrderStatus = 'Delivered' then o.Quantity else 0 end),0),2) as 'ReturnorCancel_Rates'
FROM ecom_products AS p 
INNER JOIN ecom_orders AS o 
ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY ReturnorCancel_Rates DESC;
```

# Output:
<img width="259" alt="Screenshot 2025-06-14 at 4 36 19 PM" src="https://github.com/user-attachments/assets/3b6e08ba-6ab3-445d-8a9c-05d33850a5f8" />,<img width="259" alt="image" src="https://github.com/user-attachments/assets/a22e5921-23c6-4c35-a096-8a950d40e58e" />

### 9.	What is the most commonly used payment method?
```sql
select PaymentMethod,count(*) as Frequent_Payment_method
from ecom_orders
group by PaymentMethod
order by Frequent_Payment_method Desc
Limit 1;
```

### Output:
<img width="244" alt="image" src="https://github.com/user-attachments/assets/dd7d7bd1-1dd5-4e06-b915-d84dd743e914" />


### 10.	What are the most frequently sold product categories?
```sql
select p.Category,sum(o.Quantity) as Frequently_sold
from ecom_orders as o 
right join
ecom_products as p
on p.ProductID = o.ProductID
group by p.Category
order by  Frequently_sold Desc
limit 3 ;
```

### Output:
<img width="149" alt="image" src="https://github.com/user-attachments/assets/16030fab-2dae-4200-b78a-78e82f644aef" />

## 🔧 Tools Used
- SQL (MySQL) – Core analysis performed using SQL queries.
- Power BI / Excel (Optional) – You may visualize the results using dashboards (not included in this repo).

## 💡 Skills Demonstrated

- Data Cleaning & Aggregation
- Conditional Filtering
- Joins (INNER, LEFT, RIGHT)
- Window and Aggregate Functions
- GROUP BY, HAVING, CASE WHEN
- Performance Optimization using subqueries


## 📂 How to Use

- Product returns are highest in the [X category] (based on your output).
- The most frequent payment method is [e.g., Credit Card].
- Top customer contributes [Y amount] to the revenue.

## ✅ Conclusion

This project demonstrates how structured query language (SQL) can be effectively used to extract actionable insights from e-commerce transactional data. Through various analytical queries, we were able to:

- Identify top-performing product categories and high-revenue-generating products.
- Understand customer behavior by analyzing repeat purchases and average order quantities.
- Detect operational inefficiencies by evaluating return and cancellation rates.
- Uncover key trends in revenue growth across months and purchasing patterns.
- Provide valuable inputs for marketing, sales, and supply chain decision-making.

By answering real-world business questions with data, this project highlights the importance of data-driven strategies in improving customer satisfaction, optimizing inventory, and maximizing revenue in an e-commerce environment.
