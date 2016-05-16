DROP TABLE IF EXISTS bikes;
DROP TABLE IF EXISTS humans;
DROP TABLE IF EXISTS houses;

CREATE TABLE bikes (
  id INTEGER PRIMARY KEY,
  color VARCHAR(255) NOT NULL,
  owner_id INTEGER NOT NULL,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER NOT NULL,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO houses (address) VALUES ("1203 Highland Dr.");
INSERT INTO houses (address) VALUES ("101 Channing Ave.");
INSERT INTO humans (fname, lname, house_id) VALUES ("Sara", "Westfall", 1);
INSERT INTO humans (fname, lname, house_id) VALUES ("Charlie", "Kayson", 1);
INSERT INTO bikes (color, owner_id) VALUES ("blue", 1);
INSERT INTO bikes (color, owner_id) VALUES ("red", 1);
INSERT INTO bikes (color, owner_id) VALUES ("green", 2);
INSERT INTO bikes (color, owner_id) VALUES ("yellow", 2);
