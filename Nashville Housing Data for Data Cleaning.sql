/*

Cleaning Data in SQL Queries

*/
--------------------------------------------------------------------------------------------------------
--CONVERT(date, saledate) is same as cast(saledate,date)
-- standarize date format   
select * from nashvillhousing
select saledate , CONVERT(date, saledate) from nashvillhousing

alter table nashvillhousing
add saledateconvert date;

update nashvillhousing set saledateconvert = 
CONVERT(date, saledate) 
-----------------------------------------------------


-- Populate Property Address data

Select *
From NashvillHousing
Where PropertyAddress is null
order by ParcelID

-- updating Property adresse when it is null 
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From NashvillHousing a
JOIN NashvillHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvillHousing a
JOIN NashvillHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

select PropertyAddress
from NashvillHousing a
Where a.PropertyAddress is null


---------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

select SUBSTRING(PropertyAddress, 1, charindex(' ' , PropertyAddress)-1) as Address , 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as City,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1,len(PropertyAddress))  as state
from NashvillHousing ;

-- create this colonnes
ALTER TABLE NashvillHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvillHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvillHousing
Add PropertySplitCity Nvarchar(255);

Update NashvillHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))






Select *
From NashvillHousing





Select OwnerAddress
From NashvillHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
from  NashvillHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvillHousing



ALTER TABLE NashvillHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvillHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvillHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvillHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvillHousing
Add OwnerSplitState Nvarchar(255);

Update NashvillHousing
SET OwnerSplitState
= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)





Select *
From PortfolioProject.dbo.NashvillHousing



---------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select * from NashvillHousing

select soldasvacant from NashvillHousing
where soldasvacant like 'n'

update NashvillHousing set soldasvacant ='No'
 where soldasvacant like 'n'


 select soldasvacant from NashvillHousing
where soldasvacant like 'y'

update NashvillHousing set soldasvacant ='Yes'
 where soldasvacant like 'y'

 -- using case when

 update NashvillHousing
 set soldasvacant = ( case 
                          when soldasvacant like 'y' then 'Yes'
						  when soldasvacant like 'N' then 'No'
						  else soldasvacant
						  end)


-------------------------------------------------------------------------------------------------------------------
 -- Remove Duplicates



WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvillHousing
--order by ParcelID
)

--select  * from RowNumCTE
--where row_num >1 
delete from RowNumCTE
where row_num >1 

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From NashvillHousing


ALTER TABLE NashvillHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress




-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO
