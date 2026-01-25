--[[
@title: [ UI Global Colors.lua ]
@author: [ BakaCowpoke ]
@date: [ 1/25/26 ]
@description: [ Somewhat Annoying.  
Can't seem to get rid of the Enter Command Popup when deleting colors.

Stores or Deletes the list of Custom Colors to
Root().ColorTheme.ColorGroups.Global

Once stored, When Building UI elementds, it enables the user to specify 
a color to assign with a short string.
(ie. "Global.Red")

Based on a Post on the MA forums by Ahuramazda, 
Link below to original post:

https://forum.malighting.com/forum/thread/68481-set-color-at-uiobject-in-custom-menu/ ]

]]



--[[ alfredPlease Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global ]]
local alfredPlease = select(3, ...)



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
		{name = "DarkGrey", r = 16 , g = 16, b = 18 , a = 255},
		{name = "DarkGreen", r = 0, g = 127, b = 0, a = 255},
		{name = "DeepPurple", r = 127, g = 0, b = 127, a = 255},
		{name = "Magenta", r = 255, g = 0, b = 255, a = 255},
		{name = "BlueGreen", r = 0, g = 255, b = 255, a = 255},
		{name = "DarkBlueGreen", r = 0, g = 127, b = 127, a = 255}
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


--[[ Alfred,  i hate how the List command brings up the "Enter Command" popup.
	If you would be so kind...
]]
alfredPlease.listGlobalColors()


--[[ Same issue with the Popups using the below command. ]]
--CmdIndirect("List Root().ColorTheme.ColorGroups.Global.* /nc")

end

--storing the function in the alfredPlease table (namespace).
alfredPlease.workOnNamedUIColors = workOnNamedUIColors



local function listGlobalColors()

	local globalCL = {}

    local globalGroup = Root().ColorTheme.ColorGroups.Global
    
    if not globalGroup then
        Printf("globalGroup not found.")
        return
    end
        

    -- Individual Color
    for j = 1, globalGroup:Count() do
		
        local color = globalGroup[j]
       
		local tableToInsert = {color = color.name, rgba = color.rgba, index = color.index}
		
		--[[Two colors cause grief since they have 
			empty strings in the Name field]]
		if color.name ~= "" then
			table.insert(globalCL, tableToInsert)
		end
		
	end
    
	for k = 1, #globalCL do
		
		-- Remove '#' if present
		local cleanHex = globalCL[k].rgba:gsub("#", "")

		-- Convert pairs to decimal
		local r = tonumber(cleanHex:sub(1, 2), 16)
		local g = tonumber(cleanHex:sub(3, 4), 16)
		local b = tonumber(cleanHex:sub(5, 6), 16)
		local a = tonumber(cleanHex:sub(7, 8), 16) or 255
		
		--Grouping the Decimal values into a single string.
    	local rgbaDecString = string.format("Dec: (%d, %d, %d, %d)", r, g, b, a)
	
		--[[ Made the output 4 lines because I kept 
		shuffling...this seemed most Legible in the System Monitor]]
		local outputGCL1 = string.format("#%d ", globalCL[k].index)
		local outputGCL2 = string.format("Name: %s", globalCL[k].color)
		local outputGCL3 = string.format("RGBA: %s", globalCL[k].rgba)
		local outputGCL4 = rgbaDecString

		Printf(outputGCL1)
		Printf(outputGCL2)
		Printf(outputGCL3)
		Printf(outputGCL4)
		Printf("")
	end

end

--storing the function in the alfredPlease table (namespace).
alfredPlease.listGlobalColors = listGlobalColors



local function main()
		
	alfredPlease.workOnNamedUIColors("SET")
	--alfredPlease.workOnNamedUIColors("DELETE")

end

return main
