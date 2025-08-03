WITH table_data AS (
  SELECT
    tr.transaction_id,
    tr.date,
    tr.branch_id,
    tr.customer_name,
    tr.product_id,
    pr.product_name,
    pr.product_category,
    pr.price AS harga_awal,
    tr.price AS actual_price,
    tr.discount_percentage,
    tr.rating AS rating_transaksi,
    cb.branch_name,
    cb.kota,
    cb.provinsi,
    cb.branch_category,
    cb.rating AS rating_cabang,
    inv.inventory_id,
    inv.opname_stock
  FROM `kimia_farma.kf_final_transaction` tr
  LEFT JOIN `kimia_farma.kf_inventory` inv
    ON tr.branch_id = inv.branch_id AND tr.product_id = inv.product_id
  LEFT JOIN `kimia_farma.kf_kantor_cabang` cb
    ON tr.branch_id = cb.branch_id
  LEFT JOIN `kimia_farma.kf_product` pr
    ON tr.product_id = pr.product_id
)

SELECT 
  transaction_id,
  date,
  branch_id,
  customer_name,
  product_id,
  product_name,
  product_category,
  harga_awal,
  actual_price,
  discount_percentage,
  rating_transaksi,
  branch_name,
  kota,
  provinsi,
  branch_category,
  rating_cabang,
  inventory_id,
  opname_stock,
  actual_price * (1 - discount_percentage) AS nett_sales,
  CASE
    WHEN actual_price <= 50000 THEN 0.10
    WHEN actual_price <= 100000 THEN 0.15
    WHEN actual_price <= 300000 THEN 0.20
    WHEN actual_price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  (actual_price * (1 - discount_percentage)) *
  CASE
    WHEN actual_price <= 50000 THEN 0.10
    WHEN actual_price <= 100000 THEN 0.15
    WHEN actual_price <= 300000 THEN 0.20
    WHEN actual_price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit
FROM table_data;