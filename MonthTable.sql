-- Creates a temp table containing 1 record per month (start and end date for each month) from a previous date until today
-- Start month is hard-coded as 2016-01-01

Declare @fromCCYYMMDD As DateTime, @thruCCYYMMDD As DateTime, @todayCCYYMMDD as DateTime
Set @fromCCYYMMDD = Cast('2016-01-01 00:00:00.000' As DateTime)
Set @thruCCYYMMDD = Cast('2016-01-31 23:59:59.997' As DateTime)
Set @todayCCYYMMDD = GetDate()
Declare @dateTable TABLE(
		fromCCYYMMDD DateTime NOT NULL
,		thruCCYYMMDD DateTime NOT NULL
		)	
While @fromCCYYMMDD <= @todayCCYYMMDD
Begin
	Insert Into @dateTable
	Select @fromCCYYMMDD, @thruCCYYMMDD
	Set @fromCCYYMMDD = DATEADD(month, 1, @fromCCYYMMDD)
	Set @thruCCYYMMDD = DATEADD(month, 1, @fromCCYYMMDD)
	Set @thruCCYYMMDD = DATEADD(MILLISECOND, -3, @thruCCYYMMDD)
End

Select  *
From    @dateTable
