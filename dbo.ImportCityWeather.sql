CREATE PROCEDURE [dbo].ImportCityWeather
	@json nvarchar(max)
	, @id int

AS
	DECLARE @datediff int
	--SET @json = '{"coord":{"lon":-0.13,"lat":51.51},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"cmc stations","main":{"temp":295.01,"pressure":1006,"humidity":53,"temp_min":293.15,"temp_max":297.04},"wind":{"speed":8.2,"deg":230},"clouds":{"all":20},"dt":1468172149,"sys":{"type":1,"id":5091,"message":0.0046,"country":"GB","sunrise":1468122991,"sunset":1468181697},"id":2643743,"name":"London","cod":200}'
	SET @json = REPLACE(REPLACE(@json, '[', ''), ']', '')
	SET @json =  '[' + @json + ']'

	SELECT @datediff =  DATEDIFF(minute, LastPullDateTime, GETDATE()) 
	FROM Weather WHERE Id = @id

	If ((@datediff > 10) OR (@datediff IS NULL))
		BEGIN
			DELETE FROM Weather WHERE Id = @id

			INSERT INTO Weather
  
			SELECT weather.*, GETDATE() AS LastPullDateTime
			FROM OPENJSON(@json)
			WITH (id int 'strict $.id'
			, MainWeather nvarchar(max) '$.weather.main'
			, WeatherDescription nvarchar(max) '$.weather.description'
			, Temperature numeric(18,2) '$.main.temp'
			, MinimumTemperature NUMERIC (18, 2) '$.main.temp_min'
			, MaximumTemperature NUMERIC (18, 2) '$.main.temp_max'
			, Sunrise BIGINT '$.sys.sunrise'
			, Sunset BIGINT '$.sys.sunset'
			, Pressure INT '$.main.pressure'
			, Humidity SMALLINT '$.main.humidity'
			, WindSpeed NUMERIC (18, 5) '$.wind.speed'
			, WindDegrees NUMERIC (18, 5) '$.wind.deg') AS weather
END