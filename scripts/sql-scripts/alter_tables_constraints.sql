ALTER TABLE sales_reps
ADD CONSTRAINT salesregionid FOREIGN KEY(region_id) REFERENCES region(id) ON DELETE SET NULL;

ALTER TABLE accounts
ADD CONSTRAINT sales_repid FOREIGN KEY(sales_rep_id) REFERENCES sales_reps(id) ON DELETE SET NULL;

ALTER TABLE orders
ADD CONSTRAINT orders_account_id FOREIGN KEY(account_id) REFERENCES accounts(id) ON DELETE SET NULL;

ALTER TABLE web_events
ADD CONSTRAINT webevents_account_id FOREIGN KEY(account_id) REFERENCES accounts(id) ON DELETE SET NULL;