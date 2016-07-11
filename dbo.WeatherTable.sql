CREATE TABLE [dbo].[Weather] (
    [Id]                 INT             NOT NULL,
    [MainWeather]        NVARCHAR (MAX)  NOT NULL,
    [WeatherDescription] NVARCHAR (MAX)  NOT NULL,
    [Temperature]        NUMERIC (18, 2) NOT NULL,
    [MinimumTemperature] NUMERIC (18, 2) NOT NULL,
    [MaximumTemperature] NUMERIC (18, 2) NOT NULL,
    [Sunrise]            BIGINT          NOT NULL,
    [Sunset]             BIGINT          NOT NULL,
    [Pressure]           INT             NOT NULL,
    [Humidity]           SMALLINT        NOT NULL,
    [WindSpeed]          NUMERIC (18, 5) NOT NULL,
    [WindDegrees]        NUMERIC (18, 5) NULL,
    [LastPullDateTime]   DATETIME2 (7)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Weather_ToCity] FOREIGN KEY ([Id]) REFERENCES [dbo].[City] ([Id])
);