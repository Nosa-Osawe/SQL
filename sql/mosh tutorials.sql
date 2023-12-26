USE sql_store;
select * from customers 
-- where customer_id = 1
order by first_name; 
-- ---------------
select 
	last_name, 
    first_name, 
    points + 10 as "discount factor"
from customers;
-- --------------------------------------------
select * from sql_store.customers;
UPDATE sql_store.customers
SET state = VA 
WHERE (customer_id = '1');
select distinct state from customers;

select * from products;
select name, unit_price, unit_price * 1.1 as 'new price'
from products;

select * from customers where (state != 'VA');
select * from orders where 'order date' >= '2019-01-01';

select	* from customers where birth_date > '1990-01-01' and points > 1000;
select	* from customers 
where birth_date > '1990-01-01' 
	OR (points > 1000 and state = 'VA');
    
select  * from customers
 where not birth_date >  '1990-01-01' or 
		points > 1000;

select * from order_items
where order_id = 6 and unit_price * quantity > 30;

select * from customers where state not in ('VA', 'FL', 'GA');

select * from customers where points between 1000 and 3000;
select * from customers where birth_date between '1990-01-01' and '2000-01-01';

select * from customers where last_name like 'b%';
select * from customers where last_name like '%b%';
select * from customers where last_name like '%y';
select * from customers where last_name like 'b%y';
select * from customers where last_name like 'b____y';

select * from customers 
where address like '%trail%' or 
address like '%avenue%';

select * from customers where phone not like '%9';
select * from customers where last_name regexp 'field';
select * from customers where last_name regexp '^field'; 
-- ^ represents the begninig of a string.  $ represents the end of a string
select * from customers where last_name regexp 'field$'; 
select * from customers where last_name regexp 'field|mac|rose'; 
select * from customers where last_name regexp '^field|mac|rose';  -- see what the '^' is doing

select * from customers where last_name regexp '[gim]e'; -- any character with a ge, ie, or me will output.
select * from customers where last_name regexp '[a-h]e';
-- find the customer whose first names are ELIKA or AMBUR
select * from customers where first_name regexp 'ELIKA|AMBUR';
-- last names end with EY or ON
select * from customers where last_name regexp 'EY$|ON$';
-- last name starts with MY or contains SE
select * from customers where last_name regexp '^MY|SE';
-- last name contains B followed by R or U
select * from customers where last_name regexp 'B[RU]';

select * from customers where phone is not null;
select * from customers order by
	state desc, first_name ASC; 	 
select first_name, last_name, 10 as points 
from customers order by points, first_name;
-- alternatively 
select first_name, last_name, 10 as points 
from customers order by 1,2;  -- using column index

select *, quantity * unit_price as total_price  
from order_items where order_id = 2
order by total_price desc;

-- -------------------------- 
select * from customers 
limit 6, 3;   ----- skip the first six, and select the next 3

select order_id, first_name, last_name
from orders
join customers on orders.customer_id = customers.customer_id
order by order_id;

select order_id, first_name, last_name
from orders
join customers on orders.customer_id = customers.customer_id
order by order_id;
-- alternatively

select order_id, first_name, last_name
from orders as o
join customers as c 
on o.customer_id = c.customer_id
order by order_id;
-- ----------------
select order_id, oi.product_id, oi.unit_price
from order_items as oi join products as p 
on oi.product_id = p.product_id;

select * from order_items as oi join
 sql_inventory.products as p on
 oi.product_id = p.product_id;  -- you do not have to prefix the current database. 
								-- prefix the old outer data base

use sql_hr;
select  e.employee_id, e.first_name, m.first_name as manager
from employees as e join employees as m 
on e.reports_to = m.employee_id;
--  --------------------------------------------------------------------------
use sql_store;
select 
	o.order_id, o.order_date, c.first_name, c.last_name, os.name as status
from orders as o
join customers as c
on o.customer_id = c.customer_id
join order_statuses as os 
on o.status = os.order_status_id;

use sql_invoicing;

select p.date, c.name, p.invoice_id, pm.name as 'payment method'
from clients as c
join payments as p 
on c.client_id = p.client_id
join payment_methods as pm
on p.payment_method = pm.payment_method_id;

use sql_store;
select * 
from order_item_notes as oin
join order_items as oi 
on oin.order_Id = oi.order_Id 
and	oin.product_id = oi.product_id;
--   implicit join syntax

select * from orders as o, customers as c
where o.customer_id = c.customer_id;

-- outer joins------------------------------------------------------
use sql_store;
select c.customer_id, c.first_name, o.order_id
from customers as c
join orders as o
on c.customer_id = o.customer_id
order by c.customer_id;

select c.customer_id, c.first_name, o.order_id
from customers as c
left join orders as o
on c.customer_id = o.customer_id
order by c.customer_id;

select c.customer_id, c.first_name, o.order_id
from customers as c
right join orders as o
on c.customer_id = o.customer_id
order by c.customer_id;

select p.product_id, p.name, o.quantity
from products as p
left join order_items as o
on p.product_id = o.product_id;

select c.customer_id, c.first_name, o.order_id, sh.name as shipper
from customers as c
left join orders as o
on c.customer_id = o.customer_id
left join shippers sh
on o.shipper_id = sh.shipper_id
order by c.customer_id;

select o.order_date, o.order_id, c.first_name, sh.name as shipper, os.name as status
from orders as o
left join shippers as sh
on o.shipper_id = sh.shipper_id
left join order_statuses as os
on o.status = os.order_status_id
left join customers as c
on o.customer_id = c.customer_id
order by status, o.order_date desc;

-- self outer join
use sql_hr;
select e.employee_id, e.first_name, m.first_name as manager
from  employees as e
left join  employees as m
on e.reports_to = m.employee_id;

-- if column names are thesame across two tables
-- you can use the USING clause which is simpler and shorter

use sql_store;
select  o.order_id, c.first_name, sh.name as shipper
from orders as o
 join customers as c
 using (customer_id)
 left join shippers as sh
 using (shipper_id);
 
 select *
 from order_items as oi
 join order_item_notes as oin
	using (order_id, product_id);
    
use sql_invoicing;
select p.date, c.name as client, p.amount, 	pm.name as name
from payments as p
join payment_methods as pm
on p.payment_id = pm.payment_method_id
left join clients as c
using (client_id);

select  p.date, c.name as client, p.amount, pm.name
from payments as p
join clients as c
using (client_id)
join payment_methods as pm
on p.payment_method = pm.payment_method_id;

select * 
from order_items oi
join order_item_notes oin 
	using (order_id, product_id);

--  Natural joins: Not encouraged to use because it can sometimes produced unforseen results
-- It joins by the natural identical column names
use sql_store;
select o.order_id,
		c.first_name
from orders o
natural join customers c;

-- cross join --------------------------------------------------------

-- cross join combined two tables together
select c.first_name as customer, 
		p.name as product
from customers c
cross join  products p
order by c.first_name;

select *			-- explicit syntax
from shippers as sh
cross join products; 

select *
from shippers, products; -- implicit syntax

select *
from orders where order_date >= '2019-01-01';
-- -------------   			unions------
use sql_store;
select order_id, order_date, 'Active' as status
from orders
where order_date >= '2019-01-01'
union				-- union can also be used with different tables-- 
select order_id, order_date, 'Archived' as status
from orders
where order_date < '2019-01-01';

select customer_id, first_name, points, 'Bronze' as type
from customers
where points <2000
union
select customer_id, first_name, points, 'Silver' as type
from customers
where points between 2000 and 3000
union
select customer_id, first_name, points, 'Gold' as type
from customers
where points >3000
order by first_name;

-- column attribute------------------ 	
insert into customers (first_name, last_name, birth_date, address, city, state)
values ('Smith', 'John', '1990-01-01', 'address', 'city', 'CA');

insert into shippers (name)
value ('shipper 1'),('shipper 2'), ('shipper 3');

-- create new table-----
create table orders_archived as 
select * from orders; -- remember to truncate it

insert into orders_archived 
select *
from orders
where order_date < '2019-01-01';

-- ------------------------------------------------

use sql_invoicing;

create table invoicing_arhived as
select i.invoice_id, i.number, c.name, i.invoice_total, i.payment_total
from invoices as i
join clients as c 
on i.client_id = c.client_id  					-- or :USING(client_id)--
where i.payment_date is not null;

--     updating a single row ---
update invoices 
set payment_total = 10, payment_date = '2019-03-01'
where 	invoice_id = 1;

update invoices 
set payment_total = default, payment_date = null
where 	invoice_id = 1;

update invoices 
set payment_total = invoice_total * 0.5, payment_date = due_date
where 	invoice_id in (3,4,5);

use sql_store;
update customers
set points = points + 50
where birth_date <='1990-01-01';  -- This can only be done in safe mode. change proference settings --

use sql_invoicing;
update invoices 
set payment_total = invoice_total * 0.5, 
	payment_date = due_date
where 	client_id in
				(select client_id 
                from clients 
                where state in ('CA', 'NY'));

use sql_store;
update orders
set comments = 'Gold customers'
where customer_id in 
				(select customer_id
                from customers
                where points > 3000);
use sql_invoicing;   
             
delete from invoices
where  client_id in						-- 'IN' is a safezone compared to '='
				(select client_id
                from clients
                where name = 'Myworks');
                
                
 



