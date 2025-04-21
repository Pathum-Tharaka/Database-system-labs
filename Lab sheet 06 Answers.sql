Lab Sheet 06 Answers

1.
CREATE TABLE AdminDocs (
id INT PRIMARY KEY,
xDoc XMLTYPE NOT NULL
);

INSERT INTO AdminDocs VALUES (
1,
XMLTYPE('
<catalog>
<product dept="WMN">
<number>557</number>
<name language="en">Fleece Pullover</name>
<colorChoices>navy black</colorChoices>
</product>
<product dept="ACC">
<number>563</number>
<name language="en">Floppy Sun Hat</name>
</product>
<product dept="ACC">
<number>443</number>
<name language="en">Deluxe Travel Bag</name>
</product>
<product dept="MEN">
<number>784</number><name language="en">Cotton Dress Shirt</name>
<colorChoices>white gray</colorChoices>
<desc>Our <i>favorite</i> shirt!</desc>
</product>
</catalog>')
);

INSERT INTO AdminDocs VALUES (2,
'<doc id="123">
<sections>
<section num="1"><title>XML Schema</title></section>
<section num="3"><title>Benefits</title></section>
<section num="4"><title>Features</title></section>
</sections>
</doc>')


2. Using XML Query() method

SELECT id,
XMLQUERY('/catalog/product' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs;

SELECT id,
XMLQUERY('//product' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs;

SELECT id,
XMLQUERY('/*/product' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs;

SELECT id,
XMLQUERY('/*/product[@dept="WMN"]' PASSING xDoc RETURNING CONTENT) AS ProductsFROM AdminDocs;SELECT id,
XMLQUERY(' /*/child::product[attribute::dept="WMN"] ' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs;

SELECT id,
XMLQUERY(' //product[dept="WMN"]' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs;

SELECT id,
XMLQUERY(' descendant-or-self::product[attribute::dept="WMN"]' PASSING xDoc RETURNING CONTENT) AS
Products
FROM AdminDocs;

SELECT id,
XMLQUERY(' //product[number > 500]' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id,
XMLQUERY(' //product[number cast as xs:integer > 500]' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id,
XMLQUERY(' /catalog/product[4]' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;SELECT id,
XMLQUERY(' //product[number > 500][@dept="ACC"]' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id,
XMLQUERY(' //product[number > 500][1]' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;


3. XQuery expressions

SELECT id, XMLQUERY(' for $prod in //product let $x:=$prod/number return $x' PASSING xDoc RETURNING CONTENT) AS
Products
FROM AdminDocs
Where id =1;

SELECT id, XMLQUERY(' for $prod in //product let $x:=$prod/number where $x>500 return $x' PASSING xDoc RETURNING
CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id, XMLQUERY(' for $prod in //product let $x:=$prod/number return $x' PASSING xDoc RETURNING CONTENT) AS
Products
FROM AdminDocs
Where id =1;

SELECT id, XMLQUERY(' for $prod in //product let $x:=$prod/number where $x>500 return (<Item>{$x}</Item>)' PASSING
xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id, XMLQUERY(' for $prod in //product[number > 500] let $x:=$prod/number return (<Item>{$x}</Item>)' PASSING
xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id, XMLQUERY(' for $prod in //product let $x:=$prod/number where $x>500 return (<Item>{$x}</Item>)' PASSING
xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;

SELECT id, XMLQUERY(' for $prod in //product let $x:=$prod/number return if ($x>500) then <book>{data($x)}</book>
else<paper> {data($x)}</paper>' PASSING xDoc RETURNING CONTENT) AS Products
FROM AdminDocs
Where id =1;


4. XML DML XQuery expressions

UPDATE AdminDocs
SET xDoc = UPDATEXML(xDoc,
'/doc/sections',
XMLTYPE('<sections>
<section num="1"><title>XML Schema</title></section>
<section num="2"><title>Background</title></section>
<section num="3"><title>Benefits</title></section>
<section num="4"><title>Features</title></section>
</sections>')
) WHERE id = 2;
UPDATE AdminDocs
SET xDoc = DELETEXML(xDoc, '/doc/sections/section[@num="2"]')
WHERE id = 2;