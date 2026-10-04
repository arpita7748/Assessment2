**1.The exact prompt(s) you gave the AI tool.**



Write a simple MySQL stored procedure named get\_monthly\_restaurant\_summary.



The procedure should:



* Accept restaurant\_id and month number (1–12) as input parameters.



* Return total orders, total revenue, and average order value for that restaurant in the given month.



* Use SELECT with GROUP BY and aggregate functions such as COUNT(), SUM(), and AVG().



* If the restaurant has no orders in that month, return a meaningful message instead of an empty result.



* Validate that the month is between 1 and 12.



* The procedure must run successfully in MySQL Workbench.



* Use simple beginner-friendly MySQL syntax.

\-----------------------------------------------------------------------------------------------------------------------------------------------------------------------



**2.The AI's original stored procedure code and your corrected/improved version.**



###### AI's original stored procedure code:



delimiter //



create procedure get\_monthly\_restaurant\_summary(

&#x20;   in p\_restaurant\_id int,

&#x20;   in p\_month int

)

begin



&#x20;   if p\_month < 1 or p\_month > 12 then



&#x20;       select 'invalid month. enter a month between 1 and 12' as message;



&#x20;   else



&#x20;       select

&#x20;           count(o.order\_id) as total\_orders,

&#x20;           sum(o.total\_amount) as total\_revenue,

&#x20;           avg(o.total\_amount) as average\_order\_value

&#x20;       from orders o

&#x20;       where o.restaurant\_id = p\_restaurant\_id

&#x20;         and month(o.order\_date) = p\_month

&#x20;       group by o.restaurant\_id;



&#x20;   end if;



end //



delimiter ;



call get\_monthly\_restaurant\_summary(1, 10);



OUTPUT:

total\_orders    total\_revenue    average\_order\_value

5               1020.00         204.00



call get\_monthly\_restaurant\_summary(2, 10);



OUTPUT:

total\_orders    total\_revenue    average\_order\_value

5               1620.00         324.00



###### Corrected Version:



delimiter //



create procedure get\_monthly\_restaurant\_summary(

&#x20;   in p\_restaurant\_id int,

&#x20;   in p\_month int

)

begin



&#x20;   declare v\_count int;



&#x20;   if p\_month < 1 or p\_month > 12 then



&#x20;       select 'invalid month. enter month between 1 and 12' as message;



&#x20;   else



&#x20;       select count(\*)

&#x20;       into v\_count

&#x20;       from orders

&#x20;       where restaurant\_id = p\_restaurant\_id

&#x20;         and month(order\_date) = p\_month;



&#x20;       if v\_count = 0 then



&#x20;           select 'no orders found for this restaurant in this month' as message;



&#x20;       else



&#x20;           select

&#x20;               restaurant\_id,

&#x20;               count(order\_id) as total\_orders,

&#x20;               sum(total\_amount) as total\_revenue,

&#x20;               avg(total\_amount) as average\_order\_value

&#x20;           from orders

&#x20;           where restaurant\_id = p\_restaurant\_id

&#x20;             and month(order\_date) = p\_month

&#x20;           group by restaurant\_id;



&#x20;       end if;



&#x20;   end if;



end //



delimiter ;



call get\_monthly\_restaurant\_summary(1, 10);



OUTPUT:

restaurant\_id    total\_orders    total\_revenue    average\_order\_value

1                5               1020.00          204.00



call get\_monthly\_restaurant\_summary(2, 11);



OUTPUT:

message

no orders found for this restaurant in this month

\-----------------------------------------------------------------------------------------------------------------------------------------------------------------------



**3.A 3–4 line note explaining what you changed and why the AI's version needed improvement.**



I tested the procedure with different restaurant and month values. I found that the first procedure showed no result when there were no orders for that month. I changed it by adding a check to display a message when no orders are found. I also added a check to make sure the month value is between 1 and 12.









