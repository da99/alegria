
CREATE TABLE IF NOT EXISTS main."item_in_order"(
  id INTEGER PRIMARY KEY,
  item_id INTEGER,
  order_id INTEGER,
  status INTEGER,
  created_at INTEGER
);
