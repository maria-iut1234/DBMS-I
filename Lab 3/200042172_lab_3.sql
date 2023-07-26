CREATE TABLE ACCOUNT(
  ACCOUNT_NO CHAR(5),
  BALANCE NUMBER NOT NULL,
  CONSTRAINT PK_ACCOUNT_NUM PRIMARY KEY(ACCOUNT_NO)
 );

CREATE TABLE CUSTOMER(
    CUSTOMER_NO CHAR(5),
    CUSTOMER_NAME VARCHAR(20) NOT NULL,
    CUSTOMER_CITY VARCHAR(10),
    CONSTRAINT PK_CUSTOMER_NO PRIMARY KEY(CUSTOMER_NO)
);

CREATE TABLE DEPOSITOR(
    ACCOUNT_NO CHAR(5),
    CUSTOMER_NO CHAR(5),
    CONSTRAINT PK_DEPOSITOR_NO PRIMARY KEY(ACCOUNT_NO, CUSTOMER_NO)
);

ALTER TABLE CUSTOMER ADD DATE_OF_BIRTH DATE;

ALTER TABLE ACCOUNT MODIFY BALANCE NUMBER(12,2);

ALTER TABLE DEPOSITOR RENAME COLUMN ACCOUNT_NO TO A_NO;

ALTER TABLE DEPOSITOR RENAME COLUMN CUSTOMER_NO TO C_NO;

ALTER TABLE DEPOSITOR RENAME TO DEPOSITOR_INFO;

ALTER TABLE DEPOSITOR_INFO ADD CONSTRAINT FK_DEPOSITOR_ACCOUNT FOREIGN KEY(A_NO) REFERENCES ACCOUNT(ACCOUNT_NO);

ALTER TABLE DEPOSITOR_INFO ADD CONSTRAINT FK_DEPOSITOR_CUSTOMER FOREIGN KEY(C_NO) REFERENCES CUSTOMER(CUSTOMER_NO);

SELECT ACCOUNT_NO
  FROM ACCOUNT
 WHERE BALANCE>100000;

 SELECT CUSTOMER_NAME
  FROM CUSTOMER
 WHERE CUSTOMER_CITY = 'DHK';
 
 SELECT CUSTOMER_NO
  FROM CUSTOMER
 WHERE CUSTOMER_NAME LIKE 'A%';

 SELECT DISTINCT A_NO
  FROM DEPOSITOR_INFO;
 
 SELECT *
  FROM ACCOUNT, DEPOSITOR_INFO;

 SELECT *
  FROM CUSTOMER
  NATURAL JOIN DEPOSITOR_INFO;

 SELECT CUSTOMER.CUSTOMER_NAME, CUSTOMER.CUSTOMER_CITY, CUSTOMER.DATE_OF_BIRTH
  FROM CUSTOMER, DEPOSITOR_INFO
  WHERE CUSTOMER.CUSTOMER_NO = DEPOSITOR_INFO.C_NO;

 SELECT CUSTOMER.CUSTOMER_NO, CUSTOMER.CUSTOMER_NAME, CUSTOMER.CUSTOMER_CITY
  FROM CUSTOMER, DEPOSITOR_INFO, ACCOUNT
  WHERE CUSTOMER.CUSTOMER_NO = DEPOSITOR_INFO.C_NO AND ACCOUNT.BALANCE>1000 AND ACCOUNT.ACCOUNT_NO = DEPOSITOR_INFO.A_NO;

 
 SELECT ACCOUNT.ACCOUNT_NO, ACCOUNT.BALANCE
  FROM CUSTOMER, DEPOSITOR_INFO, ACCOUNT
  WHERE CUSTOMER.CUSTOMER_NO = DEPOSITOR_INFO.C_NO AND ACCOUNT.BALANCE<100000 AND ACCOUNT.BALANCE>5000 AND ACCOUNT.ACCOUNT_NO = DEPOSITOR_INFO.A_NO AND CUSTOMER.CUSTOMER_CITY = 'KHL';

 



