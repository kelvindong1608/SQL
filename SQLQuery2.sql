
select * from DimCustomer;
select * from FactInternetSales;
select * from DimGeography;
select * from DimProduct;
select * from DimDate;
select * from DimSalesReason;

--1a.
select distinct YEAR(OrderDate)
from FactInternetSales
order by YEAR(OrderDate);

--1b
select min(DD.CalendarYear) min_year, max (DD.CalendarYear) max_year
from FactInternetSales FI
Inner join DimDate DD on FI.DueDateKey=DD.DateKey;

--1c
select distinct DD.CalendarYear
from FactInternetSales FI
Inner join DimDate DD on FI.DueDateKey=DD.DateKey
where DD.CalendarYear= Year(FI.OrderDate)
order by DD.CalendarYear desc;

--2.
select  DSR.SalesReasonName, count(FISR.SalesReasonKey) number_reason
from FactInternetSales FIS  
Inner join FactInternetSalesReason FISR on FIS.SalesOrderNumber= FISR.SalesOrderNumber
Inner join DimSalesReason DSR on FISR.SalesReasonKey= DSR.SalesReasonKey
group by FISR.SalesReasonKey, DSR.SalesReasonName
order by count(FISR.SalesReasonKey) desc ;

select DSR.SalesReasonName, count(FISR.SalesReasonKey) number_reason, Year(FIS.OrderDate) AsYear
from FactInternetSales FIS  
Inner join FactInternetSalesReason FISR on FIS.SalesOrderNumber= FISR.SalesOrderNumber
Inner join DimSalesReason DSR on FISR.SalesReasonKey= DSR.SalesReasonKey
group by FISR.SalesReasonKey, DSR.SalesReasonName,Year(FIS.OrderDate)
order by AsYear desc,count(FISR.SalesReasonKey) desc;
--order by  AsYear desc;
--3a 10 customers made the most orders during 2007? 
--Return their name and the total number of orders they made during 2007

select top 10 DC.FirstName + ' ' +DC.LastName customer_name, count(FIS.CustomerKey) total_order
from FactInternetSales FIS 
Inner join DimCustomer DC on FIS.CustomerKey = DC.CustomerKey
Inner join DimDate DD on DD.FullDateAlternateKey = FIS.OrderDate
where DD.FullDateAlternateKey between '2007-01-01' and '2007-12-31'
group by FIS.CustomerKey,DC.FirstName,DC.LastName
order by count(FIS.CustomerKey) desc;

--3b1
select top 4 DC.Gender, DP.EnglishProductName, count(FIS.OrderQuantity)
from FactInternetSales FIS
Inner join DimCustomer DC on DC.CustomerKey= FIS.CustomerKey
Inner join DimDate DD on DD.DateKey = FIS.OrderDateKey
Inner join DimProduct DP on DP.ProductKey = FIS.ProductKey
where DD.CalendarYear= 2007
group by DC.Gender,  DP.EnglishProductName
order by count(FIS.OrderQuantity) desc;

--3b2
select top 3 DC.Gender, DP.EnglishProductName, count(FIS.OrderQuantity)
from FactInternetSales FIS
Inner join DimCustomer DC on DC.CustomerKey= FIS.CustomerKey
Inner join DimDate DD on DD.DateKey = FIS.OrderDateKey
Inner join DimProduct DP on DP.ProductKey = FIS.ProductKey
where DD.CalendarYear= 2007 and DC.Gender = 'M'
group by DC.Gender,  DP.EnglishProductName
Union  All
select top 3 DC.Gender, DP.EnglishProductName, count(FIS.OrderQuantity)
from FactInternetSales FIS
Inner join DimCustomer DC on DC.CustomerKey= FIS.CustomerKey
Inner join DimDate DD on DD.DateKey = FIS.OrderDateKey
Inner join DimProduct DP on DP.ProductKey = FIS.ProductKey
where DD.CalendarYear= 2007 and DC.Gender = 'F'
group by DC.Gender,  DP.EnglishProductName
order by DC.Gender,count(FIS.OrderQuantity) desc;

--3c
with product_by_gender as
(
select DP.EnglishProductName,
count (*) as TotalProductSales,
sum( case when DC.Gender ='M' then 1 else 0 end) SalesToMen,
sum( case when DC.Gender ='F' then 1 else 0 end) SalesToWomen
from FactInternetSales FIS
Inner join DimCustomer DC on DC.CustomerKey= FIS.CustomerKey
Inner join DimDate DD on DD.DateKey = FIS.OrderDateKey
Inner join DimProduct DP on DP.ProductKey = FIS.ProductKey
where DD.CalendarYear=2007
group by DP.EnglishProductName, FIS.ProductKey
)
select * 
from product_by_gender 
where log ( SalesToMen + 0.5, 2) / log ( SalesToWomen + 0.5, 2) >=2;

--3d


select DP.EnglishProductName,
sum( case when DC.Gender ='M' then FIS.OrderQuantity else 0 end) SalesToMen,
sum( case when DC.Gender ='F' then FIS.OrderQuantity else 0 end) SalesToWomen
from FactInternetSales FIS
Inner join DimCustomer DC on DC.CustomerKey= FIS.CustomerKey
Inner join DimDate DD on DD.DateKey = FIS.OrderDateKey
Inner join DimProduct DP on DP.ProductKey = FIS.ProductKey
where DD.CalendarYear=2007
group by DP.EnglishProductName
having sum( case when DC.Gender ='M' then FIS.OrderQuantity else 0 end) > 4*
sum( case when DC.Gender ='F' then FIS.OrderQuantity else 0 end)




select * from FactInternetSales;
select * from DimProduct;
select * from DimCustomer;

select * from DimDate;


select * from FactInternetSalesReason;
select * from DimSalesReason;
