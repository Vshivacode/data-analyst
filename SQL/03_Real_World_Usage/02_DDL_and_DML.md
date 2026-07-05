### Topic: CREATE TABLE
**Companies:** Every company building any new feature/product (Flipkart adding 
a new "wishlist" feature needs a `wishlist_items` table)
**Who uses it:** Data Engineers primarily; Data Analysts occasionally for 
staging/scratch tables
**Real Query:** Creating a new table to track customer support tickets
```sql
CREATE TABLE support_tickets
(
    ticket_id INT NOT NULL IDENTITY(1,1),
    customer_id INT NOT NULL,
    issue_description VARCHAR(500),
    created_date DATETIME DEFAULT GETDATE(),
    CONSTRAINT pk_tickets PRIMARY KEY (ticket_id)
);
```
**Business Impact:** Enables a new capability (tracking support issues) that 
didn't exist before — foundational to any new feature/reporting need.

---

### Topic: ALTER TABLE
**Companies:** Swiggy, Zomato — evolving schemas as business needs change 
(e.g., adding a "delivery_instructions" field to orders)
**Who uses it:** Data Engineers (schema evolution), sometimes Data Analysts 
in analytics sandboxes
**Real Query:**
```sql
ALTER TABLE orders ADD delivery_instructions VARCHAR(255);
```
**Business Impact:** Adds new capability to existing systems without 
disrupting existing data/operations — critical for iterative product development.
**Performance Consideration:** On tables with 100M+ rows, ALTER TABLE ADD 
COLUMN can be near-instant (metadata-only in modern DBs) or slow (full table 
rewrite) depending on the DBMS and whether a DEFAULT is specified for existing rows.

---

### Topic: INSERT
**Companies:** Every transactional system (Amazon inserting a new order, 
Razorpay inserting a new payment record)
**Who uses it:** Backend Developers (application-level), Data Engineers (ETL 
loading), occasionally Analysts (loading reference/lookup data)
**Real Query:**
```sql
INSERT INTO orders(customer_id, product_id, order_amount, order_date)
VALUES (1023, 4587, 2999.00, GETDATE());
```
**Business Impact:** This is literally how every transaction in a business 
gets recorded — the backbone of all downstream reporting/analytics.

---

### Topic: UPDATE
**Companies:** Banking (updating account balances), E-commerce (updating 
order status from 'pending' to 'shipped')
**Who uses it:** Backend systems automatically; Analysts occasionally for 
data correction/cleanup tasks
**Real Query:**
```sql
UPDATE orders SET status = 'shipped' WHERE order_id = 84213;
```
**Business Impact:** Reflects real-world state changes (an order actually 
shipped) into the system of record — critical for accurate customer 
communication and reporting.
**Data Engineer Example:** UPSERT logic (INSERT if new, UPDATE if exists) is 
core to incremental ETL pipelines feeding data warehouses.

---

### Topic: DELETE vs TRUNCATE vs DROP
**Companies:** Any company managing data retention/GDPR compliance
**Who uses it:** Data Engineers (pipeline cleanup), Compliance/Legal-driven 
data deletion requests (e.g., "right to be forgotten" under GDPR)
**Real Query:**
```sql
DELETE FROM customers WHERE customer_id = 5521;  -- GDPR deletion request for one customer
TRUNCATE TABLE staging_daily_load;                -- reset before next ETL run
```
**Business Impact:** DELETE handles precise, compliant data removal 
(legal requirement). TRUNCATE is used purely for pipeline hygiene 
(clearing staging areas), never for customer-facing data removal requests.

---

### Topic: IS NULL / Data Cleanup
**Companies:** Any company with imperfect data entry (most companies)
**Who uses it:** Data Analyst, Data Quality/Governance teams
**Real Query:**
```sql
UPDATE customer_profiles SET country = 'Unknown' WHERE country IS NULL;
```
**Business Impact:** Cleaning up missing values before reports/dashboards go 
to leadership — prevents "blank" categories from confusing business stakeholders.

---

### Topic: IDENTITY / Auto-increment Primary Keys
**Companies:** Virtually every company's transactional systems
**Who uses it:** Data Engineers, Backend Developers designing schemas
**Real Scenario:** Every new customer signup, every new order, every new 
support ticket gets an auto-generated unique ID via IDENTITY — no manual 
ID assignment needed, guaranteed uniqueness even under massive concurrent load.
**Business Impact:** Enables safe, concurrent, high-volume transaction processing 
(millions of orders per day) without ID collision issues.