# 🏗️ SQL Data Warehouse Project

## 📌 Project Overview

This project demonstrates a **modern data warehouse** built from the ground up, covering architecture design, ETL pipeline development, dimensional data modeling, and SQL-based analytics.

---

## 🏛️ Data Architecture

The solution is structured around the **Medallion Architecture**, organizing data into three progressive layers of quality and readiness:
<img width="959" height="729" alt="image" src="https://github.com/user-attachments/assets/e793e1c1-e853-413d-8343-8ea9b12d3b44" />


## 🔧 Project Components

### 1. ETL Pipelines
- Extract data from flat CSV source files
- Transform with cleansing, standardization, and business rule application
- Load into layered SQL Server database tables across Bronze → Silver → Gold

### 2. Data Modeling
- Dimensional modeling using the **Star Schema** pattern
- Fact tables capturing measurable business events
- Dimension tables providing descriptive context (customers, products, dates, etc.)
- Optimized for analytical query performance

- ## 🛠️ Tech Stack

- **Database:** Microsoft SQL Server
- **Query Language:** T-SQL
- **Source Format:** CSV flat files
- **Architecture Pattern:** Medallion (Bronze / Silver / Gold)
- **Modeling Pattern:** Star Schema 
