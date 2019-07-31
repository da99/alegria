
CREATE TABLE IF NOT EXISTS main."receipt"(
  id         INTEGER PRIMARY KEY,
  created_at INTEGER,
  charged_at INTEGER,
  status     INTEGER
);
