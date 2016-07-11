CREATE PROCEDURE [dbo].[GetCityId]
	@longitude int,
	@latitude int
AS
	SELECT Id 
	FROM City
	WHERE ABS(CAST(Longitude AS INT)) = @longitude AND ABS(CAST(Latitude AS INT)) = @latitude
--RETURN 0