-----Cleaning Data using SQL-------------------------------------------------------------------------------------------------------------------


Select * 

From PortolioProject..Sheet1

------Convert The Date Format into Standardized Date Format-------------------------------------------------------------------------------------

Select SaleDateConverted,CONVERT(Date,SaleDate)
From PortolioProject..Sheet1

Update Sheet1
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Sheet1
Add SaleDateConverted Date;

Update Sheet1
SET SaleDateConverted = CONVERT(Date,SaleDate)


------ Populate The property Address Data-----------------------------------------------------------------------------------------------------


Select *
From PortolioProject..Sheet1
order by ParcelID
--Where PropertyAddress is null


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL (a.PropertyAddress,b.PropertyAddress)
From PortolioProject..Sheet1 a
JOIN PortolioProject..Sheet1 b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a

SET PropertyAddress=ISNULL (a.PropertyAddress,b.PropertyAddress)
From PortolioProject..Sheet1 a
JOIN PortolioProject..Sheet1 b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---Breaking Property Address into Individual into Columns(Address,City,State)-----------------------------------------------------------------

Select PropertyAddress
From PortolioProject..Sheet1
--order by ParcelID
--Where PropertyAddress is null



SELECT
SUBSTRING (PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)as Address

,SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address

From PortolioProject..Sheet1

ALTER TABLE Sheet1
Add PropertySplitAddress Nvarchar(255);

Update Sheet1
SET PropertySplitAddress=SUBSTRING (PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Sheet1
Add PropertySplitCity Nvarchar(255);

Update Sheet1
SET PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) 

Select *
From PortolioProject..Sheet1




Select OwnerAddress
From PortolioProject..Sheet1

----Lets use PARSENAME TO Seperate columns-------------------------------------------------------------------------------------------------------------

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

From PortolioProject..Sheet1

ALTER TABLE Sheet1
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE Sheet1
Add OwnerSplitCity Nvarchar(255);

Update Sheet1
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) 

ALTER TABLE Sheet1
Add OwnerSplitState Nvarchar(255);

Update Sheet1
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From PortolioProject..Sheet1




---------	-- Change Y and N to Yes and No in "Sold as Vacant" field -----------------------------------------------------------------------------------

Select Distinct(SoldAsVacant),Count(SoldAsVacant) as Count

From PortolioProject..Sheet1
Group by SoldAsVacant
order by 2


Select SoldAsVacant
,CASE When SoldAsVacant='Y' THEN 'Yes'
	  When SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  END
From PortolioProject..Sheet1

Update Sheet1

SET SoldAsVacant = CASE When SoldAsVacant='Y' THEN 'Yes'
	  When SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  END








-----------------------------Remove duplicate-----------------------------------------------------------------

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

From PortolioProject..Sheet1

)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortolioProject..Sheet1



------------------------Remove Unsued Column


ALTER TABLE PortolioProject..Sheet1
DROP COLUMN  PropertyAddress



---------------------DONE BY THE T.JUNIOR THE ANALYST---------------------------------------------------------------------------------------turatsinzecmu2020@gmail.com-------------------------------------------
