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

 
-- Query to summarize total sales revenue by product line, highest first
SELECT
  p.product_line,
  SUM(t.amount) AS total_revenue
FROM
  transactions t
JOIN
  product_info p ON t.product_id = p.product_id
GROUP BY
  p.product_line
ORDER BY
  total_revenue DESC;


  //*****************************************************************************************************************************
/*
Write a query to summarize the total sales revenue for each product line. The product line with the highest revenue should be at the top of the results.
*/

select * from product_info;
 select * from transactions;

--Method-1 :

select distinct  p.product_line as product_line,
sum(t.amount) over(partition by p.product_line) as total_revenue
 FROM transactions t 
left join product_info p
 on t.PRODUCT_ID = p.PRODUCT_ID
 order by total_revenue desc;


--Method2::

select p.product_line as product_line,
sum(t.amount) as total_revenue
from transactions t 
join  product_info p 
on t.PRODUCT_ID = p.PRODUCT_ID
group by 1
order by 2 desc;

//*****************************************************************************************************************************
/* Write a SQL query to find customers who have shown an interest in AI.*/

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    interests VARCHAR(255)
);

-- Insert example data
INSERT INTO Customers (customer_id, name, email, interests) VALUES
(1234, 'John Smith', 'johnsmith@email.com', 'Gaming, AI, Data Center'),
(5678, 'Mary Johnson', 'maryj@email.com', 'Gaming, Autonomous Machines'),
(9123, 'James Williams', 'jamesw@email.com', 'AI, Autonomous Machines'),
(4567, 'Patricia Brown', 'patriciab@email.com', 'Data Center, AI');

select customer_id, name, email from Customers 
where interests like '%AI%';

//*****************************************************************************************************************************
/*
SQL Question 4: Average GPU Temperatures per Model
As an SQL analyst at NVIDIA, you are given task to monitor the performance of various GPU models. You have been asked to write a SQL query to find the average running temperature for each GPU model in the database.
*/

-- Create table
CREATE OR REPLACE TABLE gpu_temps (
    record_id INT,
    timestamp TIMESTAMP_NTZ,
    model_id INT,
    temperature INT
);

-- Insert sample data
INSERT INTO gpu_temps (record_id, timestamp, model_id, temperature) VALUES
    (1, TO_TIMESTAMP_NTZ('2022-06-08 00:00:00'), 1001, 60),
    (2, TO_TIMESTAMP_NTZ('2022-06-10 00:00:00'), 1001, 65),
    (3, TO_TIMESTAMP_NTZ('2022-06-18 00:00:00'), 1002, 58),
    (4, TO_TIMESTAMP_NTZ('2022-07-26 00:00:00'), 1002, 60),
    (5, TO_TIMESTAMP_NTZ('2022-07-05 00:00:00'), 1002, 62);

--Method 1 using window functions 

select distinct model_id,
avg(temperature)over(partition by model_id) as avg_temperature
from gpu_temps;

-- using aggregate functions and group by 
select  model_id,
avg(temperature) as avg_temperature
from gpu_temps
group by 1
order by 1;

//*****************************************************************************************************************************
/*
QL Question 6: Calculate the Click-Through-Rates for NVIDIA Products
At NVIDIA, we utilize digital marketing strategies to ensure our customers are aware of our products. One essential metric we use to analyze the effectiveness of these strategies is the click-through rate (CTR). We would like you to calculate the CTR for every NVIDIA product for the past month.

Our product_views table records every time a user views one of our products:

product_views 
Example Input:
view_id	user_id	view_date	product_id
1	123	09/01/2022 09:30:00	50001
2	265	09/01/2022 10:00:00	69852
3	362	09/02/2022 14:00:00	50001
4	192	09/03/2022 16:30:00	69852
5	981	09/04/2022 20:00:00	69852
Our product_clicks table records every time a user clicks on one of our products:

product_clicks 
Example Input:
click_id	user_id	click_date	product_id
9076	123	09/01/2022 09:31:00	50001
7803	265	09/01/2022 10:02:00	69852
5294	362	09/02/2022 14:01:00	50001
6353	981	09/04/2022 20:03:00	69852
You should join the views and clicks according to user_id and product_id and then calculate CTR as the number of clicks divided by the number of views for each product.
*/
-- Create product_views table
CREATE OR REPLACE TABLE product_views (
    view_id INT,
    user_id INT,
    view_date TIMESTAMP_NTZ,
    product_id INT
);

-- Create product_clicks table
CREATE OR REPLACE TABLE product_clicks (
    click_id INT,
    user_id INT,
    click_date TIMESTAMP_NTZ,
    product_id INT
);
-- Insert sample data into product_views for last month (December 2025)
INSERT INTO product_views (view_id, user_id, view_date, product_id) VALUES
    (6, 101, TO_TIMESTAMP_NTZ('2025-12-05 10:00:00'), 50001),
    (7, 102, TO_TIMESTAMP_NTZ('2025-12-10 15:30:00'), 69852),
    (8, 103, TO_TIMESTAMP_NTZ('2025-12-15 09:45:00'), 50001),
    (9, 104, TO_TIMESTAMP_NTZ('2025-12-20 20:00:00'), 69852),
    (10, 105, TO_TIMESTAMP_NTZ('2025-12-25 18:00:00'), 69852);

-- Insert sample data into product_clicks for last month (December 2025)
INSERT INTO product_clicks (click_id, user_id, click_date, product_id) VALUES
    (10001, 101, TO_TIMESTAMP_NTZ('2025-12-05 10:05:00'), 50001),
    (10002, 102, TO_TIMESTAMP_NTZ('2025-12-10 15:35:00'), 69852),
    (10003, 103, TO_TIMESTAMP_NTZ('2025-12-15 09:50:00'), 50001),
    (10004, 105, TO_TIMESTAMP_NTZ('2025-12-25 18:05:00'), 69852);


SELECT v.product_id,
(cast(count(c.click_id) as float)/ count(v.view_id)) * 100 AS click_through_rate
FROM product_views v
LEFT JOIN product_clicks c
ON v.product_id = c.product_id AND v.user_id = c.user_id
WHERE VIEW_DATE >= DATE_TRUNC(MONTH,CURRENT_DATE) - INTERVAL '1 MONTH' 
AND VIEW_DATE < DATE_TRUNC(MONTH,CURRENT_DATE)
group by 1
;


//*****************************************************************************************************************************
/*
Customers:

customer_id	customer_name	customer_email
1	John Doe	johndoe@example.com
2	Jane Smith	janesmith@example.com
3	Bob Johnson	bob_johnson@example.com
4	Alice Davis	alice_davis@example.com
5	Charlie White	charlie_white@example.com
Purchases:

purchase_id	customer_id	product_id	purchase_date	product_price
101	1	50001	05/10/2022	$1500
102	2	50002	05/15/2022	$2500
103	3	50001	05/20/2022	$1500
104	2	50001	05/22/2022	$1500
105	1	50002	05/25/2022	$2500


Write a SQL query to get a list of all customers who bought the product with product_id = 50001 and the total amount they spent on that product. Also, sort the output by total amount spent in descending order.
*/
-- Create Customers table
CREATE TABLE Customer (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  customer_email VARCHAR(100)
);

-- Create Purchases table
CREATE TABLE Purchases (
  purchase_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  purchase_date DATE,
  product_price NUMBER(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert data into Customers
INSERT INTO Customer (customer_id, customer_name, customer_email) VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Bob Johnson', 'bob_johnson@example.com'),
  (4, 'Alice Davis', 'alice_davis@example.com'),
  (5, 'Charlie White', 'charlie_white@example.com');

-- Insert data into Purchases
INSERT INTO Purchases (purchase_id, customer_id, product_id, purchase_date, product_price) VALUES
  (101, 1, 50001, TO_DATE('05/10/2022', 'MM/DD/YYYY'), 1500),
  (102, 2, 50002, TO_DATE('05/15/2022', 'MM/DD/YYYY'), 2500),
  (103, 3, 50001, TO_DATE('05/20/2022', 'MM/DD/YYYY'), 1500),
  (104, 2, 50001, TO_DATE('05/22/2022', 'MM/DD/YYYY'), 1500),
  (105, 1, 50002, TO_DATE('05/25/2022', 'MM/DD/YYYY'), 2500);

select * from Customer;

select * from Purchases;

select c.customer_id,c.customer_name,c.customer_email,
sum(p.product_price)as  total_spent
from Customer c
left join Purchases p
on c.CUSTOMER_ID =p.CUSTOMER_ID
where p.product_id = 50001
group by 1,2,3
order by  total_spent desc 
;

//*****************************************************************************************************************************

/*
As a Data Analyst in NVIDIA, you are asked to get a analysis of every product sold in the past year. You need to retrieve the month, product ID and the total quantity sold for each product listed by NVIDIA on a monthly basis. Consider that fiscal year begins in January and ends in December. Use the sales table for your analysis.

Provided below are sample inputs and output for the problem:

sales Example Input:
sale_id	sale_date	product_id	quantity
1001	02/20/2021 12:14:00	50001	2
1002	02/25/2021 15:35:00	69852	1
1003	03/08/2021 11:11:00	50001	3
1004	03/14/2021 18:30:00	69852	5
1005	04/01/2021 09:09:00	50001	7

*/

-- Create table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATETIME,
    product_id INT,
    quantity INT
);

-- Insert data
INSERT INTO sales (sale_id, sale_date, product_id, quantity) VALUES
(1001, '2021-02-20 12:14:00', 50001, 2),
(1002, '2021-02-25 15:35:00', 69852, 1),
(1003, '2021-03-08 11:11:00', 50001, 3),
(1004, '2021-03-14 18:30:00', 69852, 5),
(1005, '2021-04-01 09:09:00', 50001, 7);

select DATE_PART(MONTH,sale_date) as month,PRODUCT_ID,
sum(QUANTITY)as total_quantity
SELECT * from sales
group by 1,2
ORDER BY 1,2;




//*****************************************************************************************************************************



//*****************************************************************************************************************************
