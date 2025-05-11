SELECT *  
FROM parks_and_recreation.employee_demographics;

SELECT first_name, 
last_name,
birth_date,
age,
(age + 10)*10+10 #PEMDAS (aturan perhitungan dalam kurung, perkalian, dst)
FROM parks_and_recreation.employee_demographics;

# Distinct (digunakan untuk melihat unik data)
SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;

# WHERE (digunakan untuk filter)
SELECT *
FROM employee_salary
WHERE first_name='Leslie';

SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_demographics
WHERE gender != 'Female'; # (!=) yang tidak sama dengan

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01';

# AND OR NOT (Operator Logical)
SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
AND gender = 'Male'
;

SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR gender = 'Male'
;

SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR NOT gender = 'Male'
;

SELECT * 
FROM employee_demographics
WHERE (first_name = 'Leslie'  AND age = 44) OR age > 55
;

# LIKE statement
# % and _
SELECT * 
FROM employee_demographics
WHERE first_name LIKE '%er%' #(%) menandakan apapun setelahnya dapat digunakan diawal dan akhir
;

SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a__' #(_ _) 2 underscore untuk mencari 2 karakter selanjutnya, jika ingin >2 karakter maka gunakan uderscore lagi
;

SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a__%' # dapat dikombinasikan underscore dan (%)
;

SELECT * 
FROM employee_demographics
WHERE birth_date LIKE '1989%' 
;

# GROUP BY
SELECT gender, AVG(age) #agrigate function
FROM employee_demographics
GROUP BY gender; #SELECT dan GROUP BY harus sama

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary
;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age) #agrigate function
FROM employee_demographics
GROUP BY gender
;

# ORDER BY (mengurutkan)
SELECT * 
FROM employee_demographics
ORDER BY first_name ASC #ASC (Ascending) dan DESC (Descending)
;

SELECT * 
FROM employee_demographics
ORDER BY gender, age DESC #Penggunaan ORDER BY utamakan kolom dengan data unik
;

SELECT * 
FROM employee_demographics
ORDER BY 5,4; # Bisa menggunakan nomor kolom (tidak disarankan)

# HAVING vs WHERE
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
; # Penggunaan agrigate WHERE tidak bisa dilakukan dengan GROUP BY sehingga penggunaan HAVING diperlukan
# HAVING bisa digunakan juga seperti WHERE untuk filter namun digunakan setalah GROUP BY 

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000 # agrigate hanya berfungsi pada penggunaan HAVING setelah GROUP BY
; 

# LIMIT
SELECT*
FROM employee_demographics
LIMIT 3
;

SELECT*
FROM employee_demographics
ORDER BY age DESC # Dapat dikombinasikan dengan ORDER BY
LIMIT 3
;

SELECT*
FROM employee_demographics
ORDER BY age DESC 
LIMIT 2, 1 # (2) Menampilkan 2 baris dan (1) itu menampilkan baris setelahnya
;

# Aliasing (mengubah nama kolom sementara)
SELECT gender, AVG (age) AS avg_age # Penggunaan AS tidak selalu diperlukan jiak dihapus sistem kerjanya masih akan sama
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40
;
