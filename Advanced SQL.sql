# CTES (Comment Table Expresion)
WITH CTE_Example AS
(
SELECT gender, AVG(salary) avg_sal, 
MAX(salary) max_sal,
MIN(salary) min_sal, 
COUNT(salary) count_Sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;
# perbandingan penggunaan CTE dengan subquery
SELECT AVG(avg_sal)
FROM (
SELECT gender, AVG(salary) avg_sal, 
MAX(salary) max_sal,
MIN(salary) min_sal, 
COUNT(salary) count_Sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery
;

SELECT AVG(avg_sal)
FROM CTE_Example; # ketika dirun akan error karena CTE_Example tidak tersimpan

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary>50000
)
SELECT*
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;
# penggunaan nama kolom dapat dilakukan seperti ini
WITH CTE_Example (Gender, AVG_sal, MAX_sal, Min_sal, COUNT_sal) AS
(
SELECT gender, AVG(salary) , 
MAX(salary),
MIN(salary) , 
COUNT(salary) 
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;

# Temporary Tables
# digunakan untuk membuat table sebelum dilakukan permanen
# jika keluar dari MYSQL maka temp table tidak berguna lagi
CREATE TEMPORARY TABLE temp_table
(first_name VARCHAR(50),
last_name VARCHAR(50),
fav_movie VARCHAR(100)
);
#or 
CREATE TEMPORARY TABLE salary_over_50k
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

SELECT*FROM salary_over_50k;

INSERT INTO temp_table
VALUES('Alex', 'Frebeg', 'Avangers');

# Stored Procedures (menyimpan query yang sudah dibuat)
CREATE PROCEDURE large_salaries()
SELECT*
FROM employee_salary
WHERE salary >= 50000
;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT*
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT*
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER;

# parameter

DELIMITER $$
CREATE PROCEDURE large_salaries4(employee_id_p INT) #memberikan parameter berbentuk integer jadi ketika melakukan pemanggilan prosedur large_salaries(4) dapat mengambil baris tertentu
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = employee_id_p
    ;
END $$
DELIMITER;


CALL large_salaries4(1);

# TRIGERS 
# update data

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary # AFTER menandakan update data pada employee_salary table ke employee_demographic atau bisa menggunakan BEFORE untuk mengubah sebaliknya
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW. last_name);
END $$
DELIMITER
;

INSERT INTO employee_salary(employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Sean', 'Marshelle', 'Entertainment', 1000000, NULL);

SELECT*
FROM employee_demographics;

#EVENTS
# untuk automation
SELECT*
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees2
ON SCHEDULE EVERY 30 SECOND #bisa diatur menjadi hari, bulan, atau tahun
DO 
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER;

SHOW VARIABLES LIKE 'event%';


