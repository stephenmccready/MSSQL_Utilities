Declare @List As VarChar(Max)
Set @List = '111111A,2222B,333333333333C,444444D,555555555E'

----------------------------------------------------------------------------------------
Declare @MemberListLen As Int
Set @MemberListLen = Len(@List)

Declare @commaLocation As Int, @end As Int
Set @commaLocation = 9999

If OBJECT_ID('tempdb..#Members') Is Not Null Drop Table #Members
Create Table tempdb..#Members (
	Member Varchar(50) Not Null
)

While @commaLocation > 1
Begin
	Set @commaLocation = CHARINDEX ( ',' , @List, 1 )

	If(@commaLocation = 0) 
		Set @end = Len(@List)
	Else
		Set @end = @commaLocation - 1

	Insert	Into #Members
	Select	SubString(@List,1,@end) As Member

	Set @List = SubString(@List, @commaLocation + 1, Len(@List) - @commaLocation)

End

Select	*
From	#Members
