select *
from PortfolioProject.dbo.[NashvilleHousing]

--- Date Format

select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.[NashvilleHousing]

Update [NashvilleHousing]
set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update [NashvilleHousing]
set SaleDateConverted = CONVERT(Date,SaleDate)


--- Populating Address data

select *
from PortfolioProject.dbo.[NashvilleHousing]
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.[NashvilleHousing] a
join PortfolioProject.dbo.[NashvilleHousing] b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
Set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.[NashvilleHousing] a
join PortfolioProject.dbo.[NashvilleHousing] b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--- Breaking Address into Seperate Columns (Address, City, State)

select PropertyAddress
from PortfolioProject.dbo.[NashvilleHousing]


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.[NashvilleHousing]


ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update [NashvilleHousing]
set PropertySplitAddress   = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 



ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update [NashvilleHousing]
set PropertySplitCity  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

select *
from PortfolioProject.dbo.[NashvilleHousing]



-- SEPERATING OWNER ADDRESS

select OwnerAddress
from PortfolioProject.dbo.[NashvilleHousing]


Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from PortfolioProject.dbo.[NashvilleHousing]


ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update [NashvilleHousing]
set OwnerSplitAddress   = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update [NashvilleHousing]
set OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update [NashvilleHousing]
set OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)



-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NashvilleHousing


UpDate NashvilleHousing
set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


--Removing Duplcates
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
--ORDER BY ParcelID
)
select *
from RowNumCTE
WHERE row_num > 1



--Delete Unused Columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

