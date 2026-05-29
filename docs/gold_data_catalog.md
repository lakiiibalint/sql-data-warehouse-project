# 📦 Gold Layer — Data Catalog

---

## Table of Contents

- [gold.dim_customer](#golddim_customer)
- [gold.dim_products](#golddim_products)
- [gold.fact_sales](#goldfact_sales)

---

## gold.dim_customer

**Type:** Dimension View  
**Description:** Contains cleansed and enriched customer master data. Each row represents one unique customer, identified by a surrogate key. Used for customer-level analysis including demographics, geography, and segmentation.

### Columns

| Column Name | Data Type | Nullable | Description |
|---|---|---|---|
| `customer_key` | BIGINT | YES | Surrogate key — primary identifier for the customer dimension (system-generated). |
| `customer_id` | INT | YES | Natural/business key — original customer identifier from the source system. |
| `customer_number` | NVARCHAR(50) | YES | Human-readable customer reference number (e.g. account code). |
| `first_name` | NVARCHAR(50) | YES | Customer's first name. |
| `last_name` | NVARCHAR(50) | YES | Customer's last name. |
| `country` | NVARCHAR(50) | YES | Country of residence. Used for geographic segmentation and reporting. |
| `marital_status` | NVARCHAR(50) | YES | Marital status of the customer (e.g. Single, Married). |
| `gender` | NVARCHAR(50) | YES | Gender of the customer. |
| `birthdate` | DATE | YES | Date of birth. Can be used to derive age and age group metrics. |
| `create_date` | DATE | YES | Date the customer record was first created in the source system. |

### Relationships

| Related Table | Join Key | Type |
|---|---|---|
| `gold.fact_sales` | `customer_key` | One-to-Many |

### Notes

- `customer_key` is the recommended join key when linking to `gold.fact_sales`.
- `customer_id` can be used for tracing records back to the source system.

---

## gold.dim_products

**Type:** Dimension View  
**Description:** Contains enriched product master data. Each row represents one unique product, identified by a surrogate key. Supports product-level analysis including category hierarchies, cost tracking, and product lifecycle.

### Columns

| Column Name | Data Type | Nullable | Description |
|---|---|---|---|
| `product_key` | BIGINT | YES | Surrogate key — primary identifier for the product dimension (system-generated). |
| `product_id` | INT | YES | Natural/business key — original product identifier from the source system. |
| `product_number` | NVARCHAR(50) | YES | Human-readable product reference code (e.g. SKU or part number). |
| `product_name` | NVARCHAR(50) | YES | Full descriptive name of the product. |
| `category_id` | NVARCHAR(50) | YES | Identifier for the top-level product category. |
| `category` | NVARCHAR(50) | YES | Top-level product category name (e.g. Bikes, Accessories). |
| `subcategory` | NVARCHAR(50) | YES | Sub-classification within the category (e.g. Road Bikes, Helmets). |
| `maintenance` | NVARCHAR(50) | YES | Indicates maintenance requirements or classification for the product. |
| `cost` | INT | YES | Standard cost of the product. Used in margin and profitability calculations. |
| `product_line` | NVARCHAR(50) | YES | Product line grouping (e.g. Road, Mountain, Touring). |
| `start_date` | DATE | YES | Date from which the product became active or was introduced. |

### Relationships

| Related Table | Join Key | Type |
|---|---|---|
| `gold.fact_sales` | `product_key` | One-to-Many |

### Notes

- Use `category` and `subcategory` together to build product hierarchies in reports.
- `cost` combined with `price` from `gold.fact_sales` enables gross margin analysis.
- `start_date` can be used for product lifecycle and cohort analysis.

---

## gold.fact_sales

**Type:** Fact View  
**Description:** Central fact table capturing transactional sales data. Each row represents one line item on a sales order. Connects to both customer and product dimensions via surrogate keys.

### Columns

| Column Name | Data Type | Nullable | Description |
|---|---|---|---|
| `order_number` | NVARCHAR(50) | YES | Business identifier for the sales order. Multiple rows can share an order number (one per line item). |
| `product_key` | BIGINT | YES | Foreign key referencing `gold.dim_products.product_key`. |
| `customer_key` | BIGINT | YES | Foreign key referencing `gold.dim_customer.customer_key`. |
| `order_date` | DATE | YES | Date the order was placed. Primary date dimension for time-series analysis. |
| `shipping_date` | DATE | YES | Date the order was shipped. Used to compute fulfilment lead time. |
| `due_date` | DATE | YES | Expected delivery due date. Used for SLA and on-time delivery analysis. |
| `sales_amount` | INT | YES | Total sales value for the line item (quantity × price, or pre-calculated). |
| `quantity` | INT | YES | Number of units ordered. |
| `price` | INT | YES | Unit selling price at the time of the transaction. |

### Relationships

| Related Table | Join Key | Type |
|---|---|---|
| `gold.dim_customer` | `customer_key` | Many-to-One |
| `gold.dim_products` | `product_key` | Many-to-One |

### Derived Metrics

| Metric | Formula | Description |
|---|---|---|
| **Revenue** | `SUM(sales_amount)` | Total revenue across selected filters. |
| **Units Sold** | `SUM(quantity)` | Total units sold. |
| **Average Order Value** | `SUM(sales_amount) / COUNT(DISTINCT order_number)` | Mean value per order. |
| **Gross Margin** | `SUM(sales_amount) - SUM(quantity × cost)` | Requires join to `dim_products.cost`. |
| **Fulfilment Lead Time** | `shipping_date - order_date` | Days between order placement and shipment. |

### Notes

- `order_number` alone does not uniquely identify a row; use `order_number + product_key` as a composite grain identifier.
- Date filtering should primarily use `order_date` unless the use case specifically requires shipping or due date.
- `sales_amount` may be pre-aggregated in source; validate against `quantity × price` if precision is required.

---

## Entity Relationship Overview

```
gold.dim_customer          gold.dim_products
─────────────────          ─────────────────
customer_key (PK) ◄──┐ ┌──► product_key (PK)
customer_id            │ │    product_id
first_name             │ │    product_name
last_name              │ │    category
country                │ │    subcategory
...                    │ │    cost
                       │ │    ...
              gold.fact_sales
              ──────────────
              order_number
              customer_key (FK) ──┘
              product_key  (FK) ──┘
              order_date
              sales_amount
              quantity
              price
```

---

*Data catalog generated from schema inspection of the `gold` layer.*
