--[[
@title: [ UI Icons Reference.lua ]
@author: [ BakaCowpoke ]
@date: [ 1/31/2026 ]
@license: [ CC0 ]
@description: [ For GrandMA3.  Displays the Icons referenced in 
the UIXML files  ]
]]



--For UI Element Functions
local pluginName = select(1, ...)
local componentName = select(2, ...)
local signalTable = select(3, ...)
local myHandle = select(4, ...)



--[[ alfredPlease Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global.  Makes it easier when I copy and paste code 
between plugins. ]]
local alfredPlease = select(3, ...)



local function uIIconList(choiceTable, switchArg)
	
	local continue = false
	local iButton = {}

	--[[ Items that are commented out in the iconList 
		table were found in my Grep search of the UIXML files, but gave 
		an error when I ran this plugin refernecing them. ]]
	local iconList = {
		--"0",
		"1",
		"add_event",
		"add_multi_events",
		"add_time_marker",
		"AlignCenter",
		"AlignLeft",
		"AlignRight",
		"arrow_down",
		"arrow_left",
		"arrow_right",
		"arrow_triangle",
		"arrow_up",
		"autoCursor",
		"back",
		"Backup",
		"button",
		"camera",
		--"cancel",
		"Cancel",
		"clear_filter",
		"commandWingBar",
		"cooking",
		"cpu",
		"delete_file",
		"DialogButtonIcon",
		"display",
		"Dp",
		"encoder_sym_24px",
		"encoder_sym_64px",
		--"encoder_sym",
		"EtherC",
		"EventsIcon",
		--"ever",
		"exec_button_100_24px",
		"exec_button_200_24px",
		"exec_button_300_24px",
		"exec_button_400_24px",
		"exec_button_X_24px",
		"execconfig",
		"ExecuteSwap20",
		"fader",
		"file",
		"fit_selected",
		"fit",
		"FlipLeftRight",
		"folder_open",
		"folder",
		"follow",
		"grid_symmetrical",
		"hardkey_ma_logo",
		"HSRectIcon",
		"icon_screenshot",
		"icon_timer",
		"icon_turn",
		"ImportExportIcon",
		"invert",
		"keyboard",
		--"LeftRight",
		"LeftToRight",
		"Linearize",
		"link",
		"locked",
		"Locked",
		"logo_small",
		--"ma_logo",
		"manager32",
		"master",
		"MergeAllRight",
		"MergeRight",
		"Midi",
		"minus",
		"move",
		"network",
		"newline",
		"object_3d",
		"object_align",
		"object_appear",
		"object_bitmaps",
		"object_camera",
		"object_clock",
		"object_cmd",
		"object_colpick",
		"object_commandwing",
		"object_content",
		"object_datapool",
		"object_dmx",
		"object_encbar",
		"object_filter",
		"object_fixture",
		"object_fps",
		"object_gels",
		"object_generators",
		"object_gobos",
		"object_group1",
		"object_images",
		"object_info",
		"object_macro",
		"object_matricks",
		"object_matricks",
		"object_meshes",
		"object_message",
		"object_pages",
		"object_phase",
		"object_playback",
		"object_plugin1",
		"object_preset",
		"object_question_small",
		"object_quickey",
		"object_rdm",
		"object_runningpb",
		"object_scribbles",
		"object_sel_bar",
		"object_selgrid",
		"object_sequence",
		"object_smart",
		"object_sound3",
		"object_special_master",
		"object_stepbar",
		"object_symbols",
		"object_sysinfo",
		"object_sysmonitor",
		"object_tags",
		"object_timecode",
		--"object_timecodeslot",
		"object_trackp",
		"object_universe",
		"object_user",
		"object_video",
		"object_world_server",
		"object_world1",
		"object_xkeys",
		--"object",
		"ok",
		"PhaserAddAbsolute",
		"PhaserAddRelative",
		"PhaserCopy",
		"PhaserCut",
		"PhaserFlip",
		"PhaserFormRect",
		"PhaserFormSaw",
		"PhaserFormSaw",
		"PhaserFormSin",
		"PhaserMirrorT",
		"PhaserMirrorX",
		"PhaserMirrorY",
		"PhaserMoveCanvase",
		"PhaserMoveHandle",
		"PhaserMovePoint",
		"PhaserPaste",
		"PhaserPhase",
		"PhaserReset",
		"PhaserRotating",
		--"PhaserRotatingClock",
		"PhaserSelectReset",
		"PhaserSizing",
		"PhaserSwap",
		"PhaserWidth",
		"pivot",
		"PlaybackBackward",
		"PlaybackForward",
		"PlaybackJumpbackward",
		"PlaybackJumpforward",
		"PlaybackPaused",
		"PlaybackRecord",
		"PlaybackStop",
		--"PlaybackTrippleBack",
		"PlaybackTrippleForward",
		"plus",
		"power",
		"PowerC",
		"PowerS",
		"QuestionMarkIcon",
		"reboot",
		"redo",
		"RemoveGaps",
		"RemoveOffset",
		"ResizeFixed",
		"ring",
		"rotate",
		"sel_to_matricks",
		"select",
		"setpivot",
		"settings",
		"setup_citp",
		"setup_patch",
		"setup_protocols",
		"setup_psn",
		"setup_rdm",
		"setup_sw_update",
		"setup_time",
		"setup_user",
		"setup_wings",
		"setup",
		"show_grid",
		"single_fader_big",
		"single_fader",
		"Snap",
		"special_master",
		"star",
		"status_blind",
		"status_dmx_tester_output",
		"status_filter",
		"status_highlight",
		"status_lowlight",
		"status_not_enough_parameters",
		"status_parked",
		"status_preview",
		"status_solo",
		"status_timecode_record",
		"status_world_filter",
		"SubD",
		"suspension",
		"test",
		"time",
		"Time",
		"TimeRangesIcon",
		"tools",
		"TopToBottom",
		"trash",
		"triangle_down",
		"triangle_left", 
		"triangle_right",
		"triangle_up",
		"undo",
		"update_small",
		"UrlBack",
		"UrlFwd",
		"UrlRel",
		"UrlZoomIn",
		"UrlZoomOut",
		"Usb2",
		"Usb3",
		"Xlr3pF",
		"Xlr4pF",
		"Xlr5pF",
		"Xlr5pM",
		--"Yes",
		"zoom"
		}



	
	local baseLayer = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
		baseLayer.Name = 'Basic'
    	baseLayer.H = '70%'  --760
    	baseLayer.W = '20%'  --800
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
    	titleBar[2][2].Size = 100
    	titleBar.Texture = 'corner2'
    	titleBar.Transparent = "No"

	local titleBarIcon = titleBar:Append('TitleButton')
		titleBarIcon.Font = 'Regular24'
    	titleBarIcon.Text = 'UI Icon List'
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
		dialog.BackColor = 83.11

	local scrollbox = dialog:Append("ScrollBox")
    	scrollbox.Name = "mybox"
 
	local scrollbar = dialog:Append("ScrollBarV")
    	scrollbar.ScrollTarget = "../mybox"
    	scrollbar.Anchors = '1,0'
   

	--Titlebars Galore to hold Icons
	for i = 1, #iconList do
    
		local iButSize = 100	
		local iButYAdj = (i - 1) * iButSize

		iButton[i] = scrollbox:Append('Button')
  			iButton[i].Anchors = '0,0'
			iButton[i].H = iButSize
			iButton[i].W = '100%'
			iButton[i].Y = iButYAdj
  			iButton[i].Textshadow = 1
  			iButton[i].HasHover = 'Yes'
  			iButton[i].Text = tostring(iconList[i])
  			iButton[i].Font = 'Medium20'
			iButton[i].TextColor = 'Global.Text'
			iButton[i].TextalignmentH = 'Left'
			iButton[i].Icon = iconList[i]
			iButton[i].IconalignmentH = 'Right'
  			iButton[i].PluginComponent = myHandle
  			iButton[i].Clicked = 'ButtonClicked'

	end
	--End of Icon Button Display

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


	signalTable.ApplyButtonClicked = function(caller)
	    GetFocusDisplay().ScreenOverlay:ClearUIChildren()
		continue = true
	end
    
	repeat 

	until continue

end

alfredPlease.uIIconList = uIIconList



local function main()
		
	alfredPlease.uIIconList()

end
return main
