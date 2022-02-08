CREATE KEYSPACE IF NOT EXISTS key_space WITH replication = {'class' : 'SimpleStrategy',   'replication_factor' : 1 };

USE key_space;

DROP MATERIALIZED VIEW items_manufacturer;
DROP MATERIALIZED VIEW items_name;
DROP TABLE IF EXISTS items;

-- Part 1
CREATE TABLE IF NOT EXISTS items
(   name         TEXT,
    category     TEXT,
    price        FLOAT,
    manufacturer TEXT,
    characteristics   MAP <TEXT, TEXT>,
    PRIMARY KEY (category, price)
) WITH CLUSTERING ORDER BY (price DESC);


INSERT INTO items (name, category, price, manufacturer, characteristics)
VALUES ('Iphone 13 Pro Max', 'Phone', 1000, 'Apple', {'year_released': '2022', 'camera': '13MP', 'OS': 'IOS 13'});

INSERT INTO items (name, category, price, manufacturer, characteristics)
VALUES ('Iphone 12 Pro Max', 'Phone', 900, 'Apple', {'year_released': '2021', 'camera': '12MP', 'OS': 'IOS 12'});

INSERT INTO items (name, category, price, manufacturer, characteristics)
VALUES ('Samsung Galaxy S5', 'Phone', 850, 'Samsung', {'year_released': '2015', 'camera': '5MP', 'OS': 'Android'});

INSERT INTO items (name, category, price, manufacturer, characteristics)
VALUES ('Lenovo Phone', 'Phone', 700, 'Lenovo', {'year_released': '2018', 'camera': '8MP', 'OS': 'Android'});

INSERT INTO items (name, category, price, manufacturer, characteristics)
VALUES ('Samsung Smart TV', 'TV', 1200, 'Samsung', {'year_released': '2014', 'screen': '42', 'OS': 'Samsung TV OS'});

INSERT INTO items (name, category, price, manufacturer, characteristics)
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
-- a
CREATE INDEX IF NOT EXISTS tv_idx
ON items ( KEYS (characteristics) );

SELECT * FROM items WHERE characteristics CONTAINS KEY 'screen';

--b
DROP INDEX year_idx;
CREATE INDEX IF NOT EXISTS year_idx
ON items (ENTRIES(characteristics));

SELECT * FROM items WHERE characteristics['year_released'] = '2021';

// Task 5
-- a
UPDATE items SET characteristics['camera'] = '14MP' where category = 'Phone' and price = 900;
SELECT * FROM items;

--b
UPDATE items SET characteristics = characteristics + {'score': '10'} where category = 'TV' and price = 1200;
SELECT * from items where category = 'TV';

--c
DELETE characteristics['score'] FROM items where category = 'TV' and price = 1200;
SELECT * from items where category = 'TV';

-- Part 2
DROP TABLE orders;
CREATE TABLE IF NOT EXISTS orders (
    customer_name text,
    items LIST<text>,
    total_sum float,
    order_date TIMESTAMP,
    PRIMARY KEY ( customer_name, order_date ))
    WITH CLUSTERING ORDER BY (order_date DESC);


INSERT INTO orders (customer_name, items, total_sum, order_date)
VALUES ('Andrian', ['Iphone 13 Pro Max', 'Samsung Smart TV'], 2000, '2022-02-08');

INSERT INTO orders (customer_name, items, total_sum, order_date)
VALUES ('Oleh', ['Iphone 12 Pro Max'], 1200, '2022-02-03');

INSERT INTO orders (customer_name, items, total_sum, order_date)
VALUES ('Sasha', ['Samsung Smart TV'], 1300, '2022-02-12');

INSERT INTO orders (customer_name, items, total_sum, order_date)
VALUES ('Denys', ['Iphone 13 Pro Max', 'Samsung Smart TV', 'Samsung Galaxy S5'], 2000, '2022-02-08');

INSERT INTO orders (customer_name, items, total_sum, order_date)
VALUES ('Andrian', ['Lenovo Phone'], 700, '2022-01-08');

// Task 1 - Describe in terminal

// Task 2
SELECT * FROM orders where customer_name = 'Andrian';

// Task 3
CREATE INDEX IF NOT EXISTS items_idx
ON orders  (items);

SELECT * FROM orders where items CONTAINS 'Lenovo Phone' and customer_name = 'Andrian';

// Task 4
SELECT COUNT(*) FROM orders WHERE customer_name = 'Andrian' and order_date > '2021-01-01';

// Task 5

SELECT customer_name, SUM(total_sum) FROM orders GROUP BY customer_name;

// Task 6
SELECT customer_name, max(total_sum) from orders GROUP BY customer_name;

// Task 7
UPDATE orders SET items = items + ['Apple TV'] WHERE customer_name = 'Oleh' and order_date = '2022-02-03';
SELECT * FROM orders;

// Task 8
SELECT customer_name, WRITETIME(total_sum) from orders;

// Task 9
INSERT INTO orders (customer_name, items, total_sum, order_date)
VALUES ('Andrii', ['Something'], 500, '2022-01-08')
USING TTL 86400;
SELECT * FROM orders;

// Task 10
SELECT JSON * FROM orders;

// Task 11

INSERT INTO orders JSON '{
  "customer_name" : "Pavlo",
  "items" : ["anything"],
  "total_sum" : "800",
  "order_date" : "2021-05-05" }';
SELECT * from orders;