# Relational Database Schema

## BRANCH
- Branch_ID (PK)
- Branch_Name
- City
- Location
- Phone
- Manager_Name

Relationship:
- One Branch can have many Customers
- One Branch can have many Accounts

## CUSTOMER
- Customer_ID (PK)
- Branch_ID (FK → BRANCH.Branch_ID)
- Full_Name
- CNIC
- Email
- Phone
- Address
- Date_Registered

Relationship:
- One Customer can own many Accounts
- One Customer can be Blacklisted

## ACCOUNT
- Account_ID (PK)
- Customer_ID (FK → CUSTOMER.Customer_ID)
- Branch_ID (FK → BRANCH.Branch_ID)
- Account_No
- Account_Type
- Balance
- Status

Relationship:
- One Account can have many Transactions

## TRANSACTION
- Transaction_ID (PK)
- Account_ID (FK → ACCOUNT.Account_ID)
- Amount
- Transaction_Type
- Channel
- Transaction_Date

Relationship:
- One Transaction may generate one Fraud Alert

## FRAUD_ALERT
- Alert_ID (PK)
- Transaction_ID (FK → TRANSACTION.Transaction_ID)
- Fraud_Rule_ID (FK → FRAUD_RULE.Fraud_Rule_ID)
- Alert_Type
- Priority
- Status

Relationship:
- One Fraud Alert may create one Investigation Case

## INVESTIGATOR
- Investigator_ID (PK)
- Full_Name
- Email
- Phone
- Status

Relationship:
- One Investigator handles many Investigation Cases

## INVESTIGATION_CASE
- Case_ID (PK)
- Alert_ID (FK → FRAUD_ALERT.Alert_ID)
- Investigator_ID (FK → INVESTIGATOR.Investigator_ID)
- Case_Status
- Date_Opened
- Date_Closed

## BLACKLIST
- Blacklist_ID (PK)
- Customer_ID (FK → CUSTOMER.Customer_ID)
- Reason
- Date_Added

## AUDIT_LOG
- Log_ID (PK)
- User_ID (FK → USERS.User_ID)
- Action
- Module
- Log_Date

## USERS
- User_ID (PK)
- Username
- Password_Hash
- Role
