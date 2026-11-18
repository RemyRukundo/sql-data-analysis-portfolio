-- Project 1: Order & Delivery Performance
-- Author: Remy Rukundo
-- Note: sample data, created for practice. SQLite syntax.

-- 1. Create the table
CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    order_date   DATE,
    client       TEXT,
    warehouse    TEXT,
    status       TEXT,
    items        INTEGER,
    shipped_date DATE
);

-- 2. Add sample data
INSERT INTO orders VALUES
(1,  '2026-01-05', 'Client A', 'Utrecht', 'Delivered', 12, '2026-01-07'),
(2,  '2026-01-06', 'Client B', 'Utrecht', 'Delivered',  5, '2026-01-11'),
(3,  '2026-01-09', 'Client A', 'Gouda',   'Delivered', 20, '2026-01-10'),
(4,  '2026-01-15', 'Client C', 'Gouda',   'Delivered',  8, '2026-01-20'),
(5,  '2026-02-02', 'Client B', 'Utrecht', 'Delivered', 15, '2026-02-04'),
(6,  '2026-02-10', 'Client C', 'Gouda',   'Cancelled',  3, NULL),
(7,  '2026-02-14', 'Client A', 'Utrecht', 'Delivered',  9, '2026-02-15'),
(8,  '2026-03-01', 'Client D', 'Gouda',   'Delivered', 30, '2026-03-06'),
(9,  '2026-03-05', 'Client D', 'Utrecht', 'Pending',    7, NULL),
(10, '2026-03-12', 'Client B', 'Gouda',   'Delivered', 11, '2026-03-13');

-- 3. Orders per status
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- 4. Average days to ship, per warehouse
SELECT warehouse,
       ROUND(AVG(julianday(shipped_date) - julianday(order_date)), 1) AS avg_days_to_ship
FROM orders
WHERE shipped_date IS NOT NULL
GROUP BY warehouse;

-- 5. Monthly order volume and items
SELECT strftime('%Y-%m', order_date) AS month,
       COUNT(*)   AS orders,
       SUM(items) AS total_items
FROM orders
GROUP BY month
ORDER BY month;

-- 6. Late shipments (more than 3 days)
SELECT order_id, client, warehouse,
       julianday(shipped_date) - julianday(order_date) AS days_to_ship,
       CASE WHEN julianday(shipped_date) - julianday(order_date) > 3
            THEN 'Late' ELSE 'On time' END AS delivery_flag
FROM orders
WHERE shipped_date IS NOT NULL
ORDER BY days_to_ship DESC;
