# Validation Queries Results

  
## Query 1 – Row Counts

| Table              | Rows |
| ------------------ | ---: |
| BRANCH             |   10 |
| CUSTOMER           |   15 |
| ACCOUNT            |   15 |
| TRANSACTION        |  100 |
| FRAUD_ALERT        |    8 |
| INVESTIGATOR       |   15 |
| INVESTIGATION_CASE |    8 |
| BLACKLIST          |    3 |
| USERS              |    6 |
| AUDIT_LOG          |   10 |
| CASE_NOTE          |   10 |

Result: All tables successfully populated.

---

## Query 2 – NULL Check

Table Checked: CUSTOMER

Result:

```sql
0 rows returned
```

Result: No NULL values found in mandatory customer fields.

---

## Query 3 – FK Validation (ACCOUNT → CUSTOMER)

Result:

```sql
0 rows returned
```

Result: All accounts reference valid customers.

---

## Query 4 – FK Validation (TRANSACTION → ACCOUNT)

Result:

```sql
0 rows returned
```

Result: All transactions reference valid accounts.

---

## Query 5 – FK Validation (FRAUD_ALERT → TRANSACTION)

Result:

```sql
0 rows returned
```

Result: All fraud alerts reference valid transactions.

---

## Query 6 – Duplicate CNIC Check

Result:

```sql
0 rows returned
```

Result: No duplicate CNIC records found.

---

## Query 7 – Open Investigation Cases

Result:

Open cases were successfully returned with assigned investigators.

Result: Investigation workflow is functioning correctly.

---

## Query 8 – Blacklisted Customers

Result:

3 customers found in blacklist.

Result: Blacklist functionality working correctly.

---

# Conclusion

All validation queries executed successfully.

* Row counts verified
* Foreign key integrity verified
* No duplicate customer CNICs found
* No NULL values in mandatory fields
* Fraud alerts, investigation cases and blacklist records validated

Database population and integrity checks passed successfully.
