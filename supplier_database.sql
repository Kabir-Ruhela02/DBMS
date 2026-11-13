create database supplier_1bm25cs149;
use supplier_1bm25cs149;

create table supplier(
	sid int primary key,
    sname varchar(20),
    city varchar(20)
);

create table part(
	pid int primary key,
    pname varchar(20),
    color varchar(20)
);

create table catalog(
	sid int, 
    pid int,
    cost int,
    foreign key(sid) references supplier(sid),
    foreign key(pid) references part(pid),
    primary key(sid, pid)
);

insert into supplier values
(10001, 'Acme Widget', 'Banglore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vinmal', 'Mumbai'), 
(10004, 'Reliance', 'Delhi');

insert into part values
(20001, 'Book', 'Red'), 
(20002, 'Pen', 'Red'), 
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

insert into catalog values
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

select * from supplier;
select * from part;
select * from catalog;

-- week 7
-- 3
select distinct p.pname as parts_name
from part p
inner join catalog c on c.pid = p.pid;

-- 4
select sname from supplier where sid in (
	select sid from catalog group by sid having count(*) =(
		select count(*) from part
    )
);

-- or

SELECT s.sname
FROM supplier s
INNER JOIN catalog c ON s.sid = c.sid
GROUP BY s.sid, s.sname
HAVING COUNT(c.pid) = (SELECT COUNT(*) FROM part);



-- 5
select s.sname
from supplier s
join catalog c on s.sid = c.sid
join part p on c.pid = p.pid 
where p.color = 'Red'
group by s.sid, s.sname
having count(c.pid) = (select count(*) from part where color = 'Red');

-- 6
select p.pname
from part p
join catalog c on p.pid = c.pid
join supplier s on c.sid = s.sid
group by p.pid, p.pname
having count(p.pid)=1 and max(s.sname) = 'Acme Widget';

-- 7
SELECT DISTINCT c.sid
FROM catalog c
WHERE c.cost > (
    SELECT AVG(c2.cost)
    FROM catalog c2
    WHERE c2.pid = c.pid
);

-- 8
SELECT p.pid, p.pname, s.sname, c.cost
FROM part p
JOIN catalog c ON p.pid = c.pid
JOIN supplier s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MAX(c1.cost)
    FROM catalog c1
    WHERE c1.pid = p.pid
)order by p.pid asc;


-- week 8
-- 1

select sid, sname 
from supplier 
where sid in (select sid from catalog where cost = (select max(cost) from catalog));


-- 2

select sid, sname
from supplier
where sid not in (
	select c.sid
    from catalog c
    join part p on c.pid = p.pid
    where p.color='Red'
);

-- 3
SELECT s.sid, s.sname, SUM(c.cost) AS total_value
FROM supplier s, catalog c
WHERE s.sid = c.sid
GROUP BY s.sid, s.sname;

-- 4
SELECT s.sid, s.sname
FROM supplier s, catalog c
WHERE s.sid = c.sid
AND c.cost < 20
GROUP BY s.sid, s.sname
HAVING COUNT(c.pid) >= 2;

-- 5
SELECT p.pid, p.pname, s.sid, s.sname, c.cost
FROM supplier s, part p, catalog c
WHERE s.sid = c.sid
AND p.pid = c.pid
AND c.cost = (
    SELECT MIN(c1.cost)
    FROM catalog c1
    WHERE c1.pid = p.pid
)
ORDER BY p.pid;
