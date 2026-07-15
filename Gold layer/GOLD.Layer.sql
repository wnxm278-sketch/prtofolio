CREATE SCHEMA Gold;
GO
CREATE TABLE GOLD.DimCity
(
    CityKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CityName NVARCHAR(50) NOT NULL
);
GO

INSERT INTO GOLD.DimCity (CityName)
SELECT DISTINCT City
FROM Silver.Airbnb;


CREATE TABLE GOLD.DimRoomType
(
    RoomTypeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RoomType NVARCHAR(50) NOT NULL,
    IsSharedRoom BIT NOT NULL,
    IsPrivateRoom BIT NOT NULL
);
GO

INSERT INTO GOLD.DimRoomType
(
    RoomType,
    IsSharedRoom,
    IsPrivateRoom
)
SELECT DISTINCT
    RoomType,
    IsSharedRoom,
    IsPrivateRoom
FROM SILVER.Airbnb;





CREATE TABLE GOLD.DimDayType
(
    DayTypekey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DayType NVARCHAR(20) NOT NULL
);


INSERT INTO GOLD.DimDayType (DayType)
SELECT DISTINCT DayType
FROM SILVER.Airbnb;



CREATE TABLE GOLD.FactAirbnb
(
    AirbnbID INT NOT NULL PRIMARY KEY,

    CityKey INT NOT NULL,
    RoomTypeKey INT NOT NULL,
    DayTypeKey INT NOT NULL,

    Price DECIMAL(10,2),
    PersonCapacity TINYINT,
    Bedrooms TINYINT,

    CleanlinessRating TINYINT,
    GuestSatisfaction TINYINT,

    CityCenterDistance DECIMAL(8,2),
    MetroDistance DECIMAL(8,2),

    AttractionIndex DECIMAL(10,2),
    AttractionIndexNormalized DECIMAL(10,2),

    RestaurantIndex DECIMAL(10,2),
    RestaurantIndexNormalized DECIMAL(10,2),

    Longitude DECIMAL(9,6),
    Latitude DECIMAL(9,6),

    IsSuperHost BIT,
    IsMultiListing BIT,
    IsBusinessListing BIT
);
INSERT INTO GOLD.FactAirbnb
(
    AirbnbID,
    CityKey,
    RoomTypeKey,
    DayTypeKey,
    Price,
    PersonCapacity,
    Bedrooms,
    CleanlinessRating,
    GuestSatisfaction,
    CityCenterDistance,
    MetroDistance,
    AttractionIndex,
    AttractionIndexNormalized,
    RestaurantIndex,
    RestaurantIndexNormalized,
    Longitude,
    Latitude,
    IsSuperHost,
    IsMultiListing,
    IsBusinessListing
)

SELECT
    S.AirbnbID,
    C.CityKey,
    R.RoomTypeKey,
    D.DayTypeKey,
    S.Price,
    S.PersonCapacity,
    S.Bedrooms,
    S.CleanlinessRating,
    S.GuestSatisfaction,
    S.CityCenterDistance,
    S.MetroDistance,
    S.AttractionIndex,
    S.AttractionIndexNormalized,
    S.RestaurantIndex,
    S.RestaurantIndexNormalized,
    S.Longitude,
    S.Latitude,
    S.IsSuperHost,
    S.IsMultiListing,
    S.IsBusinessListing

FROM SILVER.Airbnb AS S

JOIN GOLD.DimCity AS C
ON S.City = C.CityName

JOIN GOLD.DimRoomType AS R
ON S.RoomType = R.RoomType
AND S.IsSharedRoom = R.IsSharedRoom
AND S.IsPrivateRoom = R.IsPrivateRoom

JOIN GOLD.DimDayType AS D
ON S.DayType = D.DayType;
GO


ALTER TABLE GOLD.FactAirbnb ADD CONSTRAINT FK_FACT_DimCity
FOREIGN key (CityKey) 
REFERENCES Gold.DimCity(CityKey)


ALTER TABLE GOLD.FactAirbnb ADD CONSTRAINT FK_Fact_DimRoomType
FOREIGN KEY (RoomTypeKey)
REFERENCES GOLD.DimRoomType(RoomTypeKey);

ALTER TABLE GOLD.FactAirbnb ADD CONSTRAINT FK_Fact_DimDayType
FOREIGN KEY (DayTypeKey)
REFERENCES GOLD.DimDayType(DayTypeKey);


CREATE index IX_FACT_CityKey on GOLD.FactAirbnb(CityKey);
CREATE index IX_FACT_RoomTypekey on GOLD.FactAirbnb(RoomTypeKey);
CREATE index IX_FACT_DayTypekey on GOLD.FactAirbnb(DayTypekey);

