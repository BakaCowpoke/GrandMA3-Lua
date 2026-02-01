A folder for Lua Plugin Code for Reference when Developing 
your Custom UI for the GrandMA3.

Using a Grep Search (with a couple pipes for sed & sort) in the Terminal Utility on  Mac to find 
all of the Font= items in the UIXML files was HUGE.

Below is the Grep search I ran for the Fonts.


grep -roEh "Font=\"([^\"]+)\"" /Users/(Your User Folder)/MALightingTechnology/gma3_2.3.2/shared | sed 's/^.*=//' | sort -u


Hope these plugins save you Time and Grief!
