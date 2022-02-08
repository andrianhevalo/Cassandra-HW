CREATE KEYSPACE IF NOT EXISTS key_space WITH replication = {'class' : 'SimpleStrategy',   'replication_factor' : 1 };

USE key_space;

DROP TABLE IF EXISTS items;

CREATE TABLE IF NOT EXISTS items
(   name         TEXT,
    category     TEXT,
    price        FLOAT,
    manufacturer TEXT,
    characteristics   MAP <TEXT, TEXT>,
    PRIMARY KEY (category, price)
) WITH CLUSTERING ORDER BY (price DESC);


INSERT INTO key_space.items (name, category, price, manufacturer, characteristics)
VALUES ('Iphone 13 Pro Max', 'Phone', 1000, 'Apple', {'year_released': '2022', 'camera': '13MP', 'OS': 'IOS 13'});

INSERT INTO key_space.items (name, category, price, manufacturer, characteristics)
VALUES ('Iphone 12 Pro Max', 'Phone', 900, 'Apple', {'year_released': '2021', 'camera': '12MP', 'OS': 'IOS 12'});

INSERT INTO key_space.items (name, category, price, manufacturer, characteristics)
VALUES ('Samsung Galaxy S5', 'Phone', 850, 'Samsung', {'year_released': '2015', 'camera': '5MP', 'OS': 'Android'});

INSERT INTO key_space.items (name, category, price, manufacturer, characteristics)
VALUES ('Lenovo Phone', 'Phone', 700, 'Lenovo', {'year_released': '2018', 'camera': '8MP', 'OS': 'Android'});

INSERT INTO key_space.items (name, category, price, manufacturer, characteristics)
VALUES ('Samsung Smart TV', 'TV', 1200, 'Samsung', {'year_released': '2014', 'screen': '42', 'OS': 'Samsung TV OS'});

INSERT INTO key_space.items (name, category, price, manufacturer, characteristics)
VALUES ('Apple Watch Series 7', 'Watch', 300, 'Apple', {'year_released': '2021', 'waist': '42cm', 'OS': 'WatchOS'});

// Task 1 - Executed in terminal

// Task 2
SELECT name from items where category = 'Phone';

// Task 3

CREATE INDEX IF NOT EXISTS name_idx
ON items (name);

// a
SELECT * FROM items WHERE name = 'Iphone 13 Pro Max';

// b
CREATE MATERIALIZED VIEW items_name AS
    SELECT * FROM items WHERE category IS NOT NULL
                              AND price >= 1000 AND price <= 1200
    PRIMARY KEY ( category, price );

SELECT * from items_name;

// c
-- CREATE INDEX IF NOT EXISTS price_idx
-- ON items (price);

SELECT * FROM items WHERE price < 500 AND manufacturer = 'Apple';

DROP MATERIALIZED VIEW items_manufacturer;

CREATE MATERIALIZED VIEW items_manufacturer AS
    SELECT * FROM items WHERE category IS NOT NULL
                              AND manufacturer IS NOT NULL
                              AND price < 500
--                               AND manufacturer = 'Apple'
    PRIMARY KEY ( category, manufacturer, price );

CREATE INDEX IF NOT EXISTS manufacturer_idx
ON items_manufacturer (manufacturer);

SELECT * from items_manufacturer WHERE manufacturer = 'Apple';

// Task 4

// Task 5
