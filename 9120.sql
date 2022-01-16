CREATE TABLE Production(
	ProID int primary key,
	ProName varchar(20)NOT NULL,
	ProDate date NOT NULL,
	ProSeatCost float NOT NULL CHECK(ProSeatCost >=0),
	Description varchar(50)
	);
	
INSERT INTO Production
VALUES (001, 'Disney''s Frozen', '2021-08-08', 50.5, 'children cartoon disney');
INSERT INTO Production
VALUES (002, 'Romeo and Juliet', '2021-08-10', 40.0, 'love');
INSERT INTO Production
VALUES (003, 'Lion King', '2021-09-10', 66.5, 'children cartoon disney');

CREATE TABLE Theatre(
	TheatreID int primary key,
	TheatreName varchar(50) NOT NULL,
	Capacity int CHECK(Capacity >= 1),
	Address varchar(50) NOT NULL,
	PostCode int CHECK(PostCode between 800 and 9999),
	Description varchar(500)
	);

INSERT INTO Theatre
VALUES (01, 'Theatre of Sydney', 500, 'Bennelong Point Sydney NSW', 2000, 'The Sydney Opera House is located in Sydney, Australia, and is one of the most distinctive buildings of the 20th century');

CREATE TABLE Performance(
	ProID int,
	StartTime time,
	EndTime time NOT NULL,
	TheatreID int NOT NULL,
	
	CONSTRAINT ProID_FK FOREIGN KEY (ProID)   REFERENCES Production (ProID) ON DELETE CASCADE,
	CONSTRAINT TheatreID_FK FOREIGN KEY (TheatreID)   REFERENCES Theatre (TheatreID) ON DELETE CASCADE,
	primary key(ProID,StartTime)
	);
	
INSERT INTO Performance
VALUES (001, '09:10:00', '11:00:00', 01);
INSERT INTO Performance
VALUES (002, '12:00:00', '13:30:00', 01);

	
CREATE TABLE Sections(
	TheatreID int ,
	SectionID char CHECK(SectionID in ('A','B','C','D','E')) ,
	Numbers int CHECK (Numbers >= 1),
	
	CONSTRAINT TheatreID_FK FOREIGN KEY (TheatreID)   REFERENCES Theatre (TheatreID) ON DELETE CASCADE,
	primary key(TheatreID,SectionID)
	);

INSERT INTO Sections
VALUES (01, 'A', 50);
INSERT INTO Sections
VALUES (01, 'B', 30);

CREATE TABLE seat(
	TheatreID int,
	SectionID char,
	SeatID int,
	SectionCost float CHECK(SectionCost >=0),
	Available BOOLEAN,
	primary key(TheatreID,SectionID,SeatID),
	CONSTRAINT TheatreID_FK FOREIGN KEY (TheatreID,SectionID)   REFERENCES Sections (TheatreID,SectionID) ON DELETE CASCADE

	);

INSERT INTO seat
VALUES (01, 'A', 05, 10.0, '1');
INSERT INTO seat
VALUES (01, 'B', 06, 12.0, '1');

CREATE TABLE Customer(
	CustomerID int primary key,
	PhoneNo bigint NOT NULL,
	Email varchar(50),
	FirstName varchar(10) NOT NULL,
	LastName varchar(10) NOT NULL
	);

INSERT INTO Customer
VALUES (1001, 0415111111, '0415111111@gmail.com', 'Joe', 'Doe');
INSERT INTO Customer
VALUES (1002, 0415222222, '0415222222@outlook.com', 'Jack', 'Potter');
	
CREATE TABLE Ticket(
	SeatID int,
	SectionID char,
	ProID int,
	StartTime time,
	TheatreID int,
	CustomerID int NOT NULL,
	BookingTime time CHECK(BookingTime < StartTime),
	TotalCost float CHECK (TotalCost >= 0),
	primary key(SeatID,SectionID,ProID,StartTime,TheatreID),
	CONSTRAINT SeatID_FK FOREIGN KEY (SeatID,TheatreID,SectionID)   REFERENCES seat (SeatID,TheatreID,SectionID)ON DELETE CASCADE,
	CONSTRAINT SectionID_FK FOREIGN KEY (StartTime,ProID)   REFERENCES Performance (StartTime,ProID)ON DELETE CASCADE,
	CONSTRAINT CustomerID_FK FOREIGN KEY (CustomerID)   REFERENCES Customer (CustomerID)ON DELETE CASCADE
	);
	
INSERT INTO Ticket
VALUES (05, 'A', 001, '09:10:00', 01, 1001, '06:00:00', 60.5);

	
CREATE TABLE Payment(
	PaymentID int primary key,
	CustomerID int,
	Method varchar(10) NOT NULL,
	CONSTRAINT CustomerID_FK FOREIGN KEY (CustomerID)   REFERENCES Customer (CustomerID)ON DELETE CASCADE
	);
	
insert into Payment values (11001, 1001, 'GiftCard');
insert into Payment values (11002, 1001, 'Voucher');
insert into Payment values (11003, 1001, 'CreditCard');

CREATE TABLE GiftCard(
	PaymentID int primary key,
	CustomerID int NOT NULL,
	"15DigitNo" bigint UNIQUE CHECK("15DigitNo" between 100000000000000 and 999999999999999),
	PIN int NOT NULL,
	CONSTRAINT CustomerID_FK FOREIGN KEY (CustomerID)   REFERENCES Customer (CustomerID)ON DELETE CASCADE,
	CONSTRAINT PaymentID_FK FOREIGN KEY (PaymentID)   REFERENCES Payment (PaymentID)ON DELETE CASCADE
	);
	
insert into GiftCard values (11001, 1001, 100000000000001, 123456);

CREATE TABLE Voucher(
	PaymentID int primary key,
	CustomerID int NOT NULL,
	UniCode bigint UNIQUE,
	ExpiryDate date NOT NULL,
	CONSTRAINT CustomerID_FK FOREIGN KEY (CustomerID)   REFERENCES Customer (CustomerID)ON DELETE CASCADE,
	CONSTRAINT PaymentID_FK FOREIGN KEY (PaymentID)   REFERENCES Payment (PaymentID)ON DELETE CASCADE	);

insert into Voucher values(11001, 1001, 666, '2023-01-01');

	
CREATE TABLE CreditCard(
	PaymentID int primary key,
	CustomerID int NOT NULL,
	Holder varchar(20) NOT NULL,
	CardNo int UNIQUE,
	ExpiryDate date NOT NULL,
	CONSTRAINT CustomerID_FK FOREIGN KEY (CustomerID)   REFERENCES Customer (CustomerID)ON DELETE CASCADE,
	CONSTRAINT PaymentID_FK FOREIGN KEY (PaymentID)   REFERENCES Payment (PaymentID)ON DELETE CASCADE);
insert into CreditCard values(11001, 1001, 'Joe Doe', 45612354, '2025-01-01');

SELECT SUM(sectioncost)+Sum(ProSeatCost), CustomerID
FROM ticket natural join seat natural join customer natural join sections natural join production natural join performance
group by customerID
