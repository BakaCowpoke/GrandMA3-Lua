A Beginners guide to GMA3 UI Elements by a Beginner.


A few items it took me some time to wrap my head around, and how to get information about them.


When you make a Variable Declaration like this one below:


	local titleBarIcon = titleBar:Append('TitleButton')


You've defined the following:

	Make a local variable.

	Its name is  titleBarIcon.

		Then it's a bit easier to go from the End of the line back towards the =

	Its Type/Job/Class/Template is 'TitleButton'.

	Its Parent (who I want to Append it to) is named titleBar 


Making it a 'TitleButton' defines all kinds of Table structure and parameters to it.  A line later you can write:

	titleBarIcon.H = 50 

	And titleBarIcon now has the table structure and a Key/slot named "H" to store the value in, and (if done correctly) the system knows how to handle it.


Now the question comes, "Well what parameters are there?".
	The short answer is... alot.  And there are differences
	depending on the Type/Job/Class/Template.
	
	Below is how to get it.
	
	
	local titleBarIcon = titleBar:Append('TitleButton')
	
	Printf( titleBarIcon:Dump() )
	

	You've created a varialbe with the Type/Job/Class/Template.
	So now you have an instance of a variable of that type to tell the Dump() function to work on and give you information about.
	
	One Note: You should Only Dump() one object/variable at a time; it will fill your System Monitor with about 200 lines of informaiton per Dump().
	
	
	
This next portion will be a bit incomplete, but it's as far as I know at this point.

	A Bit about Buttons...(dissecting it a bit)
	
	Given the following code:

	
	local signalTable = select(3, ...)

	local applyButton = buttonGrid:Append('Button')
		applyButton.Clicked = 'ApplyButtonClicked'
		
	signalTable.ApplyButtonClicked = function(caller)
	end


	You've created a table named signalTable to store Functions in (that the system looks in for Functions when you click a UI Button)

	You've made the applyButton, told it it's a 'Button' and who to stick to (buttonGrid)

	
	Then you've told it, "When you're clicked, tell the system to look in the signalTable table for a Function named  'ApplyButtonClicked' ."
	
	The last portiom is where you've Defined the ApplyButtonClicked Fumction, its code, and posted it as a Function to be found in signaTable, so the system knows where it can find it..  
		
	
		(caller) is just a local incoming argument variabkle that you can use inside that Function.  
			Personally, I initally thought it had a greater meaning, since the same variable showed up in numerous Button examples.  The truth is it's a  descriptive name and it doesn't matter because of the scope of the function.
			

			
Hope this helps!
			
	-BakaCowpoke
