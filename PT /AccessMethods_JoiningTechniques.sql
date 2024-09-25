sqlplus soe/soe

===============
Access Methods:
===============

1) FULL TABLE SCAN:
===================

set linesize 180
set autot trace exp
SELECT * FROM WAREHOUSES;

2) TABLE ACCESS BY ROWID:
=========================
SELECT * FROM WAREHOUSES WHERE WAREHOUSE_ID=10;



3) INDEX UNIQUE SCAN:
=====================
set autotrace off;
col index_name for a20
col table_name for a20
SELECT INDEX_NAME,TABLE_NAME,UNIQUENESS FROM USER_INDEXES WHERE TABLE_NAME='WAREHOUSES';

set autot trace exp
SELECT * FROM WAREHOUSES WHERE WAREHOUSE_ID=10;

4) INDEX RANGE SCAN:
====================
SELECT * FROM WAREHOUSES WHERE WAREHOUSE_ID<180;
SELECT * FROM WAREHOUSES WHERE LOCATION_ID=7244; 

INDEX RANGE SCAN DESCENDING:
============================
SELECT * FROM WAREHOUSES WHERE WAREHOUSE_ID<180 ORDER BY WAREHOUSE_ID DESC;

Optimizer avoids sorting data after select .
Instead it scans the index in desc order.

5) INDEX FULL SCAN:
===================
SELECT DEPT_NO, DNAME FROM DEPT ORDER BY DEPT_NO;

6) INDEX FAST FULL SCAN:
========================
SELECT WAREHOUSE_ID FROM WAREHOUSES WHERE WAREHOUSE_ID>180;

select count(warehouse_id) from WAREHOUSES;

7) INDEX SKIP SCAN :
====================
CREATE TABLE PRODUCT ( ID NUMBER PRIMARY KEY,NAME VARCHAR2(20) NOT NULL, COST NUMBER NOT NULL);

INSERT INTO PRODUCT SELECT ROWNUM,'PENCIL',CEIL(DBMS_RANDOM.VALUE(0,10000)) FROM DUAL CONNECT BY LEVEL < 100;
COMMIT;  

CREATE INDEX PRODUCT_CI ON PRODUCT(ID,NAME);

EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>NULL, TABNAME=>'PRODUCT', METHOD_OPT=>'FOR ALL COLUMNS SIZE 1');

SELECT ID,NAME FROM PRODUCT WHERE NAME='PENCIL';

==========
JOINS:
==========

1) NESTED LOOP:
===============
set autot trace exp
SELECT ENAME, DNAME
FROM DEPT, EMP
WHERE DEPT.DEPT_NO = EMP.DEPT_NO
AND DEPT.DEPT_NO=10;

2) SORT MERGE JOIN:
===================
SELECT ENAME , DNAME
FROM DEPT, EMP
WHERE DEPT.DEPT_NO = EMP.DEPT_NO;

3) HASH JOIN:
=============
SELECT O.ORDER_ID, O.ORDER_DATE, C.CUST_LAST_NAME
FROM ORDERS O, CUSTOMERS C
WHERE O.CUSTOMER_ID = C.CUSTOMER_ID;
