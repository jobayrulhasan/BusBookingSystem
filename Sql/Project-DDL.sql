go
use BusBookingSystem;
go
Create Database BusBookingSystem
on
(Name='BusBookingSystem_Data_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL13.SA\MSSQL\DATA\BusBookingSystem_Data_1.mdf',
Size=25mb,
Maxsize=80mb,
FileGrowth=5%
)
Log on
(Name='BusBookingSystem_Log_1',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL13.SA\MSSQL\DATA\BusBookingSystem_Log_1.ldf',
Size=10mb,
Maxsize=50mb,
FileGrowth=2%
)
GO

create table Bus
(
BusID int Primary key not null,
BusName Varchar (30),
BusType Varchar (30),
SeatNo numeric(30)
)
print('successfully created');
go

create table [Route]
(
RouteID int primary key not null,
RouteName varchar(30),
StartPoint varchar (30),
LastPoint varchar (30)
)
print('successfully created');
go
create table Schedule
(
ScheduleID int primary key,
DepartureTime time,
ArriveTime time,
)
print('successfully created');
go

Create table BookingDetails
(
BookingDetailsID int primary key not null,
CustomerName varchar (30),
CustomerType varchar (20),
CustomerMobile varchar (30)
)
print('successfully created');
go

Create table ScheduleDetails
(
ScheduleDetailsID int primary key not null,
ScheduleType varchar (20)
)
print('successfully created');
go

Create Table Relation
(
BusID int references Bus(BusID),
RouteID int references [Route](RouteID),
ScheduleID int references Schedule(ScheduleID),
BookingDetailsID int references BookingDetails(BookingDetailsID),
ScheduleDetailsID int references ScheduleDetails(ScheduleDetailsID))
print('successfully created');
go
---------- store procedure ----------------
Go
 Create Proc Sp_Bus
 @BusID Int,
 @BusName Varchar(20)

As
 Insert into Bus(BusID,BusName)
 values (@BusID,@BusName)
Go
Exec Sp_Bus 10,'Shahi'
Go
Create Proc Sp_Bus_Update
@BusID Int,
@BusName Varchar(50)
As
 Update Bus SET BusName = BusName
 WHERE BusID=@BusID
Go
EXEC Sp_Bus_Update 9,'Bolaka'
Go
Create Proc Sp_Bus_Delete
@BusID Int
As
DELETE FROM Bus WHERE BusID=@BusID
Go
EXEC Sp_Bus_Delete 5

Go
------------------Create NonClustered Index-------------
Create NonClustered Index ix_Bus_ID
on Bus(BusID)
go
------------------ table value function  --------------
Create Function fn_tableValue
()
Returns Table
Return
(
Select Count(BusName) as TotalBus, Ba.BusName, Ro.RouteName
From Relation Re 
Join Bus Ba on Re.BusID = Ba.BusID 
Join [Route] Ro on Re.RouteID = Ro.RouteID 
Group by Ba.BusName, Ro.RouteName
Having Ba.BusName = 'Hanif'
);
------view function-----
Select * From dbo.fn_tableValue();

------drop function-----
drop function dbo.fn_tableValue

go
-------------- scalar value function  --------------------
Create Function fn_Scalarvalue()
RETURNS int
AS 
BEGIN
	declare @BusID int;
	set @BusID = (select count(re.BusID) As NumberOfBus
	from Relation re join Bus bo on re.BusID = bo.BusID
	where bo.BusName = 'Saintmartin' group by re.BusID)
    RETURN @BusID;
END;

------view function-----
select dbo.fn_Scalarvalue();

------drop function-----
drop function fn_Scalarvalue

------------Create Merge------------------
create table BusMerge
(
BusID int Primary key not null,
BusName Varchar (30))
go
---------- Trigger---------------------------
create table BusTrigger
(BusID int primary key,
BusName varchar(50));
go
--------------Update Triggers---------------

drop trigger tr_Bus_insert
Create Trigger tr_Bus_insert
On Bus
After Insert, Update
As
Insert Into BusTrigger
(BusID,BusName)
Select 
Bt.BusID,Bt.BusName From inserted Bt;
go
------------Insert Trigger Value-------------

insert into Bus(BusID,BusName)
values(13,'Green Line1');
go


select * from BusTrigger;
select  * from Bus;
select * from tr_Bus_insert;

drop table Bus;
drop table BusTrigger;
drop trigger tr_Bus_insert;
go
--------------Create View -----------------
Create View vw_Bus
as
Select Bus.BusID, Count (BusName) As TotalBusNumber
From Bus JOIN Relation
On Bus.BusID = Relation.BusID
Where BusName IN (Select BusName from Bus)
Group by Bus.BusID
go
select * from vw_Bus;

drop view vw_Bus;

go
------------ The end --------------------