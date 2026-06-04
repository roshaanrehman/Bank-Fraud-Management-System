--DDL QUERIES 
-- ============================================================
-- BANK FRAUD DETECTION SYSTEM — DDL (FIXED)
-- University: IMSciences | Course: Database Systems Lab
-- Authors   : Sarah Arif & Roshaan Rehman (BSSE-A, Sem 4) 
-- MySQL 8 / XAMPP phpMyAdmin compatible — zero errors
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = '';

DROP DATABASE IF EXISTS bank_fraud_db;
CREATE DATABASE bank_fraud_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bank_fraud_db;

-- ============================================================
-- TABLE 1: BRANCH
-- ============================================================
CREATE TABLE BRANCH (
    Branch_ID     INT           NOT NULL AUTO_INCREMENT,
    Branch_Name   VARCHAR(100)  NOT NULL,
    City          VARCHAR(60)   NOT NULL,
    Location      VARCHAR(200)  NOT NULL,
    Phone         VARCHAR(15)   NOT NULL,
    Manager_Name  VARCHAR(100)  NOT NULL,
    Created_At    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_branch PRIMARY KEY (Branch_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 2: CUSTOMER
-- ============================================================
CREATE TABLE CUSTOMER (
    Customer_ID   INT           NOT NULL AUTO_INCREMENT,
    Full_Name     VARCHAR(100)  NOT NULL,
    CNIC          CHAR(13)      NOT NULL,
    Phone         VARCHAR(15)   NOT NULL,
    Email         VARCHAR(150)  NOT NULL,
    Address       VARCHAR(250)  NOT NULL,
    Date_Joined   DATE          NOT NULL,
    Risk_Level    ENUM('Low','Medium','High','Critical') NOT NULL DEFAULT 'Low',
    Is_Active     TINYINT(1)    NOT NULL DEFAULT 1,
    Created_At    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Updated_At    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_customer       PRIMARY KEY (Customer_ID),
    CONSTRAINT uq_customer_cnic  UNIQUE (CNIC),
    CONSTRAINT uq_customer_email UNIQUE (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 3: USERS
-- ============================================================
CREATE TABLE USERS (
    User_ID        INT           NOT NULL AUTO_INCREMENT,
    Username       VARCHAR(60)   NOT NULL,
    Password_Hash  VARCHAR(255)  NOT NULL,
    Full_Name      VARCHAR(100)  NOT NULL,
    Email          VARCHAR(150)  NOT NULL,
    Role           ENUM('Admin','Investigator') NOT NULL DEFAULT 'Investigator',
    Is_Active      TINYINT(1)    NOT NULL DEFAULT 1,
    Last_Login     DATETIME      NULL DEFAULT NULL,
    Login_Attempts INT           NOT NULL DEFAULT 0,
    Locked_Until   DATETIME      NULL DEFAULT NULL,
    Created_At     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_users      PRIMARY KEY (User_ID),
    CONSTRAINT uq_username   UNIQUE (Username),
    CONSTRAINT uq_user_email UNIQUE (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 4: ACCOUNT
-- ============================================================
CREATE TABLE ACCOUNT (
    Account_ID   INT            NOT NULL AUTO_INCREMENT,
    Customer_ID  INT            NOT NULL,
    Branch_ID    INT            NOT NULL,
    Account_No   VARCHAR(20)    NOT NULL DEFAULT '',
    Account_Type ENUM('Savings','Current','Fixed','Business') NOT NULL,
    Balance      DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    Status       ENUM('Active','Frozen','Suspended','Closed') NOT NULL DEFAULT 'Active',
    Date_Opened  DATE           NOT NULL,
    Date_Closed  DATE           NULL DEFAULT NULL,
    Created_At   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Updated_At   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_account      PRIMARY KEY (Account_ID),
    CONSTRAINT uq_account_no   UNIQUE (Account_No),
    CONSTRAINT fk_acc_customer FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID) ON UPDATE CASCADE,
    CONSTRAINT fk_acc_branch   FOREIGN KEY (Branch_ID)   REFERENCES BRANCH(Branch_ID)     ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 5: TRANSACTION
-- NOTE: TRANSACTION is a reserved word — backtick-quoted everywhere
-- ============================================================
CREATE TABLE `TRANSACTION` (
    Transaction_ID  INT            NOT NULL AUTO_INCREMENT,
    Account_ID      INT            NOT NULL,
    To_Account_ID   INT            NULL DEFAULT NULL,
    Amount          DECIMAL(15,2)  NOT NULL,
    Balance_Before  DECIMAL(15,2)  NOT NULL,
    Balance_After   DECIMAL(15,2)  NOT NULL,
    Trans_Type      ENUM('Deposit','Withdrawal','Transfer') NOT NULL,
    Channel         ENUM('ATM','Online','Branch','Mobile')  NOT NULL,
    Location        VARCHAR(200)   NULL DEFAULT NULL,
    Trans_DateTime  DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status          ENUM('Success','Failed','Reversed')     NOT NULL DEFAULT 'Success',
    Reference_No    VARCHAR(30)    NOT NULL DEFAULT '',
    Remarks         VARCHAR(300)   NULL DEFAULT NULL,
    CONSTRAINT pk_transaction    PRIMARY KEY (Transaction_ID),
    CONSTRAINT uq_ref_no         UNIQUE (Reference_No),
    CONSTRAINT fk_txn_account    FOREIGN KEY (Account_ID)    REFERENCES ACCOUNT(Account_ID) ON UPDATE CASCADE,
    CONSTRAINT fk_txn_to_account FOREIGN KEY (To_Account_ID) REFERENCES ACCOUNT(Account_ID) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 6: FRAUD_RULE
-- ============================================================
CREATE TABLE FRAUD_RULE (
    Rule_ID      INT            NOT NULL AUTO_INCREMENT,
    Rule_Name    VARCHAR(100)   NOT NULL,
    Rule_Code    VARCHAR(50)    NOT NULL,
    Description  TEXT           NOT NULL,
    Threshold    DECIMAL(15,2)  NULL DEFAULT NULL,
    Time_Window  INT            NULL DEFAULT NULL COMMENT 'Minutes',
    Count_Limit  INT            NULL DEFAULT NULL,
    Severity     ENUM('Low','Medium','High','Critical') NOT NULL DEFAULT 'Medium',
    Is_Active    TINYINT(1)     NOT NULL DEFAULT 1,
    Created_At   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_fraud_rule PRIMARY KEY (Rule_ID),
    CONSTRAINT uq_rule_code  UNIQUE (Rule_Code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 7: INVESTIGATOR
-- ============================================================
CREATE TABLE INVESTIGATOR (
    Investigator_ID INT          NOT NULL AUTO_INCREMENT,
    User_ID         INT          NOT NULL,
    Full_Name       VARCHAR(100) NOT NULL,
    Designation     VARCHAR(80)  NOT NULL,
    Email           VARCHAR(150) NOT NULL,
    Phone           VARCHAR(15)  NOT NULL,
    Department      VARCHAR(80)  NOT NULL DEFAULT 'Fraud & Risk',
    Date_Joined     DATE         NOT NULL,
    Status          ENUM('Active','Inactive','On Leave') NOT NULL DEFAULT 'Active',
    Cases_Handled   INT          NOT NULL DEFAULT 0,
    Created_At      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_investigator PRIMARY KEY (Investigator_ID),
    CONSTRAINT uq_inv_user     UNIQUE (User_ID),
    CONSTRAINT uq_inv_email    UNIQUE (Email),
    CONSTRAINT fk_inv_user     FOREIGN KEY (User_ID) REFERENCES USERS(User_ID) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 8: FRAUD_ALERT
-- ============================================================
CREATE TABLE FRAUD_ALERT (
    Alert_ID        INT           NOT NULL AUTO_INCREMENT,
    Transaction_ID  INT           NOT NULL,
    Rule_ID         INT           NOT NULL,
    Customer_ID     INT           NOT NULL,
    Account_ID      INT           NOT NULL,
    Risk_Score      DECIMAL(5,2)  NOT NULL DEFAULT 0.00,
    Alert_Type      VARCHAR(120)  NOT NULL,
    Reason          TEXT          NOT NULL,
    Severity        ENUM('Low','Medium','High','Critical') NOT NULL,
    Alert_Status    ENUM('Open','Under Review','Resolved','False Positive','Escalated') NOT NULL DEFAULT 'Open',
    Alert_DateTime  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Assigned_To     INT           NULL DEFAULT NULL,
    Resolved_At     DATETIME      NULL DEFAULT NULL,
    Resolution_Note TEXT          NULL DEFAULT NULL,
    CONSTRAINT pk_fraud_alert    PRIMARY KEY (Alert_ID),
    CONSTRAINT fk_alert_txn      FOREIGN KEY (Transaction_ID) REFERENCES `TRANSACTION`(Transaction_ID) ON UPDATE CASCADE,
    CONSTRAINT fk_alert_rule     FOREIGN KEY (Rule_ID)        REFERENCES FRAUD_RULE(Rule_ID)            ON UPDATE CASCADE,
    CONSTRAINT fk_alert_customer FOREIGN KEY (Customer_ID)    REFERENCES CUSTOMER(Customer_ID)          ON UPDATE CASCADE,
    CONSTRAINT fk_alert_account  FOREIGN KEY (Account_ID)     REFERENCES ACCOUNT(Account_ID)            ON UPDATE CASCADE,
    CONSTRAINT fk_alert_inv      FOREIGN KEY (Assigned_To)    REFERENCES INVESTIGATOR(Investigator_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 9: INVESTIGATION_CASE
-- ============================================================
CREATE TABLE INVESTIGATION_CASE (
    Case_ID         INT          NOT NULL AUTO_INCREMENT,
    Alert_ID        INT          NOT NULL,
    Investigator_ID INT          NOT NULL,
    Case_Title      VARCHAR(200) NOT NULL,
    Case_Status     ENUM('Open','In Progress','Escalated','Closed - Fraud Confirmed','Closed - False Positive') NOT NULL DEFAULT 'Open',
    Priority        ENUM('Low','Medium','High','Critical') NOT NULL DEFAULT 'Medium',
    Date_Opened     DATE         NOT NULL,
    Date_Closed     DATE         NULL DEFAULT NULL,
    Summary         TEXT         NULL DEFAULT NULL,
    Evidence        TEXT         NULL DEFAULT NULL,
    Resolution      TEXT         NULL DEFAULT NULL,
    Created_At      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Updated_At      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_case       PRIMARY KEY (Case_ID),
    CONSTRAINT uq_case_alert UNIQUE (Alert_ID),
    CONSTRAINT fk_case_alert FOREIGN KEY (Alert_ID)        REFERENCES FRAUD_ALERT(Alert_ID)         ON UPDATE CASCADE,
    CONSTRAINT fk_case_inv   FOREIGN KEY (Investigator_ID) REFERENCES INVESTIGATOR(Investigator_ID) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 10: CASE_NOTE
-- ============================================================
CREATE TABLE CASE_NOTE (
    Note_ID    INT       NOT NULL AUTO_INCREMENT,
    Case_ID    INT       NOT NULL,
    Added_By   INT       NOT NULL,
    Note_Text  TEXT      NOT NULL,
    Created_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_note      PRIMARY KEY (Note_ID),
    CONSTRAINT fk_note_case FOREIGN KEY (Case_ID)  REFERENCES INVESTIGATION_CASE(Case_ID) ON DELETE CASCADE,
    CONSTRAINT fk_note_user FOREIGN KEY (Added_By) REFERENCES USERS(User_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 11: BLACKLIST
-- ============================================================
CREATE TABLE BLACKLIST (
    Blacklist_ID   INT          NOT NULL AUTO_INCREMENT,
    Customer_ID    INT          NOT NULL,
    Case_ID        INT          NULL DEFAULT NULL,
    Reason         TEXT         NOT NULL,
    Date_Added     DATE         NOT NULL,
    Added_By       INT          NOT NULL,
    Is_Active      TINYINT(1)   NOT NULL DEFAULT 1,
    Date_Removed   DATE         NULL DEFAULT NULL,
    Removed_By     INT          NULL DEFAULT NULL,
    Removal_Reason TEXT         NULL DEFAULT NULL,
    Created_At     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_blacklist      PRIMARY KEY (Blacklist_ID),
    CONSTRAINT uq_blacklist_cust UNIQUE (Customer_ID),
    CONSTRAINT fk_bl_customer    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID)          ON UPDATE CASCADE,
    CONSTRAINT fk_bl_case        FOREIGN KEY (Case_ID)     REFERENCES INVESTIGATION_CASE(Case_ID),
    CONSTRAINT fk_bl_added_by    FOREIGN KEY (Added_By)    REFERENCES USERS(User_ID),
    CONSTRAINT fk_bl_removed_by  FOREIGN KEY (Removed_By)  REFERENCES USERS(User_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TABLE 12: AUDIT_LOG
-- ============================================================
CREATE TABLE AUDIT_LOG (
    Log_ID     INT           NOT NULL AUTO_INCREMENT,
    User_ID    INT           NULL DEFAULT NULL,
    Action     VARCHAR(60)   NOT NULL,
    Module     VARCHAR(60)   NOT NULL,
    Record_ID  INT           NULL DEFAULT NULL,
    Old_Value  TEXT          NULL DEFAULT NULL,
    New_Value  TEXT          NULL DEFAULT NULL,
    IP_Address VARCHAR(45)   NULL DEFAULT NULL,
    Created_At TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_audit_log PRIMARY KEY (Log_ID),
    CONSTRAINT fk_log_user  FOREIGN KEY (User_ID) REFERENCES USERS(User_ID) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_customer_cnic    ON CUSTOMER(CNIC);
CREATE INDEX idx_customer_risk    ON CUSTOMER(Risk_Level);
CREATE INDEX idx_account_customer ON ACCOUNT(Customer_ID);
CREATE INDEX idx_account_status   ON ACCOUNT(Status);
CREATE INDEX idx_txn_account      ON `TRANSACTION`(Account_ID);
CREATE INDEX idx_txn_datetime     ON `TRANSACTION`(Trans_DateTime);
CREATE INDEX idx_txn_type         ON `TRANSACTION`(Trans_Type);
CREATE INDEX idx_alert_status     ON FRAUD_ALERT(Alert_Status);
CREATE INDEX idx_alert_datetime   ON FRAUD_ALERT(Alert_DateTime);
CREATE INDEX idx_alert_severity   ON FRAUD_ALERT(Severity);
CREATE INDEX idx_case_status      ON INVESTIGATION_CASE(Case_Status);
CREATE INDEX idx_audit_module     ON AUDIT_LOG(Module, Created_At);

-- ============================================================
-- DROP TRIGGERS IF THEY ALREADY EXIST (safe re-import)
-- ============================================================
DROP TRIGGER IF EXISTS trg_account_no_generate;
DROP TRIGGER IF EXISTS trg_block_inactive_account_txn;
DROP TRIGGER IF EXISTS trg_update_balance_after_txn;
DROP TRIGGER IF EXISTS trg_blacklist_risk_update;
DROP TRIGGER IF EXISTS trg_inc_investigator_cases;
DROP TRIGGER IF EXISTS trg_txn_reference_no;

-- ============================================================
-- TRIGGER 1: Auto-generate Account_No before INSERT
-- ============================================================
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

-- ============================================================
-- TRIGGER 2: Block transactions on Frozen/Suspended/Closed accounts
-- (only fires for NEW inserts — does not block DML seed data
--  inserted while accounts have those statuses, because we
--  disable this trigger during seeding and re-enable after)
-- ============================================================
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

-- ============================================================
-- TRIGGER 3: Update account balance after successful transaction
-- ============================================================
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

-- ============================================================
-- TRIGGER 4: Set customer Risk_Level to Critical on blacklisting
-- ============================================================
DELIMITER $$
CREATE TRIGGER trg_blacklist_risk_update
AFTER INSERT ON BLACKLIST
FOR EACH ROW
BEGIN
    UPDATE CUSTOMER SET Risk_Level = 'Critical'
    WHERE Customer_ID = NEW.Customer_ID;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 5: Increment investigator Cases_Handled on new case
-- ============================================================
DELIMITER $$
CREATE TRIGGER trg_inc_investigator_cases
AFTER INSERT ON INVESTIGATION_CASE
FOR EACH ROW
BEGIN
    UPDATE INVESTIGATOR SET Cases_Handled = Cases_Handled + 1
    WHERE Investigator_ID = NEW.Investigator_ID;
END$$
DELIMITER ;

-- ============================================================
-- TRIGGER 6: Auto-generate Reference_No before transaction INSERT
-- ============================================================
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
-- DROP PROCEDURES IF THEY EXIST (safe re-import)
-- ============================================================
DROP PROCEDURE IF EXISTS sp_process_transaction;
DROP PROCEDURE IF EXISTS sp_run_fraud_detection;

-- ============================================================
-- STORED PROCEDURE 1: Process a Transaction
-- ============================================================
DELIMITER $$
CREATE PROCEDURE sp_process_transaction(
    IN  p_account_id    INT,
    IN  p_to_account_id INT,
    IN  p_amount        DECIMAL(15,2),
    IN  p_type          VARCHAR(20),
    IN  p_channel       VARCHAR(20),
    IN  p_location      VARCHAR(200),
    IN  p_remarks       VARCHAR(300),
    OUT p_txn_id        INT,
    OUT p_result        VARCHAR(200)
)
BEGIN
    DECLARE v_balance   DECIMAL(15,2);
    DECLARE v_status    VARCHAR(20);
    DECLARE v_bal_after DECIMAL(15,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Transaction failed due to a database error.';
    END;

    START TRANSACTION;

    SELECT Balance, Status INTO v_balance, v_status
    FROM ACCOUNT WHERE Account_ID = p_account_id FOR UPDATE;

    IF v_status != 'Active' THEN
        ROLLBACK;
        SET p_result = CONCAT('ERROR: Account is ', v_status, '. Transactions not allowed.');
        LEAVE sp_process_transaction;
    END IF;

    IF p_amount <= 0 THEN
        ROLLBACK;
        SET p_result = 'ERROR: Amount must be greater than zero.';
        LEAVE sp_process_transaction;
    END IF;

    IF p_type IN ('Withdrawal','Transfer') AND v_balance < p_amount THEN
        ROLLBACK;
        SET p_result = 'ERROR: Insufficient balance.';
        LEAVE sp_process_transaction;
    END IF;

    IF p_type = 'Deposit' THEN
        SET v_bal_after = v_balance + p_amount;
    ELSE
        SET v_bal_after = v_balance - p_amount;
    END IF;

    INSERT INTO `TRANSACTION`
        (Account_ID, To_Account_ID, Amount, Balance_Before, Balance_After,
         Trans_Type, Channel, Location, Trans_DateTime, Status, Reference_No, Remarks)
    VALUES
        (p_account_id, p_to_account_id, p_amount, v_balance, v_bal_after,
         p_type, p_channel, p_location, NOW(), 'Success', '', p_remarks);

    SET p_txn_id = LAST_INSERT_ID();
    COMMIT;
    SET p_result = 'SUCCESS';
END$$
DELIMITER ;

-- ============================================================
-- STORED PROCEDURE 2: Run Fraud Detection
-- ============================================================
DELIMITER $$
CREATE PROCEDURE sp_run_fraud_detection(
    IN  p_txn_id       INT,
    OUT p_alerts_fired INT
)
BEGIN
    DECLARE v_amount          DECIMAL(15,2);
    DECLARE v_account_id      INT;
    DECLARE v_customer_id     INT;
    DECLARE v_location        VARCHAR(200);
    DECLARE v_txn_time        DATETIME;
    DECLARE v_risk_score      DECIMAL(5,2);
    DECLARE v_severity        VARCHAR(20);
    DECLARE v_hour            INT;
    DECLARE v_rapid_count     INT;
    DECLARE v_is_blacklisted  INT;
    DECLARE v_open_alerts     INT;
    DECLARE v_large_thresh    DECIMAL(15,2) DEFAULT 200000.00;
    DECLARE v_night_thresh    DECIMAL(15,2) DEFAULT 50000.00;
    DECLARE v_rule_id_large   INT DEFAULT NULL;
    DECLARE v_rule_id_night   INT DEFAULT NULL;
    DECLARE v_rule_id_rapid   INT DEFAULT NULL;
    DECLARE v_rule_id_black   INT DEFAULT NULL;
    DECLARE v_rule_id_vpn     INT DEFAULT NULL;

    SET p_alerts_fired = 0;

    SELECT Amount, Account_ID, Location, Trans_DateTime
    INTO   v_amount, v_account_id, v_location, v_txn_time
    FROM   `TRANSACTION` WHERE Transaction_ID = p_txn_id;

    SELECT Customer_ID INTO v_customer_id
    FROM   ACCOUNT WHERE Account_ID = v_account_id;

    SET v_hour = HOUR(v_txn_time);

    SELECT Rule_ID INTO v_rule_id_large FROM FRAUD_RULE WHERE Rule_Code = 'LARGE_TXN'  AND Is_Active = 1 LIMIT 1;
    SELECT Rule_ID INTO v_rule_id_night FROM FRAUD_RULE WHERE Rule_Code = 'NIGHT_TXN'  AND Is_Active = 1 LIMIT 1;
    SELECT Rule_ID INTO v_rule_id_rapid FROM FRAUD_RULE WHERE Rule_Code = 'RAPID_TXN'  AND Is_Active = 1 LIMIT 1;
    SELECT Rule_ID INTO v_rule_id_black FROM FRAUD_RULE WHERE Rule_Code = 'BLACKLIST'   AND Is_Active = 1 LIMIT 1;
    SELECT Rule_ID INTO v_rule_id_vpn   FROM FRAUD_RULE WHERE Rule_Code = 'VPN_MASKED' AND Is_Active = 1 LIMIT 1;

    -- RULE 1: Large Transaction
    IF v_rule_id_large IS NOT NULL AND v_amount >= v_large_thresh THEN
        SET v_risk_score = LEAST(100.00, 40.00 + (v_amount / v_large_thresh) * 15.00);
        SET v_severity   = IF(v_amount >= 500000, 'Critical', IF(v_amount >= 300000, 'High', 'Medium'));
        INSERT INTO FRAUD_ALERT
            (Transaction_ID, Rule_ID, Customer_ID, Account_ID, Risk_Score, Alert_Type, Reason, Severity)
        VALUES
            (p_txn_id, v_rule_id_large, v_customer_id, v_account_id, v_risk_score,
             'Large Transaction Threshold',
             CONCAT('Transaction amount PKR ', FORMAT(v_amount, 2), ' exceeds threshold of PKR ', FORMAT(v_large_thresh, 2)),
             v_severity);
        SET p_alerts_fired = p_alerts_fired + 1;
    END IF;

    -- RULE 2: Night-Time Transaction
    IF v_rule_id_night IS NOT NULL AND (v_hour >= 23 OR v_hour < 5) AND v_amount >= v_night_thresh THEN
        SET v_risk_score = LEAST(100.00, 55.00 + (v_amount / 100000.00) * 10.00);
        INSERT INTO FRAUD_ALERT
            (Transaction_ID, Rule_ID, Customer_ID, Account_ID, Risk_Score, Alert_Type, Reason, Severity)
        VALUES
            (p_txn_id, v_rule_id_night, v_customer_id, v_account_id, v_risk_score,
             'Night-Time High-Value Transaction',
             CONCAT('Transaction of PKR ', FORMAT(v_amount, 2), ' occurred at ', TIME(v_txn_time), ' (outside business hours)'),
             IF(v_risk_score >= 80, 'Critical', 'High'));
        SET p_alerts_fired = p_alerts_fired + 1;
    END IF;

    -- RULE 3: Rapid Successive Transactions
    IF v_rule_id_rapid IS NOT NULL THEN
        SELECT COUNT(*) INTO v_rapid_count
        FROM   `TRANSACTION`
        WHERE  Account_ID = v_account_id
          AND  Trans_DateTime BETWEEN DATE_SUB(v_txn_time, INTERVAL 10 MINUTE) AND v_txn_time
          AND  Transaction_ID != p_txn_id
          AND  Status = 'Success';
        IF v_rapid_count >= 3 THEN
            INSERT INTO FRAUD_ALERT
                (Transaction_ID, Rule_ID, Customer_ID, Account_ID, Risk_Score, Alert_Type, Reason, Severity)
            VALUES
                (p_txn_id, v_rule_id_rapid, v_customer_id, v_account_id, 75.00,
                 'Rapid Successive Transactions',
                 CONCAT(v_rapid_count + 1, ' transactions from this account within 10 minutes.'),
                 'High');
            SET p_alerts_fired = p_alerts_fired + 1;
        END IF;
    END IF;

    -- RULE 4: Blacklisted Customer
    IF v_rule_id_black IS NOT NULL THEN
        SELECT COUNT(*) INTO v_is_blacklisted
        FROM   BLACKLIST WHERE Customer_ID = v_customer_id AND Is_Active = 1;
        IF v_is_blacklisted > 0 THEN
            INSERT INTO FRAUD_ALERT
                (Transaction_ID, Rule_ID, Customer_ID, Account_ID, Risk_Score, Alert_Type, Reason, Severity)
            VALUES
                (p_txn_id, v_rule_id_black, v_customer_id, v_account_id, 95.00,
                 'Blacklisted Customer Activity',
                 'Transaction initiated by a blacklisted customer.',
                 'Critical');
            SET p_alerts_fired = p_alerts_fired + 1;
        END IF;
    END IF;

    -- RULE 5: VPN / Suspicious Location
    IF v_rule_id_vpn IS NOT NULL AND v_location IS NOT NULL
       AND (v_location LIKE '%VPN%' OR v_location LIKE '%Unknown%' OR v_location LIKE '%Suspicious%') THEN
        INSERT INTO FRAUD_ALERT
            (Transaction_ID, Rule_ID, Customer_ID, Account_ID, Risk_Score, Alert_Type, Reason, Severity)
        VALUES
            (p_txn_id, v_rule_id_vpn, v_customer_id, v_account_id, 70.00,
             'Suspicious / VPN Location',
             CONCAT('Transaction location flagged as suspicious: ', v_location),
             'High');
        SET p_alerts_fired = p_alerts_fired + 1;
    END IF;

    -- Update customer risk level
    SELECT COUNT(*) INTO v_open_alerts
    FROM FRAUD_ALERT
    WHERE Customer_ID = v_customer_id
      AND Alert_Status NOT IN ('Resolved','False Positive');

    IF v_open_alerts >= 5 THEN
        UPDATE CUSTOMER SET Risk_Level = 'Critical' WHERE Customer_ID = v_customer_id;
    ELSEIF v_open_alerts >= 3 THEN
        UPDATE CUSTOMER SET Risk_Level = 'High'     WHERE Customer_ID = v_customer_id;
    ELSEIF v_open_alerts >= 1 THEN
        UPDATE CUSTOMER SET Risk_Level = 'Medium'   WHERE Customer_ID = v_customer_id;
    END IF;

END$$
DELIMITER ;

-- ============================================================
-- DROP VIEWS IF THEY EXIST (safe re-import)
-- ============================================================
DROP VIEW IF EXISTS vw_customer_accounts;
DROP VIEW IF EXISTS vw_transactions_full;
DROP VIEW IF EXISTS vw_fraud_alerts_full;
DROP VIEW IF EXISTS vw_dashboard_summary;

-- ============================================================
-- VIEW 1: Customer account overview
-- ============================================================
CREATE VIEW vw_customer_accounts AS
SELECT
    c.Customer_ID,
    c.Full_Name,
    c.CNIC,
    c.Phone,
    c.Email,
    c.Risk_Level,
    a.Account_ID,
    a.Account_No,
    a.Account_Type,
    a.Balance,
    a.Status     AS Account_Status,
    b.Branch_Name,
    b.City
FROM CUSTOMER c
JOIN ACCOUNT  a ON c.Customer_ID = a.Customer_ID
JOIN BRANCH   b ON a.Branch_ID   = b.Branch_ID;

-- ============================================================
-- VIEW 2: Transaction with customer info
-- ============================================================
CREATE VIEW vw_transactions_full AS
SELECT
    t.Transaction_ID,
    t.Reference_No,
    c.Full_Name  AS Customer_Name,
    c.CNIC,
    a.Account_No,
    a.Account_Type,
    b.Branch_Name,
    t.Amount,
    t.Trans_Type,
    t.Channel,
    t.Location,
    t.Trans_DateTime,
    t.Balance_Before,
    t.Balance_After,
    t.Status     AS Txn_Status
FROM `TRANSACTION` t
JOIN ACCOUNT       a ON t.Account_ID  = a.Account_ID
JOIN CUSTOMER      c ON a.Customer_ID = c.Customer_ID
JOIN BRANCH        b ON a.Branch_ID   = b.Branch_ID;

-- ============================================================
-- VIEW 3: Fraud alerts with full context
-- ============================================================
CREATE VIEW vw_fraud_alerts_full AS
SELECT
    fa.Alert_ID,
    fa.Alert_DateTime,
    fa.Alert_Type,
    fa.Reason,
    fa.Severity,
    fa.Alert_Status,
    fa.Risk_Score,
    c.Full_Name       AS Customer_Name,
    c.CNIC,
    a.Account_No,
    t.Amount,
    t.Trans_Type,
    t.Channel,
    t.Location,
    t.Trans_DateTime,
    fr.Rule_Name,
    i.Full_Name       AS Assigned_Investigator
FROM FRAUD_ALERT       fa
JOIN `TRANSACTION`     t  ON fa.Transaction_ID = t.Transaction_ID
JOIN CUSTOMER          c  ON fa.Customer_ID    = c.Customer_ID
JOIN ACCOUNT           a  ON fa.Account_ID     = a.Account_ID
JOIN FRAUD_RULE        fr ON fa.Rule_ID        = fr.Rule_ID
LEFT JOIN INVESTIGATOR i  ON fa.Assigned_To    = i.Investigator_ID;

-- ============================================================
-- VIEW 4: Dashboard summary
-- ============================================================
CREATE VIEW vw_dashboard_summary AS
SELECT
    (SELECT COUNT(*)          FROM CUSTOMER       WHERE Is_Active = 1)                           AS Total_Customers,
    (SELECT COUNT(*)          FROM ACCOUNT        WHERE Status = 'Active')                       AS Active_Accounts,
    (SELECT COUNT(*)          FROM `TRANSACTION`  WHERE DATE(Trans_DateTime) = CURDATE())        AS Today_Transactions,
    (SELECT COALESCE(SUM(Amount), 0) FROM `TRANSACTION`
     WHERE DATE(Trans_DateTime) = CURDATE() AND Status = 'Success')                              AS Today_Volume,
    (SELECT COUNT(*)          FROM FRAUD_ALERT    WHERE Alert_Status = 'Open')                   AS Open_Alerts,
    (SELECT COUNT(*)          FROM FRAUD_ALERT    WHERE Alert_Status = 'Under Review')           AS Under_Review_Alerts,
    (SELECT COUNT(*)          FROM INVESTIGATION_CASE WHERE Case_Status NOT LIKE 'Closed%')      AS Open_Cases,
    (SELECT COUNT(*)          FROM BLACKLIST       WHERE Is_Active = 1)                          AS Blacklisted_Customers,
    (SELECT COUNT(*)          FROM CUSTOMER        WHERE Risk_Level IN ('High','Critical'))      AS High_Risk_Customers;

SET FOREIGN_KEY_CHECKS = 1;
