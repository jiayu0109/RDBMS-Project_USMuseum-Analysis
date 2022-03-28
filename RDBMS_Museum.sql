--- Module 9 
--- I combine all past project-check assignment altogether as my final project work (From module 6)
--- 0. Create database with student number: IMT_PROJ_2075507
USE MASTER
GO
DECLARE @db_Name varchar(500) = 'IMT_PROJ_2075507'
DECLARE @drop_db varchar(50)
DECLARE @create_db varchar(250)

SET @drop_db = N'DROP DATABASE ' + @db_Name;
SET @create_db = N'CREATE DATABASE ' + @db_Name;

IF EXISTS (SELECT * FROM sys.sysdatabases WHERE NAME = @db_Name)
	BEGIN
	PRINT 'database ' + @db_name  + ' exists...dropping ' + @db_Name  + ' and re-creating it for this module'
		EXECUTE (@drop_db)
		EXECUTE (@create_db)

	PRINT 'database ' + @db_Name  + ' has been dropped and re-created'
	END
ELSE
	BEGIN
		PRINT 'database ' + @db_Name  + ' does not exist and is being created';
		EXECUTE (@create_db)

	END

GO

USE  IMT_PROJ_2075507
GO

--- 1. CREATE TABLEs
--- ### 1st table ### ---
CREATE TABLE tblMuseum_Type
(MuseumTypeID INTEGER IDENTITY(1,1) primary key,
MuseumTypeName varchar(100) not null
)
GO
PRINT 'tblMuseum_Type has been created'
PRINT ''

--- ### 2nd table ### ---
CREATE TABLE tblInstitution_Type
(InstitutionID INTEGER IDENTITY(1,1) primary key,
InstitutionName varchar(100) not null
)
GO
PRINT 'tblInstitution_Type has been created'
PRINT ''

--- ### 3rd table ### ---
CREATE TABLE tblStates
(StateID INTEGER IDENTITY(1,1) primary key,
StateName varchar(5) not null
)
GO
PRINT 'tblStates has been created'
PRINT ''


--- ### 4th table ### ---
CREATE TABLE tblTaxInfo
(TaxPeriodID INTEGER IDENTITY(1,1) primary key,
TaxPeriod date not null
)
GO
PRINT 'tblTaxInfo has been created'
PRINT ''

--- ### 5th table ### ---
CREATE TABLE tblCity
(CityID INTEGER IDENTITY(1,1) primary key,
CityName varchar(50) not null,
StateID INTEGER FOREIGN KEY REFERENCES tblStates (StateID) not null
)
GO
PRINT 'tblCity has been created'
PRINT ''


--- ### 6th table ### ---
CREATE TABLE tblCounty
(CountyID INTEGER IDENTITY(1,1) primary key,
CountyName varchar(50) not null,
StateID INTEGER FOREIGN KEY REFERENCES tblStates (StateID) not null
)
GO
PRINT 'tblCounty has been created'
PRINT ''


--- ### 7th table ### ---
CREATE TABLE tblLocation
(LocationID INTEGER IDENTITY(1,1) primary key,
Longitude varchar(50) not null,
Latitude varchar(50) not null,
CountyID INTEGER FOREIGN KEY REFERENCES tblCounty (CountyID) not null,
CityID INTEGER FOREIGN KEY REFERENCES tblCity (CityID) not null
)
GO
PRINT 'tblLocation has been created'
PRINT ''


--- ### 8th table ### ---
CREATE TABLE tblMUSEUM
(MuseumID INTEGER IDENTITY(1,1) primary key,
MuseumName varchar(50) not null,
MuseumTypeID INTEGER FOREIGN KEY REFERENCES tblMuseum_Type (MuseumTypeID) not null,
LegalName varchar(50) not null,
InstitutionID INTEGER FOREIGN KEY REFERENCES tblInstitution_Type (InstitutionID) null,
PhoneNumber varchar(50) null,
StreetAdr_Admin varchar(100) not null,
CityID_Admin INTEGER FOREIGN KEY REFERENCES tblCity (CityID) not null,
ZipCode_Admin varchar(12) not null,
StreetAdr_Phy varchar(100) null,
CityID_Phy INTEGER FOREIGN KEY REFERENCES tblCity (CityID) null,
ZipCode_Phy varchar(12) null,
LocationID INTEGER FOREIGN KEY REFERENCES tblLocation (LocationID) not null,
EmployerID varchar(20) null
)

GO
PRINT 'tblMUSEUM has been created'
PRINT ''
--- Note1. Not every museum has an institution behind it, so some institution columns would be null.
--- Note2. Not every museum has physical address listed, so some physical address related columns would be null.
--- Note3. Not every museum has EmployerID listed, so some EmployerID columns would be null.

--- ### 9th table ### ---
CREATE TABLE tblSales
(SalesID INTEGER IDENTITY(1,1) primary key,
Income Numeric(16) not null,
Revenue Numeric(16) not null,
MuseumID INTEGER FOREIGN KEY REFERENCES tblMUSEUM (MuseumID) not null,
TaxPeriodID INTEGER FOREIGN KEY REFERENCES tblTaxInfo (TaxPeriodID) not null
)
GO
PRINT 'tblSales has been created'
PRINT ''


--- 2. Code INSERT INTO statements (five rows) for each table that does not have a foreign key.
--- ### insert into tblMuseum_Type table ### ---
INSERT INTO tblMuseum_Type (MuseumTypeName)
VALUES ('ARBORETUM, BOTANICAL GARDEN, OR NATURE CENTER'), ('ART MUSEUM'), ('CHILDRENS MUSEUM'), ('GENERAL MUSEUM'), ('HISTORIC PRESERVATION')
PRINT '5 rows added to tblMuseum_Type'

--- ### insert into tblInstitution_Type table ### ---
INSERT INTO tblInstitution_Type (InstitutionName)
VALUES ('ALABAMA A & M UNIVERSITY'), ('ALABAMA SOUTHERN COMMUNITY COLLEGE'), ('ALASKA PACIFIC UNIVERSITY'), ('ATHENS STATE UNIVERSITY'), ('AUBURN UNIVERSITY')
PRINT '5 rows added to tblInstitution_Type'

--- ### insert into tblStates table ### ---
INSERT INTO tblStates (StateName)
VALUES ('AK'), ('AL'), ('AR'), ('AZ'), ('CA')
PRINT '5 rows added to tblStates'

--- ### insert into tblTaxInformation table ### ---
INSERT INTO tblTaxInfo (TaxPeriod)
VALUES ('2009-12-01'), ('2011-09-01'), ('2011-12-01'), ('2012-06-01'), ('2012-12-01')
PRINT '5 rows added to tblTaxInfo'
GO

--- 3. Project requirement: Write the SQL code to create at least two (2) stored procedures to populate transactional tables.
--- Here I build 5 stored procedure to INSERT a new row in tables in my project that has a foreign key
--- ### (1) store procedure for tblCounty table ### ---
CREATE PROCEDURE uspGetStateID
@StName varchar(5),
@St_ID INT OUTPUT
AS
SET @St_ID = (SELECT StateID FROM tblStates WHERE StateName = @StName)
GO

CREATE PROCEDURE uspINSERT_County
@StateName varchar(5),
@CountyName varchar(50)
AS

DECLARE @State_ID INT

EXEC uspGetStateID
@StName = @StateName,
@St_ID = @State_ID OUTPUT

INSERT INTO tblCounty (CountyName, StateID)
VALUES (@CountyName, @State_ID)
GO

--- ### (2) store procedure for tblCity table ### ---
-- Note: PROCEDURE uspGetStateID is already created
CREATE PROCEDURE uspINSERT_City
@StateName varchar(5),
@CityName varchar(50)
AS

DECLARE @State_ID INT

EXEC uspGetStateID
@StName = @StateName,
@St_ID = @State_ID OUTPUT

INSERT INTO tblCity (CityName, StateID)
VALUES (@CityName, @State_ID)
GO

--- ### (3) store procedure for tblLocation table ### ---
CREATE PROCEDURE uspGetCountyID
@Ct_N varchar(50),
@Ct_ID INT OUTPUT
AS
SET @Ct_ID = (SELECT CountyID FROM tblCounty WHERE CountyName = @Ct_N)
GO

CREATE PROCEDURE uspGetCityID
@C_N varchar(50),
@C_ID INT OUTPUT
AS
SET @C_ID = (SELECT CityID FROM tblCity WHERE CityName = @C_N)
GO

CREATE PROCEDURE uspINSERT_Location
@County_N varchar(50),
@City_N varchar(50),
@Long varchar(50),
@Lat varchar(50)
AS

DECLARE @County_ID INT, @City_ID INT

EXEC uspGetCountyID
@Ct_N = @County_N,
@Ct_ID = @County_ID OUTPUT

EXEC uspGetCityID
@C_N = @City_N,
@C_ID = @City_ID OUTPUT

INSERT INTO tblLocation (Longitude, Latitude, CountyID, CityID)
VALUES (@Long, @Lat, @County_ID, @City_ID)
GO

--- ### (4) store procedure for tblMuseum table ### ---
CREATE PROCEDURE uspGetLocationID
@Long varchar(50),
@Lat varchar(50),
@L_ID INT OUTPUT
AS
SET @L_ID = (SELECT LocationID FROM tblLocation WHERE Longitude = @Long and Latitude = @Lat)
GO

CREATE PROCEDURE uspGetInstitutionID
@I_N varchar(100),
@I_ID INT OUTPUT
AS
SET @I_ID = (SELECT InstitutionID FROM tblInstitution_Type WHERE InstitutionName = @I_N)
GO

CREATE PROCEDURE uspGetMuseumTypeID
@MT_N varchar(100),
@MT_ID INT OUTPUT
AS
SET @MT_ID = (SELECT MuseumTypeID FROM tblMuseum_Type WHERE MuseumTypeName = @MT_N)
GO

CREATE PROCEDURE uspINSERT_MUSEUM
@Longitude varchar(50),
@Latitude varchar(50),
@Insti_N varchar(100),
@MType_N varchar(100),
@City_N_Ad varchar(50),
@City_N_Phy varchar(50),
@Museum_N varchar(50),
@LegalName varchar(50),
@PhoneNumber varchar(50),
@StreetAdr_Ad varchar(100),
@ZC_Ad varchar(12),
@StreetAdr_Phy varchar(100),
@ZC_Phy varchar(12),
@Emp_ID varchar(20)
AS

DECLARE @Location_ID INT, @Insti_ID INT, @MType_ID INT, @City_ID_Ad INT, @City_ID_Phy INT

EXEC uspGetLocationID
@Long = @Longitude,
@Lat = @Latitude,
@L_ID = @Location_ID OUTPUT

EXEC uspGetInstitutionID
@I_N = @Insti_N,
@I_ID = @Insti_ID OUTPUT

EXEC uspGetMuseumTypeID
@MT_N = @MType_N,
@MT_ID = @MType_ID OUTPUT

EXEC uspGetCityID
@C_N = @City_N_Ad,
@C_ID = @City_ID_Ad OUTPUT

EXEC uspGetCityID
@C_N = @City_N_Phy,
@C_ID = @City_ID_Phy OUTPUT

INSERT INTO tblMuseum (MuseumName, MuseumTypeID, LegalName, InstitutionID, PhoneNumber, StreetAdr_Admin, CityID_Admin,
ZipCode_Admin, StreetAdr_Phy, CityID_Phy, ZipCode_Phy, LocationID, EmployerID)
VALUES (@Museum_N, @MType_ID, @LegalName, @Insti_ID, @PhoneNumber, @StreetAdr_Ad, @City_ID_Ad, @ZC_Ad, @StreetAdr_Phy,
@City_ID_Phy, @ZC_Phy, @Location_ID, @Emp_ID)
GO

--- ### (5) store procedure for tblSales table ### ---
CREATE PROCEDURE uspGetMuseumID
@M_N varchar(50),
@Leg_N varchar(50),
@M_ID INT OUTPUT
AS
SET @M_ID = (SELECT MuseumID FROM tblMUSEUM WHERE MuseumName = @M_N and LegalName = @Leg_N)
GO

CREATE PROCEDURE uspGetTaxPeriodID
@TP date,
@TP_ID INT OUTPUT
AS
SET @TP_ID = (SELECT TaxPeriodID FROM tblTaxInfo WHERE TaxPeriod = @TP)
GO

CREATE PROCEDURE uspINSERT_Sales
@Museum_N varchar(50),
@Legal_N varchar(50),
@Tax_P date,
@Inc Numeric(16),
@Rev Numeric(16)
AS

DECLARE @Museum_ID INT, @TaxP_ID INT

EXEC uspGetMuseumID
@M_N = @Museum_N,
@Leg_N = @Legal_N,
@M_ID = @Museum_ID OUTPUT

EXEC uspGetTaxPeriodID
@TP = @Tax_P,
@TP_ID = @TaxP_ID OUTPUT

INSERT INTO tblSales (Income, Revenue, MuseumID, TaxPeriodID)
VALUES (@Inc, @Rev, @Museum_ID, @TaxP_ID)
GO

--- 4. Project requirement: Write the SQL code to create two (2) business rules

--- (1)
ALTER TABLE tblLocation
ADD CONSTRAINT CHK_null CHECK (Latitude IS NOT NULL AND Longitude IS NOT NULL);

--- (2)
ALTER TABLE tblSales
ADD CONSTRAINT CHK_income CHECK (Income > 0);


--- 5. Project requirement: Write the SQL code to create two (2) computed columns leveraging UDFs.

--- (1)
GO
CREATE FUNCTION RevCheck (@Revenue Numeric(16))
RETURNS VARCHAR(10) AS
BEGIN
    DECLARE @return_value VARCHAR(10);
    SET @return_value = 'balance';
    IF (@Revenue > 0) SET @return_value = 'positive';
    IF (@Revenue < 0) SET @return_value = 'negative';
    RETURN @return_value
END
GO

--- (2)
CREATE FUNCTION calcuCost (@Income Numeric(16), @Revenue Numeric(16))
RETURNS Numeric(16) AS
BEGIN
	RETURN (@Income - @Revenue)
END
GO


--- 6. Project requirement: Write the SQL code to create two (2) different complex queries.
--- (1) The goal is to check top 5 museums with best financial condition(judging by income) by city in U.S.A..
SELECT TOP 5 C.CityName, St.StateName, SUM(Income) as Income, SUM(Revenue) as Revenue, SUM(Cost) as Cost
FROM (SELECT *, dbo.calcuCost(tblSales.Income, tblSales.Revenue) as Cost FROM tblSales) S
LEFT JOIN tblMUSEUM M ON S.MuseumID = M.MuseumID
JOIN tblCity C ON C.CityID = M.CityID_Admin
JOIN tblStates St ON St.StateID = C.StateID
GROUP BY C.CityName, St.StateName
ORDER BY SUM(Income) DESC

--- (2) The goal is to check top 3 types of museum earning highest income in Alaska in 2014.
SELECT TOP 3 Mt.MuseumTypeName, M.MuseumName, SUM(Income) as Income
FROM tblMUSEUM M
JOIN tblSales S ON S.MuseumID = M.MuseumID
JOIN tblCity C ON C.CityID = M.CityID_Admin
JOIN tblStates St ON St.StateID = C.StateID
JOIN tblTaxInfo T ON T.TaxPeriodID = S.TaxPeriodID
JOIN tblMuseum_Type Mt ON Mt.MuseumTypeID = M.MuseumTypeID
WHERE St.StateName = 'AK'
AND YEAR(T.TaxPeriod) = 2014
GROUP BY Mt.MuseumTypeName, M.MuseumName
ORDER BY SUM(Income) DESC
