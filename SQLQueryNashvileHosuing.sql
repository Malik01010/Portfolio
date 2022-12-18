-- Cleaning Data in SQL

Select *
From 
	PortfolioProject.dbo.NashvilleHousing 


--Standarize Data Format

ALTER TABLE 
	NashvilleHousing
Add 
	SaleDateConverted Date;

Update 
	NashvilleHousing
SET 
	SaleDateConverted = CONVERT(Date,SaleDate)


-- Populate Property Address data 

Select *
From 
	PortfolioProject.dbo.NashvilleHousing 
order by 
	ParcelID

Select 
	a.ParcelID, 
	a.PropertyAddress, 
	b.ParcelID, 
	b.PropertyAddress
From 
	PortfolioProject.dbo.NashvilleHousing a
	Join PortfolioProject.dbo.NashvilleHousing b
on 
	a.ParcelID = b.ParcelID
	And a.[uniqueID ] <> b.[UniqueID ]
Where 
	a.PropertyAddress is null

Update a
SET 
	PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From 
	PortfolioProject.dbo.NashvilleHousing a
	JOIN PortfolioProject.dbo.NashvilleHousing b
on 
	a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where 
	a.PropertyAddress is null


-- Change Y and N to Yes and No in "Sold As Vacant' field

Select 
	Distinct(soldAsVacant), 
	Count(SoldAsVacant)
From 
	PortfolioProject.dbo.NashvilleHousing
Group by 
	SoldAsVacant

Select 
	SoldAsVacant, 
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End
From PortfolioProject.dbo.NashvilleHousing

Update 
	NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	End

-- Remove Duplicates

Select 
	Distinct UniqueID,
	ParcelID,
	PropertyAddress
From 
	PortfolioProject.dbo.NashvilleHousing


-- Delete Unused Columns 

Select *
From 
	PortfolioProject.dbo.NashvilleHousing

ALTER TABLE 
	PortfolioProject.dbo.NashvilleHousing
DROP COLUMN 
	OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
