select lastname, FirstName, DepartmentName, Status
from DimEmployee
where DepartmentName ='Marketing';

select FirstName, LastName, DepartmentName,StartDate, Status
from DimEmployee
where DepartmentName ='Marketing'
and status is not Null;

select ProductKey, EnglishProductName, Color, Weight
from DimProduct
where Weight > 50
order by Weight asc;

select * 
from DimSalesTerritory
where SalesTerritoryGroup ='North America';

select E.FirstName +' ' + E.LastName Employee_Name, ST.SalesTerritoryCountry, ST.SalesTerritoryGroup, ST.SalesTerritoryRegion
from DimEmployee E 
inner join DimSalesTerritory ST on E.SalesTerritoryKey = ST.SalesTerritoryKey
where SalesTerritoryGroup ='Europe';

select  Dp.ProductKey, DP.EnglishDescription, DPSC.EnglishProductSubcategoryName,DPC.EnglishProductCategoryName
from DimProduct DP 
Inner join DimProductSubcategory DPSC on DP.ProductSubcategoryKey= DPSC.ProductSubcategoryKey
Inner join DimProductCategory DPC on DPSC.ProductCategoryKey= DPC.ProductCategoryKey
where DPC.EnglishProductCategoryName ='Bikes'
order by DP.ProductKey;

select DP.EnglishDescription, DPSC.EnglishProductSubcategoryName,DPC.EnglishProductCategoryName
from DimProduct DP 
Inner join DimProductSubcategory DPSC on DP.ProductSubcategoryKey= DPSC.ProductSubcategoryKey
Inner join DimProductCategory DPC on DPSC.ProductCategoryKey= DPC.ProductCategoryKey
where DPC.EnglishProductCategoryName ='Bikes'
group by DPSC.EnglishProductSubcategoryName, DP.EnglishDescription, DPC.EnglishProductCategoryName;

--2b
select top 10 DC.FirstName +' '+ DC.LastName ,DP.EnglishDescription, DST.SalesTerritoryCountry
from FactInternetSales FIS
Inner join DimProduct DP on FIS.ProductKey= DP.ProductKey
Inner join DimSalesTerritory DST on FIS.SalesTerritoryKey= DST.SalesTerritoryKey
Inner join DimCustomer DC on FIS.CustomerKey=DC.CustomerKey
where Year (FIS.OrderDate) = '2008'
and DP.EnglishDescription is not Null
order by FIS.OrderDate asc;

select * from FactInternetSales;
select * from DimProduct;
select * from DimSalesTerritory;
select * from DimCustomer;
select * from DimProductSubcategory;
select * from DimProductCategory;


select * from DimEmployee;
select * from DimSalesTerritory;