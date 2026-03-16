--[[
@title: [ RadioButtonLogic.lua ]
@author: [ BakaCowpoke ]
@date: [ 3/16/2026 ]
@license: [ CC0 ]
@description: [ Demonstrates Logic for Using Checkboxes in the manner of Radio Buttons. ]
--]]


--Tables for UI Elements
local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)

--Table for my functions
local alfredPlease = select(3, ...)



local function demonstrateRadioButtons(choiceTable, switchArg)

	--[[Variable for Repeat Loop (So you can make different selections until you click "Apply"]]
	local continue = false

	--Table for Multiple instances of Checkboxes
	local cb = {}

	--seperate storage Table for the state of each checknox
	local checkBoxState = {}

	--[[ Basic UI elements for placement & functionality. ]]
	local baseLayer = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    	baseLayer.H, baseLayer.W, baseLayer.Columns, baseLayer.Rows = 700, 500, 1, 3
    	baseLayer[1][1].SizePolicy, baseLayer[1][1].Size, baseLayer[1][2].SizePolicy, baseLayer[1][3].SizePolicy, baseLayer[1][3].Size, baseLayer.AutoClose, baseLayer.CloseOnEscape, baseLayer.BackColor = 'Fixed', 100, 'Stretch', 'Fixed', 100, 'No', 'Yes', 30.12

	local titleBar = baseLayer:Append('TitleBar')
    	titleBar.Columns, titleBar.Rows, titleBar.Anchors = 2, 1, '0,0'  
    	titleBar[2][2].SizePolicy, titleBar[2][2].Size, titleBar.Texture, titleBar.Transparent  = 'Fixed', 50, 'corner2', "No"
    	

	local titleBarIcon = titleBar:Append('TitleButton')
		titleBarIcon.Font, titleBarIcon.Texture, titleBarIcon.Anchors, titleBarIcon.Icon = 'Regular24', 'corner1', '0,0', 'star'
    	titleBarIcon.Text = 'Radio Button Example'

  	local titleBarCloseButton = titleBar:Append('CloseButton')
    	titleBarCloseButton.Anchors, titleBarCloseButton.Texture = '1,0', 'corner2'

	local dialogFrame = baseLayer:Append("DialogFrame")
      	dialogFrame.H, dialogFrame.W, dialogFrame.Columns, dialogFrame.Rows, dialogFrame.Anchors = '95%', '100%', 2, 2, '0,1'
    	dialogFrame[2][2].SizePolicy, dialogFrame[1][2].SizePolicy = "Content", "Content"
      	

	--Checkboxes & math for Y-coordinate Adjustment

	for i = 1, #choiceTable do
    
		local cbHSize = 50
		checkBoxState[i] = 0
	
		cb[i] = dialogFrame:Append("CheckBox")
        	cb[i].Text = choiceTable[i].." #" .. i
			cb[i].TextColor = "Global.Text"
        	cb[i].H, cb.W = cbHSize, 300 -- Example height
        	cb[i].Anchors = "0,0,1,0" -- Anchoring
        	cb[i].State = 0
        	cb[i].PluginComponent = myHandle
        	cb[i].Clicked = "CheckBoxClicked"
 
		    local yAdj = 20 + (i - 1) * cbHSize

		    cb[i].X, cb[i].Y = 5, yAdj

	end


	--Bottom window Apply & Cancel Buttons
	local buttonGrid = baseLayer:Append('UILayoutGrid')
		buttonGrid.Columns, buttonGrid.Rows, buttonGrid.H, buttonGrid.Anchors = 2, 1, 80, '0,2'

  	local applyButton = buttonGrid:Append('Button')
    	applyButton.Anchors, applyButton.Textshadow, applyButton.HasHover, applyButton.Font, applyButton.TextalignmentH = '0,0', 1, 'Yes', 'Regular28', 'Centre'
    	applyButton.Text = 'Apply'
    	applyButton.PluginComponent = myHandle
    	applyButton.Clicked = 'ApplyButtonClicked'

	local cancelButton = buttonGrid:Append('Button')
    	cancelButton.Anchors, cancelButton.Textshadow, cancelButton.HasHover, cancelButton.Font, cancelButton.TextalignmentH = '1,0', 1, 'Yes', 'Regular28', 'Centre'
    	cancelButton.Text = 'Cancel'
    	cancelButton.PluginComponent = myHandle
    	cancelButton.Clicked = 'CancelButtonClicked'
		

	signalTable.CancelButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		checkBoxState = {"Cancelled"}
		continue = true
	end
    

	signalTable.ApplyButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		continue = true
	end



	--Making the CheckBox Click
  	signalTable.CheckBoxClicked = function(caller)

		if (caller.State == 1) then
			caller.State = 0
		else
			--Logic for Single Selection ("Radio Buttion Style")
			if switchArg == "RadioButton" then
        	
				for j, choice in ipairs(choiceTable) do
					cb[j].State = 0
					checkBoxState[j] = 0
				end
			end

			caller.State = 1
			
		end

		checkBoxState[caller.index] = caller.State

	end

	signalTable.ApplyButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		continue = true
	end
    
	repeat 

	until continue

	return checkBoxState
end

alfredPlease.demonstrateRadioButtons = demonstrateRadioButtons



local function main()

	local tableOfChoices = {
		"Apple",
		"Jackfruit",
		"Mulberry",
		"Pear",
		"Pecan",
		"Walnut"
	}
	--[[ Change the below string to anything other than "RadioButton" to allow multiple checkboxes to be selected ]]
	local theSwitch = "RadioButton"

	local cbResult = alfredPlease.demonstrateRadioButtons(tableOfChoices, theSwitch)

	--Prints Results to the System Monitor
	for p=1, #cbResult do
					Printf(p .. " " .. tableOfChoices[p] .. ", Result = " .. cbResult[p])
				end

end
return main
