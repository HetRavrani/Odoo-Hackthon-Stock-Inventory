CREATE TABLE IF NOT EXISTS users (
 id SERIAL PRIMARY KEY, full_name VARCHAR(150) NOT NULL, email VARCHAR(255) UNIQUE NOT NULL,
 password_hash TEXT NOT NULL, role VARCHAR(60) NOT NULL DEFAULT 'Inventory Manager' CHECK(role IN ('Inventory Manager','Warehouse Staff')),
 is_active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS warehouses (
 id SERIAL PRIMARY KEY, name VARCHAR(150) NOT NULL, code VARCHAR(50) UNIQUE NOT NULL,
 address TEXT, active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS locations (
 id SERIAL PRIMARY KEY, warehouse_id INT NOT NULL REFERENCES warehouses(id) ON DELETE CASCADE,
 name VARCHAR(150) NOT NULL, code VARCHAR(50) NOT NULL, active BOOLEAN NOT NULL DEFAULT TRUE,
 UNIQUE(warehouse_id, code)
);
CREATE TABLE IF NOT EXISTS categories (
 id SERIAL PRIMARY KEY, name VARCHAR(150) UNIQUE NOT NULL, active BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS products (
 id SERIAL PRIMARY KEY, name VARCHAR(200) NOT NULL, sku VARCHAR(100) UNIQUE NOT NULL,
 category_id INT REFERENCES categories(id) ON DELETE SET NULL, uom VARCHAR(50) NOT NULL DEFAULT 'Units',
 reorder_level NUMERIC(14,3) NOT NULL DEFAULT 0, active BOOLEAN NOT NULL DEFAULT TRUE,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS stock_balances (
 id SERIAL PRIMARY KEY, product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
 location_id INT NOT NULL REFERENCES locations(id) ON DELETE CASCADE, quantity NUMERIC(14,3) NOT NULL DEFAULT 0,
 UNIQUE(product_id, location_id)
);
CREATE TABLE IF NOT EXISTS inventory_documents (
 id SERIAL PRIMARY KEY, document_no VARCHAR(50) UNIQUE NOT NULL, document_type VARCHAR(30) NOT NULL CHECK(document_type IN ('receipt','delivery','internal','adjustment')),
 status VARCHAR(20) NOT NULL DEFAULT 'Draft' CHECK(status IN ('Draft','Waiting','Ready','Done','Canceled')),
 warehouse_id INT REFERENCES warehouses(id), source_location_id INT REFERENCES locations(id), destination_location_id INT REFERENCES locations(id),
 partner_name VARCHAR(200), notes TEXT, created_by INT REFERENCES users(id) ON DELETE SET NULL,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, validated_at TIMESTAMP
);
CREATE TABLE IF NOT EXISTS inventory_document_lines (
 id SERIAL PRIMARY KEY, document_id INT NOT NULL REFERENCES inventory_documents(id) ON DELETE CASCADE,
 product_id INT NOT NULL REFERENCES products(id), quantity NUMERIC(14,3) NOT NULL CHECK(quantity > 0)
);
CREATE TABLE IF NOT EXISTS stock_ledger (
 id SERIAL PRIMARY KEY, document_id INT REFERENCES inventory_documents(id) ON DELETE SET NULL,
 product_id INT NOT NULL REFERENCES products(id), from_location_id INT REFERENCES locations(id), to_location_id INT REFERENCES locations(id),
 quantity NUMERIC(14,3) NOT NULL, movement_type VARCHAR(30) NOT NULL, note TEXT, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS password_reset_otps (
 id SERIAL PRIMARY KEY, user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE, otp_hash TEXT NOT NULL,
 expires_at TIMESTAMP NOT NULL, used BOOLEAN NOT NULL DEFAULT FALSE, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO warehouses(name,code,address) VALUES ('Main Warehouse','WH-MAIN','') ON CONFLICT(code) DO NOTHING;
INSERT INTO locations(warehouse_id,name,code) SELECT id,'Main Store','MAIN' FROM warehouses WHERE code='WH-MAIN' AND NOT EXISTS (SELECT 1 FROM locations WHERE code='MAIN');
INSERT INTO categories(name) VALUES ('General') ON CONFLICT(name) DO NOTHING;
