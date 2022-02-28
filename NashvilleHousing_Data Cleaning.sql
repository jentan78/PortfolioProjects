/* 
Cleaning Data in SQL Queries 
*/ 

USE PortfolioProj; 

SELECT * FROM [PortfolioProj]..[NashvilleHousing]; 

--Standardize Date Format 

ALTER TABLE [NashvilleHousing]
ADD SalesConvertedDate DATE; 

UPDATE [NashvilleHousing]
SET SalesConvertedDate = CONVERT(Date,SaleDate) 


SELECT SaleDate, SalesConvertedDate
FROM [PortfolioProj]..[NashvilleHousing];

------------------------------------------- 
--Populate Property Address Data
------------------------------------------- 

SELECT count(*) AS NoofRec 
FROM [PortfolioProj]..[NashvilleHousing] 
WHERE PropertyAddress IS NULL

SELECT UniqueID, ParcelID, PropertyAddress 
FROM [PortfolioProj]..[NashvilleHousing]  

SELECT a.UniqueID, a.ParcelID, a.PropertyAddress, b.UniqueID, b.ParcelID, b.PropertyAddress, ISNULL(b.PropertyAddress, a.PropertyAddress)
FROM [PortfolioProj]..[NashvilleHousing] a 
JOIN [PortfolioProj]..[NashvilleHousing] b
ON a.ParcelID = b.ParcelID AND
a.UniqueID != b.UniqueID
WHERE b.PropertyAddress IS NULL


UPDATE b
SET PropertyAddress = ISNULL(b.PropertyAddress, a.PropertyAddress)
FROM [PortfolioProj]..[NashvilleHousing] a 
JOIN [PortfolioProj]..[NashvilleHousing] b
ON a.ParcelID = b.ParcelID AND
a.UniqueID != b.UniqueID
WHERE b.PropertyAddress IS NULL

---------------------------------------------------------------------------
--Breaking out Address into Individual Columns(Address, City, State) 
---------------------------------------------------------------------------

SELECT PropertyAddress FROM [PortfolioProj]..[NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) - 1) AS Address1, 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS Address2
FROM [PortfolioProj]..[NashvilleHousing]

ALTER TABLE [NashvilleHousing]
ADD PropertySplittoAddress NVARCHAR(255); 

ALTER TABLE [NashvilleHousing]
ADD PropertySplittoCity NVARCHAR(255); 

UPDATE [NashvilleHousing] 
SET PropertySplittoAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) - 1) 

UPDATE [NashvilleHousing] 
SET PropertySplittoCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

SELECT * FROM [PortfolioProj]..[NashvilleHousing]

SELECT OwnerAddress FROM [PortfolioProj]..[NashvilleHousing]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [PortfolioProj]..[NashvilleHousing]

ALTER TABLE [NashvilleHousing]
ADD OwnerSplittoAddress NVARCHAR(255); 

ALTER TABLE [NashvilleHousing]
ADD OwnerSplittoCity NVARCHAR(255); 

ALTER TABLE [NashvilleHousing]
ADD OwnerSplittoState NVARCHAR(255); 

UPDATE [NashvilleHousing] 
SET OwnerSplittoAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE [NashvilleHousing] 
SET OwnerSplittoCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE [NashvilleHousing] 
SET OwnerSplittoState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT * FROM [PortfolioProj]..[NashvilleHousing]

--------------------------------------------------------
--Change Y and N to Yes and No in 'Sold as Vacant' field
--------------------------------------------------------

SELECT DISTINCT(SoldAsVacant) , Count(SoldAsVacant)
FROM PortfolioProj..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC

SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProj..NashvilleHousing

UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes' 
        WHEN SoldAsVacant = 'N' THEN 'No' 
		ELSE SoldAsVacant
		END


---------------- 
--Duplicates
----------------
WITH RowNumCTE AS (
SELECT *, ROW_NUMBER() OVER (
	 PARTITION BY ParcelID, 
	              PropertyAddress, 
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				       UniqueID
					   ) row_num

FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1


------------------------
--Delete Unused  Columns
-------------------------
SELECT * 
FROM PortfolioProj..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate