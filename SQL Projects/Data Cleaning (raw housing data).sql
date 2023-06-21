/* Data Cleaning */

select *
from housingdata

-- Standardize Date Format

select saledateconverted
from housingdata

alter table housingdata
add saledateconverted date;


Update housingdata
set saledateconverted =convert(date,saledate)


--populate property adress data



select a.ParcelID , a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from housingdata a
join housingdata b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from housingdata a
join housingdata b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


select  PropertyAddress
from housingdata

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress) ) as address
from housingdata

alter table housingdata
add Split_Address nvarchar(255);


Update housingdata
set Split_Address =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table housingdata
add City nvarchar(255);

Update housingdata
set City =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress) )

select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from housingdata

alter table housingdata
add Owner_Split_Address nvarchar(255);


Update housingdata
set Owner_Split_Address =PARSENAME(Replace(OwnerAddress,',','.'),3)

alter table housingdata
add Owner_Split_City nvarchar(255);

Update housingdata
set Owner_Split_City =PARSENAME(Replace(OwnerAddress,',','.'),2)

alter table housingdata
add Owner_Split_State nvarchar(255);

Update housingdata
set Owner_Split_State =PARSENAME(Replace(OwnerAddress,',','.'),1)



-- Change Y and N to Yes and No in "Sold as Vacant" field



select distinct(SoldAsVacant)
from housingdata


select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='n'then'No'
     else SoldAsVacant
	 End
from housingdata

update housingdata
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='n'then'No'
     else SoldAsVacant
	 End


select SoldAsVacant,COUNT(SoldAsVacant)
from housingdata
group by SoldAsVacant



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housingdata
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



select *
from housingdata 



-- Delete Unused Columns


Select *
From housingdata


ALTER TABLE housingdata
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



