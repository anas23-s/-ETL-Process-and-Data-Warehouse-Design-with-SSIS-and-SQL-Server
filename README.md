# ETL-Process-and-Data-Warehouse-Design-with-SSIS-and-SQL-Server
ETL process using SSIS to move data from a staging area into a SQL Server data warehouse with fact and dimension tables. Includes a .sql file for the warehouse design and stored procedures, transforming the original SSIS-based ETL process into scalable SQL procedures
## Overview

This project includes ETL processes implemented using SQL Server Integration Services (SSIS) and a detailed design of the data warehouse and staging area. The repository is organized into two main components:

1. **SSIS Packages**: This folder contains SSIS packages responsible for the ETL processes:
   - **Dimension Tables ETL Package**: This package extracts data from the staging area, transforms it, and loads it into the dimension tables of the data warehouse.
   - **Fact Tables ETL Package**: This package performs similar operations for the fact tables.
   - Screenshots illustrating the ETL processes for both dimension and fact tables are included.

2. **SQL Files**: This folder includes `.sql` files that define:
   - The design and structure of the data warehouse.
   - The schema of the staging area used for ETL processing.
## Installation

To get started with this project, follow these steps:

1. **Clone the Repository**:
   git clone < https://github.com/anas23-s/-ETL-Process-and-Data-Warehouse-Design-with-SSIS-and-SQL-Server>
   
2. **Set Up SQL Server and SSIS:**
   - Ensure that you have SQL Server and SQL Server Integration Services (SSIS) installed on your machine.
   - Install SQL Server Data Tools (SSDT) or Visual Studio if you don’t have them already.
   - Import SSIS Packages:

3. **Open SQL Server Data Tools (SSDT) or Visual Studio.**
   - Create a new SSIS project or open an existing one.
   - Import the SSIS packages from the SSIS folder into your SSIS project.

4. **Setup Data Warehouse and Staging Area:**
   - Open SQL Server Management Studio (SSMS).
   - Navigate to the SQL folder and open the .sql files.
   - Execute the SQL scripts to create the data warehouse schema and staging area.

5. **Verify Setup:**
   - Check the data warehouse and staging area to ensure that the schema and tables have been created correctly.
   
6. **Configure SSIS Packages:**
   - Open the imported SSIS packages.
   - Update the connection managers to point to your staging area and data warehouse.
   - Configure any additional package parameters or settings as needed.

7. **Execute SSIS Packages:**
   - Run the SSIS packages to perform the ETL processes and load data into the data warehouse.

## Contributing
Feel free to fork the repository, make changes, and submit pull requests. For significant changes, please open an issue first to discuss the changes.

