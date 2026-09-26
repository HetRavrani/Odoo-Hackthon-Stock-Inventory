-- Optional demo data for the StockSense client presentation.
-- Run AFTER database/schema.sql. All values are sample inventory data.
INSERT INTO categories(name) VALUES ('Raw Materials') ON CONFLICT(name) DO NOTHING;
INSERT INTO categories(name) VALUES ('Finished Goods') ON CONFLICT(name) DO NOTHING;
INSERT INTO products(name,sku,category_id,uom,reorder_level) VALUES
 ('Steel Rods','STEEL-001',(SELECT id FROM categories WHERE name='Raw Materials'),'Kg',20)
ON CONFLICT(sku) DO NOTHING;
INSERT INTO products(name,sku,category_id,uom,reorder_level) VALUES
 ('Office Chairs','CHAIR-001',(SELECT id FROM categories WHERE name='Finished Goods'),'Units',10)
ON CONFLICT(sku) DO NOTHING;
INSERT INTO products(name,sku,category_id,uom,reorder_level) VALUES
 ('Safety Helmets','HELMET-001',(SELECT id FROM categories WHERE name='Finished Goods'),'Units',5)
ON CONFLICT(sku) DO NOTHING;
INSERT INTO stock_balances(product_id,location_id,quantity) VALUES
 ((SELECT id FROM products WHERE sku='STEEL-001'),(SELECT id FROM locations WHERE code='MAIN' LIMIT 1),100),
 ((SELECT id FROM products WHERE sku='CHAIR-001'),(SELECT id FROM locations WHERE code='MAIN' LIMIT 1),6),
 ((SELECT id FROM products WHERE sku='HELMET-001'),(SELECT id FROM locations WHERE code='MAIN' LIMIT 1),0)
ON CONFLICT(product_id,location_id) DO UPDATE SET quantity=EXCLUDED.quantity;
INSERT INTO inventory_documents(document_no,document_type,status,warehouse_id,destination_location_id,partner_name,notes)
VALUES ('REC-DEMO-001','receipt','Waiting',(SELECT id FROM warehouses WHERE code='WH-MAIN'),(SELECT id FROM locations WHERE code='MAIN' LIMIT 1),'Demo Supplier','Pending receipt demo')
ON CONFLICT(document_no) DO NOTHING;
INSERT INTO inventory_documents(document_no,document_type,status,warehouse_id,source_location_id,partner_name,notes)
VALUES ('DEL-DEMO-001','delivery','Ready',(SELECT id FROM warehouses WHERE code='WH-MAIN'),(SELECT id FROM locations WHERE code='MAIN' LIMIT 1),'Demo Customer','Pick and pack completed demo')
ON CONFLICT(document_no) DO NOTHING;
INSERT INTO inventory_documents(document_no,document_type,status,warehouse_id,source_location_id,destination_location_id,partner_name,notes)
VALUES ('INT-DEMO-001','internal','Waiting',(SELECT id FROM warehouses WHERE code='WH-MAIN'),(SELECT id FROM locations WHERE code='MAIN' LIMIT 1),(SELECT id FROM locations WHERE id<>(SELECT id FROM locations WHERE code='MAIN' LIMIT 1) ORDER BY id LIMIT 1),'Internal Production','Scheduled internal transfer demo')
ON CONFLICT(document_no) DO NOTHING;
