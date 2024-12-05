create table villas(
client_name varchar(500), 
email varchar (200), 
phone varchar (100)
); 

create table villas_gcc as(
select * from villas
where phone ilike '9%')	
; 


select * from villas_gcc; 
ALTER TABLE villas_gcc DROP COLUMN email;



create table top_leads_with_area1(
client_name varchar(500), 
phone varchar (100)
); 

create table top_leads_with_area_gcc as(
select * from top_leads_with_area1
where phone ilike '9%')	
; 


----------
create table mix_gcc_audiences1 as (
select * from villas_gcc
union 
select * from top_leads_with_area_gcc
union  
select * from uptown_cairo_owners_gcc
union  
select * from congrats_2022_gcc
union  
select * from sixth_of_october_gcc
union  
select * from congrats_reserved_gcc
union 
select * from presentations_2022_gcc
);   
---------

create table mix_ksa_audiences as(
select * from mix_gcc_audiences1
where phone ilike '966%'); 

select * from mix_ksa_audiences; 


UPDATE mix_gcc_audiences
SET phone = phone::BIGINT;



create table presentations_2022(
client_name varchar(500), 
phone varchar (100)
); 


create table presentations_2022_gcc as(
select * from presentations_2022
where phone ilike '9%'); 

create table presentations_2022_ksa as(
select * from presentations_2022_gcc
where phone ilike '966%')
; 

select * from presentations_2022_ksa; 

create table uptown_cairo_owners(
client_name varchar(500), 
phone varchar (100)
); 

create table uptown_cairo_owners_gcc as(
select * from uptown_cairo_owners
where phone ilike '9%'); 

select * from uptown_cairo_owners_gcc; 


UPDATE uptown_cairo_owners
SET phone = LTRIM(phone, '0');


create table congrats_2022(
client_name varchar(500), 
phone varchar (100)
);

create table congrats_2022_gcc as(
select * from congrats_2022
where phone ilike '9%'); 


select * from congrats_2022_gcc; 
	
UPDATE congrats_2022
SET phone = LTRIM(phone, '0');


create table sixth_of_october(
client_name varchar(500), 
phone varchar (100)
);

create table  sixth_of_october_gcc as(
select * from sixth_of_october
where phone ilike '9%'); 

select * from sixth_of_october_gcc; 


create table congrats_reserved_block_eoi(
client_name varchar(500), 
phone varchar (100)
);

create table congrats_reserved_gcc as(
select * from congrats_reserved_block_eoi
where phone ilike '9%');

select * from congrats_reserved_gcc; 
