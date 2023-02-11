--standardize date format
select SaleDate, convert (date,SaleDate) 
from PorfolioProject..NashvilleHousing
update NashvilleHousing
set SaleDate=convert (date,SaleDate)

--populate propert address data

select a.parcelid,a.Propertyaddress,b.parcelid,b.propertyaddress,isnull (a.PropertyAddress,b.PropertyAddress)
from PorfolioProject..NashvilleHousing a
join PorfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set a.propertyaddress = isnull (a.PropertyAddress,b.PropertyAddress)
from PorfolioProject..NashvilleHousing a
join PorfolioProject..NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
	where a.PropertyAddress is null

select propertyaddress
from PorfolioProject..NashvilleHousing
where PropertyAddress is null

-- breakind address into different columns

select 
SUBSTRING(PropertyAddress,1,CHARINDEX (',',PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX (',',PropertyAddress)+1,len(propertyaddress))
from PorfolioProject.dbo.NashvilleHousing

--change Y and N to yes and no

select distinct(SoldAsVacant),
count (soldasvacant)
from PorfolioProject..NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
case when soldasvacant = 'y' then 'yes'
when SoldAsVacant='n' then 'no'
else soldasvacant
end

from PorfolioProject..NashvilleHousing


update PorfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
when SoldAsVacant='n' then 'no'
else SoldAsVacant
end

--remove duplicates

with RowNumCte as(
select *,
ROW_NUMBER () over (
partition by	parcelid,
				landuse,
				propertyaddress,
				saledate,
				saleprice,
				legalreference
				order by uniqueid) rownum
from PorfolioProject..NashvilleHousing
)  
delete
from RowNumCte
where rownum >1






  select *
  from PorfolioProject..NashvilleHousing