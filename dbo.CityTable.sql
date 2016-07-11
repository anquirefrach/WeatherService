CREATE TABLE [dbo].[City] (
    [Id]        INT            NOT NULL,
    [Name]      NVARCHAR (MAX) NOT NULL,
    [Country]   NCHAR (2)      NOT NULL,
    [Longitude] NUMERIC (18, 10)   NOT NULL,
    [Latitude]  NUMERIC (18, 10)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

