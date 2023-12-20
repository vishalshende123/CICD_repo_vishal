--Example for Multi Statement Table Valued Function
CREATE FUNCTION Fn_GetCustomers
(
	@ACID  INT	
)
RETURNS    @TMP    TABLE (	ACID		INT ,
							NAME	VARCHAR(100),
							BAL		MONEY
			           )
AS
BEGIN 
	INSERT INTO @TMP (ACID, NAME, BAL)
	
	SELECT ACID, NAME, CBAL
	FROM AMASTER  
	WHERE ACID = @ACID 
	
	RETURN

END