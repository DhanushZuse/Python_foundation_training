create database CRS;
use crs;

create table vehicle(
	vehicleid int primary key,
    make varchar(255),
    model varchar(255),
    year year,
    dailyrate decimal,
    statue enum("available", "notavailable"),
    passengercapacity int,
    enginecapacity int
    );
    
create table Customer(
	CustomerID INT,
	FirstName VARCHAR(45),
	LastName VARCHAR(45),
	Email VARCHAR(45),
	Phone VARCHAR(25),
	PRIMARY KEY (CustomerID));
    
create table lease(
	leaseid int primary key,
    vehicleid int,
    customerid int,
    startdate date,
    enddate date,
    type enum("daily","monthly"));
    
create table payment(
	paymentid int primary key,
    leaseid int,
    paymentdate date,
    amount decimal);
    
  alter table lease add foreign key(vehicleid) references vehicle(vehicleid);  
  alter table lease add foreign key(customerid) references Customer(CustomerID);
  alter table payment add foreign key(leaseid) references lease(leaseid);

INSERT INTO customer VALUES 
	('1', 'john', 'doe', 'johndoe@example.com', '555-555-5555'),
	('2', 'jane', 'smith', 'janesmith@example.com', '555-123-4567'),
    ('3', 'robert', 'johnson', 'robert@example.com', '555-789-1234'),
    ('4', 'sarah', 'brown', 'sarah@example.com', '555-456-7890'),
    ('5', 'david', 'lee', 'david@example.com', '555-987-6543'),
    ('6', 'laura', 'hall', 'laura@example.com', '555-234-5678'),
    ('7', 'michael', 'davis', 'michael@example.com', '555-876-5432'),
    ('8', 'emma', 'wilson', 'emma@example.com', '555-432-1098'),
    ('9', 'william', 'taylor', 'william@example.com', '555-321-6547'),
    ('10', 'olivia', 'adams', 'olivia@examp', '555-765-4321');

INSERT INTO vehicle VALUES 
	('1', 'toyata', 'camry', 2022, '50', 'notavailable', '4', '1450'),
	('2', 'honda', 'civic', 2023, '45', 'notavailable', '7', '1500'),
    ('3', 'ford', 'focus', 2022, '48', 'available', '4', '1400'),
    ('4', 'nissan', 'altima', 2023, '52', 'notavailable', '7', '1200'),
    ('5', 'cheverlot', 'mailbu', 2022, '47', 'notavailable', '4', '1800'),
    ('6', 'hyundai', 'sanata', 2023, '49', 'available', '7', '1400'),
    ('7', 'bmw', '3 serier', 2023, '60', 'notavailable', '7', '2499'),
    ('8', 'mercedes', 'c class', 2022, '58', 'notavailable', '8', '2599'),
    ('9', 'audi', 'a4', 2022, '55', 'available', '4', '2500'),
    ('10', 'lexus', 'es', 2023, '54', 'notavailable', '4', '2500');

INSERT INTO lease VALUES 
	('1', '1', '1', '2023-01-01', '2023-01-05', 'daily'),
    ('2', '2', '2', '2023-02-15', '2023-02-28', 'monthly'),
    ('3', '3', '3', '2023-03-10', '2023-03-15', 'daily'),
    ('4', '4', '4', '2023-04-20', '2023-04-30', 'monthly'),
    ('5', '5', '5', '2023-05-05', '2023-05-10', 'daily'),
    ('6', '4', '3', '2023-06-15', '2023-06-30', 'monthly'),
    ('7', '7', '7', '2023-07-01', '2023-07-10', 'daily'),
    ('8', '8', '8', '2023-08-12', '2023-08-15', 'monthly'),
    ('9', '3', '3', '2023-09-07', '2023-09-10', 'daily'),
    ('10', '10', '10', '2023-10-10', '2023-10-31', 'monthly');

INSERT INTO payment VALUES 
	('1', '1', '2023-01-03', '200'),
    ('2', '2', '2023-02-20', '1000'),
    ('3', '3', '2023-03-12', '75'),
    ('4', '4', '2023-04-25', '900'),
    ('5', '5', '2023-05-07', '60'),
    ('6', '6', '2023-06-18', '1200'),
    ('7', '7', '2023-07-03', '40'),
    ('8', '8', '2023-08-14', '1100'),
    ('9', '9', '2023-09-09', '80'),
    ('10', '10', '2023-10-25', '1500');

#1
update vehicle set dailyrate = 68 where make = "mercedes";
select * from vehicle;
#2
delete from payment where leaseid = (select leaseid from lease where customerid = "1");
delete from lease where customerid = "1";
delete from customer where customerid = "1";
#3
alter table payment rename column paymentdate to transactiondate; 
#4
select * from customer where email = "robert@example.com";
#5
insert into lease values (11, 2, 2, "2024-1-15", "2024-2-15", "monthly");
select * from lease where customerid = 2 and now() between startdate and enddate;
#6
select * from payment where leaseid 
in (select leaseid from lease where customerid 
in (select customerid from customer where phone = '555-789-1234'));
#7
select avg(dailyrate) as Daily_avg_rate from vehicle 
group by statue having statue = "available";
#8
select * from vehicle 
where dailyrate = (select max(dailyrate) from vehicle);
#9
select * from vehicle where vehicleid in (select vehicleid from lease where customerid = 3);
#10
select * from lease order by enddate desc limit 5;
#11
select * from payment where year(transactiondate) = "2023";
#12
select * from customer 
where customerid not in 
(select customerid from lease 
where leaseid in (select leaseid from payment));
#13
select vehicle.vehicleid, vehicle.make, vehicle.model, 
	vehicle.year, vehicle.dailyrate, vehicle.statue, 
    sum(payment.amount) as total_amount 
    from vehicle join lease on vehicle.vehicleid = lease.vehicleid 
    join payment on lease.leaseid = payment.leaseid 
    group by 
    vehicle.vehicleid, vehicle.make, vehicle.model, 
    vehicle.year, vehicle.dailyrate, vehicle.statue;
#14
select customer.customerid, sum(amount) as total_payment 
from customer 
join lease on customer.customerid = lease.customerid 
join payment on lease.leaseid = payment.leaseid 
group by customer.customerid;
#15
select * from lease join vehicle on lease.vehicleid = vehicle.vehicleid;
#16
select * from lease 
join vehicle on lease.vehicleid = vehicle.vehicleid 
join customer on lease.customerid = customer.customerid 
where now() between startdate and enddate;
#17
select customer.customerid, customer.firstname, customer.lastname, 
	sum(amount) as total_amt 
    from customer join lease on customer.customerid = lease.customerid 
    join payment on lease.leaseid = payment.leaseid 
    group by customer.customerid 
    having total_amt = (select max(total_amt) 
    from (select sum(amount) as total_amt from customer 
    join lease on customer.customerid = lease.customerid 
    join payment on lease.leaseid = payment.leaseid 
    group by customer.customerid) as sub);
#18 To select current lease info 
select * from vehicle 
join lease on vehicle.vehicleid = lease.vehicleid 
where now() between startdate and enddate;

#to select last lease info
select * from vehicle 
join lease on vehicle.vehicleid = lease.vehicleid 
where (Make, Model, Year) in 
(select vehicle.Make, vehicle.Model, vehicle.Year from vehicle 
join lease on vehicle.vehicleid = lease.vehicleid 
where EndDate <= CURDATE() group by vehicle.Make, vehicle.Model, vehicle.Year 
having MAX(EndDate) = EndDate) order by vehicle.vehicleid;