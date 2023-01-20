------------------------setup---------------------------------

create database superstore_fitbit
use superstore_fitbit
set sql_safe_updates=0;
alter table superstore_usa add column new_order_date date after `Order ID`
update superstore_usa set `new_order_date`=str_to_date(`Order Date`,'%m/%d/%Y')
alter table superstore_usa add column new_ship_date date after `new_order_date`

ALTER TABLE superstore_usa DROP COLUMN `Order Date`
ALTER TABLE superstore_usa DROP COLUMN `Ship Date`


------------------------questions--------------------------------------

-------------q3  Find out how return that we ahve recived and with a product id----
select Profit, `Order ID` from superstore_usa group by `Order ID`

-------------q5 . Try to find out how many unique customer that we have---------

select distinct(`Customer Name`) from superstore_usa;
select count(distinct(`Customer Name`)) from superstore_usa;

-------------q6 try to find out in how many regions we are selling a product and who is a manager for a respective region--------

select `Region` from superstore_usa group by `Region`;

select `Region`,`customer segment`,sum(`profit`) as `regional profit` from superstore_usa group by `Region`;

-------------q7 . find out how many different differnet shipement mode that we have and what is a percentage usablity of all the shipment mode with respect to dataset ------


select `Ship Mode`,((`number of sales`/total)*100) as percent from
(SELECT `Ship Mode`, COUNT(Sales) AS `number of sales`, SUM(COUNT(Sales)) OVER() AS total
FROM superstore_usa GROUP BY `Ship Mode`) as sub group by `Ship Mode`

----- 8 Create a new coulmn and try to find our a diffrence between order date and shipment date -----

alter table superstore_usa add column delivery_time varchar(30)
update superstore_usa set delivery_time= new_ship_date - new_order_date

---- 9 . base on question number 8 find out for which order id we have shipment duration more than 10 days -----
select * from superstore_usa where delivery_time > 10

-----10 . Try to find out a list of a returned order which sihpment duration was more then 15 days and find out that region manager as well -----

select `Order ID`,delivery_time,Region from  superstore_usa where delivery_time>15 

----------11 . Gorup by region and find out which region is more profitable ---------

select region,profits from (select Region,sum(profit) as profits from  superstore_usa group by Region) as sub where profits=( SELECT MAX(profits) FROM (select Region,sum(profit) as profits from  superstore_usa group by Region)as sub ) 

-------12 . Try to find out overalll in which country we are giving more didscount -------
select `State or Province`, sum(Discount) from superstore_usa group by `State or Province` order by sum(Discount) desc limit 1

--------13 . Give me a list of unique postal code ----------

select count(distinct(`Postal Code`)) from superstore_usa

-------14 . which customer segement is more profitalble find it out ------

select `Customer Segment` ,sum(Profit) as Total_profit from superstore_usa group by `Customer Segment` 

------15 . try to find out the 10th most loss making product catagory .--------------

select `Product Category` , `Product Sub-Category` , sum(Profit) as Total_prof from superstore_usa group by `Product Sub-Category` order by Total_prof asc limit 9,1

-----16 . Try to find out 10 top  product with highest margins 
select `Product Name` , sum(Profit) as Total_prof from superstore_usa group by `Product Name` order by Total_prof desc limit 10






