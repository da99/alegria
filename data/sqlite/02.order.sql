
CREATE TABLE IF NOT EXISTS main."order"(
  id           INTEGER PRIMARY KEY,
  created_at   INTEGER,
  completed_at INTEGER,
  charged_at   INTEGER,
  status       INTEGER
);
