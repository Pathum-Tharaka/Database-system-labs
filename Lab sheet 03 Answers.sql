Lab sheet 03 Answers

1.
CREATE TYPE exch_trd_arr AS
VARRAY(4) OF VARCHAR(12);


CREATE TYPE address_type AS OBJECT(
   street_no CHAR(5),
   name CHAR(12),
   suburd CHAR(12),
   state CHAR(12),
   pin CHAR(6)
)
/

2.
CREATE TYPE stocks_type AS OBJECT(
   company CHAR(15),
   cr_price NUMBER(6,2),
   exchange exch_trd_arr,
   last_dividend NUMBER(4,2),
   erp NUMBER(5,2)
);
/
CREATE TYPE investments_type AS OBJECT(
    company stocks_type,
    p_price NUMBER(5,2),
    p_date DATE,
    qty NUMBER(5)
);
/
CREATE TYPE investments_nestedtbl_type AS TABLE OF investments_type;
/
CREATE TYPE clients_type AS OBJECT(
    clname VARCHAR2(12),
    address address_type,
    investments  investments_nestedtbl_type
); 

CREATE TABLE stocks of stocks_type(
CONSTRAINT stocks_pk PRIMARY KEY(company)
);

CREATE TABLE clients of clients_type(
CONSTRAINT clients_pk PRIMARY KEY(clname) 
)
NESTED TABLE investments STORE AS investments_tbl; 

ALTER TABLE investments_tbl
ADD SCOPE FOR(company) IS stocks; 


INSERT INTO stocks VALUES(stocks_type('BHP','10.50',exch_trd_arr('Sydney','NewYork'),'1.50','3.20'));
INSERT INTO stocks VALUES(stocks_type('IBM',70.00,exch_trd_arr('NewYork','London','Tokyo'),4.25,10.00));
INSERT INTO stocks VALUES(stocks_type('INTEL',76.50,exch_trd_arr('NewYork','London'),5.00,12.40));
INSERT INTO stocks VALUES(stocks_type('FORD',40.00,exch_trd_arr('New York'),2.00,8.50));
INSERT INTO stocks VALUES(stocks_type('GM',60.00,exch_trd_arr('New York'),2.50,9.20));
INSERT INTO stocks VALUES(stocks_type('INFOSYS',45.00,exch_trd_arr('Ne w York'),3.00,7.80));




INSERT INTO clients VALUES (clients_type(
    'John Smith',
    address_type('3', 'East Av', 'Bentley', 'WA', '6102'),
    investments_nestedtbl_type(
        investments_type((SELECT REF(s) FROM stocks s WHERE s.company = 'BHP'), 12.00, '02-OCT-01', 1000),
        investments_type((SELECT REF(s) FROM stocks s WHERE s.company = 'BHP'), 10.50, '08-JUN-02', 2000),
        investments_type((SELECT REF(s) FROM stocks s WHERE s.company = 'IBM'), 58.00, '12-FEB-00', 500),
        investments_type((SELECT REF(s) FROM stocks s WHERE s.company = 'IBM'), 65.00, '10-APR-01', 1200),
        investments_type((SELECT REF(s) FROM stocks s WHERE s.company = 'INFOSYS'), 64.00, '11-AUG-01', 1000)
    )
));
/

INSERT INTO clients VALUES (clients_type(
    'John Smith',
    address_type('3', 'East Av', 'Bentley', 'WA', '6102'),
    investments_nestedtbl_type(
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'BHP'), 12.00, '02-OCT-01', 1000  ),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'BHP'),  10.50,'08-JUN-02', 2000 ),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'IBM'),  58.00, '12-FEB-00', 500 ),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'IBM'), 65.00, '10-APR-01', 1200),
        investments_type(
(SELECT VALUE(s) FROM stocks s WHERE s.company = 'INFOSYS'), 64.00,'11-AUG-01', 1000) )
));




INSERT INTO clients VALUES (clients_type(
    'Jill Brody',
    address_type('42', 'Bent St', 'Perth', 'WA', '6001'),
    investments_nestedtbl_type(
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'INTEL'), 35.00, '30-JAN-00', 300 ),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'INTEL'), 54.00, '30-JAN-01', 400),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'INTEL'), 60.00, '02-OCT-00', 200),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'FORD'), 40.00, '05-OCT-99', 300 ),
        investments_type(
            (SELECT VALUE(s) FROM stocks s WHERE s.company = 'GM'), 55.50, '12-DEC-00', 500)
    )
));



3.
(a).
SELECT c.clname,i.company.company AS stock_name,i.company.cr_price AS current_price,
       i.company.last_dividend AS last_dividend,i.company.erp AS earnings_per_share
 FROM   clients c, TABLE(c.investments) i;


(b)
SELECT c.clname,i.company.company AS stock_name,SUM(i.qty) AS total_shares,
       SUM(i.qty * i.p_price) / SUM(i.qty) AS avg_purchase_price
 FROM   clients c,
       TABLE(c.investments) i
 GROUP BY c.clname, i.company.company;


(c)
SELECT i.company.company,
       c.clname, i.qty,  i.qty * i.company.cr_price AS current_value
FROM clients c, TABLE(c.investments) i
WHERE 'New York' IN (SELECT COLUMN_VALUE FROM TABLE(CAST(i.company.exchange AS exch_trd_arr)));


(d)
SELECT c.clname,SUM(i.qty * i.p_price) AS total_purchase_value
FROM   clients c,TABLE(c.investments) i
GROUP BY c.clname;


(e)
SELECT c.clname,(SUM(i.qty * i.company.cr_price) - SUM(i.qty * i.p_price)) AS book_profit
FROM   clients c,TABLE(c.investments) i
GROUP BY c.clname;
 

4.

DELETE FROM TABLE (
    SELECT c.investments FROM clients c WHERE c.clname = 'John Smith') i
WHERE i.company = (SELECT VALUE(s) FROM stocks s WHERE s.company = 'INFOSYS');

DELETE FROM TABLE (
    SELECT c.investments FROM clients c WHERE c.clname = 'Jill Brody') i
WHERE i.company = (SELECT VALUE(s) FROM stocks s WHERE s.company = 'GM');

INSERT INTO TABLE (
    SELECT c.investments FROM clients c WHERE c.clname = 'Jill Brody')
VALUES (
    investments_type(
        (SELECT VALUE(s) FROM stocks s WHERE s.company = 'INFOSYS'),45.00, SYSDATE,1000)
);

INSERT INTO TABLE (
    SELECT c.investments FROM clients c WHERE c.clname = 'John Smith')
VALUES (
    investments_type((SELECT VALUE(s) FROM stocks s WHERE s.company = 'GM'),60.00, SYSDATE, 500 )
);
