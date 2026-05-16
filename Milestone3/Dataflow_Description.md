# Milestone 3 — Dataflow Description
## Bank Fraud Management System
**Group Members:** Roshaan Rehman & Sarah Arif

---

## How Data Moves Through the System

### Step 1 — Customer Onboarding
A new customer visits a bank BRANCH and registers. Their personal 
details (Name, CNIC, Phone, Email, Address) are stored in the 
CUSTOMER table. The customer is then assigned an ACCOUNT which is 
linked to both their Customer_ID and the Branch_ID.

### Step 2 — Transaction Processing
When a customer performs any banking activity (ATM withdrawal, online 
transfer, branch deposit), a new record is created in the TRANSACTION 
table. Each transaction is linked to the Account_ID of the account used.

### Step 3 — Fraud Detection
The system monitors transactions. When a transaction matches a 
suspicious pattern (large amount, unusual location, multiple rapid 
transactions), the system generates a FRAUD_ALERT linked to that 
Transaction_ID. An INVESTIGATOR is assigned automatically.

### Step 4 — Investigation
An INVESTIGATION_CASE is opened for every fraud alert (one-to-one). 
The investigator reviews the case, updates Status 
(Open → In Progress → Closed) and adds Remarks.

### Step 5 — Blacklisting
If fraud is confirmed, the customer is added to the BLACKLIST table 
with the reason and the officer who added them.

---

## Data Flow Summary
BRANCH → ACCOUNT ← CUSTOMER → BLACKLIST
ACCOUNT → TRANSACTION → FRAUD_ALERT ← INVESTIGATOR
FRAUD_ALERT → INVESTIGATION_CASE ← INVESTIGATOR

---

## Data Generation
- Tool: Python Faker Library
- Type: Structured Synthetic Data
- Reason: Real banking data cannot be used due to privacy restrictions

| Table | Rows |
|-------|------|
| BRANCH | 10 |
| CUSTOMER | 50 |
| ACCOUNT | 70 |
| TRANSACTION | 100 |
| INVESTIGATOR | 15 |
| FRAUD_ALERT | 60 |
| INVESTIGATION_CASE | 60 |
| BLACKLIST | 20 |
| **Total** | **385** |
