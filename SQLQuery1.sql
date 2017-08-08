select * from HR.Employees;

select empid, sum(freight) cost
from Sales.Orders
where shipregion is not Null
group by empid ;

--1.order in 2008
select * from Sales.Orders
where orderdate between '2008-01-01' and '2008-12-31';
--add customer name to 1
select S1.orderid, S3.companyname, S3.contactname
from Sales.Orders S1
Inner join Sales.Customers S3 on S1.custid= S3.custid
where orderdate between '2008-01-01' and '2008-12-31';

select * from Sales.Customers;
--2.top 50 orders
select top 50 *  
from Sales.Orders
order by orderdate desc;

--3.top 50 orders with product info

select top 50 S1.orderid,S1.orderdate, S2.productid,P1.productname, S2.qty,P2.categoryid, P2.categoryname
	from  Sales.Orders S1
	Inner Join Sales.OrderDetails S2 on  S1.orderid= S2.orderid
	Inner Join Production.Products P1 on S2.productid = P1.productid
	Inner Join Production.Categories P2 on P1.categoryid= P2.categoryid	
	order by S1.orderdate desc;


select distinct top 50 *  into S1 
from Sales.Orders
order by orderdate desc;
select * from S1;

drop table S1;



	




--4.

--5.Shipper details for all unshipped orders
select orderid, orderdate, requireddate,shippeddate,freight,shipname, shipaddress
from Sales.Orders
where shippeddate is  Null;

--6.total orders,unit, dis, price in 2007

select count ( S1.orderid ) totalorders, sum (S2.qty) qty,
 sum (S2.discount* S2.qty*S2.unitprice) total_discount,
 sum(S2.qty*S2.unitprice*(1- S2.discount)) Total_afterdisc,
  sum(S2.qty*S2.unitprice) Total_beforedisc 
from Sales.Orders S1
Inner join Sales.OrderDetails S2 on S1.orderid= S2.orderid
where orderdate between '2007-01-01' and '2007-12-31'

--7 for unshipped orders take total orders,unit,amount 
select count (distinct S1.orderid) total_orders, sum(S2.qty) total_qty, sum( S2.unitprice * S2.qty) Amount
from Sales.Orders S1
Inner join Sales.OrderDetails S2 on S1.orderid= S2.orderid
where shippeddate is  Null;

--8 . Return the product name, total number of orders that included this product and the total units sold for that product.
select top 10 sum (S2.qty)totalqty, P1.productname, count (S2.productid) total_order
from Sales.Orders S1
Inner join Sales.OrderDetails S2 on S1.orderid= S2.orderid
Inner join Production.Products P1 on S2.productid= P1.productid
where S1.orderdate between '2008-01-01' and '2008-12-31'
group by  P1.productname
order by sum(S2.qty) desc;

select * from Sales.OrderDetails;
select * from Production.Products;
--9--
--10 product category sold the min number in 2008, supplier,total unit

with list as 
(
	select   P3.companyname CN,P2.categoryname CAT, sum (S2.qty) Total_Unit
	from Sales.Orders S1 
	Inner Join Sales.OrderDetails S2 on S1.orderid= S2.orderid
	Inner Join Production.Products P1 on S2.productid= P1.productid
	Inner Join Production.Categories P2 on P1.categoryid= P2.categoryid
	Inner Join Production.Suppliers P3 on P1.supplierid= P3.supplierid
	where S1.orderdate between '2008-01-01' and '2008-12-31'
	group by  P2.categoryname,P3.companyname
)
select * from list a
where CAT in 
( 
	select top 1 CAT from list b
	where b.CN = a.CN
	order by b.Total_Unit asc
)
order by Total_Unit asc;
	




select * from Production.Suppliers;
select * from Sales.Customers
select * from Sales.Orders;
select * from Sales.Shippers;

select * from Sales.OrderDetails;
select * from Production.Categories;
select * from Production.Products;



