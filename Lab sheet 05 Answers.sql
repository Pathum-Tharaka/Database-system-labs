Lab Sheet 05 Answers

2.3. Exercise 01
DECLARE
    v_company_name VARCHAR2(15) := 'IBM';
    v_current_price NUMBER(6,2);
BEGIN
    SELECT cr_price INTO v_current_price
    FROM stocks
    WHERE TRIM(company) = v_company_name;

    DBMS_OUTPUT.PUT_LINE('Current price of ' || v_company_name || ' is: ' ||v_current_price);
END;
/


4.1. Exercise 02
DECLARE
    v_company_name VARCHAR2(10) := 'IBM';
    v_current_price NUMBER(6,2);
    v_message VARCHAR2(50);
BEGIN
    SELECT cr_price INTO v_current_price
    FROM stocks
    WHERE TRIM(company) = v_company_name;

    IF v_current_price < 45 THEN
        v_message := 'Current price is very low!';
    ELSIF v_current_price >= 45 AND v_current_price < 55 THEN
        v_message := 'Current price is low!';
    ELSIF v_current_price >= 55 AND v_current_price < 65 THEN
        v_message := 'Current price is medium!';
    ELSIF v_current_price >= 65 AND v_current_price < 75 THEN
        v_message := 'Current price is medium high!';
    ELSE
        v_message := 'Current price is high!';
    END IF;

    DBMS_OUTPUT.PUT_LINE('Stock: ' || v_company_name || ' - ' || v_message);
END;
/


5.5.Exercise 03 
(a) Using a Simple Loop
DECLARE
    i NUMBER := 9;  
    j NUMBER;       
BEGIN
    LOOP  
        EXIT WHEN i < 1;  
        
        j := i;
        
        WHILE j > 0 LOOP  
            DBMS_OUTPUT.PUT(i || ' ');
            j := j - 1;
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE; 
        i := i - 1; 
    END LOOP;
END;
/


(b) Using a While Loop
DECLARE
    i NUMBER := 9;  
    j NUMBER;       
BEGIN
    WHILE i >= 1 LOOP  
        j := i;
        
        LOOP  
            EXIT WHEN j < 1;  
            
            DBMS_OUTPUT.PUT(i || ' ');
            j := j - 1;
        END LOOP;
        
        DBMS_OUTPUT.NEW_LINE;
        i := i - 1; 
    END LOOP;
END;
/ 


(c) Using a For Loop
BEGIN
    FOR v_i IN REVERSE 1..9 LOOP
        FOR v_j IN REVERSE 1..v_i LOOP
            DBMS_OUTPUT.PUT(v_i || ' ');
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;
/


6.1.3. Exercise 04
DECLARE
    CURSOR purchase_cursor IS
        SELECT i.p_date, i.qty, c.clname, i.company.company AS company_name
        FROM clients c, TABLE(c.investments) i;
BEGIN
    FOR record IN purchase_cursor LOOP
        IF record.p_date < TO_DATE('01-JAN-2000', 'DD-MON-YYYY') THEN
            UPDATE TABLE(
                SELECT c.investments FROM clients c WHERE c.clname = record.clname
            ) i
            SET i.qty = i.qty + 150
            WHERE i.company.company = record.company_name;
        ELSIF record.p_date < TO_DATE('01-JAN-2001', 'DD-MON-YYYY') THEN
            UPDATE TABLE(
                SELECT c.investments FROM clients c WHERE c.clname = record.clname
            ) i
            SET i.qty = i.qty + 100
            WHERE i.company.company = record.company_name;
        ELSIF record.p_date < TO_DATE('01-JAN-2002', 'DD-MON-YYYY') THEN
            UPDATE TABLE(
                SELECT c.investments FROM clients c WHERE c.clname = record.clname
            ) i
            SET i.qty = i.qty + 50
            WHERE i.company.company = record.company_name;
        END IF;
    END LOOP;
END;
/


6.2.7. Exercise 05
DECLARE
    CURSOR purchase_cursor IS
        SELECT i.p_date, i.qty, c.clname, i.company.company AS company_name
        FROM clients c, TABLE(c.investments) i
        WHERE i.p_date < TO_DATE('01-JAN-2002', 'DD-MON-YYYY');

    v_p_date     DATE;
    v_qty        NUMBER;
    v_clname     VARCHAR2(50);
    v_company    VARCHAR2(50);

BEGIN
    OPEN purchase_cursor;
    
    FETCH purchase_cursor INTO v_p_date, v_qty, v_clname, v_company;

    WHILE purchase_cursor%FOUND LOOP
        IF v_p_date < TO_DATE('01-JAN-2000', 'DD-MON-YYYY') THEN
            UPDATE TABLE(
                SELECT c.investments FROM clients c WHERE c.clname = v_clname
            ) i
            SET i.qty = i.qty + 150
            WHERE i.company.company = v_company;

        ELSIF v_p_date < TO_DATE('01-JAN-2001', 'DD-MON-YYYY') THEN
            UPDATE TABLE(
                SELECT c.investments FROM clients c WHERE c.clname = v_clname
            ) i
            SET i.qty = i.qty + 100
            WHERE i.company.company = v_company;

        ELSIF v_p_date < TO_DATE('01-JAN-2002', 'DD-MON-YYYY') THEN
            UPDATE TABLE(
                SELECT c.investments FROM clients c WHERE c.clname = v_clname
            ) i
            SET i.qty = i.qty + 50
            WHERE i.company.company = v_company;
        END IF;

        FETCH purchase_cursor INTO v_p_date, v_qty, v_clname, v_company;
    END LOOP;
    CLOSE purchase_cursor;
END;
/


