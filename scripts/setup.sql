-- use our accountadmin role
USE ROLE accountadmin;

-- create our database
CREATE OR REPLACE DATABASE time_series_analytics;

-- create schema
CREATE OR REPLACE SCHEMA time_series_analytics.raw;

-- create our virtual warehouse
CREATE OR REPLACE WAREHOUSE time_series_analytics_wh AUTO_SUSPEND = 60;

-- use our time_series_analytics_wh virtual warehouse 
USE WAREHOUSE time_series_analytics_wh;

-- create synthetic data for closing prices from tick history
CREATE OR REPLACE TABLE time_series_analytics.raw.closing_prices AS
WITH filtered_data AS (
    SELECT
        ticker,
        last_date,
        last_time,
        last_price,
        COUNT(DISTINCT date) OVER (PARTITION BY ticker) AS date_count
    FROM
        TICK_HISTORY.PUBLIC.TH_SF_MKTPLACE
    WHERE
        last_price IS NOT NULL  -- Filter out records with NULL last_price
        and msg_type = 0
        and SECURITY_TYPE = 1
),
max_times AS (
    SELECT
        ticker,
        last_date,
        last_time,
        last_price,
        ROW_NUMBER() OVER (PARTITION BY ticker, last_date ORDER BY last_time DESC) AS rn
    FROM
        filtered_data
    WHERE
        date_count > 100
)
SELECT
    ticker,
    last_date as date,
    last_time as time,
    last_price AS closing_price
FROM
    max_times
WHERE
    rn = 1
order by 2 desc;

-- Create Synthetic Data for Slippage Calculation
CREATE OR REPLACE TABLE time_series_analytics.raw.mytrades (
    ticker STRING,
    trade_time TIMESTAMP,
    shares INTEGER,
    price DECIMAL(10, 2)
);

INSERT INTO time_series_analytics.raw.mytrades (ticker, trade_time, shares, price)
VALUES 
    ('META', '2022-10-25 09:45', 10000, 133.76),
    ('META', '2022-10-25 10:45', 5000, 133.44),
    ('META', '2022-10-25 11:45', 15000, 134),
    ('META', '2022-10-25 12:45', 5000, 134.5),
    ('META', '2022-10-25 13:45', 5000, 135.7),
    ('META', '2022-10-25 14:45', 5000, 136),
    ('META', '2022-10-25 15:45', 5000, 137.80);
