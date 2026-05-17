# Milestone 2 — Normalization (1NF → 3NF)
## Bank Fraud Management System
**Group Members:**  Roshaan Rehman & Sarah Arif  
**Version:** V1.1  

---

## What is Normalization?a

Normalization is the process of organizing a database to reduce data redundancy and improve data integrity. We apply three normal forms:

- **1NF** — All values are atomic, no repeating groups, each row is unique
- **2NF** — No partial dependencies (every non-key column depends on the full primary key)
- **3NF** — No transitive dependencies (non-key columns do not depend on other non-key columns)

---

## Table 1: BRANCH

| Column | Type | Constraint |
|--------|------|------------|
| Branch_ID | INT | PK, AUTO_INCREMENT |
| Branch_Name | VARCHAR(100) | NOT NULL |
| Location | VARCHAR(150) | — |
| City | VARCHAR(100) | — |
| Phone | VARCHAR(20) | — |

### 1NF ✅
- Every attribute holds a single atomic value (no lists or arrays)
- Branch_ID uniquely identifies each row
- No repeating groups exist

### 2NF ✅
- Primary key is a single column (Branch_ID) — partial dependency is not possible
- All attributes (Branch_Name, Location, City, Phone) fully depend on Branch_ID

### 3NF ✅
- No transitive dependencies exist
- City does not determine Location; they are independent attributes of the branch
- All non-key attributes depend directly and only on Branch_ID

**Justification:** BRANCH is in 3NF. No restructuring needed.

---

## Table 2: CUSTOMER

| Column | Type | Constraint |
|--------|------|------------|
| Customer_ID | INT | PK, AUTO_INCREMENT |
| Name | VARCHAR(100) | NOT NULL |
| CNIC | VARCHAR(15) | NOT NULL, UNIQUE |
| Phone | VARCHAR(20) | — |
| Email | VARCHAR(100) | UNIQUE |
| Address | VARCHAR(255) | — |
| Date_Joined | DATE | NOT NULL |

### 1NF ✅
- All values are atomic — Name is stored as one full name field, not split into first/last (acceptable for this system)
- Customer_ID uniquely identifies each customer
- CNIC is unique per customer — no duplicate rows possible

### 2NF ✅
- Single-column PK (Customer_ID) — partial dependency cannot occur
- All attributes describe properties of one specific customer

### 3NF ✅
- CNIC is a candidate key but does not cause transitive dependency — it identifies the same entity
- No non-key attribute determines another non-key attribute
- Address, Phone, Email all depend solely on Customer_ID

**Justification:** CUSTOMER is in 3NF. CNIC is treated as a unique identifier (alternate key), not a source of transitive dependency.

---

## Table 3: ACCOUNT

| Column | Type | Constraint |
|--------|------|------------|
| Account_ID | INT | PK, AUTO_INCREMENT |
| Customer_ID | INT | FK → CUSTOMER |
| Branch_ID | INT | FK → BRANCH |
| Account_Type | VARCHAR(50) | NOT NULL |
| Balance | DECIMAL(15,2) | NOT NULL |
| Status | VARCHAR(20) | NOT NULL |
| Date_Opened | DATE | NOT NULL |

### 1NF ✅
- All attributes are atomic
- Account_ID uniquely identifies every account
- A customer can have multiple accounts — each stored as a separate row (no repeating groups)

### 2NF ✅
- Single-column PK (Account_ID) — no partial dependency possible
- Customer_ID and Branch_ID are foreign keys, not part of a composite PK

### 3NF ✅
- Balance depends on Account_ID, not on Account_Type
- Status depends on Account_ID, not on Customer_ID
- No non-key column determines another non-key column
- Customer and Branch details are stored in their own tables — no duplication here

**Justification:** ACCOUNT is in 3NF. FKs correctly reference CUSTOMER and BRANCH without embedding their data.

---

## Table 4: TRANSACTION

| Column | Type | Constraint |
|--------|------|------------|
| Transaction_ID | INT | PK, AUTO_INCREMENT |
| Account_ID | INT | FK → ACCOUNT |
| Amount | DECIMAL(15,2) | NOT NULL |
| Transaction_Date | DATE | NOT NULL |
| Transaction_Time | TIME | NOT NULL |
| Location | VARCHAR(150) | — |
| Type | VARCHAR(50) | NOT NULL |
| Channel | VARCHAR(50) | — |
| Description | VARCHAR(255) | — |

### 1NF ✅
- All values are atomic
- Date and Time are stored in separate columns for precise querying
- Transaction_ID uniquely identifies every transaction

### 2NF ✅
- Single-column PK — partial dependency is not applicable
- All attributes describe a specific transaction event

### 3NF ✅
- Location in this table refers to where the transaction happened — not the customer's address (no transitive link)
- Amount, Type, Channel all depend directly on Transaction_ID
- No non-key attribute determines another

**Justification:** TRANSACTION is in 3NF. Date and Time are kept separate intentionally for fraud detection queries (e.g., detecting night-time transactions).

---

## Table 5: INVESTIGATOR

| Column | Type | Constraint |
|--------|------|------------|
| Investigator_ID | INT | PK, AUTO_INCREMENT |
| Name | VARCHAR(100) | NOT NULL |
| Email | VARCHAR(100) | UNIQUE |
| Phone | VARCHAR(20) | — |
| Designation | VARCHAR(100) | — |
| Date_Joined | DATE | — |
| Status | VARCHAR(20) | NOT NULL |

### 1NF ✅
- All attributes are atomic
- Investigator_ID uniquely identifies each investigator
- No repeating groups or multi-valued fields

### 2NF ✅
- Single-column PK (Investigator_ID)
- All attributes are fully dependent on Investigator_ID

### 3NF ✅
- Designation does not determine Status or any other column
- Email is a unique identifier (alternate key) but does not create transitive dependency
- All non-key columns depend solely on Investigator_ID

**Justification:** INVESTIGATOR is in 3NF. No restructuring required.

---

## Table 6: FRAUD_ALERT

| Column | Type | Constraint |
|--------|------|------------|
| Alert_ID | INT | PK, AUTO_INCREMENT |
| Transaction_ID | INT | FK → TRANSACTION |
| Alert_Type | VARCHAR(100) | NOT NULL |
| Priority | VARCHAR(20) | NOT NULL |
| Alert_Time | DATETIME | NOT NULL |
| Status | VARCHAR(30) | NOT NULL |
| Assigned_Investigator_ID | INT | FK → INVESTIGATOR |

### 1NF ✅
- All values are atomic
- Alert_ID uniquely identifies each fraud alert
- One alert per transaction — no repeating groups

### 2NF ✅
- Single-column PK (Alert_ID)
- All attributes describe properties of a specific alert

### 3NF ✅
- Priority does not determine Status — they are independently set
- Alert_Type does not determine Priority — each alert can have different combinations
- Investigator details are not stored here — only the FK reference
- No transitive dependencies exist

**Justification:** FRAUD_ALERT is in 3NF. Priority and Alert_Type are independent attributes of the same alert, not dependent on each other.

---

## Table 7: INVESTIGATION_CASE

| Column | Type | Constraint |
|--------|------|------------|
| Case_ID | INT | PK, AUTO_INCREMENT |
| Alert_ID | INT | FK → FRAUD_ALERT, UNIQUE |
| Investigator_ID | INT | FK → INVESTIGATOR |
| Status | VARCHAR(30) | NOT NULL |
| Remarks | TEXT | — |
| Case_Opened_Date | DATE | NOT NULL |
| Case_Closed_Date | DATE | — |

### 1NF ✅
- All values are atomic
- Case_ID uniquely identifies each case
- Remarks is a single text field — not a repeating group
- Case_Closed_Date is nullable (NULL when case is still open) — this is valid in 1NF

### 2NF ✅
- Single-column PK (Case_ID)
- All attributes depend fully on Case_ID

### 3NF ✅
- Alert_ID is UNIQUE (one-to-one with FRAUD_ALERT) but does not cause transitive dependency
- Case_Closed_Date does not depend on Status — it is set explicitly when the case closes
- Investigator details are referenced via FK, not stored directly
- No non-key attribute determines another non-key attribute

**Justification:** INVESTIGATION_CASE is in 3NF. The one-to-one relationship with FRAUD_ALERT is enforced via UNIQUE constraint on Alert_ID.

---

## Table 8: BLACKLIST

| Column | Type | Constraint |
|--------|------|------------|
| Blacklist_ID | INT | PK, AUTO_INCREMENT |
| Customer_ID | INT | FK → CUSTOMER, UNIQUE |
| Reason | VARCHAR(255) | NOT NULL |
| Date_Added | DATE | NOT NULL |
| Added_By | VARCHAR(100) | — |

### 1NF ✅
- All values are atomic
- Blacklist_ID uniquely identifies each record
- UNIQUE on Customer_ID ensures one customer cannot appear twice

### 2NF ✅
- Single-column PK (Blacklist_ID)
- All attributes describe a specific blacklist record

### 3NF ✅
- Reason does not determine Date_Added or Added_By
- Added_By (officer name) does not depend on Reason
- Customer details are not stored here — only FK reference to CUSTOMER table
- No transitive dependencies

**Justification:** BLACKLIST is in 3NF. UNIQUE on Customer_ID enforces business rule that one customer can only be blacklisted once.

---

## Summary Table

| Table | 1NF | 2NF | 3NF | Action Taken |
|-------|-----|-----|-----|--------------|
| BRANCH | ✅ | ✅ | ✅ | No changes needed |
| CUSTOMER | ✅ | ✅ | ✅ | No changes needed |
| ACCOUNT | ✅ | ✅ | ✅ | No changes needed |
| TRANSACTION | ✅ | ✅ | ✅ | No changes needed |
| INVESTIGATOR | ✅ | ✅ | ✅ | No changes needed |
| FRAUD_ALERT | ✅ | ✅ | ✅ | No changes needed |
| INVESTIGATION_CASE | ✅ | ✅ | ✅ | No changes needed |
| BLACKLIST | ✅ | ✅ | ✅ | No changes needed |

**Conclusion:** All 8 tables in the Bank Fraud Management System are already in Third Normal Form (3NF). The schema was designed with normalization principles in mind from the start — each table represents a single entity, foreign keys are used instead of duplicating data, and no transitive or partial dependencies exist.
