--INSERT INTO City

SELECT weather.*
FROM OPENROWSET(BULK 'C:\Users\anquirefrach\Documents\city.list.json', SINGLE_CLOB) AS w
CROSS APPLY OPENJSON(BulkColumn)
WITH (_id int, name nvarchar(max), country nchar(2)
, longitude numeric(18, 10) '$.coord.lon'
, latitude numeric(18, 10) '$.coord.lat') AS weather
WHERE (weather.name = 'Tirana' AND weather.country = 'AL')
OR (name = 'Andorra la Vella' AND country = 'AD')
OR (name = 'Yerevan' AND country = 'AM')
OR (name = 'Vienna' AND country = 'AT')
OR (name = 'Baku' AND country = 'AZ')
OR (name = 'Minsk' AND country = 'BY')
OR (name = 'Brussels' AND country = 'BE')
OR (name = 'Sarajevo' AND country = 'BA')
OR (name = 'Sofia' AND country = 'BG')
OR (name = 'Zagreb' AND country = 'HR')
OR (name = 'Nicosia' AND country = 'CY')
OR (name = 'Prague' AND country = 'CZ')
OR (name = 'Copenhagen' AND country = 'DK')
OR (name = 'Tallinn' AND country = 'EE')
OR (name = 'Helsinki' AND country = 'FI')
OR (name = 'Paris' AND country = 'FR')
OR (name = 'Tbilisi' AND country = 'GE')
OR (name = 'Berlin' AND country = 'DE')
OR (name = 'Athens' AND country = 'GR')
OR (name = 'Budapest' AND country = 'HU')
OR (name = 'Reykjavik' AND country = 'IS')
OR (name = 'Dublin' AND country = 'IE')
OR (name = 'Rome' AND country = 'IT')
OR (name = 'Astana' AND country = 'KZ')
OR (name = 'Pristina' AND country = 'XK')
OR (name = 'Riga' AND country = 'LV')
OR (name = 'Vaduz' AND country = 'LI')
OR (name = 'Vilnius' AND country = 'LT')
OR (name = 'Luxembourg' AND country = 'LU')
OR (name = 'Skopje' AND country = 'MK')
OR (name = 'Valletta' AND country = 'MT')
OR (name = 'Chisinau' AND country = 'MD')
OR (name = 'Monaco' AND country = 'MC')
OR (name = 'Podgorica' AND country = 'ME')
OR (name = 'Amsterdam' AND country = 'NL')
OR (name = 'Oslo' AND country = 'NO')
OR (name = 'Warsaw' AND country = 'PL')
OR (name = 'Lisbon' AND country = 'PT')
OR (name = 'Bucharest' AND country = 'RO')
OR (name = 'Moscow' AND country = 'RU')
OR (name = 'San Marino' AND country = 'SM')
OR (name = 'Belgrade' AND country = 'RS')
OR (name = 'Bratislava' AND country = 'SK')
OR (name = 'Ljubljana' AND country = 'SI')
OR (name = 'Madrid' AND country = 'ES')
OR (name = 'Stockholm' AND country = 'SE')
OR (name = 'Bern' AND country = 'CH')
OR (name = 'Ankara' AND country = 'TR')
OR (name = 'Kyiv' AND country = 'UA')
OR (name = 'London' AND country = 'GB')
OR (name = 'Vatican City' AND country = 'VA')

-- Yerevan, AM duplicate
-- Helsinki, FI triplicate
-- Paris, FR quadruplicate
-- Berlin, DE duplicate
-- Reykjavik, IS duplicate
-- Rome, IT is missing
-- Olso, NO duplicate 
-- Lisbon, PT duplicate
-- Madrid, ES duplicate
-- Bern, CH duplicate
-- Ankara, TR
-- Kyiv, UA is missing