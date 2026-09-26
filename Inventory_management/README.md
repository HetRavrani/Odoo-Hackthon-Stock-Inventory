# StockSense - inventory_management

Odoo 19-inspired Inventory Management System based on the supplied StockSense requirements document.

## Requirements covered
- Inventory Manager and Warehouse Staff roles with visible responsibilities and access control.
- Signup/login and local-demo OTP password reset.
- Inventory Dashboard with the five requested KPIs.
- Dynamic filters for document type, status, warehouse, location and product category.
- Products with name, SKU/code, category, UOM, optional initial stock, location availability and reorder level.
- Receipts: validate increases stock.
- Delivery Orders: Pick -> Pack -> Validate; validate decreases stock.
- Internal Transfers between locations/warehouses, recorded in Stock Ledger.
- Inventory Adjustments using physical counted quantity, with automatic stock difference and ledger entry.
- Move History / Stock Ledger.
- Low-stock/out-of-stock warning notifications.
- Multi-warehouse support.
- SKU/product/warehouse smart search.
- Profile and logout.

## PostgreSQL setup
Create the database and make the application user the database owner:

```bash
sudo -u postgres psql
DROP DATABASE IF EXISTS odoo_hk_stock_management;
CREATE DATABASE odoo_hk_stock_management OWNER stocksense_user;
\q
```

Then configure `.env` from `.env.example` and run:

```bash
npm install
psql -h localhost -U stocksense_user -d odoo_hk_stock_management -W -f database/schema.sql
```

Optional presentation data:

```bash
psql -h localhost -U stocksense_user -d odoo_hk_stock_management -W -f database/demo_data.sql
```

Start:

```bash
npm start
```

Open `http://localhost:3000`.

## Demo flow from the document
1. Create/login as Inventory Manager or Warehouse Staff.
2. Create a product such as Steel Rods with SKU STEEL-001 and a reorder level.
3. Receive stock and validate the receipt.
4. Move stock from Main Store to another production/location when configured.
5. Create a Delivery Order and use Pick -> Pack -> Validate.
6. Create an Inventory Adjustment with the physical counted quantity.
7. Check the low-stock warning and Stock Ledger.
