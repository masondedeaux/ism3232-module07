-- Card shop inventory and pickup orders. Dates use YYYY-MM-DD.
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS inventory (
    set_name TEXT NOT NULL COLLATE NOCASE,
    card_number TEXT NOT NULL COLLATE NOCASE,
    card_name TEXT NOT NULL COLLATE NOCASE,
    stock INTEGER NOT NULL CHECK (typeof(stock) = 'integer' AND stock >= 0),
    PRIMARY KEY (set_name, card_number)
);

CREATE TABLE IF NOT EXISTS pickup_orders (
    order_id TEXT PRIMARY KEY NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('preparing', 'ready', 'picked_up')),
    pickup_date TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS change_requests (
    number INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id TEXT NOT NULL REFERENCES pickup_orders(order_id),
    new_value TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'waiting'
        CHECK (status IN ('waiting', 'approved', 'rejected'))
);

INSERT OR IGNORE INTO inventory (set_name, card_number, card_name, stock) VALUES
    ('Base Set', '58', 'Pikachu', 3),
    ('Base Set', '44', 'Bulbasaur', 2),
    ('Base Set', '46', 'Charmander', 0),
    ('Base Set', '47', 'Diglett', 6),
    ('Base Set', '63', 'Squirtle', 4);

INSERT OR IGNORE INTO pickup_orders (order_id, status, pickup_date) VALUES
    ('P1001', 'ready',     '2026-12-02'),
    ('P1002', 'preparing', '2026-12-03'),
    ('P1003', 'ready',     '2026-12-03'),
    ('P1004', 'preparing', '2026-12-04'),
    ('P1005', 'picked_up', '2026-11-21');

-- Requests are created when a customer asks staff to move a pickup.
