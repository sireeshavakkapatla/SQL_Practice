use AdventureWorks2022;

select top 10 * from Sales.SalesOrderHeader ;

select top 10 * from Sales.SalesOrderdetail ;

select top 10 * from Sales.customer ;

select top 10 * from person.Person ;

select top 10 * from production.Product ;

select soh.CustomerID,year(soh.OrderDate) as orderdate,soh.TotalDue
from sales.SalesOrderHeader soh

where year(soh.OrderDate) = 2013 and soh.TotalDue>1000

;
---------------------------------------------------------------------
/*
Q2 (Advanced – Joins + Aggregation + GROUP BY)

👉 Goal: Think like reporting/dashboard

Question:

Find:

Product Name
Total Quantity Sold
Total Revenue

Conditions:

Only include orders from 2013
Only include products where total quantity sold > 500

👉 Tables:

Sales.SalesOrderDetail
Sales.SalesOrderHeader
Production.Product

💡 Hint flow:

Join Header + Detail
Filter by date
Aggregate
Join Product
*/
------------------------------------------------------------------------
select p.Name,sum(od.OrderQty) quantity, sum(od.OrderQty*od.UnitPrice) as total_revenue from 
sales.SalesOrderDetail od
left join sales.SalesOrderHeader oh
on od.SalesOrderID = oh.SalesOrderID
left join Production.Product p
on od.ProductID = p.ProductID
where year(oh.orderdate) = 2013 
group by p.Name
having sum(od.OrderQty)>500;
------------------------------------------------------------------------------------------------------------
/*
Q3 (Advanced – Subquery + Filtering Logic)

👉 Goal: Real interview-style thinking

Question:

Find customers who:

Have placed more than 5 orders
AND whose average order value is greater than overall average order value

👉 Output:

CustomerID
Total Orders
Avg Order Value

👉 Tables:

Sales.SalesOrderHeader

💡 Hint:

One subquery for overall average
One aggregation per customer
*/-------------------------------------------------------------------------------------------------------------


with customer_orders as
(select c.CustomerID,count(oh.SalesOrderNumber) total_orders,sum(oh.TotalDue)  amount

from sales.Customer c
left join 
sales.SalesOrderHeader oh
on c.CustomerID = oh.CustomerID

group by c.CustomerID)

select *,round((amount/total_orders),2) as avg_order_value
from
customer_orders

where total_orders>5
and round((amount/total_orders),2) >  
(
select AVG(oh.totaldue) overall_avg from sales.SalesOrderHeader oh
);

-----------------------------------------------------------------------------------------------------

with overall_avg_cte as
(
select avg(totaldue) as overall_avg from sales.SalesOrderHeader
),
 customer_orders  as
(
select c.CustomerID,count(oh.SalesOrderNumber) total_orders,sum(oh.TotalDue)  amount

from sales.Customer c
left join 
sales.SalesOrderHeader oh
on c.CustomerID = oh.CustomerID

group by c.CustomerID
)
select co.customerid,co.total_orders,
    co.amount,(co.amount/co.total_orders) as avg_order_value,
	oa.overall_avg
from
customer_orders co
cross join
overall_avg_cte oa
where co.total_orders>5
and (co.amount/co.total_orders) >  oa.overall_avg;
