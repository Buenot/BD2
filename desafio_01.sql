## Dado as tabelas abaixo como eu poderia efetuar a consulta dos clientes (customers) que não efetuaram pedidos (orders) utilizando o LEFT JOIN ?
CREATE DATABASE database_bueno;
use database_bueno;
  CREATE TABLE customers (
	id INTEGER PRIMARY KEY auto_increment ,
    name TEXT,
    email TEXT);
    
    INSERT INTO customers (id, name, email) VALUES ("1" ,"Doctor Who", "doctorwho@timelords.com");
	INSERT INTO customers (id, name, email) VALUES ("2", "Harry Potter", "harry@potter.com");
	INSERT INTO customers (id, name, email) VALUES ("3", "Captain Awesome", "captain@awesome.com");
    
  CREATE TABLE orders (
    id INTEGER PRIMARY KEY auto_increment,
	customer_id INTEGER,
    item TEXT,
    price REAL);
    
    INSERT INTO orders (id,customer_id, item, price)
    VALUES ("4","1", "Sonic Screwdriver", 1000.00);
	INSERT INTO orders (id, customer_id, item, price)
    VALUES ("5","2", "High Quality Broomstick", 40.00);
	INSERT INTO orders (id,customer_id, item, price)
    VALUES ("6","1", "TARDIS", 1000000.00);
    
SELECT customers.name, customers.email,  orders.item, orders.price 
FROM customers
LEFT OUTER JOIN orders 
ON customers.id= orders.customer_id
where orders.item is null