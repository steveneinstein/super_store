SELECT * FROM fitbit_db.superstore_usa;

alter table superstore_usa add column new_date date after `Order Date`;
update superstore_usa set new_date = str_to_date(`Order Date`, '%d-%m-%Y');

alter table superstore_usa add column new_date_for_ship date after `Ship Date`;
update superstore_usa set new_date_for_ship = str_to_date(`Ship Date`, '%d-%m-%Y');

-- profit return wrt order ID--

select Profit, `Order ID` from superstore_usa group by `Order ID`

-- unique customers--

select distinct(`Customer Name`) from superstore_usa;
select count(distinct(`Customer Name`)) from superstore_usa;

-- how many regions we are selling a product per order ID--

select `Order ID`, count(Region) from superstore_usa group by `Order ID`;

-- number of shipment modes--

select distinct(`Ship Mode`) from superstore_usa;

-- percentage usability of all shipment mode--

select `Ship Mode` , count(`Order ID`) as lcount from superstore_usa group by `Ship Mode`;

set @total:=(select sum(lcount)) from (select `Ship Mode` , count(`Order ID`) as lcount from superstore_usa group by `Ship Mode`) as newtable;

create table new_temp_table select `Ship Mode` , count(`Order ID`) as lcount from superstore_usa group by `Ship Mode`;

select * from new_temp_table;

set @total :=(select sum(lcount) from new_temp_table);

select *, lcount/@total as percent_use from new_temp_table group by `Ship Mode`; 

-- create new column which gives diff between order data and ship date--
select `Order Date`, `Ship Date`, `Ship Date`-`Order Date` from superstore_usa;

alter table superstore_usa add column diff varchar(50) after `Ship Date`;
update superstore_usa set diff=`Ship Date`-`Order Date`;
alter table superstore_usa drop column diff
alter table superstore_usa add column diff_of_ship_order varchar(50) after `Ship Date`;
update superstore_usa set diff_of_ship_order=`new_date_for_ship`-`new_date`;

-- shiipment duration more than 10 days --
select * from superstore_usa where diff > 10  
select * from superstore_usa where `Row ID` = 18554

-- region with highest profit --
select region , sum(Profit) from superstore_usa group by region order by sum(Profit) desc limit 1

-- country with highest discount -- 
select `State or Province`, sum(Discount) from superstore_usa group by `State or Province` order by sum(Discount) desc limit 1

-- list of unique postal codes --
select distinct(`Postal Code`) from superstore_usa

select count(distinct(`Postal Code`)) from superstore_usa

-- which customer segement is most profitable -- 

select `Customer Segment` ,sum(Profit) as Total_profit from superstore_usa group by `Customer Segment` 

set @max_profit_val := (select max(Total_profit) from (select `Customer Segment` ,sum(Profit) as Total_profit from superstore_usa group by `Customer Segment`) as A)

select @max_profit_val 
select `Customer Segment` , Total_Profit from (select `Customer Segment` ,sum(Profit) as Total_profit from superstore_usa group by `Customer Segment`) as A where A.Total_profit = @max_profit_val 

-- 10th most loss making product --
select `Product Category` , `Product Sub-Category` , sum(Profit) as Total_prof from superstore_usa group by `Product Sub-Category` order by Total_prof asc limit 9,1

-- Top 10 products with highest margin --
select `Product Name` , sum(Profit) as Total_prof from superstore_usa group by `Product Name` order by Total_prof desc limit 10




