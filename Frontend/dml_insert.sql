USE bank_fraud_db;

-- INSERT: BRANCH (10 rows)
INSERT INTO BRANCH (Branch_Name, City, Location, Phone, Manager_Name) VALUES
('HBL Gulberg Branch',        'Lahore',     '17-A Gulberg III, Lahore',         '04235761234', 'Tariq Mehmood'),
('MCB Saddar Branch',         'Karachi',    'I.I. Chundrigar Road, Saddar',     '02132412345', 'Fareeha Siddiqui'),
('UBL Blue Area Branch',      'Islamabad',  'Blue Area, Jinnah Avenue',          '05128901122', 'Asad Ali Khan'),
('Meezan Bank DHA Branch',    'Lahore',     'DHA Phase 5, Lahore',              '04235219988', 'Sana Malik'),
('Allied Bank Clifton',       'Karachi',    'Clifton Block 5, Karachi',         '02135480011', 'Imran Sheikh'),
('NBP F-10 Branch',           'Islamabad',  'F-10 Markaz, Islamabad',           '05122345678', 'Rabia Noor'),
('Bank Alfalah GT Road',      'Rawalpindi', 'GT Road, Rawalpindi',              '05198765432', 'Kamran Javed'),
('Habib Metro Johar',         'Karachi',    'Johar Chowrangi, Karachi',         '02134567890', 'Nadia Hussain'),
('Faysal Bank Gulshan',       'Karachi',    'Gulshan-e-Iqbal Block 3',          '02133219988', 'Zubair Ahmed'),
('Standard Chartered PECHS',  'Karachi',    'PECHS Block 2, Karachi',           '02134112233', 'Ayesha Raza');

-- INSERT: CUSTOMER (10 rows)
INSERT INTO CUSTOMER (Full_Name, CNIC, Phone, Email, Address, Date_Joined) VALUES
('Roshaan Rehman',          '4210112345671', '03112345671', 'roshaan.rehman@gmail.com',  'House 12, Block C, Gulshan-e-Iqbal, Karachi', '2021-03-15'),
('Sarah Arif',              '3520198765432', '03218765432', 'sarah.arif@yahoo.com',       'Flat 5, DHA Phase 2, Lahore',                 '2022-07-22'),
('Kamran Javed',            '3740256781234', '03337812345', 'kamran.javed@hotmail.com',   'Sector G-11/2, Islamabad',                    '2020-11-01'),
('Nadia Hussain',           '4220187654321', '03009876543', 'nadia.hussain@gmail.com',    'North Nazimabad Block H, Karachi',            '2023-01-10'),
('Bilal Saeed',             '3520165432198', '03451234567', 'bilal.saeed@gmail.com',      'Johar Town, Lahore',                          '2021-06-18'),
('Ayesha Tariq',            '3630254321987', '03214567890', 'ayesha.tariq@yahoo.com',     'Bahria Town Phase 4, Rawalpindi',             '2022-03-05'),
('Usman Ghani',             '4210298765123', '03331122334', 'usman.ghani@gmail.com',      'Gulistan-e-Johar, Karachi',                   '2020-08-20'),
('Zara Khan',               '3520132198765', '03119988776', 'zara.khan@hotmail.com',      'Model Town, Lahore',                          '2023-05-14'),
('Faisal Mahmood',          '3840187651234', '03056677889', 'faisal.mahmood@gmail.com',   'Saddar, Rawalpindi',                          '2021-12-30'),
('Sana Mirza',              '4220143219876', '03334455667', 'sana.mirza@gmail.com',       'Clifton Block 4, Karachi',                    '2022-09-08');

-- INSERT: ACCOUNT (10 rows)
INSERT INTO ACCOUNT (Customer_ID, Branch_ID, Account_Type, Balance, Status, Date_Opened) VALUES
(1,  1,  'Savings',  125000.00, 'Active', '2021-03-15'),
(2,  4,  'Current',  890000.00, 'Active', '2022-07-22'),
(3,  3,  'Savings',   45000.00, 'Active', '2020-11-01'),
(4,  9,  'Business', 550000.00, 'Active', '2023-01-10'),
(5,  4,  'Savings',   32000.00, 'Frozen', '2021-06-18'),
(6,  7,  'Fixed',    200000.00, 'Active', '2022-03-05'),
(7,  1,  'Current',  780000.00, 'Active', '2020-08-20'),
(8,  4,  'Savings',   15000.00, 'Active', '2023-05-14'),
(9,  7,  'Business', 430000.00, 'Active', '2021-12-30'),
(10, 10, 'Savings',   67000.00, 'Active', '2022-09-08');

-- INSERT: INVESTIGATOR (5 rows)
INSERT INTO INVESTIGATOR (Full_Name, Designation, Email, Phone, Date_Joined, Status) VALUES
('Ali Hassan',    'Senior Fraud Analyst', 'ali.hassan@bankfraud.pk',  '03001234567', '2018-04-10', 'Active'),
('Mariam Khalid', 'Fraud Investigator',   'mariam.k@bankfraud.pk',    '03219988776', '2019-07-15', 'Active'),
('Tariq Farooq',  'Lead Investigator',    'tariq.f@bankfraud.pk',     '03331122334', '2017-01-20', 'Active'),
('Hina Baig',     'Junior Analyst',       'hina.baig@bankfraud.pk',   '03004455667', '2022-03-01', 'Active'),
('Zafar Iqbal',   'Senior Investigator',  'zafar.iq@bankfraud.pk',    '03336677889', '2016-09-05', 'Active');

-- INSERT: TRANSACTION (10 rows)
INSERT INTO TRANSACTION (Account_ID, Amount, Trans_Date, Trans_Time, Trans_Type, Channel, Location) VALUES
(1,  25000.00,  '2024-01-14', '23:47:00', 'Withdrawal', 'ATM',    'Karachi Airport ATM'),
(2,  500000.00, '2024-01-15', '03:12:00', 'Transfer',   'Online', 'Online — Suspicious IP'),
(3,  5000.00,   '2024-01-15', '10:30:00', 'Deposit',    'Branch', 'UBL Islamabad Branch'),
(4,  75000.00,  '2024-01-16', '22:55:00', 'Withdrawal', 'ATM',    'Karachi Port ATM'),
(5,  12000.00,  '2024-01-17', '14:20:00', 'Transfer',   'Online', 'Lahore — Online Banking'),
(6,  300000.00, '2024-01-18', '02:30:00', 'Transfer',   'Online', 'Unknown Location'),
(7,  8000.00,   '2024-01-19', '11:00:00', 'Deposit',    'Branch', 'HBL Gulberg Branch'),
(8,  450000.00, '2024-01-20', '23:59:00', 'Withdrawal', 'ATM',    'Hyderabad ATM'),
(9,  15000.00,  '2024-01-21', '09:15:00', 'Deposit',    'Branch', 'Bank Alfalah Rawalpindi'),
(10, 220000.00, '2024-01-22', '01:45:00', 'Transfer',   'Online', 'VPN — Masked Location');

-- INSERT: FRAUD_ALERT (6 rows)
INSERT INTO FRAUD_ALERT (Transaction_ID, Investigator_ID, Alert_Type, Priority, Alert_Status, Alert_Date) VALUES
(1,  1, 'Night-Time ATM Withdrawal — Airport',      'High',     'Under Review', '2024-01-14 23:50:00'),
(2,  3, 'Large Transfer — Suspicious IP Address',   'Critical', 'Open',         '2024-01-15 03:15:00'),
(4,  2, 'Night-Time High-Value ATM Withdrawal',     'High',     'Under Review', '2024-01-16 23:00:00'),
(6,  1, 'Large Online Transfer — Unknown Location', 'Critical', 'Resolved',     '2024-01-18 02:35:00'),
(8,  4, 'Midnight ATM — Unusual City',              'High',     'Open',         '2024-01-20 23:59:00'),
(10, 5, 'VPN Masked Transfer — Late Night',         'Critical', 'Under Review', '2024-01-22 01:50:00');

-- INSERT: INVESTIGATION_CASE (6 rows)
INSERT INTO INVESTIGATION_CASE (Alert_ID, Investigator_ID, Case_Status, Date_Opened, Case_Closed_Date, Remarks) VALUES
(1, 1, 'In Progress', '2024-01-15', NULL,         'Reviewing CCTV footage from airport ATM.'),
(2, 3, 'Open',        '2024-01-15', NULL,         'IP traced to foreign VPN server. Escalated.'),
(3, 2, 'In Progress', '2024-01-17', NULL,         'Customer contacted. Verifying transaction.'),
(4, 1, 'Closed',      '2024-01-18', '2024-01-25', 'Fraud confirmed. Customer blacklisted.'),
(5, 4, 'Open',        '2024-01-21', NULL,         'ATM location does not match customer profile.'),
(6, 5, 'In Progress', '2024-01-22', NULL,         'VPN usage confirmed. Account frozen pending review.');

-- INSERT: BLACKLIST (2 rows)
INSERT INTO BLACKLIST (Customer_ID, Reason, Date_Added, Added_By) VALUES
(4, 'Fraud confirmed via Case #4. Large unauthorized online transfer through VPN.', '2024-01-25', 'Ali Hassan — Senior Fraud Analyst'),
(5, 'Multiple suspicious ATM withdrawals in different cities within 24 hours.',     '2024-02-01', 'Mariam Khalid — Fraud Investigator');