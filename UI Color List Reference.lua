--[[
@title: [ UI Color List Reference.lua ]
@author: [ BakaCowpoke ]
@date: [ 1/23/2026 ]
@license: [ CC0 ]
@description: [  Plugion Code for reference for UI Color Customization on the GrandMA3.

Without making your own, GrandMA3 has 1500+ references to colors for use when 
designiing custom UI, they actually only use about 200 unique colors.  
With the omission of the "Global" colors this plugin shows the colors 
with the shortest reference names...One per unique Color.
A list of the Global color names and info can be found on the MA by entering the 
below command in the Command Line

List Root().ColorTheme.ColorGroups.Global.*

The Black Gaps in the Table were where a Global value was skipped because the 
UI didn't like what I was doing with them for whatever reason.

Hope this helps!

]
--]]



--For UI Element Functions
local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)



local function main(handleArg1, arg2)

	local continue = false

	--[[ full list of 1500+ color references overwhelms 
	the scrollbox.  Filterd down to thr condensedList of around 200 ]]
	local colorList = {}	
	local sortedOrder = {}

	--Fewer Colors by Shortest Reference length
	local condensedList = {}

	--UI Box container
	local swatchBox = {}



    local colorGroups = Root().ColorTheme.ColorGroups
    
    if not colorGroups then
        Printf("ColorGroups not found.")
        return
    end

    -- Each Color Group
    for i = 1, colorGroups:Count() do
        local group = colorGroups[i]
        
        -- Individual Color
        for j = 1, group:Count() do
            local color = group[j]
       
			local grpLen = string.len(group.name)
			local colLen = string.len(color.name)
			local totLen = grpLen + colLen

			local tableToInsert = { group = group.name, color = color.name, rgba = color.rgba, length = totLen}
			table.insert(colorList, tableToInsert)
			table.insert(sortedOrder, tableToInsert)
		end
    end

	 -- Sort by RGBA Then Reference String Lengths
	table.sort(sortedOrder, function(a, b)

		if a.rgba == b.rgba then
			--Secondary Sort (I want the shortest string to call these by.)
			return a.length < b.length
		else
			--Primary Sort (color by RGBA Hex value)
			return a.rgba > b.rgba
		end

	end)


	local cLColor = nil
	--Get rid of identical colors keep the one with the shortest reference string
	for k, v in pairs(sortedOrder) do
		
		if cLColor == nil then 
			table.insert(condensedList, v)
			
		elseif cLColor.rgba ~= v.rgba then 
			table.insert(condensedList, v)

		end
		cLColor = v
	end

	--[[
	Printf("condensed List#: ".. #condensedList)

	for k, v in pairs(condensedList) do
		--Printf("RGBA: ".. v.rgba.." Length: "..v.length .. " Color Name: "..v.color .. " Group: ".. v.group)
	end
	]]

	
	local baseLayer = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
		baseLayer.Name = 'Blah'
    	baseLayer.H = 760
    	baseLayer.W = 800
    	baseLayer.Columns = 1
    	baseLayer.Rows = 3
    	baseLayer[1][1].SizePolicy = 'Fixed'
    	baseLayer[1][1].Size = 100
    	baseLayer[1][2].SizePolicy = 'Stretch'
    	baseLayer[1][3].SizePolicy = 'Fixed'
    	baseLayer[1][3].Size = 100
    	baseLayer.AutoClose = 'No'
    	baseLayer.CloseOnEscape = 'Yes'

	local titleBar = baseLayer:Append('TitleBar')
    	titleBar.Columns = 2  
    	titleBar.Rows = 1
    	titleBar.Anchors = '0,0'
    	titleBar[2][2].SizePolicy = 'Fixed'
    	titleBar[2][2].Size = 50
    	titleBar.Texture = 'corner2'
    	titleBar.Transparent = "No"

	local titleBarIcon = titleBar:Append('TitleButton')
		titleBarIcon.Font = 'Regular24'
    	titleBarIcon.Text = 'UI Tags Assist'
    	titleBarIcon.Texture = 'corner1'
    	titleBarIcon.Anchors = '0,0'
    	titleBarIcon.Icon = 'star'

  	local titleBarCloseButton = titleBar:Append('CloseButton')
    	titleBarCloseButton.Anchors = '1,0'
    	titleBarCloseButton.Texture = 'corner2'


	--[[I believe I have Ahuramazda on the GrandMA Forums to thank 
		for the below ScrollBox Portions of this.  
		Thanks to "From Dark To Light" for the rest.
	]]
	local dialog = baseLayer:Append("DialogFrame")
    	dialog.H, dialog.W, dialog.Columns = '98%', '100%', 2
    	dialog[2][2].SizePolicy = "Content"
    	dialog.Anchors = '0,1'

	local scrollbox = dialog:Append("ScrollBox")
    	scrollbox.Name = "mybox"
 
	local scrollbar = dialog:Append("ScrollBarV")
    	scrollbar.ScrollTarget = "../mybox"
    	scrollbar.Anchors = '1,0'
   


	--[[ When I used the full 1500+ Sorted List to make the 
		below swatchBoxes it wouldn't work.  I'm guessing it 
		overwhelmed the scrollBox. ]]
	
	--Swatches for each of the Colors
	for i = 1, #condensedList do
    
		local boxSize = 30
		
		--[[ swatchBox seems to have issues with any of the Global Colors 
			probably has to do with the strings formatting retrieved from the system ]]
		if condensedList[i].group == "Global" then
			
		else
			local currentSwatchText = string.format("Root().ColorTheme.ColorGroups.%s.%s", condensedList[i].group, condensedList[i].color)
			local currentSwatchColor = string.format("%s.%s", condensedList[i].group, condensedList[i].color) 
		

			swatchBox[i] = scrollbox:Append('UIObject')
    			swatchBox[i].H = boxSize
				swatchBox[i].W = 700
    			swatchBox[i].Anchors = "0,0,1,0"
				swatchBox[i].TextColor = "Global.White"
        		swatchBox[i].Font = 'Medium20'
				swatchBox[i].Text = currentSwatchText
				swatchBox[i].Textshadow = 10
				swatchBox[i].BackColor = currentSwatchColor

				local yAdj = (i - 1) * boxSize

				swatchBox[i].X, swatchBox[i].Y = 5, yAdj

		end

	end
	--End of Swatch Boxes


		local buttonGrid = baseLayer:Append('UILayoutGrid')
		buttonGrid.Columns = 2
    	buttonGrid.Rows = 1
    	buttonGrid.H = 80
    	buttonGrid.Anchors = '0,2' 

  	local applyButton = buttonGrid:Append('Button')
    	applyButton.Anchors = '0,0'
    	applyButton.Textshadow = 1
    	applyButton.HasHover = 'Yes'
    	applyButton.Text = 'Apply'
    	applyButton.Font = 'Regular28'
    	applyButton.TextalignmentH = 'Centre'
    	applyButton.PluginComponent = myHandle
    	applyButton.Clicked = 'ApplyButtonClicked'

	local cancelButton = buttonGrid:Append('Button')
    	cancelButton.Anchors = '1,0'
    	cancelButton.Textshadow = 1
    	cancelButton.HasHover = 'Yes'
    	cancelButton.Text = 'Cancel'
    	cancelButton.Font = 'Regular28'
    	cancelButton.TextalignmentH = 'Centre'
    	cancelButton.PluginComponent = myHandle
    	cancelButton.Clicked = 'CancelButtonClicked'
		

	signalTable.CancelButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		checkBoxState = {"Cancelled"}
		continue = true
	end
    
	--[[ Left the Apply Button for If I want to give feedback 
		to the System Monitor at a later date. ]]
	signalTable.ApplyButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		continue = true
	end

	repeat 

	until continue


end

return main