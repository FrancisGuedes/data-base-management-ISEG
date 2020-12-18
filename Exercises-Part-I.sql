Q1.

--Familiarize yourself with the Customer table by writing a Transact-SQL query that retrieves all columns for all customers.

select *
from customer

Q2.
-- Create a list of all customer contact names that includes the title, first name, middle name (if any), last name, and suffix (if any) of all customers.

select title, firstname, middlename, lastname, suffix
from customer

Q3.

/*
Retrieve customer names and phone numbers Each customer has an assigned salesperson.
You must write a query to create a call sheet that lists:
- The salesperson
- A column named CustomerName that displays how the customer contact should be
greeted (for example, “Mr Smith”)
- The customer’s phone number
*/

select salesperson, title || ' ' || lastname as CustomerName, phone
from customer

Q4.
/*
Retrieve a list of cities. Initially, you need to produce a list of all of you customers' locations.
-- Write a query that queries the Address table and retrieves all values for City and
-- StateProvince, removing duplicates.
*/

select distinct City, StateProvince
from address

Q5.
/* 
Retrieve a list of customer companies. You have been asked to provide a list of all customer
companies in the format <Customer ID> :<Company Name> - for example, 78: Preferred
Bikes.
*/

select customerid || ': ' || companyname as customercompany from customer

Q6.
/* Retrieve customers with only a main office address. Write a query that returns the company
name of each company that appears in a table of customers with a ‘Main Office’ address, but
not in a table of customers with a ‘Shipping’ address.
*/

select cst.customerid, companyname
from customer cst
join customer_address csta
on cst.customerid = csta.customerid
where csta.addresstype = 'Main Office'
MINUS
select cst.customerid, companyname
from customer cst
join customer_address csta
on cst.customerid = csta.customerid
where csta.addresstype = 'Shipping'

-- NOTE: Oracle does not allow EXCEPT

Q7.

/* Retrieve only customers with both a main office address and a shipping address.Write a
query that returns the company name of each company that appears in a table of customers
with a ‘Main Office’ address, and also in a table of customers with a ‘Shipping’ address.
*/

select cst.customerid, companyname
from customer cst
join customer_address csta
on cst.customerid = csta.customerid
where csta.addresstype = 'Main Office'
intersect
select cst.customerid, companyname
from customer cst
join customer_address csta
on cst.customerid = csta.customerid
where csta.addresstype = 'Shipping'

Q8.
/*
Retrieve a list of sales order revisions. The SalesOrderHeader table contains records of sales
orders. You have been asked to retrieve data for a report that shows:
- The sales order number and revision number in the format <Order Number>
(<Revision>) – for example SO71774 (2).
- The order date converted to ANSI standard format (yyyy.mm.dd – for example
2015.01.31).
*/

select salesordernumber || '(' || revisionnumber || ')' as salesorderrevisions, to_char(orderdate, 'yyyy.mm.dd') as orderdate
from sales_order_header

Q9.
/*
Retrieve customer contact names with middle names if known. You have been asked to write
a query that returns a list of customer names. The list must consist of a single field in the
format <first name> <last name> (for example Keith Harris) if the middle name is unknown,
or <first name> <middle name> <last name> (for example Jane M. Gates) if a middle name
is stored in the database.
*/

/*
update customer
set middlename=null
where middlename='NULL'
- first we execute de comand above before we could resolve the exercise 
*/

select firstname || ' ' || nvl(middlename, '') || ' ' || lastname as customername
from customer

Q10.
/*
Retrieve the product ID, name, and list price for each product where the list price is higher
than the average unit price for all products that have been sold.
*/

select p.productid, name, listprice
from product p
join sales_order_detail sd
on p.productid = sd.productid
group by p.productid, name, listprice
having listprice > avg (unitprice) 
order by productid

--------------------------------------------

SELECT p.ProductID, Name, ListPrice 
From Product p
WHERE ListPrice > (
    SELECT AVG(UnitPrice) FROM sales_order_detail
    )
ORDER BY ProductID

Q11.
/*
Retrieve the product ID, name, and list price for each product where the list price is $100 or
more, and the product has been sold for less than $100.
*/

select productid, name, listprice
from product p
where productid in (
    select productid 
    from sales_order_detail
    where listprice >= 100 and unitprice < 100
)

Q12.
/*
Retrieve the product ID, name, cost, and list price for each product along with the average
unit price for which that product has been sold.
o preço medio de venda por produto
*/

select distinct p.productid, name, standardcost, listprice
from product p
join sales_order_detail sd
on p.productid = sd.productid
where unitprice = (
    select avg(unitprice)
    from sales_order_detail sd
    where p.productid = sd.productid
) 

Q13.
/*
Write a query to retrieve a list of the product names and the total revenue calculated as the
sum of the LineTotal from the SalesOrderDetail table, with the results sorted in descending
order of total revenue
*/

select p.name, sum(linetotal)
from Sales_Order_Detail sd, product p
where sd.productid = p.productid
group by p.name
order by sum(linetotal) desc

Q14.
/*
Modify the previous query to include sales totals for products that have a list price of more
than $1000
*/

select p.name, sum(linetotal)
from Sales_Order_Detail sd, product p
where sd.productid = p.productid and p.listprice in (select p.listprice from product p where p.listprice > 1000)
group by p.name
order by sum(linetotal) desc

---------------------------

select p.name, sum(linetotal)
from Sales_Order_Detail sd
join product p
on sd.productid = p.productid
where p.listprice > 1000
group by p.name
ORDER BY SUM(LineTotal) DESC

Q15.
/*
Modify the previous query to include sales totals for products that have a list price of more
than $1000
*/

select p.name, sum(linetotal)
from Sales_Order_Detail sd, product p
where sd.productid = p.productid and p.listprice in (select p.listprice from product p where p.listprice > 1000)
having sum(linetotal) > 20000
group by p.name
order by sum(linetotal) desc

---------------------------

select p.name, sum(linetotal)
from Sales_Order_Detail sd
join product p
on sd.productid = p.productid
where p.listprice > 1000
group by p.name
having sum(linetotal) > 20000
ORDER BY SUM(LineTotal) DESC

Q16.
/*
An existing report uses the following query to return total sales revenue grouped by
country/region and state/province.

You have been asked to modify this query so that the results include a grand total for all sales
revenue and a subtotal for each country/region in addition to the state/province subtotals that
are already returned.
*/

select a.countryregion, a.stateprovince, sum(sh.totaldue) Revenue
from address a
join customer_address ca on a.addressid = ca.addressid
join customer c on ca.customerid = c.customerid
join Sales_Order_Header sh on c.customerid = sh.customerid
group by cube (a.countryregion, a.stateprovince)
order by a.countryregion, a.stateprovince

Q19.
/*
The sales manager at Adventure Works has mandated a 10% price increase for all products
in the Road Bikes category. Update the rows in the Product table for these products to
increase their price by 10%
*/

update product
set listprice = listprice * 1.1
where productcategoryid = (
    select productcategoryid
    from product_model
    where name = 'Road Bikes'
)

Q21.
/*
Delete the records from the Road Bikes category and its products. You must ensure that you
delete the records from the tables in the correct order to avoid a foreign-key constraint
violation
*/

delete from product
where productcategoryid = (
    select productcategoryid
    from product_model
    where name = 'Road Bikes'
)




