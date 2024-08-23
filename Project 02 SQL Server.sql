use [Project 02];
select * from healthcare;

--------------------------------------------------Data Cleaning-----------------------------------------------
-- Standardize the names to proper case.
UPDATE healthcare
SET Name = UPPER(LEFT(Name, 1)) +
           LOWER(SUBSTRING(Name, 2, CHARINDEX(' ', Name + ' ') - 1)) +
           UPPER(SUBSTRING(Name, CHARINDEX(' ', Name + ' ') + 1, 1)) +
           LOWER(SUBSTRING(Name, CHARINDEX(' ', Name + ' ') + 2, LEN(Name)));

-- Fix incorrect or NULL entries in the "Blood Type" column.
UPDATE healthcare
SET "Blood_Type" = 'Unknown'
WHERE "Blood_Type" IS NULL OR "Blood_Type" = '';

-- Trim any leading or trailing spaces in the "Doctor" column.
UPDATE healthcare
SET Doctor = TRIM(Doctor);

-------------------------------------------------Filtering Data-----------------------------------------------
-- 1.1: Filter patients who are older than 50.
SELECT [Name], Age FROM healthcare
WHERE Age > 50;

SELECT COUNT(*) AS TotalPatientsOver50
FROM healthcare
WHERE Age > 50;

-- 1.2: Filter patients who are older than 60.
SELECT [Name], Age FROM healthcare
WHERE Age > 60;

SELECT COUNT(*) AS TotalPatientsOver60
FROM healthcare
WHERE Age > 60;

-- 1.3: Filter patients who are older than 70.
SELECT [Name], Age FROM healthcare
WHERE Age > 70;

SELECT COUNT(*) AS TotalPatientsOver70
FROM healthcare
WHERE Age > 70;

-- 1.4: Filter patients who are older than 80.
SELECT [Name], Age FROM healthcare
WHERE Age > 80;

SELECT COUNT(*) AS TotalPatientsOver80
FROM healthcare
WHERE Age > 80;

-- 1.5: Filter patients who are older than 90.
SELECT [Name], Age FROM healthcare
WHERE Age > 90;

SELECT COUNT(*) AS TotalPatientsOver90
FROM healthcare
WHERE Age > 90;

select *from healthcare;

-- 2.1: Filter records where the billing amount between $30,000, $40,000.
SELECT [Name], Age, Gender, Medical_Condition,Billing_Amount  FROM healthcare
WHERE "Billing_Amount" between 30000 and 40000;

SELECT COUNT(*) AS Total_Count
FROM healthcare
WHERE Billing_Amount between 30000 and 40000;

-- 2.2: Filter records where the billing amount between $40,000, $50,000.
SELECT [Name], Age, Gender, Medical_Condition,Billing_Amount  FROM healthcare
WHERE "Billing_Amount" between 40000 and 50000;

SELECT COUNT(*) AS Total_Count
FROM healthcare
WHERE Billing_Amount between 40000 and 50000;

-- 2.3: Filter records where the billing amount between $50,000, $60,000.
SELECT [Name], Age, Gender, Medical_Condition,Billing_Amount  FROM healthcare
WHERE "Billing_Amount" between 50000 and 60000;

SELECT COUNT(*) AS Total_Count
FROM healthcare
WHERE Billing_Amount between 50000 and 60000;

-- 2.4: Filter records where the billing amount between $60,000, $70,000.
SELECT [Name], Age, Gender, Medical_Condition,Billing_Amount  FROM healthcare
WHERE "Billing_Amount" between 60000 and 70000;

SELECT COUNT(*) AS Total_Count
FROM healthcare
WHERE Billing_Amount between 60000 and 70000;

select *from healthcare;

-- 3.1. Retrieve all patients admitted under "Urgent" admission type.
SELECT [Name], Age, Medical_Condition  FROM healthcare
WHERE "Admission_Type" = 'Urgent';

SELECT COUNT(*) AS Total_Urgent_Patients
FROM healthcare
WHERE Admission_Type = 'Urgent';

-- 3.2. Retrieve all patients admitted under "Elective" admission type.
SELECT [Name], Age, Medical_Condition  FROM healthcare
WHERE "Admission_Type" = 'Elective';

SELECT COUNT(*) AS Total_Urgent_Patients
FROM healthcare
WHERE Admission_Type = 'Elective';

-- 3.3. Retrieve all patients admitted under "Emergency" admission type.
SELECT [Name], Age, Medical_Condition  FROM healthcare
WHERE "Admission_Type" = 'Emergency';

SELECT COUNT(*) AS Total_Urgent_Patients
FROM healthcare
WHERE Admission_Type = 'Emergency';

select *from healthcare;

-- 4.1:Filter patients who were admitted between 2022-01-01 and 2022-12-31.
SELECT * FROM healthcare
WHERE "Date_of_Admission" BETWEEN '2022-01-01' AND '2022-12-31';


-- 5.1: Retrieve all Medical Condition where  "Arthritis".
SELECT [Name], Age,Gender,Medical_Condition  FROM healthcare
WHERE "Medical_Condition" = 'Arthritis';

-- Count the number of records where Medical_Condition is 'Arthritis'
SELECT COUNT(*) AS Arthritis_Count
FROM healthcare
WHERE Medical_Condition = 'Arthritis';

-- 5.2: Retrieve all Medical Condition where  "Asthma".
SELECT [Name], Age,Gender,Medical_Condition  FROM healthcare
WHERE "Medical_Condition" = 'Asthma';

-- Count the number of records where Medical_Condition is 'Asthma'
SELECT COUNT(*) AS Arthritis_Count
FROM healthcare
WHERE Medical_Condition = 'Asthma';


-- 5.3: Retrieve all Medical Condition where  "Cancer".
SELECT [Name], Age,Gender,Medical_Condition  FROM healthcare
WHERE "Medical_Condition" = 'Cancer';

-- Count the number of records where Medical_Condition is 'Cancer'
SELECT COUNT(*) AS Arthritis_Count
FROM healthcare
WHERE Medical_Condition = 'Cancer';


-- 5.4: Retrieve all Medical Condition where  "Diabetes".
SELECT [Name], Age,Gender,Medical_Condition  FROM healthcare
WHERE "Medical_Condition" = 'Diabetes';

-- Count the number of records where Medical_Condition is 'Diabetes'
SELECT COUNT(*) AS Arthritis_Count
FROM healthcare
WHERE Medical_Condition = 'Diabetes';

-- 5.5: Retrieve all Medical Condition where  "Hypertension".
SELECT [Name], Age,Gender,Medical_Condition  FROM healthcare
WHERE "Medical_Condition" = 'Hypertension';

-- Count the number of records where Medical_Condition is 'Hypertension'
SELECT COUNT(*) AS Arthritis_Count
FROM healthcare
WHERE Medical_Condition = 'Hypertension';

-- 5.6: Retrieve all Medical Condition where  "Obesity".
SELECT [Name], Age,Gender,Medical_Condition  FROM healthcare
WHERE "Medical_Condition" = 'Obesity';

-- Count the number of records where Medical_Condition is 'Obesity'
SELECT COUNT(*) AS Arthritis_Count
FROM healthcare
WHERE Medical_Condition = 'Obesity';

----------------------------------------------------Aggregation Functions------------------------------------------------
-- 1. Find the average age of all patients.
SELECT AVG(Age) AS "Average Age" FROM healthcare;

-- 2. Calculate the total billing amount for all patients.
SELECT SUM("Billing_Amount") AS "Total Billing Amount" FROM healthcare;

-- 3. Find the maximum and minimum billing amounts.
SELECT MAX("Billing_Amount") AS "Max Billing", MIN("Billing_Amount") AS "Min Billing"
FROM healthcare;

-- 4. Calculate the average billing amount by insurance provider.
SELECT "Insurance_Provider", AVG("Billing_Amount") AS "Average Billing"
FROM healthcare
GROUP BY "Insurance_Provider";

-- 5. Calculate the average age of patients grouped by gender.
SELECT Gender, AVG(Age) AS "Average Age"
FROM healthcare
GROUP BY Gender;

-- 6. Find the total number of patients for each medical condition.
SELECT "Medical_Condition", COUNT(*) AS "Number of Patients"
FROM healthcare
GROUP BY "Medical_Condition";

-- 7. Calculate the Top 10  total billing amount for each hospital.
SELECT TOP 10 Hospital, SUM("Billing_Amount") AS "Total Billing Amount"
FROM healthcare
GROUP BY Hospital;

-- 8. Determine the maximum length of stay (in days) for patients.
SELECT MAX(DATEDIFF(DAY, "Date_of_Admission", "Discharge_Date")) AS "Max Length of Stay"FROM healthcare

-- 9. Find the number of unique medications prescribed.
SELECT COUNT(DISTINCT Medication) AS "Unique Medications"
FROM healthcare;

--------------------------------------------------- Data Transformation--------------------------------------------------
-- 1. Convert the "Date of Admission" to a different format (e.g., YYYY-MM-DD).
SELECT FORMAT("Date_of_Admission", 'yyyy-MM-dd') AS "Formatted Admission Date"
FROM healthcare;


-- 2. Combine "Doctor" and "Hospital" into one column.
SELECT CONCAT(Doctor, ' - ', Hospital) AS "Doctor & Hospital"
FROM healthcare;

-- 3. Extract the year from the "Date of Admission".
SELECT YEAR("Date_of_Admission") AS "Admission Year"
FROM healthcare;

-- 4. Replace null values in "Test Results" with 'Pending'.
UPDATE healthcare
SET "Test_Results" = 'Pending'
WHERE "Test_Results" IS NULL;

-- 5. Create a new column indicating whether the patient had an "Abnormal" test result.
SELECT *, CASE WHEN "Test_Results" = 'Abnormal' THEN 'Yes' ELSE 'No' END AS "Abnormal Test Result"
FROM healthcare;

---------------------------------------------------- Window Functions----------------------------------------------------
-- 1. Calculate the running total of billing amounts.
SELECT [Name], "Billing_Amount",
       SUM("Billing_Amount") OVER (ORDER BY "Date_of_Admission") AS "Running Total"
FROM healthcare;

-- 2. Rank patients by billing amount within each hospital.
SELECT Name, Hospital, "Billing_Amount",
       RANK() OVER (PARTITION BY Hospital ORDER BY "Billing_Amount" DESC) AS "Billing Rank"
FROM healthcare;

-- 3. Find the moving average of billing amounts over a 3-patient window.
SELECT Name, "Billing_Amount",
       AVG("Billing_Amount") OVER (ORDER BY "Date_of_Admission" ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS "Moving Average"
FROM healthcare;

-- 4. Determine the lag in billing amounts between successive admissions.
SELECT Name, "Billing_Amount",
       LAG("Billing_Amount", 1) OVER (ORDER BY "Date_of_Admission") AS "Previous Billing Amount"
FROM healthcare;

-- 5. Calculate the difference in billing amount compared to the previous patient.
SELECT Name, "Billing_Amount",
       "Billing_Amount" - LAG("Billing_Amount", 1) OVER (ORDER BY "Date_of_Admission") AS "Difference from Previous"
FROM healthcare;

-------------------------------------------------Recursive Queries-------------------------------------------------------
select *from healthcare;
-- 1. Generate a list of patient visits recursively (if we assume repeated admissions).
WITH Patient_Visits AS (
    SELECT Name, Date_of_Admission, Discharge_Date
    FROM healthcare
    WHERE Date_of_Admission IS NOT NULL
    UNION ALL
    SELECT pv.Name, hc.Date_of_Admission, hc.Discharge_Date
    FROM Patient_Visits pv
    JOIN healthcare hc ON pv.Name = hc.Name AND pv.Discharge_Date = hc.Date_of_Admission
)
SELECT * FROM Patient_Visits;

-- 2. Create a recursive query to list all possible room transfers for a patient.
WITH RoomTransfers AS (
    SELECT Name, "Room_Number", "Date_of_Admission" , "Discharge_Date"
    FROM healthcare
    WHERE "Room_Number" IS NOT NULL
    UNION ALL
    SELECT rt.Name, hc."Room_Number", rt."Discharge_Date", hc."Discharge_Date"
    FROM RoomTransfers rt
    JOIN healthcare hc ON rt.Name = hc.Name
    WHERE rt."Discharge_Date" = hc."Date_of_Admission"
)
SELECT * FROM RoomTransfers;

-- 3. Recursively calculate cumulative billing for each patient over multiple admissions.
WITH CumulativeBilling AS (
    SELECT Name, "Billing_Amount", "Date_of_Admission"
    FROM healthcare
    WHERE "Date_of_Admission" IS NOT NULL
    UNION ALL
    SELECT cb.Name, cb."Billing_Amount" + hc."Billing_Amount", hc."Date_of_Admission"
    FROM CumulativeBilling cb
    JOIN healthcare hc ON cb.Name = hc.Name
    WHERE cb."Date_of_Admission"  < hc."Date_of_Admission" 
)
SELECT Name, MAX("Billing_Amount") AS "Total Billing"
FROM CumulativeBilling
GROUP BY [Name];

-- 4. List the hierarchy of patients who share the same doctor recursively.
WITH PatientHierarchy AS (
    SELECT Name, Doctor
    FROM healthcare
    WHERE Doctor IS NOT NULL
    UNION ALL
    SELECT hc.Name, ph.Doctor
    FROM healthcare hc
    JOIN PatientHierarchy ph ON hc.Doctor = ph.Doctor
)
SELECT * FROM PatientHierarchy;





