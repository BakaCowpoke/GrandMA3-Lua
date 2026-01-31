A folder for Lua Plugin Code for Reference when Developing 
your Custom UI for the GrandMA3.

Using a Grep Search in the Terminal Utility on  Mac to find 
all of the Font= and Icon= items in the UIXML files was HUGE.

That in conjunction with a program that handles Text search & replacement in 
bulk was an immense time saver.  A program like BBEdit or Textastic to tidy 
the search results helps a lot.

Below is the Grep search I ran for the Fonts, I'm sure someone else can make it dance 
prettier than I did.

grep -roE 'Font=.{0,20}' /Users/(Your User Folder)/MALightingTechnology/gma3_2.3.2/shared


Hope these plugins save you Time and Grief!
