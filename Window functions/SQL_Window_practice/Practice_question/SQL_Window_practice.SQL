create database SQL_Window_practice;

CREATE TABLE employees (
    emp_id      INT,
    emp_name    VARCHAR(50),
    dept_id     INT,
    salary      INT,
    join_date   DATE
);

CREATE TABLE departments (
    dept_id     INT,
    dept_name   VARCHAR(50)
);


INSERT INTO departments VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance');


INSERT INTO employees VALUES
(1, 'Abhishek', 10, 40000, '2021-01-10'),
(2, 'Sachin',   10, 50000, '2021-03-15'),
(3, 'Rahul',    10, 60000, '2022-06-20'),

(4, 'Vishal',   20, 30000, '2021-02-12'),
(5, 'Rajat',    20, 50000, '2022-01-18'),
(6, 'Amit',     20, 70000, '2023-05-01'),

(7, 'Neha',     30, 45000, '2021-04-10'),
(8, 'Pooja',    30, 55000, '2022-07-25');


select * from employees;

select * from departments;


//****************************************************************************************************
/*find employees with second highest salaary dep wise */

with cte as (select emp_id,emp_name,salary,dept_id,row_number() 
over(partition by dept_id order by salary desc) as rn
from employees)

select * from cte where rn =2;

//Method-2::

select * from employees qualify row_number() 
over(partition by dept_id order by salary desc) 
=2;

select emp_id,emp_name,salary,dept_id  from employees qualify dense_rank() over(partition by dept_id order by salary desc)<=2;






//****************************************************************************************************
/*find employees with salaary above department average*/

select emp_id,emp_name,salary,dept_id
from(
select emp_id,emp_name,salary,dept_id ,avg(salary)
over(partition by dept_id)as dept_avg
from  employees
)t
where salary >t.dept_avg;


//****************************************************************************************************
//Department Average Salary (Window Function)

SELECT emp_id,
       emp_name,
       dept_id,
       salary,
       AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg_salary
FROM employees;


//********************************************************************************************
//Important :::::CUMULATIVE (RUNNING) AVERAGE

--Method-1
select emp_id , emp_name, salary,dept_id,
avg(salary) over(partition by dept_id order by emp_id) as cummulative_avg
from employees;


--Method-2
select emp_id , emp_name, salary,dept_id,
avg(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and current row) as cummulative_avg
from employees;



CREATE OR REPLACE TABLE employees_cummulative (
    emp_id   INT,
    salary   NUMBER(10,2),
    dept_id  INT
);

INSERT INTO employees_cummulative (emp_id, salary, dept_id) VALUES
(1, 40000, 10),
(2, 50000, 10),
(2, 60000, 10),
(3, 70000, 10);



select * from employees_cummulative;

SELECT * FROM employees_cummulative ORDER BY emp_id, salary;

SELECT emp_id,
       salary,
       AVG(salary) OVER (
           PARTITION BY dept_id
           ORDER BY emp_id
       ) AS cumulative_avg_range
FROM employees_cummulative;


SELECT emp_id,
       salary,
       AVG(salary) OVER (
           PARTITION BY dept_id
           ORDER BY emp_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_avg_rows
FROM employees_cummulative;

//****************************************************************************************************
/*
moving average of last 3 months

For each month (or date):

👉 Calculate the average using data from
current month + previous 2 months

*/
CREATE TABLE employee_salary (
    emp_id     INT,
    salary     INT,
    dept_id    INT,
    salary_dt  DATE
);

INSERT INTO employee_salary VALUES
(1, 40000, 10, '2023-01-01'),
(1, 45000, 10, '2023-02-01'),
(1, 50000, 10, '2023-03-01'),
(1, 55000, 10, '2023-04-01'),
(1, 60000, 10, '2023-05-01');


select * from employee_salary;


SELECT dept_id,
       salary_dt,
       salary,
       AVG(salary) OVER (
           PARTITION BY dept_id
           ORDER BY salary_dt
           RANGE BETWEEN INTERVAL '2 MONTHS' PRECEDING AND CURRENT ROW
       ) AS moving_avg_3_months
FROM employee_salary
ORDER BY dept_id, salary_dt;

show tables;

//****************************************************************************************************


           // using qualify 

CREATE OR REPLACE TABLE employees_qualify (
    emp_id    INT,
    emp_name  STRING,
    dept_id   INT,
    salary    NUMBER,
    salary_dt DATE
);

INSERT INTO employees_qualify VALUES
(1,'A',10,70000,'2023-01-01'),
(2,'B',10,60000,'2023-02-01'),
(3,'C',10,60000,'2023-03-01'),
(4,'D',10,50000,'2023-04-01'),
(5,'E',20,80000,'2023-01-01'),
(6,'F',20,75000,'2023-02-01'),
(7,'G',20,75000,'2023-03-01');



select * from employees_qualify;

--1) Top salary per department

select emp_id,emp_name,salary,dept_id from employees_qualify qualify row_number()
over(partition by dept_id order by salary desc) =1;

SELECT *
FROM employees_qualify
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY dept_id
    ORDER BY salary DESC
) = 1;


--✅ 2) 2nd highest salary per department (handles duplicates)

select emp_id,emp_name,dept_id,salary from employees_qualify
qualify ROW_NUMBER() over(partition by dept_id order by salary desc) =2
;


select emp_name,dept_id,salary,
ROW_NUMBER() over(partition by dept_id order by salary desc) as rn ,
dense_rank() over(partition by dept_id order by salary desc) as dense_rank_rn ,
rank() over(partition by dept_id order by salary desc) as rank_rn
from employees_qualify;



--✅ 3) Employees earning above department average

select avg(dept_id) from employees_qualify;

select emp_id,emp_name,salary,dept_id from employees_qualify
qualify salary >  avg(salary) over(partition by dept_id);
;


SELECT emp_id, emp_name, dept_id, salary
FROM employees_qualify
QUALIFY salary >
       AVG(salary) OVER (PARTITION BY dept_id);

//****************************************************************************************************
--Employees earning above department average

select * from employees_qualify;

--Method1 using qualify method 

select emp_id, emp_name,salary,dept_id,salary_dt
from employees_qualify qualify salary > avg(salary) over(partition by dept_id);

--Method 2 using subquery (joins )

select e.emp_name,e.salary,e.dept_id from employees_qualify e
join(
select avg(SALARY) as avg_salary,dept_id from employees_qualify 
group by 2
)d
on e.dept_id =d.dept_id
where e.salary > d.avg_salary
;


--using window functions 

select emp_id,emp_name,dept_id,salary
from 
(
    select emp_id,emp_name,dept_id,salary,avg(SALARY) over(partition by dept_id) as avg_Salary from employees_qualify
)d
where salary >d.avg_Salary;;




//****************************************************************************************************
-- 					EMPLOYEES earning above department average on EMPLOYEES
-- **************************************************************************************************************


-- Method1:: using subquery and joins 

-- >>>
select e.EMP_ID,e.EMP_NAME,e.salary,e.DEPT_ID from EMPLOYEES e 
	join(
		SELECT DEPT_ID,avg(Salary) as avg_Salary_usingjoins_subquery from EMPLOYEES 
		group by 1
	)d
ON e.DEPT_ID =d.DEPT_ID
where e.salary > d.avg_Salary_usingjoins_subquery;

-- **************************************************************************************************************


-- Method2:: using subquery and window functions 

-- >>>
select EMP_ID,EMP_NAME,salary,DEPT_ID from (

		select EMP_ID,EMP_NAME,salary,DEPT_ID 
		,avg(salary) over(partition by DEPT_ID) as avg_Salary_using_windows_functions
		from EMPLOYEES 
)d
where salary > d.avg_Salary_using_windows_functions ;

-- **************************************************************************************************************


-- Method3::without subquery and in a single query by using qualify 

-- >>>

select EMP_ID,EMP_NAME,salary,DEPT_ID from EMPLOYEES 
qualify salary > avg(salary)over(partition by DEPT_ID);

-- **************************************************************************************************************

