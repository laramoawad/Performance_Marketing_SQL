create table list1 (
	phone_number text
); 


select * 
from list1; 

--remove spaces in numbers 
with cte as (
SELECT phone_number, REPLACE(phone_number, ' ', '') AS cleaned_phone_number
FROM list1)
select cleaned_phone_number
from cte
;


UPDATE list1
SET phone_number = REPLACE(phone_number, ' ', '');


select * from list1; 

UPDate list 1
set phone number to start with 20
where phone_number is in(
select phone_number 
from list1
where phone_number ilike '002%'); 


UPDATE list1
SET phone_number = '20' || SUBSTRING(phone_number FROM 4)
WHERE phone_number LIKE '002%';

select * from list1; 


select phone_number 
from list1
where phone_number ilike '002%'; 

DELETE FROM list1
WHERE phone_number = '20020101303333';

insert into list1 values ('20101303333')

UPDATE list1
SET phone_number = '2' || SUBSTRING(phone_number FROM 3)
WHERE phone_number LIKE '200%';


select * from list1; 


delete from list1 where phone_number in(
select phone_Number, length(phone_number)
from list1
where (length(phone_number) <12 and phone_number like '20%')); 



delete from list1 where phone_number in(
select phone_Number
from list1
where (length(phone_number) >12 and phone_number like '20%'))


UPDATE list1
SET phone_number = '20' || phone_number
WHERE phone_number LIKE '11%';


select * from list1
where phone_number LIKE '2015%';


select phone_Number
from list1
where (length(phone_number) =12 and phone_number like '20%')


create view egyptian_numbers as(
select phone_Number
from list1
where (length(phone_number) =12 and phone_number like '20%')	
);


select *
from list1
where phone_number not like '20%';

DELETE FROM list1;


select * from list1; 


update list1
set phone_number substring(phone_number from 2)


UPDATE list1
SET phone_number = SUBSTRING(phone_number FROM 3);

update list1
set phone_number = '+' || SUBSTRING(phone_number FROM 1)


UPDATE list1
SET phone_number = '+' || phone_number;


alter table list1
rename to custom_list_ali_rafe3; 

select * from custom_list_ali_rafe3;


create table copy_custom_list_ali_rafe3 (
	phone_number text
); 


select * from copy_custom_list_ali_rafe3;

insert into copy_custom_list_ali_rafe3 values('00201001021184'); 


select * from copy_custom_list_ali_rafe3
where phone_number= '00201001021184';




select * from copy_custom_list_ali_rafe3; 

select *, substring(phone_number from 3) 
	from copy_custom_list_ali_rafe3; 

update copy_custom_list_ali_rafe3
set phone_number = substring(phone_number from 3) ; 


update copy_custom_list_ali_rafe3
set phone_number = '+' || phone_number ; 




-------------------

create table presentations_ds(
	phone_number text
); 


select * from presentations_ds; 


UPDATE presentations_ds
SET phone_number = '2' || trim(phone_number)
WHERE phone_number ILIKE '010%' 
   OR phone_number ILIKE '011%' 
   OR phone_number ILIKE '012%' 
   OR phone_number ILIKE '015%';



UPDATE presentations_ds
SET phone_number = '20' || trim(phone_number)
where phone_number ilike '10%'
   OR phone_number ILIKE '11%' 
   OR phone_number ILIKE '12%' 
   OR phone_number ILIKE '15%';

select * from presentations_ds
where phone_number ~ '[^0-9]';

DELETE FROM presentations_ds
WHERE phone_number ~ '[^0-9]';

UPDATE presentations_ds
SET phone_number = regexp_replace(phone_number, '^\+', '')
WHERE phone_number LIKE '+%';


UPDATE presentations_ds
SET phone_number = regexp_replace(phone_number, '\s', '', 'g')
WHERE phone_number ~ '\s';


select * from presentations_ds
; 



--------------------

--MEETINGS: 

create table meetings_ds(
	phone text
); 


select * from meetings_ds; 


UPDATE meetings_ds
SET phone = '2' || trim(phone)
WHERE phone ILIKE '010%' 
   OR phone ILIKE '011%' 
   OR phone ILIKE '012%' 
   OR phone ILIKE '015%';



UPDATE meetings_ds
SET phone = '20' || trim(phone)
WHERE phone ILIKE '10%'
   OR phone ILIKE  '11%' 
   OR phone ILIKE  '12%' 
   OR phone ILIKE  '15%';

select * from meetings_ds
where phone ~ '[^0-9]';

DELETE FROM meetings_ds
WHERE phone ~ '[^0-9]';

UPDATE meetings_ds
SET phone = regexp_replace(phone, '^\+', '')
WHERE phone LIKE '+%';


UPDATE meetings_ds
SET phone = regexp_replace(phone, '\s', '', 'g')
WHERE phone ~ '\s';


select * from meetings_ds; 
; 

truncate table meetings_ds; 



-------------------------


--Congrats: 

create table contraction_ds(
	phone text
); 


select * from contraction_ds; 


UPDATE contraction_ds
SET phone = '2' || trim(phone)
WHERE phone ILIKE '010%' 
   OR phone ILIKE '011%' 
   OR phone ILIKE '012%' 
   OR phone ILIKE '015%';



UPDATE contraction_ds
SET phone = '20' || trim(phone)
WHERE phone ILIKE '10%'
   OR phone ILIKE  '11%' 
   OR phone ILIKE  '12%' 
   OR phone ILIKE  '15%';

select * from contraction_ds
where phone ~ '[^0-9]';

DELETE FROM contraction_ds
WHERE phone ~ '[^0-9]';




select * from contraction_ds
; 

truncate table meetings_ds; 
