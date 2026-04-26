use AdventureWorks2022;
select top 10 * from sales.SalesOrderHeader;
select top 10 * from sales.SalesOrderDetail;
select top 10 * from Production.Product;

--Find the top 3 customers by total revenue (cusid,totalrevenue,rank)
with cte as(
select customerid,sum(totaldue) as revenue
from sales.salesorderheader group by CustomerID
)

select  (customerid),revenue,
rank() over(order by revenue desc) as rk
from cte

 ;
 --Running Total – VERY IMPORTANT Question:For each customer, show:OrderID,OrderDate,TotalDue,Running total of spending


 select CustomerID,SalesOrderID,OrderDate,TotalDue,
 SUM(TotalDue) over(partition by customerid order by orderdate,salesorderid rows between unbounded preceding and current row) as runningtotal
 from sales.SalesOrderHeader 
;

---------Q3 (LAG – Interview Favorite)Write query:For each order:CustomerID,SalesOrderID,TotalDue,Previous order value,Difference from previous orderHint:


select CustomerID,SalesOrderID,orderdate,TotalDue,
LAG(TotalDue) over(partition by customerid order by orderdate,salesorderid ) as prev_ordervalue,
(TotalDue-LAG(TotalDue) over(partition by customerid order by orderdate,salesorderid )) as diff_prevorder
from sales.SalesOrderHeader;
