select * from e_beauty_clean_data
	where State = 'NY';
#1734 rows
select count(*) as num_records
from e_beauty_clean_data
where state = 'NY';
#1734 rows

#b.
select state, SUM(Total) AS sales_by_state
from e_beauty_clean_data
group by state
order by sales_by_state DESC;
#california

#c
select distinct `First Name`, `Last Name`, Email
from e_beauty_clean_data
where state in ('CA', 'TX', 'NY', 'IL', 'FL')
GROUP BY `First Name`, `Last Name`, Email
ORDER BY Email;

#d 
select State, count(distinct OrderId) as number_of_customer_by_state
from e_beauty_clean_data
group by state
having count(distinct OrderId) > 100
order by number_of_customer_by_state DESC;

#e. 
describe nyc_airbnb;