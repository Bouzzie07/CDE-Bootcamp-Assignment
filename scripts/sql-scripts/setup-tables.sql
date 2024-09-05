CREATE TABLE region (
	id integer PRIMARY KEY,
	name VARCHAR(255) NOT NULL
);

CREATE TABLE sales_reps (
	id integer PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	region_id INTEGER)
;

CREATE TABLE accounts (
	id INTEGER PRIMARY KEY,
	name VARCHAR(120),
	website VARCHAR(255),
	lat VARCHAR(255),
	long VARCHAR(255),
	primary_poc VARCHAR(255),
	sales_rep_id INTEGER
);

CREATE TABLE orders (
	id INTEGER PRIMARY KEY,
	account_id INTEGER,
	occurred_at TIMESTAMP with TIME ZONE,
	standard_qty INTEGER NOT NULL,
	gloss_qty INTEGER  NOT NULL,
	poster_qty INTEGER NOT NULL,
	total NUMERIC,
	standard_amt_usd NUMERIC,
	gloss_amt_usd NUMERIC,
	poster_amt_usd NUMERIC,
	total_amt_usd NUMERIC
);

CREATE TABLE web_events (
	id integer PRIMARY KEY,
	account_id INTEGER,
	occurred_at timestamp with time zone,
	channel VARCHAR(255)
);