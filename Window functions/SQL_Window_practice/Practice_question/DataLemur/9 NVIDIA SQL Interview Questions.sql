create database DataLemur_NVIDIA;
use database DataLemur_NVIDIA;
create schema NVIDIA_SQL_Interview_Questions;
use schema NVIDIA_SQL_Interview_Questions;

-- Create product_info table
CREATE OR REPLACE TABLE product_info (
  product_id INTEGER,
  product_name VARCHAR,
  product_line VARCHAR
);

-- Insert sample data into product_info
INSERT INTO product_info (product_id, product_name, product_line) VALUES
  (1, 'Quadro RTX 8000', 'GPU'),
  (2, 'Quadro RTX 6000', 'GPU'),
  (3, 'GeForce RTX 3060', 'GPU'),
  (4, 'BlueField-3', 'DPU');

-- Create transactions table
CREATE OR REPLACE TABLE transactions (
  transaction_id INTEGER,
  product_id INTEGER,
  amount INTEGER
);

-- Insert sample data into transactions
INSERT INTO transactions (transaction_id, product_id, amount) VALUES
  (101, 1, 5000),
  (102, 2, 4200),
  (103, 3, 9000),
  (104, 4, 7000);

 select * from product_info;
 select * from transactions;
//*****************************************************************************************************************************
/*
Write a query to summarize the total sales revenue for each product line. The product line with the highest revenue should be at the top of the results.
*/

