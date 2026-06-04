USE bank_fraud_db;

-- =====================================
-- VALIDATION QUERY 1: ROW COUNTS
-- =====================================

SELECT 'BRANCH' AS Table_Name, COUNT(*) AS Row_Count FROM BRANCH
UNION ALL
SELECT 'CUSTOMER', COUNT(*) FROM CUSTOMER
UNION ALL
SELECT 'ACCOUNT', COUNT(*) FROM ACCOUNT
UNION ALL
SELECT 'TRANSACTION', COUNT(*) FROM TRANSACTION
UNION ALL
SELECT 'FRAUD_ALERT', COUNT(*) FROM FRAUD_ALERT
UNION ALL
SELECT 'INVESTIGATOR', COUNT(*) FROM INVESTIGATOR
UNION ALL
SELECT 'INVESTIGATION_CASE', COUNT(*) FROM INVESTIGATION_CASE
UNION ALL
SELECT 'BLACKLIST', COUNT(*) FROM BLACKLIST
UNION ALL
SELECT 'USERS', COUNT(*) FROM USERS
UNION ALL
SELECT 'AUDIT_LOG', COUNT(*) FROM AUDIT_LOG
UNION ALL
SELECT 'CASE_NOTE', COUNT(*) FROM CASE_NOTE;

-- =====================================
-- VALIDATION QUERY 2: NULL CHECK
-- =====================================

SELECT *
FROM CUSTOMER
WHERE Full_Name IS NULL
OR CNIC IS NULL
OR Email IS NULL;

-- =====================================
-- VALIDATION QUERY 3: FK CHECK
-- ACCOUNT -> CUSTOMER
-- =====================================

SELECT a.Account_ID
FROM ACCOUNT a
LEFT JOIN CUSTOMER c
ON a.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

-- =====================================
-- VALIDATION QUERY 4: FK CHECK
-- TRANSACTION -> ACCOUNT
-- =====================================

SELECT t.Transaction_ID
FROM TRANSACTION t
LEFT JOIN ACCOUNT a
ON t.Account_ID = a.Account_ID
WHERE a.Account_ID IS NULL;

-- =====================================
-- VALIDATION QUERY 5: FK CHECK
-- FRAUD_ALERT -> TRANSACTION
-- =====================================

SELECT fa.Alert_ID
FROM FRAUD_ALERT fa
LEFT JOIN TRANSACTION t
ON fa.Transaction_ID = t.Transaction_ID
WHERE t.Transaction_ID IS NULL;

-- =====================================
-- VALIDATION QUERY 6: DUPLICATE CNIC
-- =====================================

SELECT CNIC, COUNT(*)
FROM CUSTOMER
GROUP BY CNIC
HAVING COUNT(*) > 1;

-- =====================================
-- VALIDATION QUERY 7: OPEN CASES
-- =====================================

SELECT ic.Case_ID,
ic.Case_Status,
i.Full_Name AS Investigator
FROM INVESTIGATION_CASE ic
JOIN INVESTIGATOR i
ON ic.Investigator_ID = i.Investigator_ID
WHERE ic.Case_Status <> 'Closed';

-- =====================================
-- VALIDATION QUERY 8: BLACKLIST REPORT
-- =====================================

SELECT c.Full_Name,
c.CNIC,
b.Reason
FROM BLACKLIST b
JOIN CUSTOMER c
ON b.Customer_ID = c.Customer_ID;
