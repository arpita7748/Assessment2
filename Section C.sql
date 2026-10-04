create database food_delivery;

use food_delivery;
create table restaurants(
	restaurant_id int primary key auto_increment,
    name varchar(100) not null,
    city varchar(50) not null,
    cuisine_type varchar(50) not null,
    created_at timestamp
);

create table menu_items(
	item_id int primary key auto_increment,
    restaurant_id int not null,
    item_name varchar(50) not null,
    price decimal(10,2) not null,
    category varchar(50) not null,
    foreign key (restaurant_id) references restaurants(restaurant_id)
);

create table orders(
	order_id int primary key auto_increment,
    customer_name varchar(100) not null,
    restaurant_id int not null,
    item_id int not null,
    quantity int not null,
    total_amount decimal(10,2) not null,
    order_date timestamp not null default current_timestamp,
    foreign key (restaurant_id) references restaurants(restaurant_id),
    foreign key (item_id) references menu_items(item_id)
);

drop table orders;

insert into restaurants(name,city,cuisine_type) values
('tasty bites', 'ahmedabad', 'north indian'),
('pizza palace', 'gandhinagar', 'italian'),
('spice hub', 'ahmedabad', 'chinese');

insert into menu_items
(restaurant_id,item_name,price,category) values
(1, 'paneer butter masala', 220.00, 'main course'),
(1, 'veg biryani', 180.00, 'rice'),
(1, 'samosa', 40.00, 'snacks'),
(1, 'gulab jamun', 80.00, 'dessert'),
(1, 'masala dosa', 120.00, 'breakfast'),

(2, 'margherita pizza', 250.00, 'pizza'),
(2, 'farmhouse pizza', 350.00, 'pizza'),
(2, 'garlic bread', 120.00, 'snacks'),
(2, 'chocolate brownie', 150.00, 'dessert'),
(2, 'pasta arrabbiata', 220.00, 'main course'),

(3, 'veg noodles', 160.00, 'noodles'),
(3, 'manchurian', 180.00, 'main course'),
(3, 'fried rice', 170.00, 'rice'),
(3, 'spring rolls', 130.00, 'snacks'),
(3, 'ice cream', 90.00, 'dessert');

insert into orders
(customer_name,restaurant_id,item_id,quantity,total_amount)
values
('arpita', 1, 1, 2, 440.00),
('rahul', 1, 2, 1, 180.00),
('priya', 1, 3, 3, 120.00),
('jay', 1, 4, 2, 160.00),
('neha', 1, 5, 1, 120.00),

('amit', 2, 6, 1, 250.00),
('riya', 2, 7, 2, 700.00),
('karan', 2, 8, 1, 120.00),
('meena', 2, 9, 2, 300.00),
('rohan', 2, 10, 1, 220.00),

('pooja', 3, 11, 2, 320.00),
('vikas', 3, 12, 1, 180.00),
('simran', 3, 13, 2, 340.00),
('deep', 3, 14, 3, 390.00),
('isha', 3, 15, 1, 90.00);

create view restaurant_sales_summry as
select
	r.name as restaurant_name,
    count(o.order_id) as total_orders,
    sum(o.total_amount) as total_revenue
from restaurants r
left join orders o
on r.restaurant_id=o.restaurant_id
group by r.restaurant_id,r.name;

select * from restaurant_sales_summry;

create table order_audit(
	order_id int not null,
    restaurant_id int not null,
    action varchar(40) not null,
    log_time datetime not null
);

delimiter //

create trigger after_order_insert
after insert on orders
for each row
begin
    insert into order_audit
    (order_id, restaurant_id, action, log_time)
    values
    (new.order_id, new.restaurant_id, 'insert', now());
end //

delimiter ;

delimiter //

create procedure add_order(
    in p_customer_name varchar(100),
    in p_restaurant_id int,
    in p_item_id int,
    in p_quantity int
)
begin
    declare v_price decimal(10,2);
    declare v_total decimal(10,2);
    declare v_count int;

    select count(*)
    into v_count
    from restaurants
    where restaurant_id = p_restaurant_id;

    if v_count = 0 then
        rollback;
    else

        select price
        into v_price
        from menu_items
        where item_id = p_item_id;

        set v_total = v_price * p_quantity;

        insert into orders
        (customer_name, restaurant_id, item_id, quantity, total_amount)
        values
        (p_customer_name, p_restaurant_id, p_item_id,
         p_quantity, v_total);

    end if;
end //

delimiter ;

call add_order('karishma', 1, 1, 2);
select * from orders;
select * from order_audit;
