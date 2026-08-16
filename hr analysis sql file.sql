Create Database hr_analysis;
use hr_analysis;
create Table hr_data(
    Attrition varchar(10),
	Business_Travel	varchar(50),
    CF_age_band	varchar(20),
    CF_attrition_label varchar(20),
	Department varchar(20),
	Education_Field	varchar(50),
    emp_no	varchar(20),
    Employee_Number int(20),
	gender	varchar(10),
    Job_Role varchar(20),
	Marital_Status  varchar(20),
	Over_Time  varchar(10),
	Over18	 char(2),
    Training_Times_Last_Year  int,
	Age int,
    CF_current_Employee int,
	Daily_Rate	int,
    Distance_From_Home int,
	Education char(30),
	Employee_Count int,
	Environment_Satisfaction int,
	Hourly_Rate int,
	Job_Involvement int,
	Job_Level	int,
    Job_Satisfaction int,
	Monthly_Income	int,
    Monthly_Rate	int,
    Num_Companies_Worked int,
	Percent_Salary_Hike int,
	Performance_Rating	int,
    Relationship_Satisfaction	int,
    Standard_Hours int,
	Stock_Option_Level	int,
    Total_Working_Years	int,
    Work_Life_Balance	int,
    Years_At_Company  int,
	Years_In_Current_Role int,
	Years_Since_Last_Promotion int,	
    Years_With_Curr_Manager int
    );
    ALTER TABLE hr_data
MODIFY Monthly_Income DECIMAL(10,2),
MODIFY Monthly_Rate Decimal(10,2);
ALTER TABLE hr_data
MODIFY job_role VARCHAR(100);
SELECT * FROM hr_data;

#que-1 find the total number of employees in the company
SELECT COUNT(*) AS Total_Employees
FROM hr_data;

 #que-2 Display the number of employees in each department.
 SELECT Department, COUNT(*) AS Total_Employees
FROM hr_data
GROUP BY Department;
 
 #que-3 calculate average salary for each department.
 select department, avg(monthly_income) As average_salary
 from hr_data
 group by Department;
 
 #que-4 Display the top 5 employees with the highest salary
 select employee_number, monthly_income
 from hr_data
 order by monthly_income DESC
 LIMIT 5;
 
 #que-5 find employees whose salary is higher than the comapny's average salary.
SELECT Employee_Number, Monthly_Income
FROM hr_data
WHERE Monthly_Income > (
    SELECT AVG(Monthly_Income)
    FROM hr_data
);

#que-6 find the employee with the highest salary in every department
SELECT Department, Employee_Number, Monthly_Income
FROM hr_data h
WHERE Monthly_Income = (
    SELECT MAX(Monthly_Income)
    FROM hr_data
    WHERE Department = h.Department
);

#que-7 count the number of male and female employees.
select gender , COUNT(*) As employee_number
FROM hr_data 
group by gender;

#que-8 : Find the average salary of employees based on their job level.
SELECT Job_Level, AVG(Monthly_Income) AS Average_Salary
from hr_data
group by job_level;

#que-9 find employees who have worked in the comapny for more than 5 year
SELECT Employee_Number, Department, Job_Role, Years_At_Company
FROM hr_data
WHERE Years_At_Company > 5;

#que-10 classify employees as high,medium or low salary based on their salary
select employee_number , Monthly_income,
case
    when monthly_income >=10000 then "high"
     when monthly_income >=5000 then "medium"
     else "low"
end as salary_category
from hr_data;

#que-11 calculate the total salary paid by each department
select department,
     sum(monthly_income) As Total_Salary
	from hr_data
    group by department;
    
#Que-12 Top 5 employees with highest salary in each department
SELECT Employee_Number, Department, Monthly_Income
FROM (
    SELECT Employee_Number, Department, Monthly_Income,
           RANK() OVER (
               PARTITION BY Department
               ORDER BY Monthly_Income DESC
           ) AS Salary_Rank
    FROM hr_data
) AS ranked_employees
WHERE Salary_Rank <= 5;

#que-13 find the number of employees who left the company in each department
select department ,
     count(*) AS employee_left
from hr_data
where  Attrition = "yes"
group by department;

#que-14 identify the department that has the highest average performance rating
SELECT Department, 
   AVG(Performance_Rating) AS Average_Performance_Rating
FROM hr_data
GROUP BY Department
ORDER BY Average_Performance_Rating DESC
LIMIT 1;


#que-15 find the number of employees in each job role
SELECT Job_Role,
 COUNT(*) AS Total_Employees
FROM hr_data
GROUP BY Job_Role
ORDER BY Total_Employees DESC;
   
#Que-16 Find the attrition rate of employees.
SELECT 
    ROUND(
        (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS Attrition_Rate
FROM hr_data;

#Que-17 Find the average salary of employees who left vs. employees who stayed.
SELECT 
    Attrition,
    AVG(Monthly_Income) AS Average_Salary
FROM hr_data
GROUP BY Attrition;

#Que-18 Find the job role with the highest attrition.
SELECT Job_Role,
    COUNT(*) AS Employees_Left
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Job_Role
ORDER BY Employees_Left DESC
LIMIT 1;
#Que-19 Find the average years at company for employees who left vs. stayed.
SELECT Attrition,
    AVG(Years_At_Company) AS Average_Years_At_Company
FROM hr_data
GROUP BY Attrition;
#Que-20 Find the percentage of employees working overtime in each department.
SELECT Department,
    ROUND(
        (SUM(CASE WHEN Over_Time = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS Overtime_Percentage
FROM hr_data
GROUP BY Department
ORDER BY Overtime_Percentage DESC;

