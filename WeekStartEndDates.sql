-- Return Sunday (week start), Saturday (week end) for a given year and week number

Declare @CCYY As Int, @WeekNum As Int
Set @CCYY = 2020
Set @WeekNum = 1
-------------------------------------------------------------------------------------------------------------------------------------------------

Declare @WeekStart As DateTime, @WeekEnd As DateTime
Set @WeekStart = DateAdd(Week, @WeekNum - 1, DateAdd(dd, 1 - DatePart(dw, '1/1/' + Cast(@CCYY As Char(4))), '1/1/' +  Cast(@CCYY As Char(4))))
Set @WeekEnd = DateAdd(Day, 7, @WeekStart)
-- Set the week end date to yyyy-mm-dd 23:59:59.997
Set @WeekEnd = DateAdd(ms, -3, @WeekEnd)

Select @WeekStart, @WeekEnd
