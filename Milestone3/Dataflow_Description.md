Milestone 3 — Dataflow Description
Bank Fraud Detection System (BFDS)

Group Members: Roshaan Rehman & Sarah Arif

Introduction

The Bank Fraud Detection System (BFDS) is designed to monitor banking transactions, detect suspicious activities, manage fraud investigations, maintain audit records, and generate reports. The system follows a structured flow from customer registration to fraud detection and investigation.

Step 1 — User Authentication

Before accessing the system, authorized users log in using their credentials.

User information is stored in the USERS table.
Users are assigned roles such as Admin or Investigator.
Access to system functions is controlled according to user roles.

Tables Involved:

USERS
Step 2 — Customer Onboarding

A customer visits a bank branch and registers for banking services.

Customer details are stored in the CUSTOMER table.
The customer is associated with a specific BRANCH.
Customer information includes CNIC, phone number, email, address, and risk level.

Tables Involved:

BRANCH
CUSTOMER
Step 3 — Account Management

After registration, one or more bank accounts are created for the customer.

Each account is linked to a customer.
Each account belongs to a specific branch.
Account information includes account type, balance, status, and opening date.

Tables Involved:

ACCOUNT
CUSTOMER
BRANCH
Step 4 — Transaction Processing

Customers perform banking activities through their accounts.

Examples:

ATM Withdrawals
Online Transfers
Branch Deposits
Fund Transfers

Each activity creates a new transaction record.

Tables Involved:

TRANSACTION
ACCOUNT
Step 5 — Fraud Detection

The system continuously monitors transactions.

Fraud alerts may be generated when suspicious behavior is detected, such as:

Large transaction amounts
Rapid multiple transactions
Unusual locations
High-risk customer activity

When suspicious activity is found:

A record is created in the FRAUD_ALERT table.
The alert is assigned a severity level.
The alert status is tracked.

Tables Involved:

TRANSACTION
FRAUD_ALERT
Step 6 — Investigator Assignment

Suspicious alerts are assigned to investigators for review.

Investigators:

Review alert details
Examine transaction history
Analyze customer behavior

Investigator information is maintained separately.

Tables Involved:

INVESTIGATOR
FRAUD_ALERT
Step 7 — Investigation Management

For every significant fraud alert, an investigation case is opened.

The investigator can:

Change case status
Add remarks
Escalate cases
Close investigations

Case progress is tracked throughout the investigation lifecycle.

Tables Involved:

INVESTIGATION_CASE
FRAUD_ALERT
INVESTIGATOR
Step 8 — Case Notes

Investigators can record detailed observations during investigations.

Notes may include:

Evidence collected
Investigation findings
Recommendations
Follow-up actions

Multiple notes can be associated with a single case.

Tables Involved:

CASE_NOTE
INVESTIGATION_CASE
INVESTIGATOR
Step 9 — Blacklisting

If fraud is confirmed:

The customer is added to the blacklist.
The reason for blacklisting is recorded.
Future monitoring can be performed more effectively.

A customer can only appear once in the blacklist.

Tables Involved:

BLACKLIST
CUSTOMER
Step 10 — Audit Logging

All important system activities are recorded.

Examples:

User Login
Customer Creation
Account Updates
Fraud Alert Updates
Case Management Actions
Blacklist Operations

This ensures accountability and system security.

Tables Involved:

AUDIT_LOG
USERS
Step 11 — Reporting

The system generates analytical reports for management and investigators.

Reports include:

Fraud Alert Summary
Investigation Statistics
Blacklisted Customers
Transaction Monitoring Reports

Reports help decision-makers monitor fraud trends and system performance.

Data Flow Summary
USERS → AUDIT_LOG

BRANCH → CUSTOMER → ACCOUNT → TRANSACTION

TRANSACTION → FRAUD_ALERT → INVESTIGATION_CASE

INVESTIGATOR → FRAUD_ALERT
INVESTIGATOR → INVESTIGATION_CASE

INVESTIGATION_CASE → CASE_NOTE

CUSTOMER → BLACKLIST

FRAUD_ALERT → REPORTS
INVESTIGATION_CASE → REPORTS
Data Generation

Method: Structured Synthetic Data

Tools Used:

Python Faker Library
SQL Scripts
Custom Data Generation Logic

Reason:
Real banking information cannot be used due to privacy and security concerns. Therefore, synthetic data was generated to simulate realistic banking and fraud detection scenarios.