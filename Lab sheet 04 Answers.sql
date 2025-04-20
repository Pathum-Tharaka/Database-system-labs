Lab Sheet 04 Answers

1.
(a) 
ALTER TYPE stocks_type
ADD MEMBER FUNCTION yield return float
cascade
/

CREATE OR REPLACE TYPE BODY stocks_type AS
MEMBER FUNCTION yield RETURN FLOAT IS
  BEGIN
     RETURN ((SELF.last_dividend/SELF.cr_price)*100) ;
  END yield;
END;
     

SELECT s.company, s.yield()
FROM stocks s 


(b)
ALTER TYPE stocks_type 
ADD MEMBER FUNCTION priceInUSD (rate FLOAT)
RETURN FLOAT
CASCADE
/

 CREATE OR REPLACE TYPE BODY stocks_type
 AS 
 MEMBER FUNCTION yield RETURN FLOAT IS   
   BEGIN
      RETURN ((SELF.last_dividend/SELF.cr_price)*100) ;
   END yield;

 MEMBER FUNCTION priceInUSD (rate FLOAT) RETURN FLOAT IS 
  BEGIN
    RETURN (rate*SELF.cr_price);
  END priceInUSD;

 END; 

SELECT s.company, s.yield(), s.priceInUSD(100)
FROM stocks s 

 (c)
ALTER TYPE stocks_type 
ADD MEMBER FUNCTION no_of_trades 
RETURN INTEGER
CASCADE
/

 CREATE OR REPLACE TYPE BODY stocks_type
 AS 
 MEMBER FUNCTION yield RETURN FLOAT  IS   
   BEGIN
      RETURN ((SELF.last_dividend/SELF.cr_price)*100) ;
   END yield;

 MEMBER FUNCTION priceInUSD (rate FLOAT) RETURN FLOAT  IS 
  BEGIN
    RETURN (rate*SELF.cr_price);
  END priceInUSD;

 MEMBER FUNCTION no_of_trades RETURN INTEGER IS 
countt integer;
  BEGIN
    select count(e.column_value) into countt
    from table(self.exchange) e;
    RETURN countt;
  END no_of_trades;
 END;

select s.company, s.yield(), s.priceInUSD(100), s.no_of_trades()
from stocks s

(d)
ALTER TYPE investments_type 
ADD MEMBER FUNCTION purchase_value 
RETURN FLOAT 
CASCADE;
/
CREATE OR REPLACE TYPE BODY investments_type AS 
  MEMBER FUNCTION purchase_value 
  RETURN FLOAT IS
  BEGIN
    RETURN SELF.p_price * SELF.qty;
  END purchase_value;
END;
/

SELECT c.clname, 
       SUM(i.purchase_value()) AS total_purchase_value
FROM clients c, 
     TABLE(c.investments) i
GROUP BY c.clname;


(e)
ALTER TYPE investments_type 
ADD MEMBER FUNCTION profit 
RETURN FLOAT 
CASCADE;
/

CREATE OR REPLACE TYPE BODY investments_type AS 
  MEMBER FUNCTION purchase_value 
  RETURN FLOAT IS
  BEGIN
    RETURN SELF.p_price * SELF.qty;
  END purchase_value;

  MEMBER FUNCTION profit 
  RETURN FLOAT IS
  BEGIN
    RETURN (SELF.company.cr_price - SELF.p_price) * SELF.qty;
  END profit; 
END;
/ 



2.
(a)SELECT s.company, s.yield(), s.priceInUSD(0.74), s.no_of_trades()
   FROM stocks s


(b)
SELECT s.company, 
       s.cr_price AS current_price, 
       s.no_of_trades() AS number_of_exchanges
FROM stocks s
WHERE s.no_of_trades() > 1;


(c)
SELECT c.clname AS client_name, 
       i.company.company AS stock_name, 
       i.company.yield() AS stock_yield, 
       i.company.cr_price AS current_price, 
       i.company.erp AS earnings_per_share
FROM clients c, 
     TABLE(c.investments) i;


(d) 
SELECT c.clname, c.tot_purchase_val(), c.tot_profit()
FROM clients c;


(e)
SELECT c.clname AS client_name, 
       c.tot_profit() AS book_profit
FROM clients c; 

