use amazon
select * from amazon;


select * from amazon;

describe amazon;

#check data type and convert date,time and id column with correct datatype
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET date = STR_TO_DATE(date, '%d-%m-%Y')
SET SQL_SAFE_UPDATES = 1;
ALTER TABLE amazon
MODIFY date DATE;
alter table amazon
modify Time Time;
ALTER TABLE amazon
MODIFY `Invoice ID` VARCHAR(30);

SELECT * FROM amazon WHERE 
    `Invoice Id` IS NULL OR
    Branch IS NULL OR
    City IS NULL OR
    `Customer type` IS NULL OR
    Gender IS NULL OR
    `Product line` IS NULL OR
    `Unit price` IS NULL OR
    Quantity IS NULL OR
    `Tax 5%` IS NULL OR
    Total IS NULL OR
    `date` IS NULL OR
    Time IS NULL OR
    Payment IS NULL OR
    cogs IS NULL OR
    `gross margin percentage` IS NULL OR
    `gross income` IS NULL OR
    rating IS NULL;
    
    
#Feature Engineering:    
#Add new columns for timeofday, dayname, and monthname
alter Table amazon
add timeofday varchar(10);

alter Table amazon
add dayname varchar(10);

alter Table amazon
add monthname varchar(10);

update amazon
set timeofday=case
when Time(time) BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
when Time(time) BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
when Time(time) BETWEEN '18:00:00' AND '23:59:59' THEN 'Evening'
ELSE 'Night'
END;

update amazon
set dayname=Dayname(date);
update amazon
set monthname=Monthname(date);
select timeofday,dayname,monthname from amazon;

#Business Questions To Answer:

#1.What is the count of distinct cities in the dataset?
select Distinct City from amazon;

#2.For each branch, what is the corresponding city?
select distinct branch,City from amazon;

#3.What is the count of distinct product lines in the dataset?
select distinct `Product line` from amazon;

#4.Which payment method occurs most frequently?
select Payment,count(*) as frequency 
from amazon
group by Payment
order by frequency Desc
limit 1;

#5.Which product line has the highest sales?
select `Product line`,count(*) as `highest sales` from amazon
group by `Product line`
order by `highest sales` desc
limit 1;

#6.How much revenue is generated each month?
select distinct monthname from amazon;
select monthname, sum(Total)as revenue from amazon
group by monthname
order by revenue desc;

#7.In which month did the cost of goods sold reach its peak?
select monthname,sum(cogs)as totalcost_of_goods 
from amazon
group by monthname
order by totalcost_of_goods desc
limit 1;

#8.Which product line generated the highest revenue?
select `Product line`,sum(total) as higest_revenue
from amazon
group by `Product line`
order by higest_revenue desc
limit 1;

#9.In which city was the highest revenue recorded?
select City,sum(total) as higest_revenue
from amazon
group by City
order by higest_revenue desc
limit 1;

#10.Which product line incurred the highest Value Added Tax?
select `Product line`,sum(`Tax 5%`) as total_tax
from amazon
group by `Product line`
order by total_tax desc
limit 1;

#11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
alter table amazon
add column sales_classification varchar(4);

UPDATE amazon a
JOIN (
    SELECT `Product line`,
           CASE 
               WHEN SUM(Total) > (SELECT AVG(Total) FROM amazon) THEN 'Good'
               ELSE 'Bad'
           END AS sales_classification
    FROM amazon
    GROUP BY `Product line`
) AS subquery ON a.`Product line` = subquery.`Product line`
SET a.sales_classification = subquery.sales_classification;
select  `Product line`, sales_classification from amazon;


#12.Identify the branch that exceeded the average number of products sold.
select Branch, sum(Quantity) as total_quantity
from amazon
group by Branch
having total_quantity > (select avg(Quantity) from amazon);

#13.Which product line is most frequently associated with each gender?
select Gender,`Product line`,count(*) as frequency 
from amazon
group by Gender,`Product line`
Order By Frequency Desc
limit 1;

#14.Calculate the average rating for each product line.
select `Product line`,avg(Rating)as rating from amazon
group by `Product line`
order by rating  desc;

#15.Count the sales occurrences for each time of day on every weekday.
select timeofday,dayname,count(Total)as totalsales
from amazon
group by timeofday,dayname
order by totalsales desc;

#16.Identify the customer type contributing the highest revenue.
select `Customer type`,sum(Total) as higest_revenue
from amazon
group by `Customer type`
order by higest_revenue desc;

#17.Determine the city with the highest VAT percentage.
select City,avg(`Tax 5%`) as total_vat
from amazon
group by City
order by total_vat desc
limit 1;

#18.Identify the customer type with the highest VAT payments.
select `Customer type`,sum(`Tax 5%`) as total_vat
from amazon
group by `Customer type`
order by total_vat desc
limit 1;

#19.What is the count of distinct customer types in the dataset?
select distinct `Customer type`
from amazon;

#20.What is the count of distinct payment methods in the dataset?
select count(distinct Payment)
from amazon;
select distinct Payment
from amazon;

#21.Which customer type occurs most frequently?
select  `Customer type`,count(*) as frequently
from amazon
group by  `Customer type`
order by frequently desc
limit 1;

#22.Identify the customer type with the highest purchase frequency.
select  `Customer type`,count(Quantity) as  purchase_count
from amazon
group by  `Customer type`
order by  purchase_count desc
limit 1;

#23.Determine the predominant gender among customers.
SELECT gender, COUNT(*) AS count
FROM amazon
GROUP BY gender
ORDER BY count DESC
limit 1;

#24.Examine the distribution of genders within each branch.
SELECT Branch,gender, COUNT(*) AS count
FROM amazon
GROUP BY Branch,gender
order by Branch,gender;

#25.Identify the time of day when customers provide the most ratings.
select timeofday,count(*)as rating_counts
from amazon
group by timeofday
order by rating_counts desc;

#26.Determine the time of day with the highest customer ratings for each branch.
select timeofday,branch,avg(rating) as avg_rating
from amazon
group by timeofday,branch
order by  avg_rating desc;

#27.Identify the day of the week with the highest average ratings.
select dayname,avg(rating) as avg_rating
from amazon
group by dayname
order by  avg_rating desc;


#28.Determine the day of the week with the highest average ratings for each branch.
select dayname,branch,avg(rating) as avg_rating
from amazon
group by dayname,branch
order by  avg_rating desc;




