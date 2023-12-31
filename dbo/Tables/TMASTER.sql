﻿CREATE TABLE [dbo].[TMASTER] (
    [TNO]     INT           IDENTITY (1, 1) NOT NULL,
    [DOT]     DATETIME      NOT NULL,
    [ACID]    INT           NOT NULL,
    [BRID]    CHAR (3)      NOT NULL,
    [TXNTYPE] CHAR (3)      NOT NULL,
    [CHQNO]   INT           NULL,
    [CHQDATE] SMALLDATETIME NULL,
    [TXNAMT]  MONEY         NOT NULL,
    [UID]     INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([TNO] ASC),
    CONSTRAINT [CK_TMASTER] CHECK ([TXNTYPE]='CQD' OR [TXNTYPE]='CW' OR [TXNTYPE]='CD'),
    FOREIGN KEY ([ACID]) REFERENCES [dbo].[AMASTER] ([ACID]),
    FOREIGN KEY ([BRID]) REFERENCES [dbo].[BRMASTER] ([BRID]),
    FOREIGN KEY ([UID]) REFERENCES [dbo].[UMASTER] ([UID])
);


GO

CREATE TRIGGER EXCEEDEDAMT
ON TMASTER

AFTER INSERT
AS 
BEGIN

-- DECLARE VRIABLE --
DECLARE		@ACID			INT,
			@TXNTYPE		CHAR(3),
			@TXNAMT			MONEY,
            @CBAL			MONEY,
            @TOTAL			INT
         
                    
-- GET THE VALUES FROM INSERTED TABLE --
SELECT		@ACID     = ACID,
			@TXNTYPE  = TXNTYPE,
			@TXNAMT   = TXNAMT
FROM		INSERTED
--GET BALANCE FROM COUSTOMER
SELECT @TOTAL=
             ( SELECT   SUM(TXNAMT)
                FROM TMASTER
                WHERE ACID=@ACID
                )


					
IF ( (@TXNTYPE='CW') AND (@TXNAMT>50000)  )
	BEGIN
		UPDATE AMASTER
		SET CBAL=CBAL-(0.01*@TOTAL)
		WHERE ACID=@ACID
		PRINT'U HAVE DONE MORE THAN 50000 TXN 1% DEBITED FROM U R ACCOUNT'
	END
END
GO

CREATE TRIGGER UPDATEBALANCE
ON TMASTER
AFTER INSERT
AS BEGIN

-- DECLARE VARIABLES TO HOLD THE VALUES
DECLARE @ACID		 INT
DECLARE @TXNTYPE	 CHAR(3)
DECLARE @TXNAMT		 MONEY
DECLARE @CBAL		 MONEY

-- GET THE VALUES FROM INSERTED TABLE
SELECT @ACID    = ACID,		
	   @TXNTYPE = TXNTYPE,	
	   @TXNAMT	= TXNAMT
FROM   INSERTED

--GET THE BAL OF THE CUSTOMERS --
SELECT @CBAL = CBAL
FROM AMASTER
WHERE ACID = @ACID


-- FOR CASH DEPOSIT
IF @TXNTYPE ='CD' 
BEGIN 
UPDATE AMASTER
SET		CBAL = CBAL + @TXNAMT,
		UBAL = UBAL	+ @TXNAMT
WHERE 	ACID = @ACID
PRINT 'THE CASH DEPOSIT IS SUCCESSFUL. THANK YOU. VISIT AGAIN.....'
END

-- FOR CASH WITHDRAWALAS
ELSE IF (@TXNTYPE ='CW') AND (@CBAL>=@TXNAMT)
BEGIN 
UPDATE AMASTER
SET		CBAL = CBAL - @TXNAMT
WHERE 	ACID = @ACID
PRINT 'THE CASH WITHDRAWAL IS SUCCESSFUL. THANK YOU. VISIT AGAIN.....'
END
ELSE
BEGIN
PRINT 'NO SUFFICIENT FUNDS IN YOUR ACCOUNT'
ROLLBACK TRAN
END
END
GO
EXECUTE sp_settriggerorder @triggername = N'[dbo].[UPDATEBALANCE]', @order = N'first', @stmttype = N'insert';


GO
CREATE TRIGGER WITDRAWLIMIT
ON TMASTER

AFTER INSERT
AS 
BEGIN

-- DECLARE VRIABLE --
DECLARE		@ACID			INT,
			@TXNTYPE		CHAR(3),
			@TXNAMT			MONEY,
			@NoOfTxns		INT,
            @CBAL			MONEY,
            @DAMT			MONEY
            
    SET @DAMT=50        
-- GET THE VALUES FROM INSERTED TABLE --
SELECT		@ACID     = ACID,
			@TXNTYPE  = TXNTYPE,
			@TXNAMT   = TXNAMT
FROM		INSERTED
--GET BALANCE FROM COUSTOMER
SELECT @CBAL=CBAL
FROM AMASTER
WHERE ACID=@ACID


-- TOTAL TXN'S FROM TMASTER --
SELECT @NoOfTxns =
					(
						SELECT		COUNT(*)
						FROM		TMASTER
						WHERE		ACID=@ACID
									AND
									TXNTYPE='CW'
									OR
									TXNTYPE='CD'
									AND
									DOT = '2013-03-17'		
					)
					
IF ( (@NoOfTxns>5)  )
	BEGIN
		UPDATE AMASTER
		SET CBAL=CBAL-@DAMT
		WHERE ACID=@ACID
		PRINT'TXN IS SUCCESSFULL'
		PRINT'U HAVE DONE MORE THAN 5 TXN THIS MNTH N BAL IS REDUCED 50'
	END
--ELSE IF((@NoOfTxns>5) AND (@TXNTYPE='CD' ))
--BEGIN
--UPDATE AMASTER
--SET CBAL=CBAL+@TXNAMT-@DAMT
--WHERE ACID=@ACID
--END
----ELSE
----BEGIN
----ROLLBACK
----PRINT'NO SUFFICINT AMT IN UR ACCOUNT'
--END	

END