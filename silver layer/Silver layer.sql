CREATE SCHEMA Silver;
GO



SELECT
    IDENTITY(INT,1,1) AS AirbnbID,
    TRY_CAST(realSum AS DECIMAL(10,2))              AS Price,
    NULLIF(LTRIM(RTRIM(room_type)), '')             AS RoomType,
    TRY_CAST(room_shared AS BIT)                    AS IsSharedRoom,
    TRY_CAST(room_private AS BIT)                   AS IsPrivateRoom,
   TRY_CAST(TRY_CAST(person_capacity AS FLOAT) AS TINYINT) AS PersonCapacity,
    TRY_CAST(host_is_superhost AS BIT)              AS IsSuperHost,
    TRY_CAST(multi AS BIT)                          AS IsMultiListing,
    TRY_CAST(biz AS BIT)                            AS IsBusinessListing,
    TRY_CAST( try_cast (cleanliness_rating AS float)as tinyint)         AS CleanlinessRating,
    TRY_CAST(TRY_CAST (guest_satisfaction_overall AS float) AS Tinyint) As GuestSatisfaction,
    TRY_CAST( bedrooms AS INT)                     AS Bedrooms,
    TRY_CAST(dist AS DECIMAL(8,2))                  AS CityCenterDistance,
    TRY_CAST(metro_dist AS DECIMAL(8,2))            AS MetroDistance,
    TRY_CAST(attr_index AS DECIMAL(10,2))           AS AttractionIndex,
    TRY_CAST(attr_index_norm AS DECIMAL(10,2))      AS AttractionIndexNormalized,
    TRY_CAST(rest_index AS DECIMAL(10,2))           AS RestaurantIndex,
    TRY_CAST(rest_index_norm AS DECIMAL(10,2))      AS RestaurantIndexNormalized,
    TRY_CAST(lng AS DECIMAL(9,6))                   AS Longitude,
    TRY_CAST(lat AS DECIMAL(9,6))                   AS Latitude,
    NULLIF(LTRIM(RTRIM(City)), '')                  AS City,
    NULLIF(LTRIM(RTRIM(DayType)), '')               AS DayType
INTO Silver.Airbnb
FROM Bronze.Airbnb;


ALTER TABLE Silver.Airbnb
ADD CONSTRAINT PK_Silver_Airbnb
PRIMARY KEY (AirbnbID);
GO

select *
from Silver.Airbnb


select
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Price_NULL,
    SUM(CASE WHEN RoomType IS NULL THEN 1 ELSE 0 END) AS RoomType_NULL,
    
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS City_NULL,
    SUM(CASE WHEN DayType IS NULL THEN 1 ELSE 0 END) AS DayType_NULL
FROM Silver.Airbnb;


SELECT Price, RoomType, City, COUNT(*) AS Cnt
FROM Silver.Airbnb
GROUP BY Price, RoomType, City
HAVING COUNT(*) > 1;



