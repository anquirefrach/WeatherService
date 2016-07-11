
CREATE PROCEDURE [dbo].GetCityWeather
	@id int
	
AS
	SELECT City.Name AS City, Weather.Id, MainWeather + '; ' + WeatherDescription AS Weather
	, Temperature, MinimumTemperature, MaximumTemperature, Sunrise, Sunset
	, Pressure, Humidity, WindSpeed, WindDegrees, LastPullDateTime
	FROM Weather
	INNER JOIN City ON Weather.Id = City.Id
	WHERE Weather.Id = @id