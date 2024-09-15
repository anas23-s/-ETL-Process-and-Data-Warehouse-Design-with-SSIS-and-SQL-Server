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
