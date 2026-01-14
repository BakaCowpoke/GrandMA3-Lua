--[[
@title: [ UI Global Colors.lua ]
@author: [ BakaCowpoke ]
@date: [ January 10, 2026 ]
@description: [ Somewhat Annoying.  
Can't seem to get rid of the Enter Command Popups.

Stores or Deletes the list of Custom Colors to
Root().ColorTheme.ColorGroups.Global

Once stored, When Building UI elementds enables the user to specify a color to assign 
with a short string (ie. "Global.Red")

Based on a Post on the MA forums by Ahuramazda, 
Link below to original post:

https://forum.malighting.com/forum/thread/68481-set-color-at-uiobject-in-custom-menu/ ]

]]



--[[ impy Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global ]]
local impy = select(3, ...)



local function workOnNamedUIColors(strArg1)

	local globalColors =  Root().ColorTheme.ColorGroups.Global
	local lowerArg1 = nil

	--Argument Strings that this function will accept.
	local valid1 = {
		make = true, 
		set = true, 
		delete = true, 
		remove = true
	}


	--Note: keep in mind "a" is Alpha in this context.
    local colorList = {
        {name = "Red", r = 255, g = 0, b = 0, a = 255},
        {name = "Green", r = 0, g = 255, b = 0, a = 255},
        {name = "Blue", r = 0, g = 0, b = 255, a = 255},
        {name = "Black", r = 0, g = 0, b = 0, a = 255},
		{name = "White", r = 255, g = 255, b = 255, a = 255},
		{name = "DarkGrey", r = 16 , g = 16, b = 18 , a = 255}
    }

	--Exists and making the argument lowercase for simpler comparison
	if strArg1 and type(strArg1) == "string" then
		lowerArg1 = strArg1:lower()
	else
		ErrPrintf("I need a Proper Argument to work on Named UI Colors")
	end

	--[[ Argument Validation and Should it 
		Create or Obliterate the Colors ]]
	if valid1[lowerArg1] and (lowerArg1 == 'make' or lowerArg1 == 'set') then 

		for _, clValue in ipairs(colorList) do 

			local gCKids = globalColors:Children()

			local childIndex = nil

			--Making sure no Decimal point values snuck into the colorList table.
			if clValue.r % 1 ~= 0 then
				ErrPrintf(clValue.name .. "\'s Red value must be whole number.")
				ErrPrintf("The string Conversion to a Hex color value will fail.")
				Printf("")
				return

			elseif clValue.g % 1 ~= 0 then
				ErrPrintf(clValue.name .. "\'s Green value must be whole number.")
				ErrPrintf("The string Conversion to a Hex color value will fail.")
				Printf("")
				return

			elseif clValue.b % 1 ~= 0 then
				ErrPrintf(clValue.name .. "\'s Blue value must be whole number.")
				ErrPrintf("The string Conversion to a Hex color value will fail.")
				Printf("")
				return

			elseif clValue.a % 1 ~= 0 then
				ErrPrintf(clValue.name .. "\'s Alpha value must be whole number.")
				ErrPrintf("The string Conversion to a Hex color value will fail.")
				Printf("")
				return

			end


    		-- Loop through children and match name
    		for i = 1, #gCKids do
        		if gCKids[i].name == clValue.name then
            		childIndex = gCKids[i]
        		end
    		end


			if childIndex == nil then

				--Color Name isn't there.  ADD IT!
				local currentColor = globalColors:Acquire()

				Printf("Adding " .. clValue.name .. " to the UI Global Color Groups.")
				
				currentColor:Set('name', clValue.name )

				--Color String Conversion to HEX.
				currentColor:Set('rgba',string.format('%02x%02x%02x%02x', clValue.r, clValue.g, clValue.b, clValue.a))
			
			else
				--Color Name Exists, Leaving the it alone.
				Echo("* The Color \"" .. clValue.name .. "\" was found in the UI Global Color Groups")
				Echo("* Skipping.")
				Echo("")
			end

		end

	--Ditch the Colors in the colorList
	elseif valid1[lowerArg1] and (lowerArg1 == 'delete' or lowerArg1 == 'remove') then 

		for _,clValue in ipairs(colorList) do 

			local gCKids = globalColors:Children()
			
			local childIndex = nil


    		-- Loop through children and match name
    		for i = 1, #gCKids do
        		if gCKids[i].name == clValue.name then
            		childIndex = clValue.name
        		end
    		end
		
			--If it Exists then Ditch it.
			if childIndex then
			
				Printf("Removing " .. clValue.name .. " from the UI Global Color Groups")


				--[[ I CANNOT Get rid of the "Enter Command" Popups. 
					Tried to use Delete() and Remove() in Lua they don't work.
					It seems MA took the ball into their court.  ]]
				local cmdString = string.format('Delete Root().ColorTheme.ColorGroups.Global.\"%s\" /nc', childIndex)
				
				CmdIndirectWait(cmdString)

			else

				Printf("Color was Not Found.")

			end

		end

	else
		ErrPrintf("Please check your Argument for Named UI Colors")
	end

	--[[
    local base_input = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    base_input.h,base_input.w = 100,100

    local button = base_input:Append('Button')
    button.backcolor = my_color

]]

--[[ Same issue with the Popups. ]]
CmdIndirect("List Root().ColorTheme.ColorGroups.Global.* /nc")

end

--storing the function in the impy table (namespace).
impy.workOnNamedUIColors = workOnNamedUIColors



local function main()
		
	impy.workOnNamedUIColors("SET")
	--impy.workOnNamedUIColors("DELETE")

end
return main
