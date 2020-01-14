-- Create a temp table with 1 record per week for each year from the given start year (2012 in this example)
Declare @CCYY As Int, @Jan1 As DateTime, @Dec31 As DateTime, @Saturday As DateTime
Set @CCYY = 2012

If OBJECT_ID('tempdb..#Weeks') Is Not Null Drop Table #Weeks
Create Table #Weeks (
	CCYY Int
,	WeekNum Int
,	WeekStart DateTime
,	WeekEnd DateTime
)

While @CCYY <= DatePart(Year, GetDate())
Begin
		Set @Jan1 = '1/1/' + Cast(@CCYY As Char(4))
		Set @Dec31 = '12/31/' + Cast(@CCYY As Char(4))

		Set	@Saturday = '1/' + Case When DatePart(WeekDay, @Jan1) = 1 Then '7' Else
									Cast( ((8 - DatePart(WeekDay, @Jan1))) As Char(1)) End + '/' + Cast(@CCYY As Char(4))
									
		Insert Into #Weeks
		Select	DatePart(Year, @Saturday) As CCYY
		,		DatePart(Week, @Saturday) As WeekNum
		,		@Saturday - 6 As WeekStart
		,		@Saturday As WeekEnd

		While @Saturday + 7 <= @Dec31
		Begin
			Set @Saturday = @Saturday + 7
			Insert Into #Weeks
			Select	DatePart(Year, @Saturday) As CCYY
			,		DatePart(Week, @Saturday) As WeekNum
			,		@Saturday - 6 As WeekStart
			,		@Saturday As WeekEnd
		End
		
		Set @CCYY = @CCYY + 1
End

Create Index ix_CCYY On #Weeks(CCYY)
Create Index ix_WeekNum On #Weeks(WeekNum)
Create Index ix_WeekStart On #Weeks(WeekStart)
Create Index ix_WeekEnd On #Weeks(WeekEnd)

Select	*
From	#weeks
Order	By CCYY, WeekNum
