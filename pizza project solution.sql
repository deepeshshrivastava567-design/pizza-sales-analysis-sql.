create database dominos;
USE dominos;

-- 1.Retrieve the total no. of orders placed
select count(order_id) as total_orders from orders;
-- 2.Calculate the total revenue generated from pizza sales
select sum(order_details.quantity*pizzas.price) as total_revenue from order_details join pizzas 
on order_details.pizza_id=pizzas.pizza_id;
-- 3.identify the highest priced pizza
select pt.name,p.price from pizza_types pt join pizzas p 
on pt.pizza_type_id=p.pizza_type_id
order by p.price desc limit 1;
-- 4.Identify most common pizza size ordered
select quantity,count(order_details_id) from order_details group by quantity;
select p.size,count(od.order_details_id) as order_count 
from pizzas p join order_details od
on p.pizza_id=od.pizza_id
group by p.size order by order_count desc;
-- 5.list top 5 most ordered pizza types along with their quantities
select pt.name,sum(od.quantity) as quantity from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on od.pizza_id=p.pizza_id
group by pt.name order by quantity desc limit 5;

-- 6.join the nescessary tables to find total quantity of each pizza category ordered
select pt.category,sum(od.quantity) as quantity from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on od.pizza_id=p.pizza_id
group by  pt.category order by quantity desc; 

-- 7.determine the distribution of orders by hour of the day
select hour(time) as hour,count(distinct order_id) as order_count from orders 
group by hour(time);

-- 8.join relevant table to find category wise distribution of pizza
select category,count(name) from pizza_types group by category ; 

-- 9.group the order by date and calc. the avg no.of pizzas ordered per day 
select avg(quantity) from 
(select distinct(o.date),sum(od.quantity) as quantity from orders o join order_details od
on o.order_id=od.order_id
group by o.date) as order_quantity;



-- 10.detemine top 3 most ordered pizza types based on revenue
select distinct(pt.pizza_type_id),sum(od.quantity*p.price) as revenue from pizza_types pt join pizzas p
on pt.pizza_type_id=p.pizza_type_id
join order_details od
on od.pizza_id=p.pizza_id
group by (pizza_type_id) order by revenue desc limit 3;

-- 11.calc. the percentage contribution of each pizza type to total revenue
SELECT pt.category,(SUM(od.quantity * p.price) /
        (SELECT SUM(od.quantity * p.price)
         FROM order_details od
         JOIN pizzas p
         ON p.pizza_id = od.pizza_id)
    ) * 100 AS revenue
FROM pizza_types pt
JOIN pizzas p
    ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
    ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue DESC;