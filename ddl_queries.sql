CREATE DATABASE IF NOT EXISTS bank_fraud_db;
USE bank_fraud_db;
-- TABLE 1: BRANCH
CREATE TABLE BRANCH (
    Branch_ID     INT PRIMARY KEY AUTO_INCREMENT,
    Branch_Name   VARCHAR(100) NOT NULL,
    City          VARCHAR(50)  NOT NULL,
    Location      VARCHAR(150) NOT NULL,
    Phone         VARCHAR(15)  NOT NULL CHECK (LENGTH(Phone) >= 10),
    Manager_Name  VARCHAR(100) NOT NULL
);

-- TABLE 2: CUSTOMER
CREATE TABLE CUSTOMER (
    Customer_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name     VARCHAR(100) NOT NULL,
    CNIC          CHAR(13)     NOT NULL UNIQUE CHECK (LENGTH(CNIC) = 13),
    Phone         VARCHAR(15)  NOT NULL,
    Email         VARCHAR(100) NOT NULL UNIQUE,
    Address       VARCHAR(200) NOT NULL,
    Date_Joined   DATE         NOT NULL
);

-- TABLE 3: ACCOUNT
CREATE TABLE ACCOUNT (
    Account_ID    INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID   INT          NOT NULL,
    Branch_ID     INT          NOT NULL,
    Account_Type  ENUM('Savings','Current','Fixed','Business') NOT NULL,
    Balance       DECIMAL(15,2) NOT NULL DEFAULT 0.00 CHECK (Balance >= 0),
    Status        ENUM('Active','Frozen','Closed') NOT NULL DEFAULT 'Active',
    Date_Opened   DATE         NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID),
    FOREIGN KEY (Branch_ID)   REFERENCES BRANCH(Branch_ID)
);

-- TABLE 4: TRANSACTION
CREATE TABLE TRANSACTION (
    Transaction_ID  INT PRIMARY KEY AUTO_INCREMENT,
    Account_ID      INT           NOT NULL,
    Amount          DECIMAL(15,2) NOT NULL CHECK (Amount > 0),
    Trans_Date      DATE          NOT NULL,
    Trans_Time      TIME          NOT NULL,
    Trans_Type      ENUM('Deposit','Withdrawal','Transfer') NOT NULL,
    Channel         ENUM('ATM','Online','Branch') NOT NULL,
    Location        VARCHAR(150),
    FOREIGN KEY (Account_ID) REFERENCES ACCOUNT(Account_ID)
);

-- TABLE 5: INVESTIGATOR
CREATE TABLE INVESTIGATOR (
    Investigator_ID  INT PRIMARY KEY AUTO_INCREMENT,
    Full_Name        VARCHAR(100) NOT NULL,
    Designation      VARCHAR(80)  NOT NULL,
    Email            VARCHAR(100) NOT NULL UNIQUE,
    Phone            VARCHAR(15)  NOT NULL,
    Date_Joined      DATE         NOT NULL,
    Status           ENUM('Active','Inactive') NOT NULL DEFAULT 'Active'
);

-- TABLE 6: FRAUD_ALERT
CREATE TABLE FRAUD_ALERT (
    Alert_ID        INT PRIMARY KEY AUTO_INCREMENT,
    Transaction_ID  INT          NOT NULL,
    Investigator_ID INT          NOT NULL,
    Alert_Type      VARCHAR(80)  NOT NULL,
    Priority        ENUM('Low','Medium','High','Critical') NOT NULL,
    Alert_Status    ENUM('Open','Under Review','Resolved','Dismissed') NOT NULL DEFAULT 'Open',
    Alert_Date      DATETIME     NOT NULL,
    FOREIGN KEY (Transaction_ID)  REFERENCES TRANSACTION(Transaction_ID),
    FOREIGN KEY (Investigator_ID) REFERENCES INVESTIGATOR(Investigator_ID)
);

-- TABLE 7: INVESTIGATION_CASE
CREATE TABLE INVESTIGATION_CASE (
    Case_ID          INT PRIMARY KEY AUTO_INCREMENT,
    Alert_ID         INT          NOT NULL UNIQUE,
    Investigator_ID  INT          NOT NULL,
    Case_Status      ENUM('Open','In Progress','Closed') NOT NULL DEFAULT 'Open',
    Date_Opened      DATE         NOT NULL,
    Case_Closed_Date DATE,
    Remarks          TEXT,
    FOREIGN KEY (Alert_ID)        REFERENCES FRAUD_ALERT(Alert_ID),
    FOREIGN KEY (Investigator_ID) REFERENCES INVESTIGATOR(Investigator_ID)
);

-- TABLE 8: BLACKLIST
CREATE TABLE BLACKLIST (
    Blacklist_ID  INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID   INT          NOT NULL UNIQUE,
    Reason        TEXT         NOT NULL,
    Date_Added    DATE         NOT NULL,
    Added_By      VARCHAR(100) NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID)
);