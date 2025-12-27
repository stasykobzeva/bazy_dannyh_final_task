EXPLAIN ANALYZE
SELECT 
    t.id AS transaction_id,
    t.amount,
    t.date,
    c.name AS category_name,
    c.type AS category_type,
    a.name AS account_name,
    u.username,
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY t.date) AS transaction_rank,
    SUM(t.amount) OVER (PARTITION BY u.id ORDER BY t.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_amount
FROM transactions t
JOIN categories c ON t.category_id = c.id
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
ORDER BY u.id, t.date;

CREATE INDEX idx_transactions_user_date ON transactions(user_id, date);
CREATE INDEX idx_categories_id ON categories(id);
CREATE INDEX idx_accounts_id ON accounts(id);
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_users_id ON users(id);

ANALYZE transactions;
ANALYZE categories;
ANALYZE accounts;
ANALYZE users;