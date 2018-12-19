-- Calculates all the quarters start and end dates for a given date range
-- and puts them in a table variable
------------------------------------------------------------------------
Declare @StartDate As DateTime, @EndDate As DateTime
Set @StartDate=Cast('01/01/2018' As DateTime)
Set @EndDate=Cast('12/31/2018' As DateTime)
------------------------------------------------------------------------
Declare @WorkStartDate As DateTime, @QtrEndMMDD As Char(5)

Declare @TempQtrTable As Table (
	QtrYYYYMM Char(6) Primary Key
,	QtrBeginDate DateTime NOT NULL
,	QtrEndDate DateTime NOT NULL
,	Unique(QtrBeginDate)
,	Unique(QtrEndDate)
)

Set @WorkStartDate=@StartDate

While @WorkStartDate < @EndDate
Begin
	Set	@QtrEndMMDD = 
		Case When Format(@WorkStartDate,'MM') In(1,2,3) Then '03/31'
			 When Format(@WorkStartDate,'MM') In(4,5,6) Then '06/30'
			 When Format(@WorkStartDate,'MM') In(7,8,9) Then '09/30'
			 When Format(@WorkStartDate,'MM') In(10,11,12) Then '12/31'
		End
	Insert	Into @TempQtrTable
	Select	Format(@WorkStartDate,'yyyyMM') As QtrYYYYMM
	,		Cast(Cast(DatePart(Year,@WorkStartDate) As Char(4))+'/'
				 +Cast(DatePart(Month,@WorkStartDate) As VarChar(2))
				 +'/01' As DateTime) As QtrBeginDate
	,		Cast(Cast(DatePart(Year,@WorkStartDate) As Char(4))+'/'
				 +@QtrEndMMDD As DateTime) As QtrEndDate

	Declare @NextYear As char(4)
	Set @NextYear = Cast(Year(@WorkStartDate)+1 As Char(4))

	Set @WorkStartDate= 
		Case When Month(@WorkStartDate) In(1,2,3) Then Cast(Year(@WorkStartDate) As Char(4))+'/04/01'
			 When Month(@WorkStartDate) In(4,5,6) Then Cast(Year(@WorkStartDate) As Char(4))+'/07/01'
			 When Month(@WorkStartDate) In(7,8,9) Then Cast(Year(@WorkStartDate) As Char(4))+'/10/01'
			 When Month(@WorkStartDate) In(10,11,12) Then @NextYear+'/01/01'
		End
End

Select	* From @TempQtrTable
