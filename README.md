Data Cleaning in SQL Queries
This SQL script focuses on cleaning and enhancing the quality of data in the NashvillHousing table. The script performs various tasks to standardize date formats, populate missing property addresses, split address columns, change 'Y' and 'N' to 'Yes' and 'No,' remove duplicates, and delete unused columns. Additionally, it demonstrates importing data using both OPENROWSET and BULK INSERT methods.

Data Standardization
1. Standardizing Date Format
The script creates a new column saledateconvert to store standardized sale dates using the CONVERT function.
2. Populating Missing Property Addresses
The script updates the PropertyAddress column with values from other records when it is null, based on the matching ParcelID.
3. Breaking out Address into Individual Columns
New columns PropertySplitAddress, PropertySplitCity, and PropertySplitState are added to break down the PropertyAddress into separate parts.
4. Breaking out Owner Address into Individual Columns
New columns OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState are added to break down the OwnerAddress into separate parts.
5. Changing 'Y' and 'N' to 'Yes' and 'No'
The soldasvacant column is updated using the CASE WHEN statement to change 'Y' to 'Yes' and 'N' to 'No'.
Data Quality Improvement
6. Removing Duplicates
Duplicate records are identified using the ROW_NUMBER() function, and only the first occurrence is kept. This helps in maintaining data integrity.
7. Deleting Unused Columns
Unused columns (OwnerAddress, TaxDistrict, PropertyAddress) are dropped to simplify the table structure.
Importing Data
8. Importing Data using OPENROWSET and BULK INSERT
The script includes examples of importing data into the NashvillHousing table using both OPENROWSET and BULK INSERT methods. These methods are more advanced and may require server configuration.
Usage
Execute the script against your SQL Server database containing the NashvillHousing table.
Review the results and ensure that the data has been standardized and cleaned appropriately.
Customize the script according to your specific data cleaning needs.
Use the provided import examples if needed, ensuring proper server configurations.
Notes
Ensure that you have appropriate permissions to alter tables and perform data modifications.
Back up your data before running data cleaning scripts, especially when removing duplicates.
