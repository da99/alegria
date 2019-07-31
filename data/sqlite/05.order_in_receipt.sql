
CREATE TABLE IF NOT EXISTS main."order_in_receipt"(
  id INTEGER PRIMARY KEY,
  order_id INTEGER,
  receipt_id INTEGER,
  status INTEGER,
  create_at INTEGER
);
