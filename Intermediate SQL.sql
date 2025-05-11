# JOINS (menggabungkan kolom)
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT *
FROM employee_demographics
INNER JOIN employee_salary # Menggabungkan semua kolom
	ON employee_demographics.employee_id = employee_salary.employee_id # Sumber table.kolom table
;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal 
	ON dem.employee_id = sal.employee_id
;

SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal 
	ON dem.employee_id = sal.employee_id
;

SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal 
	ON dem.employee_id = sal.employee_id
;

# SELF JOIN (mengatur kolom mana yang ingin digabungkan secara mandiri)
SELECT * # Playing secret santa
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name,
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

# JOINING MULTIPLE TOGETHER
SELECT * # walaupun table dem tidak memiliki dept_id bisa digabungkan melalui tabel sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
	ON sal.dept_id = pd.department_id # dikarenakan employee_demographic tidak memiliki kolom dept_id
;

SELECT*
FROM parks_departments;

# UNIONS (menggabungkan baris)
SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT #DISTINCT hanya menggabungkan data unik
SELECT first_name, last_name
FROM employee_salary
;

SELECT first_name, last_name
FROM employee_demographics
UNION ALL # ALL menggabungkan semua data sehingga terdapat duplikat
SELECT first_name, last_name
FROM employee_salary
;

# Ingin mengetahui karyawan dengan umur tua dan gaji tinggi
SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION  
SELECT first_name, last_name, 'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;

# STRING FUNCTIONS 
SELECT LENGTH('skyfall'); #mengetahui berapa panjang kata dari skyfall

SELECT first_name, length(first_name)
FROM employee_demographics
ORDER BY 2 #biasa digunakan untuk mengetahui jumlah nomor telp
;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name) #membuat semua menjadi kapital atau non kapital menggunakan LOWER
FROM employee_demographics
;

# TRIM (menghapus blank atau spasi berlebih)
SELECT TRIM('         sky       ');
# LTRIM menghapus spasi atau blank disebelah kiri saja
# RTRIM menghapus spasi atau blank disebelah kanan saja

SELECT first_name, 
LEFT(first_name, 4), #mengambil 4 huruf dari kiri
RIGHT(first_name, 4), #mengambil 4 huruf dari kana
SUBSTRING(first_name, 3, 2), #mengambil huruf ke-3 dari depan dan diambil sebanyak 2 huruf
birth_date,
SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE (first_name, 'A', 'Z') # mengganti huruf tertentu
FROM employee_demographics
WHERE first_name='April'
;

SELECT LOCATE('X','Alexander'); #mengetahui huruf X berada diposisi berapa

SELECT first_name, LOCATE('An', first_name) #mengetahui nama yang mengandung An
FROM employee_demographics
;

SELECT first_name, last_name,
CONCAT(first_name,' ', last_name) AS full_name #menggabungkan 2 kolom dan (' ') memberikan spasi
FROM employee_demographics
;

# CASE STATEMENT (seperti if else)
SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN 'Very Old'
END AS Age_Bracket #letakan alias setelah END
FROM employee_demographics
;

-- scenario: bonus and pay increase
-- pay increase: <50000 = 5%, >50000 = 7%, and finance = 10% bonus
SELECT first_name,
last_name,
salary,
dept_id,
CASE
	WHEN salary < 50000 THEN salary + (salary*0.05)
    WHEN salary > 50000 AND dept_id = 6 THEN salary 
	WHEN salary > 50000 THEN salary + (salary*0.07)
END AS new_Salary,
CASE	
	WHEN dept_id = 6 THEN salary*.10
END as Bonus
FROM employee_salary
;

# SUBQUERIES (Query dalam Query)
-- mengambil employee yang bekerja pada dept tertentu
SELECT*
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id
					FROM employee_salary
                    WHERE dept_id = 1)
;
-- ingin melihat salary dibawah rata2 atau diatas rata2
SELECT first_name, salary, 
(SELECT AVG(salary)
FROM employee_salary) AS Average
FROM employee_salary 
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender
;

SELECT gender, AVG(`MAX(age)`)
FROM
(SELECT gender,
 AVG(age), 
 MAX(age),
 MIN(age), 
 COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_table
GROUP BY gender
;
#atau
SELECT gender, AVG(max_age)
FROM
(SELECT gender,
 AVG(age) AS avg_age, # dibuat nama kolom terlebih dahulu
 MAX(age) AS max_age,
 MIN(age) AS min_age, 
 COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_table
GROUP BY gender
;

#WINDOW FUNCTION (seperti group by tetapi tidak meletekana semua menjadi 1 baris)
SELECT dem.first_name, dem.last_name,
gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_saemployee_salaryemployee_salarylary sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name,
gender;
# perbedaan antara penggunaan group by dan over partition by adalah group by bergantung pada nilai unik kolom first_name, dan last_name
# sedangkan partition by tidak bergantung pada nilai unik dari first_name dan last_name
SELECT dem.first_name, dem.last_name,
gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS rolling_total # menambah total salary berdasarkan gender
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num, #perbedaan akan terus mengurutkan
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num, # sedangkan ini akan memberikan rank yang sama apabila nilai salary sama
DENSE_RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num 
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT*
FROM employee_salary;