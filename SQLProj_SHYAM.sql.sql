#CREATING DATABASE FOR PROJECT
CREATE database SQL_PROJECT;
USE SQL_PROJECT;



#CREATING BOOKS TABLE
create table books(
bookid int primary key auto_increment,
title varchar(50),
author varchar (50),
copiesavailable int not null 
) ;
alter table books auto_increment=1000;



#CREATING MEMBER TABL

create table members(
memberid int primary key auto_increment,
name varchar(35),
email varchar(100) not null unique,
membershipdate date not null
);
alter table members auto_increment=202401;




#CREATING TABLE RENTAL

create table rental(
rentalid int primary key auto_increment,
bookid int not null,
memberid  int not null ,
rentaldate date not null,
returndate date ,
foreign key (bookid) REFERENCES books(bookid), 
foreign key (memberid) REFERENCES members(memberid) 
);




#INSERTING SAMPLE VALUES IN MEMBERS
insert into members (name,EMAIL,membershipdate)      
value
("Akshy","akshay@email.com","2024-01-01"),  #-we have given email overhere to avoid error
("brown","brown@email.com","2024-01-02");


#INSERTING SAMPLE VALUES IN BOOKS
insert into books (title,author,copiesavailable)
values
("sql for beginners","john doe",3),
("database design","jane smith",5),
("Python Programming", "Guido van Rossum", 4),
("Machine Learning Basics", "Andrew Ng", 6),
("Data Science Essentials", "Jake VanderPlas", 5),
("Deep Learning with Python", "François Chollet", 3),
("SQL Mastery", "Ben Forta", 7),
("NoSQL Explained", "Pramod J. Sadalage", 4),
("Big Data Analytics", "Viktor Mayer-Schönberger", 5),
("Artificial Intelligence", "Stuart Russell", 6),
("Cloud Computing Fundamentals", "Rajkumar Buyya", 3),
("Cybersecurity for Beginners", "Bruce Schneier", 4),
("Business Intelligence Guide", "Cindi Howson", 5),
("Data Visualization with Tableau", "Joshua N. Milligan", 6),
("Excel for Data Analysis", "John Walkenbach", 7),
("Google BigQuery in Action", "Jordan Tigani", 5),
("Statistics for Data Science", "Nathan Yau",4);


#VARIFING SAMPLE DATA 
select * from members;
select * from BOOKS;


#CREATING STORE PROCEDURE WHEN A NEW MEMBER COMES IN AND GIVING CONDITION  ACCORDING HIS EXISTING 


delimiter $$
create procedure addnewmember(
in p_name varchar(35),
in p_email varchar(100),
in p_membershipdate date 
)
begin
declare existing int;
select count(*) into existing from members where email=p_email;


if existing > 0 then
SIGNAL   sqlstate "45000"
set message_text = "member already exist ";
    
    else 
               insert into members (name,email,membershipdate)
			values(p_Name, p_Email, p_MembershipDate);
    END IF;
END $$
delimiter ;

#TESTING THE NO. OF  MEMBERS
select * from MEMBERS;



#CALLING EXISTING MEMBER SHOWING="MEMBER ALREADY EXIST"
CALL ADDNEWMEMBER( "Akshy" , "akshay@email.com" , "2024-01-01");


#ADDING NEW MEMBER 
call addnewmember('John Doe', 'johndoe@example.com', '2024-03-09');
call addnewmember('Jack Merard', 'jack@example.com', '2025-03-09');



#CREATING STORE PROCEDURE FOR RENTING BOOKS

DELIMITER $$
create procedure rentbook(
in p_memberid int,
in p_bookid int,
in p_rentaldate date 
)
begin
declare Copies_Available int;

SELECT CopiesAvailable INTO Copies_Available FROM books WHERE BookID = p_BookID;


if Copies_Available < 1 then
	signal sqlstate "45000"
	set message_text= "isufficient quantity" ;
    
else  

		insert into rental (bookid,memberid,rentaldate)
		values	(p_bookid,p_memberid,p_rentaldate) ;
	
end if;
end $$
delimiter ;




#RENTING BOOK 
CALL RentBook(202401, 1000, '2024-03-11');
CALL RentBook(202401, 1001, '2024-03-11');


#CREATING TRIGGER UPDATING THE BOOKS QUANTITY IN CASE OF BORROWING 

DELIMITER $$
CREATE TRIGGER reduce_book_quantity
AFTER INSERT ON rental
FOR EACH ROW

BEGIN
    UPDATE books
    SET copiesavailable = copiesavailable - 1
   WHERE bookid = NEW.bookid;

END;
$$
DELIMITER ;


# TESTING THE QUANTITY REDUCED OR NOT 
SELECT * FROM books WHERE bookid = 1001;
SELECT*FROM MEMBERS;
SELECT*FROM BOOKS;
DROP PROCEDURE RENTBOOK ;


#CREATING PROCEDURE FOR RETURNING BOOKS
delimiter $$
create procedure returnbook(
in p_rentalid int ,
in p_returndate date
)

begin
    declare rental_exists int;
select count(*) into rental_exists from rental  
where rentalid =p_rentalid  and returndate is  null ;

if rental_exists<=0 then
signal sqlstate "45000"
set message_text = "rentalid not found  already returned ";

       else
             update rental 
             set returndate=p_returndate
             where rentalid =p_rentalid ;
             
  select " return succesfully " as message ;
end if;
end $$
delimiter ;

 
 
 #CREATING TRIIGER FOR RETURNING BOOKS

DELIMITER $$

CREATE TRIGGER increase_book_quantity_on_return
AFTER UPDATE ON rental
FOR EACH row
BEGIN
    IF OLD.returndate IS NULL AND NEW.returndate IS NOT NULL THEN
        UPDATE books
        SET copiesavailable = copiesavailable + 1
        WHERE bookid = NEW.bookid;
    END IF;
END;
$$

DELIMITER ;


#RETURNING THE BOOKS

call returnbook(2,"2024-03-12");
call returnbook(3,"2024-03-12");
call returnbook(5,"2024-03-12");


#CHECKING THE WHETHER BOOKS QUANTITY GOT  REDUCED OR NOT 

SELECT*FROM BOOKS ;
SELECT*FROM MEMBERS ;
SELECT * FROM rental WHERE memberid = 202401 AND returndate IS NULL;


#Books Not Rented or Borrowed:
#Identifies books that haven’t been borrowed yet.

SELECT  b.bookid,b.title,b.author,b.copiesavailable
from books b
left join rental r
 on b.bookid=r.bookid
 where r.bookid is null;

SELECT*FROM BOOKS;

#3. Member Activity Report:
#Displays each member’s Rental history.

select 
m.memberid ,m.name as member_name,
b.bookid,b.title,
r.rentaldate,r.returndate
from rental r
join  members m on  m.memberid=r.memberid 
join  books b on  b.bookid=r.bookid
order by m.memberid ,r.rentaldate ;



#PENALTY *5 PER DAY  
select
    r.rentalid,
    m.memberid,
    m.name AS member_name,
    b.bookid,
    b.title AS book_title,
    r.rentaldate,
    r.returndate,
    DATEDIFF(CURDATE(), r.rentaldate) - 7 AS overdue_days, 
    (DATEDIFF(CURDATE(), r.rentaldate) - 7) * 5 AS penalty_amount
FROM rental r
JOIN members m ON r.memberid = m.memberid
JOIN books b ON r.bookid = b.bookid
WHERE r.returndate IS NULL 
  AND DATEDIFF(CURDATE(), r.rentaldate) > 7
HAVING penalty_amount > 0;


#CHECK WHICH MEMBER RENTED BOOKS AND NOT RETURNED -- JUST FOR CONFIRMATION 
SELECT 
    r.rentalid,
    b.bookid,
    b.title AS book_title,
    m.memberid,
    m.name AS member_name,
    r.rentaldate
FROM rental r
JOIN books b ON r.bookid = b.bookid
JOIN members m ON r.memberid = m.memberid
WHERE r.returndate IS NULL;

