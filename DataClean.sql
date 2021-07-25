--cleaning data 
select *
from PortfolioProject.dbo.NashvilleHousing

--standardising date format
select saledateconverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate= CONVERT(date,saledate)

alter table nashvillehousing
add SaleDateConverted date

update NashvilleHousing
set saleDateconverted  = convert(date,saledate)

--------------------------

--populate property address data


select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID= b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null


 update a
 set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID= b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]

 --------------------------------------------------------------------


 --Breaking out address into individual columns(Address, city, state)

 Select PropertyAddress
 from PortfolioProject.dbo.NashvilleHousing

 select
 SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
  SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1,len(propertyaddress)) as Address1
 from PortfolioProject.dbo.NashvilleHousing


alter table nashvillehousing
add PropertySplitAddress nvarchar(255)

update NashvilleHousing
set PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table nashvillehousing
add PropertySplitCity nvarchar(255)

update NashvilleHousing
set PropertySplitCity  = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1,len(propertyaddress))

Select *
from PortfolioProject.dbo.NashvilleHousing


---------------------------------------------------------

--Owner address

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
parsename(replace(OwnerAddress,',','.'), 3)
,parsename(replace(OwnerAddress,',','.'), 2)
,parsename(replace(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.NashvilleHousing



alter table nashvillehousing
add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress  = parsename(replace(OwnerAddress,',','.'), 3)

alter table nashvillehousing
add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity  = parsename(replace(OwnerAddress,',','.'), 2)


alter table nashvillehousing
add OwnerSplitState nvarchar(255)

update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'), 1)
Select *
from PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------

--Changing Y and N to Yes and No in soldasvacant field

Select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select Soldasvacant
,case when SoldAsVacant= 'Y' THEN 'Yes'
      when SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant= case when SoldAsVacant= 'Y' THEN 'Yes'
      when SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END



----------------------------------------------------

--Remove Duplicates(Deleting duplicate data)

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

from PortfolioProject.dbo.NashvilleHousing
)

select *
from RowNumCTE
where row_num >1
order by PropertyAddress


---------------------------------------------------------------------------

--Deleting unused columns 

Select *
From PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate