--[[
@title: [ Tags UI Helper.lua ]
@author: [ BakaCowpoke ]
@date: [ 1/20/2026 ]
@license: [ CC0 ]
@description: [ A GrandMA3 Plugin to make Tagging 
	and Untagging En Masse Much quicker.  ]
]]



--For UI Element Functions
local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)



--[[ alfredPlease Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global ]]
local alfredPlease = select(3, ...)



local function makeOrRemoveTags()

	local tagList = {}
	local fixList = {}
	local seqList = {}
	local cueList = {}

	local tagString = ""
	local targetList = {}

	local targetAction = nil
	local tagPicked = {}
	local targetPicked = {}

	--String to alter the behavior of the Custom UI Items & Functions
	local switchUI = ""

	local retValue = {}

	--Originally there were four but I pruned it down.
	local riddlesThree = {}

	--List of oPtions for the MessageBoxes
	local strTable = {"Create New Tag",
						"Assign Existing Tag", 
						"Unassign Tags", 
						"Fixtures", 
						"Sequences",
						"Cues in a Specific Sequence",
						"All Cues"
						}
	

	riddlesThree['1'] = MessageBox({
		title = "Tags UI Helper",
    	message = "What would you like to do?",
    	commands = {{value = 1, name = strTable[1]}, 
					{value = 2, name = strTable[2]}, 
					{value = 3, name = strTable[3]},
					{value = 0, name = "Cancel"}}
		})

	
	--Clicked the "Cancel" Button
	if riddlesThree['1'].result == 0 then 
		table.insert(retValue, "Cancelled") 
		return retValue 
	end
	


	if riddlesThree['1'].result == 1 then

		targetAction = "Assign"

		--User Input for New Tag
		riddlesThree['2'] = MessageBox({
			title = "Tags UI Helper",
    		message = "Please Enter your New Tag.",
    		commands = {{value = 8, name = "Apply"},
				{value = 0, name = "Cancel"}},
    		inputs = {{name = "User Input", 
				value = "Default Text"}}
			})

		--Clicked the "Cancel" Button
		if riddlesThree['2'].result == 0 then 
			table.insert(retValue, "Cancelled") 
			return retValue 

		--Clicked the "Apply" Button	
		elseif riddlesThree['2'].result == 8 then
			--User Input Results
			tagEntered = riddlesThree['2']['inputs']['User Input']
			table.insert(tagPicked, tagEntered)

		end
	end



	if riddlesThree['1'].result == 2 or riddlesThree['1'].result == 3 then
		
		if riddlesThree['1'].result == 2 then
			targetAction = "Assign"
		elseif riddlesThree['1'].result == 3 then
			targetAction = "Assign Off"
		end


		--Getting All Tags (up to 9999)
		for i=1, 9999 do 

			--[[ Least cumbersome way I coukld find since Tags 
			no longer have a pool of their own in DataPool() ]]
			local tagHandle = ObjectList("Tag " .. i)[1]

			if tagHandle ~= nil then
        	
        		local tagName = tagHandle:Get("Name")

        		table.insert(tagList, tagName)
        	
    		end
		
		end

		--UI needs to alter Behavior based on Input
		switchUI = "tag"

		tagPicked = alfredPlease.tagsUIChecklist(tagList, switchUI)

		--Clicked the "Cancel" Button
		if tagPicked[1] == "Cancelled" then
			table.insert(retValue, "Cancelled") 
			return retValue 
		end
	
		--Finding rhe one Chosen Tag
		for i2=1, #tagPicked do 

			if tagPicked[i2] > 0 then
				tagString = tagList[i2]
			end
			
		end
		
    end

		

	local message1 = "What would you like to Tag or Untag?"

	riddlesThree['3'] = MessageBox({
		title = "Tags UI Helper",
    	message = message1,
    	commands = {{value = 4, name = strTable[4]},
			{value = 5, name = strTable[5]},
			{value = 6, name = strTable[6]},
			{value = 7, name = strTable[7]},
        	{value = 0, name = "Cancel"}}
		})

	--Clicked the "Cancel" Button	
	if riddlesThree['3'].result == 0 then 
		table.insert(retValue, "Cancelled") 
		return retValue 
	end


	if riddlesThree['3'].result == 4 then
		-- Fixture List: Getting All Fixtures

		local fixHandle = ObjectList("Fixture Thru")
	
		for k, v in ipairs(fixHandle) do 

			local fixID = v:Get("FID")
			local fixName = v:Get("Name")

			local fixToInsert = {fid = fixID, name = fixName }
			table.insert(fixList, fixToInsert)
		end

		--UI needs to alter Behavior based on Input
		switchUI = "fixture"

		targetList = alfredPlease.tagsUIChecklist(fixList, switchUI)
		
		--Clicked the "Cancel" Button
		if targetList[1] == "Cancelled" then
			table.insert(retValue, "Cancelled") 
			return retValue 
		end

		--Filtering the Fixtures Selected
		for i3=1, #targetList do 
			if targetList[i3] > 0 then
				table.insert(targetPicked, fixList[i3])
			end
		end

	
	elseif riddlesThree['3'].result == 5 or riddlesThree['3'].result == 6 or riddlesThree['3'].result == 7 then
		--Sequences & Cues List: Getting All
		
		local seqHandle = ObjectList("Sequence Thru")
	
		for k, v in ipairs(seqHandle) do 

			local sIndex = v.index
			local seqName = v.name
			--Printf("Sequence Index: " .. sIndex .. ",  ".. seqName )

			local seqToInsert = {seqIndex = sIndex, name = seqName }
			table.insert(seqList, seqToInsert)

			--Working on a list of Cues
			local seqKids = v:Children()
			for k2, v2 in ipairs(seqKids) do 
				local cIndex = v2.index
				local cueName = v2.name
			
				local cueToInsert = {seqIndex = sIndex, cueIndex = cIndex, name = cueName }
				table.insert(cueList, cueToInsert)
			end
		end


		if riddlesThree['3'].result == 5 then
			--use the established Sequences List as choices
			
			--UI needs to alter Behavior based on Input
			switchUI = "sequence"

			targetList = alfredPlease.tagsUIChecklist(seqList, switchUI)

			--Clicked the "Cancel" Button
			if targetList[1] == "Cancelled" then
				table.insert(retValue, "Cancelled") 
				return retValue 
			end

			--Filtering the chosen Sequences
			for i4=1, #targetList do 
				if targetList[i4] > 0 then

					table.insert(targetPicked, seqList[i4])

				end
			end


		elseif riddlesThree['3'].result == 6 then
			--Cues in a Specific Sequence

			--UI needs to alter Behavior based on Input
			switchUI = "cueInSequence"

			targetList = alfredPlease.tagsUIChecklist(seqList, switchUI)
	
			--Clicked the "Cancel" Button
			if targetList[1] == "Cancelled" then
				table.insert(retValue, "Cancelled") 
				return retValue 
			end

			--Filtering Cues by the Chosen Sequence
			local cueFilter = {}

			for i5=1, #targetList do 

				if targetList[i5] > 0 then
    				
					local seqFilterIndex = seqList[i5].seqIndex
					
					for i6=1, #cueList do 

						if cueList[i6].seqIndex == seqFilterIndex then

							table.insert(cueFilter, cueList[i6])
						end
					end
				end
			end

			--UI needs to alter Behavior based on Input
			switchUI = "cue"

			targetList = alfredPlease.tagsUIChecklist(cueFilter, switchUI)

			--Clicked the "Cancel" Button
			if targetList[1] == "Cancelled" then
				table.insert(retValue, "Cancelled") 
				return retValue 
			end

			--Filtering to find the selected Cues
			for i7=1, #targetList do 
				if targetList[i7] > 0 then
    				
					table.insert(targetPicked, cueFilter[i7])
				end
			end
			

		elseif riddlesThree['3'].result == 7 then
			--All Cues
			
			--UI needs to alter Behavior based on Input
			switchUI = "cue"

			targetList = alfredPlease.tagsUIChecklist(cueList, switchUI)

			--Clicked the "Cancel" Button
			if targetList[1] == "Cancelled" then
				table.insert(retValue, "Cancelled") 
				return retValue 
			end

			--Filtering to find the selected Cues
			for i8=1, #targetList do 
				if targetList[i8] > 0 then
    				
					table.insert(targetPicked, cueList[i8])
				end
			end
		end
	end



	--Building the Assign/UnAssign Commands
	local baseTagCMD = string.format([[%s Tag "%s" At ]], targetAction, tagString)

	for i9=1, #targetPicked do

		local currentTagCMD = ""

		if riddlesThree['3'].result == 4 then 
		--Fixtures
			currentTagCMD = baseTagCMD .. "Fixture " .. targetPicked[i9].fid
		
		elseif riddlesThree['3'].result == 5 then 
		--Sequences
			currentTagCMD = baseTagCMD .. "Sequence " .. targetPicked[i9].seqIndex

		elseif riddlesThree['3'].result == 6 or riddlesThree['3'].result == 7 then
		--Cues in a Sequence OR All Cues

			currentTagCMD = string.format([[%s Sequence %s Cue "%s"]], baseTagCMD, targetPicked[i9].seqIndex, targetPicked[i9].name)
			
		end		

		--Building a list of what was done for the Return to the main function.
		table.insert(retValue, currentTagCMD) 

		--commit the changes
		CmdIndirectWait(currentTagCMD)

	end
	
return retValue
end

--[[ I find it easier to assign functions to Alfred... 
	I build in seperate Components to keep organized.
	using him I can copy and paste functions in without 
	changing code.]]
alfredPlease.makeOrRemoveTags = makeOrRemoveTags



local function tagsUIChecklist(choiceTable, switchArg)
	--Scrolling UI Checkbox List

	--[[ abbreviated code to Add a custom Color to 
		the GlobalColors Pool for use with the UI Elements herein ]]

	local colorList = {
    	{name = "DeepPurple", r = 127, g = 0, b = 127, a = 255}
    	}
	local globalColors =  Root().ColorTheme.ColorGroups.Global    
	local gCKids = globalColors:Children()
	local childIndex = nil

	for _, clValue in ipairs(colorList) do 
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
    
    	end
	end
  	--End of UI Color Additon Code

	--[[ Tricky bit this.  Need to Reset continue to false 
	if you're using the same code to build a second UI box. ]]
	local continue = false

	local checkBoxState = {}
	local cb = {}

	
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
		--Custom UI Color from above Code.
		dialog.BackColor = "Global.DeepPurple"

	local scrollbox = dialog:Append("ScrollBox")
    	scrollbox.Name = "mybox"
 
	local scrollbar = dialog:Append("ScrollBarV")
    	scrollbar.ScrollTarget = "../mybox"
    	scrollbar.Anchors = '1,0'
   

	--Checkboxes Galore
	for i = 1, #choiceTable do
    
		checkBoxState[i] = 0

		local cbHSize = 100

		--
    	cb[i] = scrollbox:Append("CheckBox")

		--[[ Logic to alter the Textbox Input depending on 
			which Table the function Recieveds]]
		if switchArg == "tag" then
        	cb[i].Text = tostring(choiceTable[i])

		elseif switchArg == "fixture" then
			local cbText = tostring ("FID: " .. choiceTable[i].fid .. ", " .. choiceTable[i].name)
			cb[i].Text = cbText

		elseif switchArg == "sequence" or switchArg == "cueInSequence" then
			local cbText = tostring ("Seq#: " .. choiceTable[i].seqIndex .. ", " .. choiceTable[i].name)
			cb[i].Text = cbText

		elseif switchArg == "cue" then
			local cbText = tostring ("Seq#: " .. choiceTable[i].seqIndex .. ", Cue#:" .. choiceTable[i].cueIndex .. ", Cue Name: " .. choiceTable[i].name)
			cb[i].Text = cbText

		end

		cb[i].TextColor = "Global.White"
        cb[i].Font = 'Regular24'
        cb[i].H, cb.W = cbHSize, 200 
        cb[i].Anchors = "0,0,1,0" -- Anchoring
        cb[i].State = 0
        cb[i].PluginComponent = myHandle
        cb[i].Clicked = "CheckBoxClicked"
 
		local yAdj = (i - 1) * cbHSize

		cb[i].X, cb[i].Y = 5, yAdj

	end
	--End of UI Checkboxes

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
		

	--Making the CheckBox Click
  	signalTable.CheckBoxClicked = function(caller)

		if (caller.State == 1) then
			caller.State = 0
		else
			--Logic for Single Selection ("Radio Box Style")
			if switchArg == "tag" or switchArg == "cueInSequence" then
        	
				for j, choice in ipairs(choiceTable) do
					cb[j].State = 0
					checkBoxState[j] = 0
				end
			end

			caller.State = 1
			
		end

		checkBoxState[caller.index] = caller.State

	end

	signalTable.CancelButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		checkBoxState = {"Cancelled"}
		continue = true
	end


	signalTable.ApplyButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		continue = true
	end
    
	repeat 

	until continue

	return checkBoxState

end


alfredPlease.tagsUIChecklist = tagsUIChecklist




local function main()
		
	local response1 = alfredPlease.makeOrRemoveTags()
	
	--Report to the System Monitor what was done.
	Echo("")
	Echo("List of Tagging commands performed:")
	Echo("")
	for i10 = 1, #response1 do
		Echo("   " .. response1[i10])
	end

end
return main
