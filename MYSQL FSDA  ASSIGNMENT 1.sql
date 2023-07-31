-- PERFORMED ON MYSQL
-- TASK 1 (TOTAL QUE : 1)

-- QUESTION 1
CREATE DATABASE shopping;
USE  shopping;

CREATE TABLE shopping_history(
product VARCHAR(30) NOT NULL,
quantity INT NOT NULL,
unit_price INT NOT NULL);

INSERT INTO shopping_history VALUES
('milk',3,10),
('bread',7,3),
('bread',5,2);

SELECT 
product ,
SUM(quantity*unit_price) AS total_price
FROM shopping_history
GROUP BY product;

-- TASK 2 (TOTAL QUE : 2)

CREATE DATABASE telecomm;
USE telecomm;

-- QUESTION 1

CREATE TABLE phones(
name VARCHAR(20) NOT NULL UNIQUE,
phone_number INT NOT NULL UNIQUE);

CREATE TABLE calls(
id INT NOT NULL UNIQUE,
caller INT NOT NULL,
callee INT NOT NULL,
duration INT NOT NULL);

INSERT INTO phones VALUES
("Jack",1234),
("Lena",3333),
("Mark",999),
("Anna",7582);

INSERT INTO calls VALUES
(25,1234,7582,8),
(7,9999,7582,1),
(18,9999,3333,4),
(2,7582,3333,3),
(3,3333,1234,1),
(21,3333,1234,1);

with call_duration as (
select caller as phone_number, 
sum(duration) as duration 
from calls 
group by caller
	union all
select callee as phone_number,
sum(duration) as duration 
from calls 
group by callee
)
SELECT name
FROM phones p 
join call_duration cd 
on cd.phone_number = p.phone_number
GROUP BY name
HAVING SUM(duration) >= 10;

-- QUESTION 2

CREATE TABLE phones_1(
name VARCHAR(20) NOT NULL UNIQUE,
phone_number INT NOT NULL UNIQUE);

CREATE TABLE calls_1(
ID INT NOT NULL,
caller INT NOT NULL,
callee INT NOT NULL,
duration INT NOT NULL,
UNIQUE(id));

INSERT INTO phones_1 VALUES
("John",6356),
("Addison",4315),
("Kate",8003),
("Ginny",9831);

INSERT INTO calls_1 VALUES
(65,8003,9831,7),
(100,9831,8003,3),
(145,4315,9831,18);

WITH call_duartion AS(
SELECT callee AS phone_number,
 SUM(duration) AS duration
FROM calls_1 
GROUP BY callee
UNION ALL
SELECT caller AS phone_number,
 SUM(duration) AS duration
FROM calls_1  
GROUP BY caller)
SELECT name
FROM phones_1 AS p
JOIN call_duartion AS cd
ON p.phone_number = cd.phone_number
GROUP BY name
HAVING SUM(cd.duration) >=10;


-- TASK 3 (TOTAL QUE :3)

CREATE DATABASE BANK;
USE BANK;

-- QUESTION 1

CREATE TABLE transactions (
Amount INTEGER NOT NULL,
Date DATE NOT NULL);

INSERT INTO transactions (Amount, Date) VALUES (1000, '2020-01-06');
INSERT INTO transactions (Amount, Date) VALUES (-10, '2020-01-14');
INSERT INTO transactions (Amount, Date) VALUES (-75, '2020-01-20');
INSERT INTO transactions (Amount, Date) VALUES (-5, '2020-01-25');
INSERT INTO transactions (Amount, Date) VALUES (-4, '2020-01-29');
INSERT INTO transactions (Amount, Date) VALUES (2000, '2020-03-10');
INSERT INTO transactions (Amount, Date) VALUES (-75, '2020-03-12');
INSERT INTO transactions (Amount, Date) VALUES (-20, '2020-03-15');
INSERT INTO transactions (Amount, Date) VALUES (40, '2020-03-15');
INSERT INTO transactions (Amount, Date) VALUES (-50, '2020-03-17');
INSERT INTO transactions (Amount, Date) VALUES (200, '2020-10-10');
INSERT INTO transactions (Amount, Date) VALUES (-200,'2020-10-10');


WITH monthly_summary AS (
SELECT 
		DATE_FORMAT(date, '%Y-%m-01') AS month,
		SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS incoming_transfers,
		COUNT(CASE WHEN amount < 0 THEN 1 END) AS credit_card_payments,
		SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_credit_card_cost
	FROM bank.transactions
    GROUP BY DATE_FORMAT(date, '%Y-%m-01')
),
monthly_balance AS (
    SELECT 
        month,
        incoming_transfers,
        credit_card_payments,
        total_credit_card_cost,
        CASE 
            WHEN credit_card_payments >= 3 AND ABS(total_credit_card_cost) >= 100 
            THEN 0
            ELSE 5 
        END AS monthly_fee
    FROM monthly_summary
),
all_months AS (
    SELECT '2020-01-01' AS month
    UNION ALL SELECT '2020-02-01'
    UNION ALL SELECT '2020-03-01'
    UNION ALL SELECT '2020-04-01'
    UNION ALL SELECT '2020-05-01'
    UNION ALL SELECT '2020-06-01'
    UNION ALL SELECT '2020-07-01'
    UNION ALL SELECT '2020-08-01'
    UNION ALL SELECT '2020-09-01'
    UNION ALL SELECT '2020-10-01'
    UNION ALL SELECT '2020-11-01'
    UNION ALL SELECT '2020-12-01'
)
SELECT 
    SUM(incoming_transfers - ABS(total_credit_card_cost) - monthly_fee) -
    (COUNT(DISTINCT all_months.month) - COUNT(DISTINCT monthly_balance.month)) * 5 AS balance
FROM all_months
LEFT JOIN monthly_balance 
ON all_months.month = monthly_balance.month;

-- QUESTION 2

CREATE TABLE transactions_2 (
Amount INTEGER NOT NULL,
Date DATE NOT NULL);

INSERT INTO transactions_2 (Amount, Date) VALUES (1, '2020-06-29');
INSERT INTO transactions_2 (Amount, Date) VALUES (35, '2020-02-20');
INSERT INTO transactions_2 (Amount, Date) VALUES (-50, '2020-02-03');
INSERT INTO transactions_2 (Amount, Date) VALUES (-1, '2020-02-26');
INSERT INTO transactions_2 (Amount, Date) VALUES (-200, '2020-08-01');
INSERT INTO transactions_2 (Amount, Date) VALUES (-44, '2020-02-07');
INSERT INTO transactions_2 (Amount, Date) VALUES (-5, '2020-02-25');
INSERT INTO transactions_2 (Amount, Date) VALUES (1, '2020-06-29');
INSERT INTO transactions_2 (Amount, Date) VALUES (1, '2020-06-29');
INSERT INTO transactions_2 (Amount, Date) VALUES (-100, '2020-12-29');
INSERT INTO transactions_2 (Amount, Date) VALUES (-100, '2020-12-30');
INSERT INTO transactions_2 (Amount, Date) VALUES (-100,'2020-12-31');

WITH monthly_summary AS (
SELECT 
		DATE_FORMAT(date, '%Y-%m-01') AS month,
		SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS incoming_transfers,
		COUNT(CASE WHEN amount < 0 THEN 1 END) AS credit_card_payments,
		SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_credit_card_cost
	FROM bank.transactions_2
    GROUP BY DATE_FORMAT(date, '%Y-%m-01')
),
monthly_balance AS (
    SELECT 
        month,
        incoming_transfers,
        credit_card_payments,
        total_credit_card_cost,
        CASE 
            WHEN credit_card_payments >= 3 AND ABS(total_credit_card_cost) >= 100 
            THEN 0
            ELSE 5 
        END AS monthly_fee
    FROM monthly_summary
),
all_months AS (
    SELECT '2020-01-01' AS month
    UNION ALL SELECT '2020-02-01'
    UNION ALL SELECT '2020-03-01'
    UNION ALL SELECT '2020-04-01'
    UNION ALL SELECT '2020-05-01'
    UNION ALL SELECT '2020-06-01'
    UNION ALL SELECT '2020-07-01'
    UNION ALL SELECT '2020-08-01'
    UNION ALL SELECT '2020-09-01'
    UNION ALL SELECT '2020-10-01'
    UNION ALL SELECT '2020-11-01'
    UNION ALL SELECT '2020-12-01'
)
SELECT 
    SUM(incoming_transfers - ABS(total_credit_card_cost) - monthly_fee) -
    (COUNT(DISTINCT all_months.month) - COUNT(DISTINCT monthly_balance.month)) * 5 AS balance
FROM all_months
LEFT JOIN monthly_balance 
ON all_months.month = monthly_balance.month;

-- QUESTION 3

CREATE TABLE transactions_3 (
Amount INTEGER NOT NULL,
Date DATE NOT NULL);

INSERT INTO transactions_3 (Amount, Date) VALUES (6000, '2020-04-03');
INSERT INTO transactions_3 (Amount, Date) VALUES (5000, '2020-04-02');
INSERT INTO transactions_3 (Amount, Date) VALUES (4000, '2020-04-01');
INSERT INTO transactions_3 (Amount, Date) VALUES (3000, '2020-03-01');
INSERT INTO transactions_3 (Amount, Date) VALUES (2000, '2020-02-01');
INSERT INTO transactions_3 (Amount, Date) VALUES (1000, '2020-01-01');

WITH monthly_summary AS (
SELECT 
		DATE_FORMAT(date, '%Y-%m-01') AS month,
		SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS incoming_transfers,
		COUNT(CASE WHEN amount < 0 THEN 1 END) AS credit_card_payments,
		SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_credit_card_cost
	FROM bank.transactions_3
    GROUP BY DATE_FORMAT(date, '%Y-%m-01')
),
monthly_balance AS (
    SELECT 
        month,
        incoming_transfers,
        credit_card_payments,
        total_credit_card_cost,
        CASE 
            WHEN credit_card_payments >= 3 AND ABS(total_credit_card_cost) >= 100 
            THEN 0
            ELSE 5 
        END AS monthly_fee
    FROM monthly_summary
),
all_months AS (
    SELECT '2020-01-01' AS month
    UNION ALL SELECT '2020-02-01'
    UNION ALL SELECT '2020-03-01'
    UNION ALL SELECT '2020-04-01'
    UNION ALL SELECT '2020-05-01'
    UNION ALL SELECT '2020-06-01'
    UNION ALL SELECT '2020-07-01'
    UNION ALL SELECT '2020-08-01'
    UNION ALL SELECT '2020-09-01'
    UNION ALL SELECT '2020-10-01'
    UNION ALL SELECT '2020-11-01'
    UNION ALL SELECT '2020-12-01'
)
SELECT 
    SUM(incoming_transfers - ABS(total_credit_card_cost) - monthly_fee) -
    (COUNT(DISTINCT all_months.month) - COUNT(DISTINCT monthly_balance.month)) * 5 AS balance
FROM all_months
LEFT JOIN monthly_balance 
ON all_months.month = monthly_balance.month;

-- ASSIGNMENT FINISHED ////////////////////////////////////




/*ALTERNATIVE : TASK 2

SELECT p.name,p.phone_number,
SUM(t1.duration)
FROM calls AS t1
JOIN calls as t2
ON t1.callee =  t2.caller
JOIN phones as p
ON t1.callee = p.phone_number
GROUP BY p.name;

SELECT t1.*,
sum(t1.duration)
FROM calls AS t1
JOIN calls as t2
ON t1.callee =  t2.caller
group by t1.caller;

TASK3

with mud as (select 
distinct(extract(MONTH from transactions.Date)) as mon,
sum(amount) as amt
from bank.transactions
group by mon)
select 
distinct(extract(MONTH from transactions.Date)) as mon,
count(extract(MONTH from transactions.Date)) as num_of_transc,
case
when count(extract(MONTH from transactions.Date)) >=3
then m.amt+0
else m.amt+5
end as c
from bank.transactions tr
join mud m
on m.mon = tr.mon
group by mon
;

WITH monthly_summary AS (
    SELECT 
        DISTINCT EXTRACT(MONTH FROM date) AS mon,
        SUM(amount) AS amt
    FROM bank.transactions
    GROUP BY mon
)
SELECT 
    mon,
    COUNT(EXTRACT(MONTH FROM date)) AS num_of_transc,
    CASE
        WHEN COUNT(EXTRACT(MONTH FROM date)) >= 3 and amt >100
        THEN amt
        ELSE amt + 5
    END AS c
FROM bank.transactions tr
JOIN monthly_summary m ON m.mon = EXTRACT(MONTH FROM tr.date)
GROUP BY mon;*/
