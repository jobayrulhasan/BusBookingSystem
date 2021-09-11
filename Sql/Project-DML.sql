Use BusBookingSystem
go
 -----------------------INSERT-------------------------
insert into Bus values(1,'Hanif','AC',40),
                      (2,'Green Line','Non AC',44),
	                  (3,'Samoli','AC',46),
	                  (4,'Saintmartin','AC',48),
	                  (5,'Trisha','Non AC',42),
	                  (6,'Landon Paribahan','AC',46),
	                  (7,'Dipzol Paribahan','Non AC',42),
	                  (8,'Lal Sabuj','Non AC',44),
	                  (9,'Jonaki Paribahan','AC',40),
	                  (10,'Unique','AC',46);
go

insert into [Route] values(1,'Chittagong','Saidabad','Agrabad'),
                          (2,'Comilla','TT Para','Sadar Comilla'),
	                      (3,'Tangail','Mohakhali','Korotia'),
	                      (4,'Serpur','Mohakhali','Serpur Sadar'),
	                      (5,'Jamalpur','Mohakhali','Jamalpur Sadar'),
	                      (6,'Maymensing','Uttara','Sadar Mymensing'),
	                      (7,'Noakhali','Malibag','Sonapur'),
	                      (8,'Chadpur','Jatrabari','Sadar Chadpur'),
	                      (9,'Feni','Motijheel','Mohipal'),
	                      (10,'Rangamati','Narayangonj','Sadar Rangamati');
go

insert into Schedule values(1,'8:30 AM','01:00 PM'),
                           (2,'02:00 PM','05:00 PM'),
	                       (3,'11:00 AM','02:00 PM'),
	                       (4,'06:00 AM','12:00 PM'),
	                       (5,'09:00 AM','03:00 PM'),
	                       (6,'04:00 AM','09:00 AM'),
	                       (7,'06:00 AM','11:00 AM'),
	                       (8,'07:00 AM','12:00 PM'),
	                       (9,'08:00 AM','01:00 PM'),
	                       (10,'06:00 AM','08:00 PM');
go

insert into BookingDetails values(1,'Aminul Ialam','Male','01750908755'),
                                 (2,'Shariful Islam','Male','01843432092'),
	                             (3,'Fatema Noor','Female','01683664666'),
	                             (4,'Kaoser Ahamed','Male','01759352188'),
	                             (5,'Jarin Khan','Female','01727516622'),
	                             (6,'Nobir Uddin','Male','01732532166'),
	                             (7,'Khaleda Akter','Female','01732253219'),
	                             (8,'Ahmed Abir','Male','01683664521'),
	                             (9,'Bahar Uddin','Male','01750305742'),
	                             (10,'Zamil Ahmed','Male','01780904721');
go

insert into ScheduleDetails values (1,'Morning'),
                                   (2,'Evening'),
	                               (3,'Morning'),
	                               (4,'Evening'),
	                               (5,'Morning'),
	                               (6,'Night'),
	                               (7,'Morning'),
	                               (8,'Morning'),
	                               (9,'Morning'),
	                               (10,'Morning')
go


insert into Relation values(1,1,1,1,1),
                           (4,3,5,10,6),
						   (2,6,7,4,4),
						   (3,4,3,6,2),
						   (5,2,4,3,5),
						   (6,5,2,5,2),
						   (7,9,6,7,7),
						   (8,7,9,4,8),
						   (9,10,8,2,10),
						   (10,8,10,8,9)                      
go

select * from Bus;
select * from [Route];
select * from Schedule;
select * from BookingDetails;
select * from ScheduleDetails;
select * from Relation

----------------Jonining Table-----------------------
Select Bus.BusID,BusType,SeatNo, [Route].RouteName,StartPoint,LastPoint,Schedule.DepartureTime,ArriveTime,BookingDetails.CustomerName,CustomerType,CustomerMobile,ScheduleDetails.ScheduleType
From Relation Join Bus on
Relation.BusID = Bus.BusID Join [Route] on
Relation.RouteID = [Route].RouteID Join Schedule on
Relation.ScheduleID = Schedule.ScheduleID Join BookingDetails on
Relation.BookingDetailsID = BookingDetails.BookingDetailsID join ScheduleDetails on 
Relation.ScheduleDetailsID = ScheduleDetails.ScheduleDetailsID
where BookingDetails.CustomerName = 'Zamil Ahmed';
go
---------------Jonining Table With Having---------------
Select Count(BusType) as Available,Bu.BusName,Ro.RouteName,Bo.CustomerName
From Relation Re 
Join Bus Bu on Re.BusID = Bu.BusID 
Join [Route] Ro on Re.RouteID = Ro.RouteID
Join BookingDetails Bo on Re.BookingDetailsID = Bo.BookingDetailsID
group by Bu.BusName, Ro.RouteName,Bo.CustomerName
having Bo.CustomerName = 'Fatema Noor';
go
------------Sub Query------------------
Select BookingDetails.CustomerName,BookingDetails.CustomerType,BookingDetails.CustomerMobile,Schedule.ArriveTime
From BookingDetails join Relation
On BookingDetails.BookingDetailsID = Relation.BookingDetailsID join 
Schedule on Schedule.ScheduleID = Relation.ScheduleID
Where CustomerName in (Select CustomerName from BookingDetails
Where BookingDetails.CustomerName = 'Jarin Khan')
go
----------------searched case function-----------------
Select  CASE
    WHEN BusID = 4 THEN 'Saintmartin AC'
    WHEN BusID = 8 THEN 'Lal sabuj non AC'
    WHEN BusID = 3 THEN 'Samoli AC'
    ELSE 'Not Found'
END AS [Column]
from Bus
Group by BusID;
go

------------------Insert Merge Value---------------
Insert into BusMerge
values (1, 'Hanif'),(2, 'Green Line'),(3, 'Samoli'),(4,'Saintmartin'),(5,'Trisha')
go
-------------------Update Merge Value--------------
MERGE INTO dbo.Bus as B
USING dbo.BusMerge as Mer
        ON B.BusID = Mer.BusID
WHEN MATCHED THEN
    UPDATE SET
      B.BusName = Mer.BusName
      WHEN NOT MATCHED THEN 
      INSERT (BusID, BusName)
      VALUES (Mer.BusID, Mer.BusName);
go
select * from BusMerge;
go

---------------- CTE ----------------------
with Ct_BusTotal(BusID,BusName) as (select Bus.BusID,count(BusName) as NumberOfBus
from Bus join Relation on Bus.BusID = Relation.BusID where BusName in (select BusName from Bus)
group by Bus.BusID)

select * from Ct_BusTotal;
go
------------Update Query-------------
Update Bus set BusName = 'Bolaka' where BusID = 2;

----------------Delete Query------------------
delete Bus  where BusID = 2;

------------Cast---------------------
select cast('01-Jan-2021' AS date)

----------------Convert----------------
SELECT Datetime = CONVERT(datetime,'01-Jan-2021 10:00:10.00')

--------------Thanks---------------