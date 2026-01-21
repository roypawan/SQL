Create database Leetcode;

use database Leetcode;

CREATE OR REPLACE TABLE Scores (
    Id INT,
    Score NUMBER(4,2)
);

INSERT INTO Scores VALUES
(1, 3.50),
(2, 3.65),
(3, 4.00),
(4, 3.85),
(5, 4.00),
(6, 3.65);


select id,score,dense_rank() over(order by score desc )as rn from Scores;

/*
                Consecutive Numbers – Logs Table
*/
CREATE OR REPLACE TABLE Logs (
    Id INT,
    Num INT
);

INSERT INTO Logs VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 2),
(7, 2);

with cte as (select id,num,
 lag(num) over(order by id) as prev_num1,
lead(num) over(order by id) as prev_num2
from logs
)
select num from cte 
where num =prev_num1
and num =prev_num2;

/*
Problem

Find all numbers that appear at least 4 times consecutively in the table.

🧱 DDL
*/
CREATE OR REPLACE TABLE logs_q1 (
    id INT,
    num INT
);

--INSERT
INSERT INTO logs_q1 VALUES
(1, 5),
(2, 5),
(3, 5),
(4, 5),
(5, 3),
(6, 3),
(7, 3),
(8, 4),
(9, 4),
(10, 4),
(11, 4),
(12, 4);

with cte as (
select num
,lag(num,1) over(order by id) as pre_num
,lag(num,2) over(order by id) as pre_num1
,lag(num,3) over(order by id) as pre_num2
from logs_q1
)

select distinct num from cte  
where num =pre_num
and num =pre_num1
and num =pre_num2;


/*
QUESTION 2: Find IDs Where Value Repeats 3 Consecutive Days
📌 Problem

Return id and value where the same value occurs for 3 consecutive records.
*/
CREATE OR REPLACE TABLE metrics_q2 (
    record_id INT,
    value INT
);

INSERT INTO metrics_q2 VALUES
(1, 10),
(2, 10),
(3, 10),
(4, 20),
(5, 30),
(6, 30),
(7, 30),
(8, 30),
(9, 40);


with cte as (select record_id,value,
lag(value) over(order by record_id) as prev ,
lag(value,1) over(order by record_id) as prev1 ,
lag(value,2) over(order by record_id) as prev2 ,
from metrics_q2)

select distinct value
from cte 
where value =prev
and value =prev1
and value =prev2;


/*
QUESTION 3: Detect Consecutive Status Failures (REAL PROJECT STYLE)
Problem

Find systems where status = 'FAILED' occurs 3 times in a row.
*/

CREATE OR REPLACE TABLE system_logs_q3 (
    log_id INT,
    system_name STRING,
    status STRING
);


INSERT INTO system_logs_q3 VALUES
(1, 'A', 'FAILED'),
(2, 'A', 'FAILED'),
(3, 'A', 'FAILED'),
(4, 'A', 'SUCCESS'),
(5, 'B', 'FAILED'),
(6, 'B', 'FAILED'),
(7, 'B', 'SUCCESS'),
(8, 'C', 'FAILED'),
(9, 'C', 'FAILED'),
(10,'C', 'FAILED');




with cte as (select system_name,status,
lag(status) over(order by system_name)as pre_Status,
lead(status) over(order by system_name)as nxt_Status
from system_logs_q3)


select distinct system_name from cte 
where status=pre_Status
and status=nxt_Status
order by system_name;




/*
QUESTION 4: Consecutive Same Salary per Employee (Advanced)
📌 Problem

Find employees whose salary remained unchanged for 3 consecutive records.

*/

CREATE OR REPLACE TABLE salary_history_q4 (
    record_id INT,
    emp_id INT,
    salary INT
);

INSERT INTO salary_history_q4 VALUES
(1, 101, 50000),
(2, 101, 50000),
(3, 101, 50000),
(4, 101, 52000),
(5, 102, 60000),
(6, 102, 60000),
(7, 102, 60000),
(8, 103, 70000),
(9, 103, 70000);


with cte as (select emp_id,salary ,
lag(salary) over(order by emp_id) as prev_salary ,
lead(salary) over(order by emp_id) as nxt_salary
from salary_history_q4
)

select  emp_id from cte 
where salary =prev_salary
and salary =nxt_salary;

;

//********************************************************************************************
/*Employees Earning More Than Their Managers – Employee Table*/

CREATE OR REPLACE TABLE Employee (
    Id INT,
    Name STRING,
    Salary INT,
    ManagerId INT
);

INSERT INTO Employee VALUES
(1, 'Joe', 70000, 3),
(2, 'Henry', 80000, 4),
(3, 'Sam', 60000, NULL),
(4, 'Max', 90000, NULL);

select e.name as Employee 
from Employee e
join Employee m
on e.id=m.managerid
where e.salary > m.salary
;

//******************************************************************************************
            /*Q1: Employees Who Earn Less Than Their Managers*/

CREATE OR REPLACE TABLE emp_q1 (
    id INT,
    name STRING,
    salary INT,
    manager_id INT
);


INSERT INTO emp_q1 VALUES
(1, 'Alice', 60000, 3),
(2, 'Bob', 50000, 3),
(3, 'Charlie', 70000, NULL);



select e.Name 
from emp_q1 e
join emp_q1 m
on e.manager_id =m.id
and e.salary <m.salary;


/*Q2: Managers Who Earn Less Than Any of Their Employees
📌 Problem

Find managers whose salary is less than at least one reportee*/


CREATE OR REPLACE TABLE emp_q2 (
    id INT,
    name STRING,
    salary INT,
    manager_id INT
);


INSERT INTO emp_q2 VALUES
(1, 'Dev', 90000, 3),
(2, 'Test', 110000, 3),
(3, 'Lead', 100000, NULL);


select * from emp_q2;


select m.name from emp_q2 e 
join emp_q2 m 
on e.manager_id =m.id
where e.salary >m.salary;


/*Q4: Employees Who Earn More Than Their Manager’s Manager (ADVANCED)
🧱 DDL

*/
CREATE OR REPLACE TABLE emp_q4 (
    id INT,
    name STRING,
    salary INT,
    manager_id INT
);

--📥 INSERT
INSERT INTO emp_q4 VALUES
(1, 'A', 120000, 2),
(2, 'B', 100000, 3),
(3, 'C', 110000, NULL);


select * from emp_q4;


select e.name 
from emp_q4 e
join emp_q4 m 
on e.manager_id =m.id
join emp_q4 gm 
on m.manager_id =gm.id
where e.salary > gm.salary
;


            /*Q5. Count Employees Per Manager (VERY COMMON)*/

select count(e.id) as count_emp,
m.name as manager
from emp_q2 e
join emp_q2 m 
ON e.manager_id = m.id
group by 2
;



//******************************************************************************************
            /*🔹 TRICK VARIATION 1
            Managers Who Earn More Than All of Their Employees

📌 Problem

Find managers whose salary is greater than every one of their direct reportees.

🧠 Why it’s tricky

“Any” vs “All” changes logic completely

Requires GROUP BY + HAVING, not just WHERE*/

CREATE OR REPLACE TABLE emp_tv1 (
    id INT,
    name STRING,
    salary INT,
    manager_id INT
);

INSERT INTO emp_tv1 VALUES
(1, 'A', 60000, 3),
(2, 'B', 70000, 3),
(3, 'C', 80000, NULL),
(4, 'D', 90000, NULL);


select m.name as manager
from emp_tv1 e
join emp_tv1 m 
on e.manager_id =m.id
group by m.salary, m.name
having m.salary > max(e.salary)
;

        /*TRICK VARIATION 2
            Managers Who Earn Less Than the Average Salary of Their Team*/


select m.name as manager 
FROM emp_tv2 e
JOIN emp_tv2 m
on e.manager_id =m.id
group by m.name,m.id,m.salary
having m.salary <avg(e.salary)

                /*Managers Who Earn Less Than Their Highest-Paid Employee*/

select m.name as manager 
FROM emp_tv2 e
JOIN emp_tv2 m
on e.manager_id =m.id
group by m.name,m.id,m.salary
having m.salary <max(e.salary)


//******************************************************************************************



//******************************************************************************************



//******************************************************************************************



//******************************************************************************************





