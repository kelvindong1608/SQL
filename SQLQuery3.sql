select * from DimEmployee;
select * from DimSalesTerritory;
--1
with empdata as
(
select SalesTerritoryCountry, SalesTerritoryRegion, FirstName, LastName,SickLeaveHours,DE.Status
from	DimEmployee DE
Inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
)
select 
	SalesTerritoryCountry,
	SalesTerritoryRegion,
	FirstName + ' ' + LastName Employee_Name,	
	SickLeaveHours, Status
from empdata
where SalesTerritoryCountry != 'NA' 
and SalesTerritoryRegion != 'NA'
and Status is not Null;
--2a with
with empdata as
(
select SalesTerritoryCountry, SalesTerritoryRegion, FirstName, LastName,SickLeaveHours,DE.Status
from	DimEmployee DE
Inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
)
select 
	salesTerritoryCountry,SalesTerritoryRegion,sum(SickLeaveHours) Total_sickleave
from empdata
where SalesTerritoryCountry != 'NA' 
and SalesTerritoryRegion != 'NA'
and Status is not Null
Group by SalesTerritoryCountry,SalesTerritoryRegion
order by Total_sickleave desc;

--2a1
with empdata as
(
select SalesTerritoryCountry,
	 SalesTerritoryRegion,	 	
	 DE.Status,
	 sum(SickLeaveHours) Totalsick
from	DimEmployee DE
Inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
where SalesTerritoryCountry != 'NA' 
and SalesTerritoryRegion != 'NA'
and Status is not Null
Group by SalesTerritoryCountry,SalesTerritoryRegion, DE.Status
)
select 	*
from empdata
order by Totalsick desc;

--2b subquery

select 
	salesTerritoryCountry,SalesTerritoryRegion,sum(SickLeaveHours) Total_sickleave
from 
(select SalesTerritoryCountry, SalesTerritoryRegion, FirstName, LastName,SickLeaveHours,DE.Status
from	DimEmployee DE
Inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
) sickleave
where SalesTerritoryCountry != 'NA' 
and SalesTerritoryRegion != 'NA'
and Status is not Null
Group by SalesTerritoryCountry,SalesTerritoryRegion
order by Total_sickleave desc;

--3
with empdata as
(
select 
	 SalesTerritoryCountry,
	 SalesTerritoryRegion,	 	
	 DE.Status,
	 FirstName + ' ' + LastName Employee_Name,
	 SickLeaveHours
from	DimEmployee DE
Inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
where SalesTerritoryCountry != 'NA' 
and SalesTerritoryRegion != 'NA'
and Status is not Null
)
select 	*
from empdata
where Employee_Name in
	( select top 5  Employee_Name from empdata
	group by SickLeaveHours, Employee_Name
	order by SickLeaveHours desc);

--4
with empdata as
(
select 
	 SalesTerritoryCountry,
	 SalesTerritoryRegion,	 	
	 DE.Status,
	 FirstName + ' ' + LastName Employee_Name,
	 SickLeaveHours
from	DimEmployee DE
Inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
where SalesTerritoryCountry != 'NA' 
and SalesTerritoryRegion != 'NA'
and Status is not Null
)
select 	*
from empdata
where Employee_Name in
	( select top 3  Employee_Name from empdata
	group by SickLeaveHours, Employee_Name, SalesTerritoryCountry
	order by SickLeaveHours desc);
--4
with sickleave as
(
select 
	 SalesTerritoryCountry,
	 SalesTerritoryRegion,	 	
	 DE.Status,
	 FirstName + ' ' + LastName Employee_Name,
	 SickLeaveHours
from	DimEmployee DE
inner join DimSalesTerritory DST on DE.SalesTerritoryKey = DST.SalesTerritoryKey
where SalesTerritoryCountry != 'NA' 
--and SalesTerritoryRegion != 'NA'
and Status is not Null
)
select * from sickleave a
where Employee_Name in 
(	select top 3 Employee_Name from sickleave b
	where b.SalesTerritoryCountry = a.SalesTerritoryCountry
	order by b.SickLeaveHours desc)
order by SalesTerritoryCountry, SickLeaveHours desc;

--5
with product_sales as
(
	select
		d.CalendarYear,
		d.CalendarQuarter,
		d.EnglishMonthName,
		pc.EnglishProductCategoryName,
		ps.EnglishProductSubcategoryName,
		p.EnglishProductName,		
		sum(f.OrderQuantity) as TotalSales
	from FactInternetSales f
		inner join DimProduct p on p.ProductKey = f.ProductKey
		inner join DimProductSubcategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
		inner join DimProductCategory pc on pc.ProductCategoryKey = ps.ProductCategoryKey
		inner join DimDate d on d.DateKey = f.OrderDateKey
	group by 
		d.CalendarYear,
		d.CalendarQuarter,
		d.EnglishMonthName,
		pc.EnglishProductCategoryName,
		ps.EnglishProductSubcategoryName,
		p.EnglishProductName
),
yearly_sales as
(
	select
		CalendarYear,
		EnglishProductSubcategoryName,
		sum(TotalSales) as YearlySales
	from product_sales
	group by 
		CalendarYear,
		EnglishProductSubcategoryName
)
select * from yearly_sales A
where EnglishProductSubcategoryName in (
	select top 3 EnglishProductSubcategoryName from yearly_sales B
	where B.CalendarYear = A.CalendarYear
	order by B.YearlySales desc
)
order by CalendarYear asc, YearlySales desc
	