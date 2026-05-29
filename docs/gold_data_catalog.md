# 📦 Gold Layer — Data Catalog

## Table of Contents

- [gold.dim_customer](#golddim_customer)
- [gold.dim_products](#golddim_products)
- [gold.fact_sales](#goldfact_sales)

---

## gold.dim_customer

**Type:** Dimension View  
**Description:** Contains cleansed and enriched customer master data. Each row represents one unique customer, identified by a surrogate key.

### Columns

| Column Name | Data Type | Description |
|---|---|---|
| `customer_key` | INT | Surrogate key - primary identifier for the customer dimension (system-generated). |
| `customer_id` | INT | Natural/business key - original customer identifier from the source system. |
| `customer_number` | NVARCHAR(50) | Human-readable customer reference number (e.g. account code). |
| `first_name` | NVARCHAR(50) | Customer's first name. |
| `last_name` | NVARCHAR(50) | Customer's last name. |
| `country` | NVARCHAR(50) | Country of residence. |
| `marital_status` | NVARCHAR(50) | Marital status of the customer (e.g. Single, Married). |
| `gender` | NVARCHAR(50) | Gender of the customer. |
| `birthdate` | DATE | Date of birth. (Format : YYYY-MM-DD, 1971-05-10). |
| `create_date` | DATE | Date the customer record was first created in the source system. |

### Relationships

| Related Table | Join Key | Type |
|---|---|---|
| `gold.fact_sales` | `customer_key` | One-to-Many |

---

## gold.dim_products

**Type:** Dimension View  
**Description:** Contains enriched product master data. Each row represents one unique product, identified by a surrogate key. 

### Columns

| Column Name | Data Type | Description |
|---|---|---|
| `product_key` | INT | Surrogate key - primary identifier for the product dimension (system-generated). |
| `product_id` | INT | Natural/business key - original product identifier from the source system. |
| `product_number` | NVARCHAR(50) | Human-readable product reference code. |
| `product_name` | NVARCHAR(50) | Full descriptive name of the product. |
| `category_id` | NVARCHAR(50) | Identifier for the top-level product category. |
| `category` | NVARCHAR(50) | Top-level product category name (e.g. Bikes, Accessories). |
| `subcategory` | NVARCHAR(50) | Sub-category within the category (e.g. Road Bikes, Helmets). |
| `maintenance` | NVARCHAR(50) | Indicates maintenance requirements(e.g. Yes, No) |
| `cost` | INT | Standard cost of the product. |
| `product_line` | NVARCHAR(50) | Product line grouping (e.g. Road, Mountain, Touring). |
| `start_date` | DATE | Date from which the product became active or was introduced. |

### Relationships

| Related Table | Join Key | Type |
|---|---|---|
| `gold.fact_sales` | `product_key` | One-to-Many |

---

## gold.fact_sales

**Type:** Fact View  
**Description:** Central fact table capturing transactional sales data. Each row represents one line item on a sales order. Connects to both customer and product dimensions via surrogate keys.

### Columns

| Column Name | Data Type | Description |
|---|---|---|
| `order_number` | NVARCHAR(50) | Business identifier for the sales order. Multiple rows can share an order number (one per line item). |
| `product_key` | INT | Foreign key referencing `gold.dim_products.product_key`. |
| `customer_key` | INT | Foreign key referencing `gold.dim_customer.customer_key`. |
| `order_date` | DATE | Date the order was placed. |
| `shipping_date` | DATE | Date the order was shipped.|
| `due_date` | DATE | Expected delivery due date. |
| `sales_amount` | INT | Total sales value for the line item (quantity × price). |
| `quantity` | INT | Number of units ordered. |
| `price` | INT | Unit selling price at the time of the transaction. |

### Relationships

| Related Table | Join Key | Type |
|---|---|---|
| `gold.dim_customer` | `customer_key` | Many-to-One |
| `gold.dim_products` | `product_key` | Many-to-One |

