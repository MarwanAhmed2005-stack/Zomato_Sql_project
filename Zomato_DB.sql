--Zomato Data Analysis using SQL
  
  --inserting to tables deliveries , orders and its rows so i dont type it here 
   
--create customer table
DROP TABLE IF EXISTS customers;
create table customers(
customer_id int primary key,
customer_name varchar(45),
reg_date DATE 
);




--create restaurant table
DROP TABLE IF EXISTS restaurants;
create table restaurants(
restaurant_id int primary key,
restaurant_name varchar(55),
city varchar(20),
opening_hours varchar(55)
);




--create table riders
DROP TABLE IF EXISTS riders;
create table riders(
rider_id float primary key,
rider_name varchar(30),
sign_up DATE
);

--FOREIGN KEY
alter table orders
ADD CONSTRAINT fk_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

--FOREIGN KEY
alter table orders
ADD CONSTRAINT FK_restaurants
FOREIGN KEY (restaurant_id)
REFERENCES restaurants(restaurant_id);

--FOREIGN KEY  runs
alter table deliveries
ADD CONSTRAINT FK_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

--FOREIGN KEY
alter table deliveries
ADD CONSTRAINT FK_riders
FOREIGN KEY (rider_id)
REFERENCES riders(rider_id);


INSERT INTO customers (customer_id, customer_name, reg_date) VALUES
(1,'Ahmed Ali','2024-01-05'),
(2,'Sara Mohamed','2024-01-08'),
(3,'Omar Hassan','2024-01-12'),
(4,'Mariam Samy','2024-01-18'),
(5,'Youssef Adel','2024-01-20'),
(6,'Nour Tarek','2024-01-25'),
(7,'Mahmoud Hany','2024-02-01'),
(8,'Salma Mostafa','2024-02-03'),
(9,'Kareem Ashraf','2024-02-10'),
(10,'Laila Ahmed','2024-02-15'),
(11,'Hassan Fathy','2024-02-18'),
(12,'Menna Khaled','2024-02-21'),
(13,'Ali Mahmoud','2024-03-01'),
(14,'Fatma Wael','2024-03-04'),
(15,'Mohamed Tarek','2024-03-08'),
(16,'Aya Adel','2024-03-12'),
(17,'Mostafa Samir','2024-03-18'),
(18,'Esraa Hassan','2024-03-20'),
(19,'Khaled Ibrahim','2024-03-25'),
(20,'Habiba Ahmed','2024-04-01'),
(21,'Yasmine Nasser','2024-04-04'),
(22,'Amr Salah','2024-04-10'),
(23,'Hoda Ali','2024-04-15'),
(24,'Shady Mohamed','2024-04-20'),
(25,'Rana Ashraf','2024-04-25'),
(26,'Tamer Adel','2024-05-01'),
(27,'Mona Ibrahim','2024-05-04'),
(28,'Ziad Hassan','2024-05-08'),
(29,'Reem Ahmed','2024-05-12'),
(30,'Adham Khaled','2024-05-18'),
(31,'Farah Samy','2024-05-22'),
(32,'Sherif Mostafa','2024-05-26'),
(33,'Nada Wael','2024-05-30');



INSERT INTO restaurants (restaurant_id, restaurant_name, city, opening_hours) VALUES
(1,'McDonald''s','Cairo','09:00-02:00'),
(2,'KFC','Cairo','10:00-01:00'),
(3,'Pizza Hut','Alexandria','11:00-01:00'),
(4,'Burger King','Giza','10:00-12:00'),
(5,'Hardee''s','Cairo','09:00-01:00'),
(6,'Buffalo Burger','Giza','11:00-02:00'),
(7,'Papa John''s','Alexandria','10:00-12:00'),
(8,'Cook Door','Mansoura','09:00-01:00'),
(9,'Bazooka','Cairo','11:00-02:00'),
(10,'Heart Attack','Cairo','12:00-03:00'),
(11,'Arabiata','Cairo','24 Hours'),
(12,'Chili''s','Alexandria','11:00-11:00');



INSERT INTO riders (rider_id, rider_name, sign_up) VALUES
(1,'Ali Salem','2023-11-01'),
(2,'Hassan Ahmed','2023-11-15'),
(3,'Mohamed Tarek','2023-12-01'),
(4,'Khaled Samir','2023-12-10'),
(5,'Ahmed Wael','2024-01-05'),
(6,'Youssef Ali','2024-01-15'),
(7,'Mahmoud Adel','2024-02-01'),
(8,'Mostafa Hassan','2024-02-10'),
(9,'Amr Nasser','2024-02-18'),
(10,'Karim Ibrahim','2024-03-01'),
(11,'Sherif Ashraf','2024-03-10'),
(12,'Omar Mahmoud','2024-03-18'),
(13,'Tamer Ahmed','2024-04-01'),
(14,'Bassem Khaled','2024-04-12'),
(15,'Walid Fathy','2024-04-20');


select * from customers;
select * from riders;
select * from orders;
select * from deliveries;
select * from restaurants;
;
