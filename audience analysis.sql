-----CREATE NORTH COAST TABLE

Create table north_coast (
final_delivery varchar(100), 
adset_budget numeric (10,2), 
project_name varchar(100), 	
trial varchar (200), 
audience text, 	
area varchar(200), 
total_leads	int, 
valid_leads int,
perc_valid_from_total numeric (10,2),	
perc_low_budget_from_total numeric (10,2),
answered int,	
perc_client_not_available_from_answered numeric (10,2),	
perc_answered_from_valid numeric (10,2),	
qualified int, 	
perc_qualified_from_valid	numeric (10,2),
perc_qualified_from_answered numeric (10,2),
m_scheduled	int,
m_happened	int,
amount_spent numeric (10,2)	,
cpa	numeric (10,2),
cpq	numeric (10,2)
); 

select * 
from north_coast;

alter table north_coast
add column adset_name text; 

--how to seperate ad set name (like text to column in excel)
SELECT
    split_part(adset_name, '--', 1) AS part1,
    split_part(adset_name, '--', 2) AS part2,
    split_part(adset_name, '--', 3) AS part3,
    split_part(adset_name, '--', 4) AS part4,
    split_part(adset_name, '--', 5) AS part5
FROM north_coast;

--now ill drop the column 
alter table north_coast
drop column adset_name; 

----NEW CAIRO 

Create table new_cairo (
final_delivery varchar(100), 
adset_budget numeric (10,2), 
project_name varchar(100), 	
trial varchar (200), 
audience text, 	
area varchar(200), 
total_leads	int, 
valid_leads int,
perc_valid_from_total numeric (10,2),	
perc_low_budget_from_total numeric (10,2),
answered int,	
perc_client_not_available_from_answered numeric (10,2),	
perc_answered_from_valid numeric (10,2),	
qualified int, 	
perc_qualified_from_valid	numeric (10,2),
perc_qualified_from_answered numeric (10,2),
m_scheduled	int,
m_happened	int,
amount_spent numeric (10,2)	,
cpa	numeric (10,2),
cpq	numeric (10,2)
); 

select * 
from new_cairo;


Create table october (
final_delivery varchar(100), 
adset_budget numeric (10,2), 
project_name varchar(100), 	
trial varchar (200), 
audience text, 	
area varchar(200), 
total_leads	int, 
valid_leads int,
perc_valid_from_total numeric (10,2),	
perc_low_budget_from_total numeric (10,2),
answered int,	
perc_client_not_available_from_answered numeric (10,2),	
perc_answered_from_valid numeric (10,2),	
qualified int, 	
perc_qualified_from_valid	numeric (10,2),
perc_qualified_from_answered numeric (10,2),
m_scheduled	int,
m_happened	int,
amount_spent numeric (10,2)	,
cpa	numeric (10,2),
cpq	numeric (10,2)
); 


select * 
from october;


create table all_locations as(
select * 
from october 
union all 
select * 
from new_cairo
union all
select * 
from north_coast); 


select * from all_locations; 

alter table all_locations
drop column ad_set_name;


create temp table paused_new_cairo as(
select * from new_cairo
where final_delivery= 'PAUSED'); 

create temp table active_new_cairo as(
select * from new_cairo
where final_delivery= 'ACTIVE'); 


select * 
from active_new_cairo
join paused_new_cairo
on active_new_cairo.project_name = paused_new_cairo.project_name ; 

SELECT 
    parts[1] AS project_name,
    parts[2] AS audience,
    parts[3] AS area,
    parts[4] AS part4,
    parts[5] AS ad_set_id
FROM (
    SELECT regexp_split_to_array('Taj Villas--10m+ Budget Lookalike 3%--New Cairo--*--120211948232400745', '--') AS parts
) AS split_parts;


--BEST AUDIENCES above 35% qualified and answered sum above 4 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

---same as above but 6th october only 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage, 
	count (audience) as audience_count
FROM october
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY SUM(answered) DESC;


--north coast 
SELECT audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage, 
	count (audience) as audience_count
FROM north_coast
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY SUM(answered) DESC;


--new cairo 
SELECT audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage, 
	count (audience) as audience_count
FROM new_cairo
GROUP BY audience
HAVING SUM(answered) > 3 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >10
ORDER BY SUM(answered) DESC;


select audience, count (audience) as audience_repetition, SUM(answered) AS answered_sum, sum(qualified) as sum_qualified, 
	round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
from all_locations 
where area ilike 'new cairo'
group by audience
having count(audience) >= 3 and SUM(answered) >=3
order by qualified_percentage desc; 

--------------------------------------------WATCH OUT FOR THESE:--------------------------------------------- 

--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 35% qualified and answered sum above 4 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--gcc and khaleeji good audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
where audience ilike '%khaleeji%' or audience ilike '%GCC%' 
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--mashup good audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
where audience ilike '%mashup%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--lookalike 1% good audience
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
where audience ilike '%lookalike 1%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--lookalike 3% good audience
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM all_locations
where audience ilike '%lookalike 3%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--how many times each audience used from total ad sets opened
select audience, count(audience) as audience_repitition, round(count(audience)*100/377::numeric, 2) as audience_percentage_from_adsets
From all_locations
Group by audience
order by audience_percentage_from_adsets desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	round(count(audience)*100/377::numeric, 2) as audience_percentage_from_adsets,
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From all_locations
Group by audience
having count(audience) < 3 and SUM(answered) >0
order by audience_percentage_from_adsets desc;



------------------------------------COOING 3 USD ------------------------------------------


Create table three_USD_all ( 
final_delivery varchar(100), 
adset_budget numeric (10,2), 
project_name varchar(100), 	
trial varchar (200), 
audience text, 	
area varchar(200), 
total_leads	int, 
valid_leads int,
perc_valid_from_total numeric (10,2),	
perc_low_budget_from_total numeric (10,2),
answered int,	
perc_client_not_available_from_answered numeric (10,2),	
perc_answered_from_valid numeric (10,2),	
qualified int, 	
perc_qualified_from_valid	numeric (10,2),
perc_qualified_from_answered numeric (10,2),
m_scheduled	int,
m_happened	int,
amount_spent numeric (10,2)	,
cpa	numeric (10,2),
cpq	numeric (10,2)
); 

select * from three_USD_all; 

alter table three_USD_all
drop column adset_name; 


--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM three_USD_all
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 35% qualified and answered sum above 4 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM three_USD_all
GROUP BY audience
HAVING SUM(answered) > 3 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--gcc and khaleeji good audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM three_USD_all
where audience ilike '%khaleeji%' or audience ilike '%GCC%' 
GROUP BY audience
HAVING SUM(answered) > 3 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--mashup good audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM three_USD_all
where audience ilike '%mashup%'
GROUP BY audience
HAVING SUM(answered) > 3 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--lookalike 1% good audience
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM three_USD_all
where audience ilike '%lookalike 1%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--lookalike 3% good audience
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM three_USD_all
where audience ilike '%lookalike 3%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--how many times each audience used from total ad sets opened
select audience, count(audience) as audience_repitition, round(count(audience)*100/377::numeric, 2) as audience_percentage_from_adsets
From three_USD_all
Group by audience
order by audience_percentage_from_adsets desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	round(count(audience)*100/377::numeric, 2) as audience_percentage_from_adsets,
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From three_USD_all
Group by audience
having count(audience) < 3 and SUM(answered) >0
order by audience_percentage_from_adsets desc;



---------------------------all accounts extraction (last 30 days)-----------------------------------------

Create table nawy_accounts (
account varchar(60),
final_delivery varchar(100), 
adset_budget numeric (10,2), 
project_name varchar(100), 	
trial varchar (200), 
audience text, 	
area varchar(200), 
total_leads	int, 
valid_leads int,
perc_valid_from_total numeric (10,2),	
perc_low_budget_from_total numeric (10,2),
answered int,	
perc_client_not_available_from_answered numeric (10,2),	
perc_answered_from_valid numeric (10,2),	
qualified int, 	
perc_qualified_from_valid	numeric (10,2),
perc_qualified_from_answered numeric (10,2),
m_scheduled	int,
m_happened	int,
amount_spent numeric (10,2)	,
cpa	numeric (10,2),
cpq	numeric (10,2)
); 

select * 
from nawy_accounts;


--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
GROUP BY audience
HAVING SUM(answered) > 10 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--gcc and khaleeji good audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM nawy_accounts
where audience ilike '%khaleeji%' or audience ilike '%GCC%' 
GROUP BY audience
HAVING SUM(answered) > 3 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--mashup good audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM nawy_accounts
where audience ilike '%ap%'
GROUP BY audience
HAVING SUM(answered) > 3 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--lookalike 1% good audience
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM nawy_accounts
where audience ilike '%lookalike 1%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--lookalike 3% good audience
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_count
FROM nawy_accounts
where audience ilike '%lookalike 3%'
GROUP BY audience
HAVING SUM(answered) > 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--ABUSED audiences(used more than 25 times) regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	round(count(audience)*100/377::numeric, 2) as audience_percentage_from_adsets,
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
Group by audience
HAVING count(audience)>25 AND SUM(answered) > 1
order by audience_percentage_from_adsets desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	round(count(audience)*100/377::numeric, 2) as audience_percentage_from_adsets,
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
Group by audience
having count(audience) < 9 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by audience_percentage_from_adsets desc;


----------------------COOING 1 ------------------

--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 1' --and audience ilike '%mega%'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <34 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 1'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--BEST AUDIENCES with gcc audiences 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 1' and (audience ilike '%Khaleeji%' or audience ilike '%gcc%')
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--BEST AUDIENCES with lookalike audiences 

SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 1' and audience ilike '%3%' 
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--BEST AUDIENCES with AP audiences 

SELECT 
    audience, trial, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 1' and (audience ilike '%AP%' or trial ilike '%AP') 
GROUP BY audience, trial
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 1'
Group by audience
HAVING count(audience)>10 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 1'
Group by audience
having count(audience) < 5 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;

---------COOING 2: -----------------


--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 2'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 2'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 2'
Group by audience
HAVING count(audience)>10 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 2'
Group by audience
having count(audience) < 5 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;



---------------cooing 3: ------------------

--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 3'
Group by audience
HAVING count(audience)>10 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 3'
Group by audience
having count(audience) < 5 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;


----------------------COOING 4 ------------------

--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 4'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 4'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 4'
Group by audience
HAVING count(audience)>10 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 4'
Group by audience
having count(audience) < 5 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;


---------COOING 7: -------------------

--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 7'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 7'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 7'
Group by audience
HAVING count(audience)>10 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 7'
Group by audience
having count(audience) < 5 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;



--------cooing 7 (usd)------------------


--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 7 (USD)'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 7 (USD)'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >35
ORDER BY count (audience);

--BEST AUDIENCES gcc/khaleeji
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 7 (USD)' and (audience ilike '%Khaleeji%' or audience ilike '%gcc%')
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--BEST AUDIENCES lookalike 3% 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 7 (USD)' and (audience ilike '%LOOKALIKE 1%')
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 7 (USD)'
Group by audience
HAVING count(audience)>10 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 7 (USD)'
Group by audience
having count(audience) < 6 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;


--------------cooing 3 (USD)------------------------

--WORST AUDIENCES IN LAST MONTH: 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3 (USD)' 
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) <35 and count (audience) >3
ORDER BY count (audience);


--BEST AUDIENCES above 37% qualified and answered sum above 3 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3 (USD)'
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >35
ORDER BY count (audience);

--BEST AUDIENCES gcc/khaleeji
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3 (USD)' and (audience ilike '%Khaleeji%' or audience ilike '%gcc%')
GROUP BY audience
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);

--BEST AUDIENCES lookalike 1% 
SELECT 
    audience, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3 (USD)' and (audience ilike '%LOOKALIKE 3%')
GROUP BY audience
HAVING SUM(answered) >= 5 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >35
ORDER BY count (audience);


--BEST AUDIENCES with AP audiences 

SELECT 
    audience, trial, SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage,
	count (audience) as audience_repitition
FROM nawy_accounts
where account = 'Cooing 3 (USD)' and (audience ilike '%AP%' or trial ilike '%AP') 
GROUP BY audience, trial
HAVING SUM(answered) >= 4 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) >37
ORDER BY count (audience);


--audiences used more than 10 times regardless of bad/good quality
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 3 (USD)'
Group by audience
HAVING count(audience)>5 AND SUM(answered) > 1
order by count(audience) desc;


--audiences we need to use more: 
select audience, count(audience) as audience_repitition, 
	SUM(answered) AS answered_sum, SUM(qualified) AS qualified_sum, 
    round((SUM(qualified) * 100.0 / SUM(answered)), 2) AS qualified_percentage
From nawy_accounts
where account = 'Cooing 3 (USD)'
Group by audience
having count(audience) <= 5 and SUM(answered) >0 AND round((SUM(qualified) * 100.0 / SUM(answered)), 2) > 33
order by count(audience) desc;

-----------------------------------------
select * from nawy_accounts; 

select * from nawy_accounts; 

truncate table nawy_accounts; 


ALTER TABLE nawy_accounts
ALTER COLUMN account TYPE varchar(100);


