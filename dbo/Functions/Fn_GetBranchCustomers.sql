--Example for Inline Functions
CREATE FUNCTION Fn_GetBranchCustomers
(
	@BRID CHAR(4)
)
RETURNS TABLE
AS
RETURN 
	(
		SELECT *
		FROM AMASTER
		WHERE BRID = @BRID
	)