--[[
@title: [ UI Compact Layout.lua ]
@author: [ BakaCowpoke ]
@date: [ 1/27/2026 ]
@description: [ A Proof of Concept.  
  After reading a post about Running GrandMA with only a single Monitor
  I wanted to Put together a Plugin with UI "Layers".  
  I'm sure I'll put it to use at a later date. ]
]]


--For UI Element Functions
local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)


function main() 

  local continue = false
  local dialogFr = {}
  local dialogPages = 4

  local scrollbox = {}
  local scrollbarV = {}
  local scrollbarH = {}

  local checkBoxState = {}
  local cb = {}

  local faders = {}
  local visibleFrame = nil

    
local baseLayer = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    	baseLayer.H = 700
    	baseLayer.W = 500
    	baseLayer.Columns = 1
    	baseLayer.Rows = 3
    	baseLayer[1][1].SizePolicy = 'Fixed'
    	baseLayer[1][1].Size = 100
    	baseLayer[1][2].SizePolicy = 'Stretch'
    	baseLayer[1][3].SizePolicy = 'Fixed'
    	baseLayer[1][3].Size = 100
    	baseLayer.AutoClose = 'No'
    	baseLayer.CloseOnEscape = 'Yes'
      baseLayer.BackColor = 30.12

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
    	titleBarIcon.Text = 'UI Compact Layout'
    	titleBarIcon.Texture = 'corner1'
    	titleBarIcon.Anchors = '0,0'
    	titleBarIcon.Icon = 'star'

  local titleBarCloseButton = titleBar:Append('CloseButton')
    	titleBarCloseButton.Anchors = '1,0'
    	titleBarCloseButton.Texture = 'corner2'


    --Dialog BackColor List
    local diaBC = { 53.28, 75.14, 105.5, 28.19 }

  for i = 1, dialogPages do
    dialogFr[i] = baseLayer:Append("DialogFrame")
      dialogFr.H, dialogFr[i].W, dialogFr[i].Columns, dialogFr[i].Rows = '95%', '100%', 2, 2
    	dialogFr[i][2][2].SizePolicy = "Content"
      dialogFr[i][1][2].SizePolicy = "Content"
    	dialogFr[i].Anchors = '0,1'
      --dialogFr[i].BackAlpha = '1'

      --Printf(tostring(diaBC[i]))

      dialogFr[i].BackColor = diaBC[i]


      if i == 1 then
        dialogFr[i].Visible = 'Yes' 
        dialogFr[i].Enabled = 'Yes' 
        visibleFrame = 1
      else
        dialogFr[i].Visible = 'No' 
        dialogFr[i].Enabled = 'No' 
      end
  

    scrollbox[i] = dialogFr[i]:Append("ScrollBox")
      scrollbox[i].Name = tostring("mybox"..i)
 
    scrollbarV[i] = dialogFr[i]:Append("ScrollBarV")
      scrollbarV[i].ScrollTarget = tostring("../mybox"..i)
      scrollbarV[i].Anchors = '1,0'

    scrollbarH[i] = dialogFr[i]:Append("ScrollBarH")
      scrollbarH[i].ScrollTarget = tostring("../mybox"..i)
      scrollbarH[i].Anchors = '0,1'
      scrollbarH[i].BackColor = 'Global.Inactive'

  end


  for i = 1, 24 do 

    local faderWidth = 125
    faders[i] = scrollbox[1]:Append('UiFader')

      local faderXAdj = ((faderWidth + 5) * (i-1))

    	faders[i].Text = tostring(i)
      faders[i].W = faderWidth
      faders[i].H = 460
      faders[i].X = faderXAdj
  	  faders[i].ContentDriven = 'Yes'
  	  faders[i].ContentWidth = 'No'
  	  faders[i].TextAutoAdjust = 'Yes'
  	  faders[i].Anchors = '0, 0'
  	  faders[i].Padding = '20, 15'
  	  faders[i].Font = 'Medium20'
  	  faders[i].HasHover = 'No'
  	  faders[i].BackColor = 'Global.Inactive'

  end


  local numCB = 20
  for i = 1, numCB do
    
    checkBoxState[i] = 0

    local cbHSize = 50

    cb[i] = scrollbox[2]:Append("CheckBox")
        cb[i].Text = "Checkbox " .. i
		    cb[i].TextColor = "Global.Text"
        cb[i].H, cb.W = cbHSize, 300 -- Example height
        cb[i].Anchors = "0,0,1,0" -- Anchoring
        cb[i].State = 0
        cb[i].PluginComponent = myHandle
        cb[i].Clicked = "CheckBoxClicked"
 
		    local yAdj = 20 + (i - 1) * cbHSize

		    cb[i].X, cb[i].Y = 5, yAdj

  end

  --adding a Button to the third "page"
  local button2Grid = scrollbox[3]:Append('UILayoutGrid')
		  button2Grid.Columns = 1
    	button2Grid.Rows = 1
    	button2Grid.H = '100%'
    	button2Grid.Anchors = '0,0' 
    
  local toggle2Button = button2Grid:Append('Button')
    	toggle2Button.Anchors = '0,0'
    	toggle2Button.Textshadow = 1
    	toggle2Button.HasHover = 'Yes'
    	toggle2Button.Text = 'Toggle'
    	toggle2Button.Font = 'Regular32'
    	toggle2Button.TextalignmentH = 'Centre'
    	toggle2Button.PluginComponent = myHandle
    	toggle2Button.Clicked = 'togglButtonClicked'

  --Bottom Buttons (Apply & Cancel)
  local buttonGrid = baseLayer:Append('UILayoutGrid')
		buttonGrid.Columns = 2
    	buttonGrid.Rows = 1
    	buttonGrid.H = 80
    	buttonGrid.Anchors = '0,2' 

  	local toggleButton = buttonGrid:Append('Button')
    	toggleButton.Anchors = '0,0'
    	toggleButton.Textshadow = 1
    	toggleButton.HasHover = 'Yes'
    	toggleButton.Text = 'Toggle'
    	toggleButton.Font = 'Regular28'
    	toggleButton.TextalignmentH = 'Centre'
    	toggleButton.PluginComponent = myHandle
    	toggleButton.Clicked = 'togglButtonClicked'

	local cancelButton = buttonGrid:Append('Button')
    	cancelButton.Anchors = '1,0'
    	cancelButton.Textshadow = 1
    	cancelButton.HasHover = 'Yes'
    	cancelButton.Text = 'Cancel'
    	cancelButton.Font = 'Regular28'
    	cancelButton.TextalignmentH = 'Centre'
    	cancelButton.PluginComponent = myHandle
    	cancelButton.Clicked = 'CancelButtonClicked'


  --Changes the state of the checkbox if it is clicked
  signalTable.CheckBoxClicked = function(caller)

  --Printf(caller.name.." Index = "..caller.index)

    if (caller.State == 1) then
      caller.State = 0
    else
      caller.State = 1
    end

    checkBoxState[caller.index] = caller.State

    --[[
    for i=1, #checkBoxState do 
      Printf("State of #%d = %d", i, checkBoxState[i])
    end
    ]]

  end

  signalTable.CancelButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		checkBoxState = {"Cancelled"}
		continue = true
	end


	signalTable.togglButtonClicked = function(caller)
	    --GetFocusDisplay().ScreenOverlay:ClearUIChildren()
      
      --Logic for turning the "Pages" "On" and "Off"
      local numPages = #dialogFr

      local currentView = visibleFrame
      local nextView = visibleFrame + 1

      --Printf("NextView = "..nextView .. " NumPages = ".. numPages)
      if nextView > numPages then

        dialogFr[currentView].Visible = 'No' 
        dialogFr[currentView].Enabled = 'No' 

        dialogFr[1].Visible = 'Yes' 
        dialogFr[1].Enabled = 'Yes' 

        visibleFrame = 1

      else

        dialogFr[currentView].Visible = 'No' 
        dialogFr[currentView].Enabled = 'No' 

        dialogFr[nextView].Visible = 'Yes' 
        dialogFr[nextView].Enabled = 'Yes' 

        visibleFrame = nextView
      end

		--continue = true

	end

  repeat 

	until continue


end
return main


 

