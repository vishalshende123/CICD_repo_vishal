CREATE TABLE [dbo].[AMASTER_COPY] (
    [ACID]    INT          NOT NULL,
    [NAME]    VARCHAR (40) NOT NULL,
    [ADDRESS] VARCHAR (50) NOT NULL,
    [BRID]    CHAR (3)     NOT NULL,
    [PID]     CHAR (2)     NOT NULL,
    [DOO]     DATETIME     NOT NULL,
    [CBAL]    MONEY        NULL,
    [UBAL]    MONEY        NULL,
    [STATUS]  CHAR (1)     NULL
);

