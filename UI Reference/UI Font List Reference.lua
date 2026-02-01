--[[
@title: [ UI Font List Reference.lua ]
@author: [ BakaCowpoke ]
@date: [ 2/1/2026 ]
@license: [ CC0 ]
@description: [ UI Code to visualize and compare Fonts 
	that exist in the GMA UIXML files. 

	To find the fonts on a Mac.
On a Mac in the Terminal utility I used a Grep search 
to retrieve the text assignments out of the GMA UIXML files.  
Used Piping to prune, sort, and make sure there were not duplicates. 

Grep command was similar to:


grep -roEh "Font=\"([^\"]+)\"" /Users/(Your User Folder)/MALightingTechnology/gma3_2.3.2/shared | sed 's/^.*=//' | sort -u

-roEh = recursive, only Matching, Enable Extended Regular Expressions, no filename
sed portion was to remove "Font=" 
sort defaults to Alphbetical. 
the -u switch on the sort is "Unique", eliminates Duplicates.
]

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



local function fontUIChecklist()

local possibleFont = {
	"console16",
	"console18",
	"console20",
	"console24",
	"Medium20",
	"Regular9",
	--"Regular10",  --In the UIXML files, but causes an error when included
	"Regular11",
	--"Regular12",  --In the UIXML files, but causes an error when included
	"Regular14",
	"Regular18",
	"Regular20",
	"Regular28",
	"Regular32"
	}
	

	--Scrolling UI Checkbox List

	--[[ Tricky bit this.  Need to Reset continue to false 
	if you're using the same code to build a second UI box. ]]
	local continue = false

	local singleSelection = false
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

	local scrollbox = dialog:Append("ScrollBox")
    	scrollbox.Name = "mybox"
 
	local scrollbar = dialog:Append("ScrollBarV")
    	scrollbar.ScrollTarget = "../mybox"
    	scrollbar.Anchors = '1,0'
   

	--Checkboxes Galore

	--[[ Left as Checkboxes partly due to laziness, partly since 
		I'm not certain how I might use this code in the future. ]]

	for i = 1, #possibleFont do
    
		checkBoxState[i] = 0

		local cbHSize = 100

		--
    	cb[i] = scrollbox:Append("CheckBox")

		--[[ Logic to alter the Textbox Input depending on 
			which Table the function Recieveds]]
		if switchArg then
			local cbText = tostring ("")
        	cb[i].Text = cbText
		end

		cb[i].TextColor = "Global.Text"
		cb[i].Text = possibleFont[i]
        cb[i].Font = possibleFont[i]
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


	--Sending Choices to the Command Line History & System Monitor...just because.
	Printf("") --for Legiboility
	Printf("You Chose:")

	for i, v in ipairs(checkBoxState) do
		if v == 1 then 
			Printf("	"..possibleFont[i])
		end
	end

	Printf("") --for Legiboility

	--return checkBoxState

end


alfredPlease.fontUIChecklist = fontUIChecklist




local function main()
		
	alfredPlease.fontUIChecklist()

end
return main
