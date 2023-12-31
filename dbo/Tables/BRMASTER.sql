﻿CREATE TABLE [dbo].[BRMASTER] (
    [BRID]   CHAR (3)     NOT NULL,
    [BRNAME] VARCHAR (30) NOT NULL,
    [BRADD]  VARCHAR (50) NOT NULL,
    [RID]    INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([BRID] ASC),
    FOREIGN KEY ([RID]) REFERENCES [dbo].[RMASTER] ([RID])
);

