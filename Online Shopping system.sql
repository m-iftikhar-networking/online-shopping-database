Create database onlineShoping;

use onlineShoping;

create table Customers(

customerID int auto_increment primary key,
firstname varchar(255),
lastname varchar(255),
phone varchar(100),
email varchar(255)
);

insert into customers (firstname,lastname,phone,email) values 
('Muhammad','Abdullah','03259889765','abd123@gmail.com'),
('Ahmed','Khan','03259449766','ahmed123@gmail.com'),
('Abdul','Rehman','03223289767','Reh123@gmail.com'),
('Muhammad','Shoaib','03349389765','sho123@gmail.com'),
('Ayeza','Khan','03251123465','aye123@gmail.com');

select *from Customers;

create table Products(

ProductID int auto_increment primary key, 
ProductName varchar(255),
Category varchar(255),
Price int,
StockQuantity int
);

insert into Products (ProductName,Category,Price,StockQuantity) values 
('Cell Phone','Electronics',30000,10),
('Tablet','Electronics',25000,15),
('Watch','Smart',10000,8),
('Fan','Home Appliances',12000,11),
('Book','Stationary',800,20);

select *from Products;

create table Orders(

OrderID int auto_increment primary key,
OrderDate int,
CustomerID int, 
TotalAmount int,
foreign key(customerID) references Customers(customerID)
);
alter table Orders modify OrderDate varchar(100);

insert into Orders (OrderDate,CustomerID,TotalAmount) values 
('23-05-2023',2,30000),
('18-05-2023',2,25000),
('15-05-2023',2,800),
('29-05-2023',1,12000),
('21-05-2023',4,10000),
('10-05-2023',3,30000);

select *from Orders;


create table orderDetails(

OrderDetailID int auto_increment primary key, 
OrderID int, 
ProductID int, 
Quantity int,
Price int,
foreign key(OrderID) references Orders(OrderID),
foreign key(ProductID) references Products(ProductID)
);

insert into OrderDetails (OrderID,ProductID,Quantity,Price) values 
(1,3,7,10000),
(1,4,5,12000),
(3,2,2,25000),
(1,1,4,30000),
(1,1,3,30000);

select *from OrderDetails;

/*Query 1 Join*/

select c.firstname,c.lastname,o.OrderDate
from customers c
inner join Orders o on c.customerID=o.OrderID;

/*Query 2 aggregate function*/

select c.firstname, c.lastname, SUM(o.TotalAmount) as TotalSpent
from Customers c
inner join Orders o on c.customerID = o.CustomerID
group by c.customerID, c.firstname, c.lastname;

/*Query 3 GB with having*/

select category, max(StockQuantity) 
from products p
where  StockQuantity > 10
group by p.category
;


/*Query 4 order by*/

select c.lastname from customers c order by c.lastname asc;


/*Query 5 join& aggregate*/

select p.ProductName, p.StockQuantity as highestSoldQ
from Products p
where p.StockQuantity = (select MAX(StockQuantity) from Products)
limit 1;


/*Query 6 Stored Procedure*/
DELIMITER //

create procedure NewProducts
(in PName varchar(255), in Pcat varchar(255), in Pquant int, in PPrice int)
begin
    insert into Products(ProductName, Category, Price, StockQuantity) values
    (PName, Pcat, Pquant, PPrice);
    select * from Products;
end //

DELIMITER ;

call NewProducts('Tablet', 'Electronics', 30000, 15);

/*Query 7 Stored Procedure*/

DELIMITER //

CREATE PROCEDURE TotallSales(IN cID INT, OUT TS INT)
BEGIN
    SELECT (SUM(TotalAmount), 0)
    INTO TS
    FROM Orders
    WHERE CustomerID = cID;
END //

DELIMITER ;

/* New variable for storing value */
SET @totalS = 0;

/* Call the procedure and pass the output variable */
CALL TotallSales(1, @totalS);

/* Select the output variable to see the result */
SELECT @totalS AS TotallSales;
call TotallSales(1,@totalS);


/*Querey 8 Subquery*/

select firstName,lastName,customerID
from Customers where customerId not in
(select customerID from Orders);

/*Querey 9 Complex Join*/

select o.OrderID,c.firstName,c.lastName,o.OrderDate, 
sum(od.Quantity) as TotalQuantity
from Orders o
 join Customers c on o.customerID=c.customerID
 join OrderDetails od on o.OrderID=od.OrderID
group by o.OrderID,c.firstName,c.lastName,o.OrderDate;

/* Delete Products */

delete from Products where ProductID 
not in (select distinct ProductID from OrderDetails);

select *from OrderDetails;

