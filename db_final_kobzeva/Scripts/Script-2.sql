SELECT 
    t.id AS transaction_id,
    t.amount,
    t.date,
    c.name AS category_name,
    c.type AS category_type,
    a.name AS account_name,
    u.username,
    
    u_total.total_transactions,
   
    u_total.total_amount
FROM transactions t

JOIN categories c ON t.category_id = c.id

JOIN accounts a ON t.account_id = a.id

JOIN users u ON a.user_id = u.id

LEFT JOIN (
    SELECT 
        u.id AS user_id,
        COUNT(t2.id) AS total_transactions,
        COALESCE(SUM(t2.amount), 0) AS total_amount
    FROM users u
    LEFT JOIN accounts a2 ON u.id = a2.user_id
    LEFT JOIN transactions t2 ON a2.id = t2.account_id
    GROUP BY u.id
) u_total ON u.id = u_total.user_id
ORDER BY t.date DESC;