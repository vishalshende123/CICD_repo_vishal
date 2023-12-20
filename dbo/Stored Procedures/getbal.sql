CREATE proc [getbal]
(
@ACID INT = 101 ,
@BAL MONEY OUT
)
as 
begin
select @BAL = CBAL 
from AMASTER
where ACID = @acid
end