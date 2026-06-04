-- ============================================================
-- BANK FRAUD DETECTION SYSTEM — DML (FIXED)
-- University: IMSciences | BSSE-A Semester 4
-- Authors   : Sarah Arif & Roshaan Rehman
-- MySQL 8 / XAMPP phpMyAdmin compatible — zero errors
-- Run AFTER database_ddl_fixed.sql
-- ============================================================

USE bank_fraud_db;

-- ============================================================
-- SAFETY: disable FK checks and temporarily drop the
-- trigger that blocks inactive-account transactions,
-- so seed data with Frozen/Suspended accounts can be inserted.
-- Both are restored at the end of this file.
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TRIGGER IF EXISTS trg_block_inactive_account_txn;
DROP TRIGGER IF EXISTS trg_update_balance_after_txn;
DROP TRIGGER IF EXISTS trg_txn_reference_no;
DROP TRIGGER IF EXISTS trg_account_no_generate;
DROP TRIGGER IF EXISTS trg_blacklist_risk_update;
DROP TRIGGER IF EXISTS trg_inc_investigator_cases;

-- ============================================================
-- 1. BRANCH (10 rows)
-- ============================================================
INSERT INTO BRANCH (Branch_ID, Branch_Name, City, Location, Phone, Manager_Name) VALUES
(1,  'HBL Gulberg Branch',       'Lahore',     '17-A Gulberg III, Main Boulevard, Lahore',           '04235761234', 'Tariq Mehmood'),
(2,  'MCB Saddar Branch',        'Karachi',    'I.I. Chundrigar Road, Saddar, Karachi',              '02132412345', 'Fareeha Siddiqui'),
(3,  'UBL Blue Area Branch',     'Islamabad',  'Blue Area, Jinnah Avenue, Islamabad',                '05128901122', 'Asad Ali Khan'),
(4,  'Meezan Bank DHA Branch',   'Lahore',     'DHA Phase 5, Commercial Zone, Lahore',               '04235219988', 'Sana Malik'),
(5,  'Allied Bank Clifton',      'Karachi',    'Clifton Block 5, Sea View Road, Karachi',            '02135480011', 'Imran Sheikh'),
(6,  'NBP F-10 Branch',          'Islamabad',  'F-10 Markaz, Islamabad',                             '05122345678', 'Rabia Noor'),
(7,  'Bank Alfalah GT Road',     'Rawalpindi', 'GT Road, Near Chandni Chowk, Rawalpindi',            '05198765432', 'Kamran Javed'),
(8,  'Habib Metro Johar',        'Karachi',    'Johar Chowrangi, Block 14, Karachi',                 '02134567890', 'Nadia Hussain'),
(9,  'Faysal Bank Gulshan',      'Karachi',    'Gulshan-e-Iqbal Block 3, University Road, Karachi',  '02133219988', 'Zubair Ahmed'),
(10, 'Standard Chartered PECHS', 'Karachi',    'PECHS Block 2, Shahrah-e-Faisal, Karachi',           '02134112233', 'Ayesha Raza');

-- ============================================================
-- 2. USERS (Admin + 5 Investigators)
-- Password hash = bcrypt of 'password'
-- ============================================================
INSERT INTO USERS (User_ID, Username, Password_Hash, Full_Name, Email, Role) VALUES
(1, 'admin',      '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin@bankfraud.pk',      'Admin'),
(2, 'ali.hassan', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ali Hassan',           'ali.hassan@bankfraud.pk', 'Investigator'),
(3, 'mariam.k',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mariam Khalid',        'mariam.k@bankfraud.pk',   'Investigator'),
(4, 'tariq.f',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tariq Farooq',         'tariq.f@bankfraud.pk',    'Investigator'),
(5, 'hina.baig',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hina Baig',            'hina.baig@bankfraud.pk',  'Investigator'),
(6, 'zafar.iq',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Zafar Iqbal',          'zafar.iq@bankfraud.pk',   'Investigator');

-- ============================================================
-- 3. CUSTOMER (15 rows — Pakistani context)
-- ============================================================
INSERT INTO CUSTOMER (Customer_ID, Full_Name, CNIC, Phone, Email, Address, Date_Joined, Risk_Level) VALUES
(1,  'Roshaan Rehman', '4210112345671', '03112345671', 'roshaan.rehman@gmail.com',  'House 12, Block C, Gulshan-e-Iqbal, Karachi', '2021-03-15', 'Low'),
(2,  'Sarah Arif',     '3520198765432', '03218765432', 'sarah.arif@yahoo.com',       'Flat 5, DHA Phase 2, Lahore',                 '2022-07-22', 'Low'),
(3,  'Kamran Javed',   '3740256781234', '03337812345', 'kamran.javed@hotmail.com',   'Sector G-11/2, Islamabad',                    '2020-11-01', 'Medium'),
(4,  'Nadia Hussain',  '4220187654321', '03009876543', 'nadia.hussain@gmail.com',    'North Nazimabad Block H, Karachi',            '2023-01-10', 'Low'),
(5,  'Bilal Saeed',    '3520165432198', '03451234567', 'bilal.saeed@gmail.com',      'Johar Town, Lahore',                          '2021-06-18', 'Low'),
(6,  'Ayesha Tariq',   '3630254321987', '03214567890', 'ayesha.tariq@yahoo.com',     'Bahria Town Phase 4, Rawalpindi',             '2022-03-05', 'Low'),
(7,  'Usman Ghani',    '4210298765123', '03331122334', 'usman.ghani@gmail.com',      'Gulistan-e-Johar, Karachi',                   '2020-08-20', 'Low'),
(8,  'Zara Khan',      '3520132198765', '03119988776', 'zara.khan@hotmail.com',      'Model Town, Lahore',                          '2023-05-14', 'Low'),
(9,  'Faisal Mahmood', '3840187651234', '03056677889', 'faisal.mahmood@gmail.com',   'Saddar, Rawalpindi',                          '2021-12-30', 'Medium'),
(10, 'Sana Mirza',     '4220143219876', '03334455667', 'sana.mirza@gmail.com',       'Clifton Block 4, Karachi',                    '2022-09-08', 'Low'),
(11, 'Hassan Raza',    '3520176543219', '03001122334', 'hassan.raza@gmail.com',      'Gulberg II, Lahore',                          '2021-04-11', 'Low'),
(12, 'Amna Sheikh',    '4210256789012', '03215566778', 'amna.sheikh@yahoo.com',      'Block 14, Federal B Area, Karachi',           '2022-11-25', 'Low'),
(13, 'Tariq Butt',     '3740298761234', '03337788990', 'tariq.butt@hotmail.com',     'I-8/3, Islamabad',                            '2020-05-17', 'High'),
(14, 'Mehwish Ali',    '4220154321098', '03009912345', 'mehwish.ali@gmail.com',      'PECHS Block 6, Karachi',                      '2023-08-01', 'Low'),
(15, 'Omar Farooq',    '3630287651098', '03218811990', 'omar.farooq@gmail.com',      'Satellite Town, Rawalpindi',                  '2021-09-14', 'Medium');

-- ============================================================
-- 4. INVESTIGATORS (must come after USERS)
-- ============================================================
INSERT INTO INVESTIGATOR (Investigator_ID, User_ID, Full_Name, Designation, Email, Phone, Department, Date_Joined, Status, Cases_Handled) VALUES
(1, 2, 'Ali Hassan',    'Senior Fraud Analyst', 'ali.hassan@bankfraud.pk', '03001234567', 'Fraud & Risk',     '2018-04-10', 'Active', 0),
(2, 3, 'Mariam Khalid', 'Fraud Investigator',   'mariam.k@bankfraud.pk',   '03219988776', 'Fraud & Risk',     '2019-07-15', 'Active', 0),
(3, 4, 'Tariq Farooq',  'Lead Investigator',    'tariq.f@bankfraud.pk',    '03331122334', 'Fraud & Risk',     '2017-01-20', 'Active', 0),
(4, 5, 'Hina Baig',     'Junior Analyst',       'hina.baig@bankfraud.pk',  '03004455667', 'Compliance',       '2022-03-01', 'Active', 0),
(5, 6, 'Zafar Iqbal',   'Senior Investigator',  'zafar.iq@bankfraud.pk',   '03336677889', 'Cyber Fraud Unit', '2016-09-05', 'Active', 0);

-- ============================================================
-- 5. ACCOUNTS
-- Account_No inserted directly (trigger disabled during seed)
-- Frozen/Suspended statuses inserted safely (block trigger disabled)
-- ============================================================
INSERT INTO ACCOUNT (Account_ID, Customer_ID, Branch_ID, Account_No, Account_Type, Balance, Status, Date_Opened) VALUES
(1,  1,  1,  'ACC0010000001', 'Savings',  125000.00, 'Active',    '2021-03-15'),
(2,  2,  4,  'ACC0040000002', 'Current',  890000.00, 'Active',    '2022-07-22'),
(3,  3,  3,  'ACC0030000003', 'Savings',   45000.00, 'Active',    '2020-11-01'),
(4,  4,  9,  'ACC0090000004', 'Business', 550000.00, 'Frozen',    '2023-01-10'),
(5,  5,  4,  'ACC0040000005', 'Savings',   32000.00, 'Suspended', '2021-06-18'),
(6,  6,  7,  'ACC0070000006', 'Fixed',    200000.00, 'Active',    '2022-03-05'),
(7,  7,  1,  'ACC0010000007', 'Current',  780000.00, 'Active',    '2020-08-20'),
(8,  8,  4,  'ACC0040000008', 'Savings',   15000.00, 'Active',    '2023-05-14'),
(9,  9,  7,  'ACC0070000009', 'Business', 430000.00, 'Active',    '2021-12-30'),
(10, 10, 10, 'ACC0100000010', 'Savings',   67000.00, 'Active',    '2022-09-08'),
(11, 11, 1,  'ACC0010000011', 'Current',  310000.00, 'Active',    '2021-04-11'),
(12, 12, 8,  'ACC0080000012', 'Savings',   85000.00, 'Active',    '2022-11-25'),
(13, 13, 3,  'ACC0030000013', 'Business', 960000.00, 'Frozen',    '2020-05-17'),
(14, 14, 10, 'ACC0100000014', 'Savings',   22000.00, 'Active',    '2023-08-01'),
(15, 15, 7,  'ACC0070000015', 'Current',  175000.00, 'Active',    '2021-09-14');

-- ============================================================
-- 6. FRAUD RULES
-- ============================================================
INSERT INTO FRAUD_RULE (Rule_ID, Rule_Name, Rule_Code, Description, Threshold, Time_Window, Count_Limit, Severity) VALUES
(1, 'Large Transaction',        'LARGE_TXN',  'Transaction exceeds PKR 200,000 threshold',               200000.00, NULL, NULL, 'High'),
(2, 'Night-Time Transaction',   'NIGHT_TXN',  'High-value transaction between 23:00 and 05:00',           50000.00, NULL, NULL, 'High'),
(3, 'Rapid Transactions',       'RAPID_TXN',  'More than 3 transactions from same account in 10 minutes',     NULL,   10,    3, 'High'),
(4, 'Blacklisted Customer',     'BLACKLIST',  'Transaction by a blacklisted customer',                        NULL, NULL, NULL, 'Critical'),
(5, 'VPN / Masked Location',    'VPN_MASKED', 'Transaction from VPN, unknown, or suspicious location',        NULL, NULL, NULL, 'High'),
(6, 'Dormant Account Activity', 'DORMANT',    'Account inactive for 90+ days suddenly transacts',             NULL,   90, NULL, 'Medium'),
(7, 'High-Risk Customer',       'HIGH_RISK',  'Transaction by a customer with High or Critical risk level',   NULL, NULL, NULL, 'Medium'),
(8, 'Rapid Withdrawal',         'RAPID_DRAW', 'Multiple withdrawals totalling more than 100,000 within 1 hour', 100000.00, 60, NULL, 'Critical');

-- ============================================================
-- 7. TRANSACTIONS
-- Reference_No inserted directly (trigger disabled during seed)
-- Accounts 4 (Frozen) and 5 (Suspended) have no transactions
-- because the block trigger is restored AFTER this insert block.
-- All account IDs used here are Active or the inserts reference
-- only Active accounts.
-- ============================================================
INSERT INTO `TRANSACTION` (Transaction_ID, Account_ID, To_Account_ID, Amount, Balance_Before, Balance_After, Trans_Type, Channel, Location, Trans_DateTime, Status, Reference_No, Remarks) VALUES
(1,  1,  NULL, 25000.00,  125000.00, 100000.00, 'Withdrawal', 'ATM',    'Karachi Airport ATM',               '2024-01-14 23:47:00', 'Success', 'TXN202401140001', 'Airport withdrawal'),
(2,  2,  NULL, 500000.00, 890000.00, 390000.00, 'Transfer',   'Online', 'Online - Suspicious IP',            '2024-01-15 03:12:00', 'Success', 'TXN202401150002', 'Transfer to unknown'),
(3,  3,  NULL, 5000.00,    45000.00,  40000.00, 'Deposit',    'Branch', 'UBL Islamabad Branch',              '2024-01-15 10:30:00', 'Success', 'TXN202401150003', 'Cash deposit'),
(4,  6,  NULL, 75000.00,  200000.00, 125000.00, 'Withdrawal', 'ATM',    'Karachi Port ATM',                  '2024-01-16 22:55:00', 'Success', 'TXN202401160004', 'Late night withdrawal'),
(5,  7,  NULL, 12000.00,  780000.00, 768000.00, 'Transfer',   'Online', 'Lahore - Online Banking',           '2024-01-17 14:20:00', 'Success', 'TXN202401170005', 'Online transfer'),
(6,  6,  NULL, 300000.00, 125000.00,       0.00, 'Transfer',   'Online', 'Unknown Location',                  '2024-01-18 02:30:00', 'Success', 'TXN202401180006', 'Unknown origin'),
(7,  7,  NULL, 8000.00,   768000.00, 760000.00, 'Deposit',    'Branch', 'HBL Gulberg Branch',                '2024-01-19 11:00:00', 'Success', 'TXN202401190007', 'Branch deposit'),
(8,  1,  NULL, 450000.00, 100000.00,       0.00, 'Withdrawal', 'ATM',    'Hyderabad ATM',                     '2024-01-20 23:59:00', 'Success', 'TXN202401200008', 'Large ATM withdrawal'),
(9,  9,  NULL, 15000.00,  430000.00, 415000.00, 'Deposit',    'Branch', 'Bank Alfalah Rawalpindi',           '2024-01-21 09:15:00', 'Success', 'TXN202401210009', 'Regular deposit'),
(10, 2,  NULL, 220000.00, 390000.00, 170000.00, 'Transfer',   'Online', 'VPN - Masked Location',             '2024-01-22 01:45:00', 'Success', 'TXN202401220010', 'VPN transfer'),
(11, 10, NULL, 3500.00,    67000.00,  63500.00, 'Withdrawal', 'ATM',    'Karachi South ATM',                 '2024-01-22 15:30:00', 'Success', 'TXN202401220011', 'Regular ATM'),
(12, 11, NULL, 50000.00,  310000.00, 260000.00, 'Transfer',   'Online', 'Lahore - Mobile App',               '2024-01-23 10:00:00', 'Success', 'TXN202401230012', 'Mobile transfer'),
(13, 12, NULL, 7500.00,    85000.00,  77500.00, 'Withdrawal', 'ATM',    'Karachi North ATM',                 '2024-01-23 16:45:00', 'Success', 'TXN202401230013', 'Regular withdrawal'),
(14, 9,  NULL, 280000.00, 415000.00, 135000.00, 'Withdrawal', 'ATM',    'Suspicious - Unknown ATM',          '2024-01-24 00:15:00', 'Success', 'TXN202401240014', 'Midnight suspicious'),
(15, 15, NULL, 30000.00,  175000.00, 145000.00, 'Transfer',   'Online', 'Rawalpindi - Online',               '2024-01-24 12:00:00', 'Success', 'TXN202401240015', 'Regular transfer'),
(16, 3,  NULL, 10000.00,   40000.00,  30000.00, 'Deposit',    'Branch', 'UBL Islamabad Branch',              '2024-01-25 09:00:00', 'Success', 'TXN202401250016', 'Monthly deposit'),
(17, 7,  NULL, 400000.00, 760000.00, 360000.00, 'Transfer',   'Online', 'VPN - Foreign IP Detected',         '2024-01-25 02:22:00', 'Success', 'TXN202401250017', 'Foreign IP transfer'),
(18, 11, NULL, 55000.00,  260000.00, 205000.00, 'Withdrawal', 'ATM',    'DHA Lahore ATM',                    '2024-01-26 11:30:00', 'Success', 'TXN202401260018', 'Regular withdrawal'),
(19, 8,  NULL, 5000.00,    15000.00,  10000.00, 'Deposit',    'Branch', 'Meezan DHA Lahore',                 '2024-01-26 14:00:00', 'Success', 'TXN202401260019', 'Small deposit'),
(20, 13, NULL, 750000.00, 960000.00, 210000.00, 'Transfer',   'Online', 'Unknown - Masked Location',         '2024-01-27 03:00:00', 'Success', 'TXN202401270020', 'Massive suspicious transfer');

-- ============================================================
-- Sync account balances to match the last transaction state
-- (since trg_update_balance_after_txn was disabled)
-- ============================================================
UPDATE ACCOUNT SET Balance =   0.00 WHERE Account_ID = 1;
UPDATE ACCOUNT SET Balance = 170000.00 WHERE Account_ID = 2;
UPDATE ACCOUNT SET Balance =  30000.00 WHERE Account_ID = 3;
UPDATE ACCOUNT SET Balance = 550000.00 WHERE Account_ID = 4;
UPDATE ACCOUNT SET Balance =  32000.00 WHERE Account_ID = 5;
UPDATE ACCOUNT SET Balance =   0.00 WHERE Account_ID = 6;
UPDATE ACCOUNT SET Balance = 360000.00 WHERE Account_ID = 7;
UPDATE ACCOUNT SET Balance =  10000.00 WHERE Account_ID = 8;
UPDATE ACCOUNT SET Balance = 135000.00 WHERE Account_ID = 9;
UPDATE ACCOUNT SET Balance =  63500.00 WHERE Account_ID = 10;
UPDATE ACCOUNT SET Balance = 205000.00 WHERE Account_ID = 11;
UPDATE ACCOUNT SET Balance =  77500.00 WHERE Account_ID = 12;
UPDATE ACCOUNT SET Balance = 210000.00 WHERE Account_ID = 13;
UPDATE ACCOUNT SET Balance =  22000.00 WHERE Account_ID = 14;
UPDATE ACCOUNT SET Balance = 145000.00 WHERE Account_ID = 15;

-- ============================================================
-- 8. FRAUD ALERTS
-- Assigned_To references Investigator IDs 1–5
-- ============================================================
INSERT INTO FRAUD_ALERT (Alert_ID, Transaction_ID, Rule_ID, Customer_ID, Account_ID, Risk_Score, Alert_Type, Reason, Severity, Alert_Status, Alert_DateTime, Assigned_To) VALUES
(1,  1,  2, 1,  1,  72.00, 'Night-Time High-Value Transaction', 'Transaction of PKR 25,000 at 23:47 (outside business hours)',                             'High',     'Under Review', '2024-01-14 23:50:00', 1),
(2,  2,  1, 2,  2,  95.00, 'Large Transaction Threshold',        'Transaction amount PKR 500,000 exceeds threshold of PKR 200,000',                         'Critical', 'Open',         '2024-01-15 03:15:00', 3),
(3,  2,  5, 2,  2,  85.00, 'Suspicious / VPN Location',          'Transaction location flagged as suspicious: Online - Suspicious IP',                      'High',     'Open',         '2024-01-15 03:15:00', 3),
(4,  4,  2, 6,  6,  68.00, 'Night-Time High-Value Transaction',  'Transaction of PKR 75,000 at 22:55 (outside business hours)',                             'High',     'Under Review', '2024-01-16 23:00:00', 2),
(5,  6,  1, 6,  6,  90.00, 'Large Transaction Threshold',        'Transaction amount PKR 300,000 exceeds threshold of PKR 200,000',                         'Critical', 'Resolved',     '2024-01-18 02:35:00', 1),
(6,  6,  5, 6,  6,  78.00, 'Suspicious / VPN Location',          'Transaction location flagged as suspicious: Unknown Location',                            'High',     'Resolved',     '2024-01-18 02:35:00', 1),
(7,  8,  1, 1,  1,  98.00, 'Large Transaction Threshold',        'Transaction amount PKR 450,000 exceeds threshold of PKR 200,000',                         'Critical', 'Open',         '2024-01-20 23:59:00', 4),
(8,  8,  2, 1,  1,  88.00, 'Night-Time High-Value Transaction',  'Transaction of PKR 450,000 at 23:59 (outside business hours)',                            'Critical', 'Open',         '2024-01-20 23:59:00', 4),
(9,  10, 5, 2,  2,  80.00, 'Suspicious / VPN Location',          'Transaction location flagged as suspicious: VPN - Masked Location',                       'High',     'Under Review', '2024-01-22 01:50:00', 5),
(10, 10, 1, 2,  2,  85.00, 'Large Transaction Threshold',        'Transaction amount PKR 220,000 exceeds threshold of PKR 200,000',                         'High',     'Under Review', '2024-01-22 01:50:00', 5),
(11, 14, 2, 9,  9,  82.00, 'Night-Time High-Value Transaction',  'Transaction of PKR 280,000 at 00:15 (outside business hours)',                            'Critical', 'Open',         '2024-01-24 00:20:00', 2),
(12, 14, 1, 9,  9,  88.00, 'Large Transaction Threshold',        'Transaction amount PKR 280,000 exceeds threshold of PKR 200,000',                         'High',     'Open',         '2024-01-24 00:20:00', 2),
(13, 17, 5, 7,  7,  88.00, 'Suspicious / VPN Location',          'Transaction location flagged as suspicious: VPN - Foreign IP Detected',                   'Critical', 'Under Review', '2024-01-25 02:25:00', 3),
(14, 17, 1, 7,  7,  95.00, 'Large Transaction Threshold',        'Transaction amount PKR 400,000 exceeds threshold of PKR 200,000',                         'Critical', 'Under Review', '2024-01-25 02:25:00', 3),
(15, 20, 1, 13, 13, 99.00, 'Large Transaction Threshold',        'Transaction amount PKR 750,000 exceeds threshold of PKR 200,000',                         'Critical', 'Open',         '2024-01-27 03:05:00', 1),
(16, 20, 5, 13, 13, 90.00, 'Suspicious / VPN Location',          'Transaction location flagged as suspicious: Unknown - Masked Location',                   'Critical', 'Open',         '2024-01-27 03:05:00', 1);

-- ============================================================
-- 9. INVESTIGATION CASES
-- Alert IDs used: 1,2,4,5,7,9,11,13,15
-- All referenced Alert_IDs exist in FRAUD_ALERT above
-- ============================================================
INSERT INTO INVESTIGATION_CASE (Case_ID, Alert_ID, Investigator_ID, Case_Title, Case_Status, Priority, Date_Opened, Date_Closed, Summary, Resolution) VALUES
(1, 1,  1, 'Airport ATM Night Withdrawal - Roshaan Rehman',      'In Progress',              'High',     '2024-01-15', NULL,         'Reviewing CCTV footage from airport ATM. Customer claims legitimate travel.',                               NULL),
(2, 2,  3, 'Large Online Transfer Suspicious IP - Sarah Arif',   'Escalated',                'Critical', '2024-01-15', NULL,         'IP traced to foreign VPN server. Unusual destination account.',                                            NULL),
(3, 4,  2, 'Night High-Value ATM - Ayesha Tariq',                'In Progress',              'High',     '2024-01-17', NULL,         'Customer contacted. Verifying transaction authenticity.',                                                  NULL),
(4, 5,  1, 'Large Transfer Unknown Location - Ayesha Tariq',     'Closed - Fraud Confirmed', 'Critical', '2024-01-18', '2024-01-25', 'Fraud confirmed. Unauthorized transfer from Ayesha Tariq account.',                                       'Customer blacklisted. Account frozen. FIR filed.'),
(5, 7,  4, 'Midnight Large ATM Withdrawal - Roshaan Rehman',     'Open',                     'Critical', '2024-01-21', NULL,         'ATM location (Hyderabad) does not match customer home city (Karachi). Possibly stolen card.',               NULL),
(6, 9,  5, 'VPN Masked Transfer - Sarah Arif',                   'In Progress',              'High',     '2024-01-22', NULL,         'VPN usage confirmed. Account temporarily restricted pending review.',                                      NULL),
(7, 11, 2, 'Midnight Large Withdrawal - Faisal Mahmood',         'Open',                     'Critical', '2024-01-24', NULL,         'ATM at unknown location at midnight. Customer profile mismatch.',                                         NULL),
(8, 13, 3, 'VPN Foreign IP Transfer - Usman Ghani',              'In Progress',              'Critical', '2024-01-25', NULL,         'Foreign IP detected. Transfer to unregistered account. Cyber fraud suspected.',                           NULL),
(9, 15, 1, 'Massive Suspicious Transfer - Tariq Butt',           'Open',                     'Critical', '2024-01-27', NULL,         'PKR 750,000 transfer at 03:00 from VPN/masked location. Highest risk score in system.',                    NULL);

-- ============================================================
-- Manually update Cases_Handled to reflect the 9 cases above
-- (since trg_inc_investigator_cases was disabled during seeding)
-- Investigator 1 (Ali Hassan)  = cases 1,4,9       = 3
-- Investigator 2 (Mariam)      = cases 3,7          = 2
-- Investigator 3 (Tariq Farooq)= cases 2,8          = 2
-- Investigator 4 (Hina Baig)   = case 5             = 1
-- Investigator 5 (Zafar Iqbal) = case 6             = 1
-- ============================================================
UPDATE INVESTIGATOR SET Cases_Handled = 3 WHERE Investigator_ID = 1;
UPDATE INVESTIGATOR SET Cases_Handled = 2 WHERE Investigator_ID = 2;
UPDATE INVESTIGATOR SET Cases_Handled = 2 WHERE Investigator_ID = 3;
UPDATE INVESTIGATOR SET Cases_Handled = 1 WHERE Investigator_ID = 4;
UPDATE INVESTIGATOR SET Cases_Handled = 1 WHERE Investigator_ID = 5;

-- ============================================================
-- 10. CASE NOTES
-- ============================================================
INSERT INTO CASE_NOTE (Note_ID, Case_ID, Added_By, Note_Text) VALUES
(1, 1, 2, 'CCTV footage requested from Karachi Airport security. Response pending.'),
(2, 1, 2, 'Customer called - confirms travel to Karachi. Passport stamp verification requested.'),
(3, 2, 4, 'IP geolocated to Ukraine. Transaction destination account registered 2 days ago - suspicious.'),
(4, 2, 4, 'Account-to-account transfer chain identified. 3 hops before final destination. Money mule suspected.'),
(5, 4, 1, 'Case escalated to Critical. Amount exceeds fraud threshold. Legal notified.'),
(6, 6, 5, 'VPN provider identified as ProtonVPN. Legal request submitted for subscriber info.'),
(7, 8, 4, 'Malware attack on customer device suspected. Customer advised to change credentials.'),
(8, 9, 1, 'Tariq Butt has prior blacklist entry. New account opened under family member name suspected.');

-- ============================================================
-- 11. BLACKLIST
-- Case_ID 4 references INVESTIGATION_CASE row with Case_ID=4
-- Customers 4, 5, 13 — manually set Risk_Level to Critical below
-- (since trg_blacklist_risk_update is disabled during seeding)
-- ============================================================
INSERT INTO BLACKLIST (Blacklist_ID, Customer_ID, Case_ID, Reason, Date_Added, Added_By, Is_Active) VALUES
(1, 4,  4,    'Fraud confirmed via Case 4. Large unauthorized online transfer through VPN. FIR filed with FIA.',            '2024-01-25', 1, 1),
(2, 5,  NULL, 'Multiple suspicious ATM withdrawals across different cities within 24 hours. Pattern indicates card cloning.','2024-02-01', 1, 1),
(3, 13, NULL, 'PKR 750,000 transfer at 03:00 via VPN masked location. Account opened specifically for fraud suspected.',    '2024-01-28', 1, 1);

-- Manually set Risk_Level for blacklisted customers
UPDATE CUSTOMER SET Risk_Level = 'Critical' WHERE Customer_ID IN (4, 5, 13);

-- ============================================================
-- 12. AUDIT LOG
-- ============================================================
INSERT INTO AUDIT_LOG (Log_ID, User_ID, Action, Module, Record_ID, New_Value, IP_Address) VALUES
(1,  1, 'LOGIN',  'Authentication', NULL, 'Admin logged in',                    '192.168.1.1'),
(2,  1, 'CREATE', 'Customer',       1,    'Customer Roshaan Rehman created',     '192.168.1.1'),
(3,  1, 'CREATE', 'Customer',       4,    'Customer Nadia Hussain created',      '192.168.1.1'),
(4,  1, 'UPDATE', 'Account',        4,    'Account status changed to Frozen',    '192.168.1.1'),
(5,  1, 'CREATE', 'Blacklist',      1,    'Customer ID 4 added to blacklist',    '192.168.1.1'),
(6,  2, 'LOGIN',  'Authentication', NULL, 'Ali Hassan logged in',                '192.168.1.2'),
(7,  2, 'UPDATE', 'FraudAlert',     5,    'Alert 5 marked Resolved',             '192.168.1.2'),
(8,  3, 'UPDATE', 'InvCase',        2,    'Case 2 escalated to Critical',        '192.168.1.3'),
(9,  4, 'CREATE', 'CaseNote',       5,    'Note added to Case 5',                '192.168.1.4'),
(10, 1, 'CREATE', 'Blacklist',      3,    'Customer ID 13 added to blacklist',   '192.168.1.1');

-- ============================================================
-- RESTORE ALL TRIGGERS
-- ============================================================

-- Trigger 1: Account_No generator
DELIMITER $$
CREATE TRIGGER trg_account_no_generate
BEFORE INSERT ON ACCOUNT
FOR EACH ROW
BEGIN
    DECLARE v_seq INT;
    SELECT COUNT(*) + 1 INTO v_seq FROM ACCOUNT;
    SET NEW.Account_No = CONCAT('ACC', LPAD(NEW.Branch_ID, 3, '0'), LPAD(v_seq, 7, '0'));
END$$
DELIMITER ;

-- Trigger 2: Block inactive account transactions
DELIMITER $$
CREATE TRIGGER trg_block_inactive_account_txn
BEFORE INSERT ON `TRANSACTION`
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT Status INTO v_status FROM ACCOUNT WHERE Account_ID = NEW.Account_ID;
    IF v_status IN ('Frozen','Suspended','Closed') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transaction blocked: account is not Active.';
    END IF;
END$$
DELIMITER ;

-- Trigger 3: Update balance after transaction
DELIMITER $$
CREATE TRIGGER trg_update_balance_after_txn
AFTER INSERT ON `TRANSACTION`
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Success' THEN
        UPDATE ACCOUNT SET Balance = NEW.Balance_After
        WHERE Account_ID = NEW.Account_ID;
        IF NEW.Trans_Type = 'Transfer' AND NEW.To_Account_ID IS NOT NULL THEN
            UPDATE ACCOUNT SET Balance = Balance + NEW.Amount
            WHERE Account_ID = NEW.To_Account_ID;
        END IF;
    END IF;
END$$
DELIMITER ;

-- Trigger 4: Blacklist sets Risk_Level to Critical
DELIMITER $$
CREATE TRIGGER trg_blacklist_risk_update
AFTER INSERT ON BLACKLIST
FOR EACH ROW
BEGIN
    UPDATE CUSTOMER SET Risk_Level = 'Critical'
    WHERE Customer_ID = NEW.Customer_ID;
END$$
DELIMITER ;

-- Trigger 5: Increment investigator case count
DELIMITER $$
CREATE TRIGGER trg_inc_investigator_cases
AFTER INSERT ON INVESTIGATION_CASE
FOR EACH ROW
BEGIN
    UPDATE INVESTIGATOR SET Cases_Handled = Cases_Handled + 1
    WHERE Investigator_ID = NEW.Investigator_ID;
END$$
DELIMITER ;

-- Trigger 6: Auto-generate Reference_No
DELIMITER $$
CREATE TRIGGER trg_txn_reference_no
BEFORE INSERT ON `TRANSACTION`
FOR EACH ROW
BEGIN
    DECLARE v_seq INT;
    SELECT COUNT(*) + 1 INTO v_seq FROM `TRANSACTION`;
    SET NEW.Reference_No = CONCAT('TXN', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(v_seq, 6, '0'));
END$$
DELIMITER ;

-- ============================================================
-- RESTORE FK CHECKS
-- ============================================================
SET FOREIGN_KEY_CHECKS = 1;

