--[[
@title: [ UI Icon List Reference.lua ]
@author: [ BakaCowpoke ]
@date: [ 2/2/2026 ]
@description: [ For GrandMA3.  Displays the Icons referenced in 
the UIXML files.

Used a Grep search in Mac Terminal to search for Icons & Textures in the UIXML files.
Revised search after looking at "Gma3 Icon List" by Jeremy Dufeux of Carrot Industries

I believe I've found about 7 more Icons...I think.

Added a Tooltip for the Icons that hog the space.
Names show up in Grey in the Command Line when you hover over them.

I'll come back to it at a later date.
  
]
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

  local visibleFrame = nil

  local iconList = {}
	local iButton = {}

  --local buttonGrid = {}
  --local toggleButton = {}
  --local cancelButton = {}



	--[[ Items that are commented out in the textureSearch 
		table were found in my search of the UIXML files, but gave 
		an error when I ran this plugin refernecing them. 

    Used Grep on Mac in Terminal Utility.
    Grep|sed|sort command below:
    
    grep -Eorh "Texture {1,2}Name=\"([^\"]+)\"" /Users/(Your User Folder)/MALightingTechnology/gma3_2.3.2/shared | sed 's/^.*=//' | sort -u
   
    ]]
	local textureSearch = {
		"add_event", 
		"add_multi_events", 
		"add_time_marker", 
		"AlignCenter", 
		"AlignLeft", 
		"AlignRight", 
		"and", 
		"arrow_down", 
		"arrow_left", 
		"arrow_right", 
		"arrow_triangle", 
		"arrow_up", 
		"autoCursor", 
		"back", 
		"backup_as", 
		"backup", 
		"ball_hole", 
		"ball3d", 
		"bat_0", 
		"bat_100", 
		"bat_25", 
		"bat_50", 
		"bat_75", 
		"bat_none", 
		"batt_charge", 
		"batt_fault", 
		"batt", 
		"bell", 
		"button_200_with_fader", 
		"button_300_with_encoder", 
		"button_400_with_encoder", 
		"button_press", 
		"button_release", 
		"button_sym", 
		"button_with_encoder", 
		"button_with_fader", 
		"button_with_wheel", 
		"button", 
		"ButtonOffIcon", 
		"ButtonOnIcon", 
		"calculator", 
		"camera", 
		"cameraToSelection", 
		"cancel", 
		"Center", 
		"chat", 
		"checkboard", 
		"CheckboxChecked", 
		"CheckboxUnchecked", 
		"circle_outline_empty", 
		"circle_outline_full", 
		"circle", 
		"CircleBackground", 
		"CircleBackground2", 
		"CircleBackground256", 
		"CircleBackground2HR", 
		"CircleBackgroundInv256", 
		"CircleChecker", 
		"CircleForeground", 
		"CircleForegroundHR", 
		"CircleOpen", 
		"CircleOpenTransparent", 
		"CircleThick", 
		"clear_filter", 
		"close", 
		"ColorTest1", 
		"ColorTest2", 
		"ColorTest3", 
		"commandWingBar", 
		"console", 
		"context", 
		"conventional", 
		"cooking", 
		"cpu", 
		"cursor_large", 
		"cursor_medium", 
		"cursor_move_tool_large", 
		"cursor_move_tool_medium", 
		"cursor_move_tool", 
		"cursor_resize_cell_large", 
		"cursor_resize_cell_medium", 
		"cursor_resize_cell", 
		"cursor_resize_large", 
		"cursor_resize_medium", 
		"cursor_resize_row_large", 
		"cursor_resize_row_medium", 
		"cursor_resize_row", 
		"cursor_resize_tool_fixed_large", 
		"cursor_resize_tool_fixed_medium", 
		"cursor_resize_tool_fixed", 
		"cursor_resize_tool_large", 
		"cursor_resize_tool_medium", 
		"cursor_resize_tool", 
		"cursor_resize", 
		"cursor", 
		"CurveBrush01", 
		"CurveBrush02", 
		"CurveIcon", 
		"delete_file", 
		"DeleteLines", 
		"dependency_indicator", 
		"device_onpc", 
		"device_xport", 
		"DiagonalCross", 
		"DialogButtonIcon", 
		"digits_sdf", 
		"display", 
		"dot", 
		"dotted1", 
		"dotted2", 
		"dotted4", 
		"dotted6", 
		"Dp", 
		"drop_shadow", 
		"dynamic_filter_24px", 
		"dynamic_filter_title_bar", 
		"encoder_left_right", 
		"encoder_left", 
		"encoder_right", 
		"encoder_sym_24px", 
		"encoder_sym_64px", 
		"encoderbar", 
		"EncoderBothActive", 
		"EncoderInnerActive", 
		"EncoderOuterActive", 
		"EtherC", 
		"EventsIcon", 
		"exec_button_100_24px", 
		"exec_button_100_64px", 
		"exec_button_200_24px", 
		"exec_button_200_64px", 
		"exec_button_300_24px", 
		"exec_button_300_64px", 
		"exec_button_400_24px", 
		"exec_button_400_64px", 
		"exec_button_special_1_64px", 
		"exec_button_special_2_64px", 
		"exec_button_special_3_64px", 
		"exec_button_X_24px", 
		"exec_button_X_64px", 
		"execconfig", 
		"ExecuteAt10", 
		"ExecuteAt20", 
		"ExecuteAt84", 
		"ExecuteBlack10", 
		"ExecuteBlack20", 
		"ExecuteBlack84", 
		"ExecuteCall10", 
		"ExecuteCall20", 
		"ExecuteCall84", 
		"ExecuteDoubleSpeed10", 
		"ExecuteDoubleSpeed20", 
		"ExecuteDoubleSpeed84", 
		"ExecuteEnd", 
		"ExecuteFastSync10", 
		"ExecuteFastSync20", 
		"ExecuteFastSync84", 
		"ExecuteFlash10", 
		"ExecuteFlash20", 
		"ExecuteFlash84", 
		"ExecuteFlashDownRel", 
		"ExecuteFlashUpRel", 
		"ExecuteGo10", 
		"ExecuteGo20", 
		"ExecuteGo84", 
		"ExecuteGoBack10", 
		"ExecuteGoBack20", 
		"ExecuteGoBack84", 
		"ExecuteGoBackFast10", 
		"ExecuteGoBackFast20", 
		"ExecuteGoBackFast84", 
		"ExecuteGoFast10", 
		"ExecuteGoFast20", 
		"ExecuteGoFast84", 
		"ExecuteGoto10", 
		"ExecuteGoto20", 
		"ExecuteGoTo84", 
		"ExecuteHalfSpeed10", 
		"ExecuteHalfSpeed20", 
		"ExecuteHalfSpeed84", 
		"ExecuteKill10", 
		"ExecuteKill20", 
		"ExecuteKill84", 
		"ExecuteLearn10", 
		"ExecuteLearn20", 
		"ExecuteLearn84", 
		"ExecuteLearnSpeed10", 
		"ExecuteLearnSpeed20", 
		"ExecuteLearnSpeed84", 
		"ExecuteLoad10", 
		"ExecuteLoad20", 
		"ExecuteLoad84", 
		"ExecuteLogin10", 
		"ExecuteLogin20", 
		"ExecuteLogin84", 
		"ExecuteOff10", 
		"ExecuteOff20", 
		"ExecuteOff84", 
		"ExecuteOn10", 
		"ExecuteOn20", 
		"ExecuteOn84", 
		"ExecutePause10", 
		"ExecutePause20", 
		"ExecutePause84", 
		"ExecuteRate110", 
		"ExecuteRate120", 
		"ExecuteRate184", 
		"ExecuteReSync10", 
		"ExecuteReSync20", 
		"ExecuteReSync84", 
		"ExecuteSelect10", 
		"ExecuteSelect20", 
		"ExecuteSelect84", 
		"ExecuteSelectFixtures10", 
		"ExecuteSelectFixtures20", 
		"ExecuteSelectFixtures84", 
		"ExecuteSpeed110", 
		"ExecuteSpeed120", 
		"ExecuteSpeed184", 
		"ExecuteSwap10", 
		"ExecuteSwap20", 
		"ExecuteSwap84", 
		"ExecuteTemp10", 
		"ExecuteTemp20", 
		"ExecuteTemp84", 
		"ExecuteTempRel", 
		"ExecuteTime10", 
		"ExecuteTime20", 
		"ExecuteTime84", 
		"ExecuteToggle10", 
		"ExecuteToggle20", 
		"ExecuteToggle84", 
		"ExecuteToggleRel", 
		"ExecuteTop10", 
		"ExecuteTop20", 
		"ExecuteTop84", 
		"ExternMonitor", 
		"factory", 
		"fader_slot", 
		"fader_sym", 
		"fader", 
		"FaderAssignment", 
		"FaderbandH", 
		"FaderbandV", 
		"FaderGrad1", 
		"FaderGrad2", 
		"file", 
		"fit_selected", 
		"fit", 
		"FlipLeftRight", 
		"folder_open", 
		"folder", 
		"follow", 
		"forbidden", 
		"gdtf", 
		"globe", 
		"glow", 
		"gma2", 
		"gma3", 
		"grad_round_h", 
		"grad_round_v", 
		"grid_symmetrical", 
		"hardkey_setup", 
		"HSCircle", 
		"HSRect", 
		"HSRectChecker", 
		"HSRectCovered", 
		"HSRectIcon", 
		"icon_color_picker", 
		"icon_screenshot", 
		"icon_swap", 
		"icon_timer", 
		"icon_turn", 
		"IconFPS100", 
		"IconFPS24", 
		"IconFPS25", 
		"IconFPS30", 
		"IconFPS60", 
		"ImportExportIcon", 
		"infinity", 
		"invert", 
		"keyboard", 
		"led_rect", 
		"led", 
		--"LeftRight", 
		"LeftToRight", 
		"LightV2Icon", 
		"Linearize", 
		"link", 
		"locked_big_red", 
		"locked_big", 
		"locked", 
		"logo_ball", 
		--"logo14", 
		--"logo8", 
		"ma_key", 
		"manager32", 
		"master", 
		"max_1080", 
		"memory", 
		"MergeAllLeft", 
		"MergeAllRight", 
		"MergeLeft", 
		"MergeRight", 
		"message_center_alert", 
		"message_center_error", 
		"message_center_spam", 
		"message_center_warning", 
		"message", 
		"Midi", 
		"minus", 
		"mirror", 
		"move", 
		"network", 
		"newline", 
		"no_forward", 
		"no_record", 
		--"NormalSign", 
		"object_3d", 
		"object_agenda", 
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
		"object_fixture1", 
		"object_fixture2", 
		"object_fps", 
		"object_gels", 
		"object_generators", 
		"object_gobos", 
		"object_group1", 
		"object_group2", 
		"object_images", 
		"object_info", 
		"object_layout", 
		"object_macro", 
		"object_master1", 
		"object_master2", 
		"object_master3", 
		"object_master4", 
		"object_matricks", 
		"object_menu1", 
		"object_menu2", 
		"object_menu3", 
		"object_menu4", 
		"object_meshes", 
		"object_message", 
		"object_note", 
		"object_pages", 
		"object_phase", 
		"object_playback", 
		"object_plugin1", 
		"object_plugin2", 
		"object_plugin3", 
		"object_preset", 
		"object_progparts", 
		"object_question_small", 
		"object_question", 
		"object_quickey", 
		"object_rdm", 
		"object_runningpb", 
		"object_scribbles", 
		"object_scrnconfig1", 
		"object_scrnconfig2", 
		"object_sel_bar", 
		"object_selgrid", 
		"object_sequence_small", 
		"object_sequence", 
		"object_smart", 
		"object_sound1", 
		"object_sound2", 
		"object_sound3", 
		"object_special_master", 
		"object_stepbar", 
		"object_subfixture1", 
		"object_subfixture2", 
		"object_symbols", 
		"object_sysinfo", 
		"object_sysmonitor", 
		"object_tags", 
		"object_timecode", 
		"object_timecodeslots", 
		"object_trackp", 
		"object_universe", 
		"object_user", 
		"object_video", 
		"object_view", 
		"object_view2", 
		"object_world_server", 
		"object_world1", 
		"object_xkeys", 
		"objectaction_flash", 
		"objectaction_go", 
		"objectaction_select", 
		"objectaction_temp", 
		"objectaction_toggle", 
		"ok", 
		"or", 
		"PhaserAddAbsolute", 
		"PhaserAddRelative", 
		"PhaserBeam", 
		"PhaserCopy", 
		"PhaserCut", 
		"PhaserFlip", 
		"PhaserFormCos", 
		"PhaserFormRect", 
		"PhaserFormSaw", 
		"PhaserFormSin", 
		"PhaserMirrorT", 
		"PhaserMirrorX", 
		"PhaserMirrorY", 
		"PhaserMoveCanvase", 
		"PhaserMoveHandle", 
		"PhaserMovePoint", 
		"PhaserMoveSmall", 
		"PhaserPaste", 
		"PhaserPhase", 
		"PhaserPhaseAligned", 
		"PhaserPhaseReset", 
		"PhaserReset", 
		"PhaserRotating", 
		"PhaserRotatingClockwise", 
		"PhaserSelectReset", 
		"PhaserSizing", 
		"PhaserSizingSmall", 
		"PhaserSplineAbsolute", 
		"PhaserSplineHandle", 
		"PhaserSplinePosition", 
		"PhaserSplinePosition32", 
		"PhaserSplinePositionThin", 
		"PhaserSplineRelative", 
		"PhaserSwap", 
		"PhaserWidth", 
		"pin", 
		"pivot", 
		"playback_tracked", 
		"PlaybackBackward", 
		"PlaybackFastbackward", 
		"PlaybackFastforward", 
		"PlaybackFastupward", 
		"PlaybackForward", 
		"PlaybackJumpbackward", 
		"PlaybackJumpforward", 
		"PlaybackPaused", 
		"PlaybackRecord", 
		"PlaybackStop", 
		"PlaybackTrippleBackward", 
		"PlaybackTrippleForward", 
		"plus", 
		"pool_individual_selectsquare", 
		"pool_individual_selfix_at", 
		"pool_individual_selfix_extrakt", 
		"power", 
		"PowerC", 
		"PowerS", 
		"prio_high", 
		"prio_highest", 
		"prio_htp", 
		"prio_low", 
		"prio_lowest", 
		"prio_ltp", 
		"prio_super", 
		"prio_swap", 
		"PropertyInputIcon", 
		"QuestionMarkIcon", 
		"QuickSaveIcon", 
		"RadioButtonOff", 
		"RadioButtonOn", 
		"RadioButtonSmallOff", 
		"RadioButtonSmallOn", 
		"reboot", 
		"Rect1", 
		"Rect2", 
		"Rect3", 
		"Rect4", 
		"redo", 
		"refresh", 
		"RemoveGaps", 
		"RemoveOffset", 
		"reset_filter", 
		"ResizeFixed", 
		"ResizeFixedSmall", 
		"ResizeX", 
		"ResizeY", 
		"ring", 
		"rotate", 
		"SaveAsIcon", 
		"SaveIcon", 
		"scroll_handle_h", 
		"scroll_handle_v", 
		"sel_to_matricks", 
		"select", 
		"setpivot", 
		"settings", 
		"setup_citp", 
		"setup_patch_live", 
		"setup_patch", 
		"setup_protocols", 
		"setup_psn", 
		"setup_rdm", 
		"setup_settings", 
		"setup_sw_update", 
		"setup_time", 
		"setup_user", 
		"setup_wings", 
		"setup", 
		--"setup2", 
		"show_grid", 
		"show", 
		"single_fader_big", 
		"single_fader", 
		"slot_rect_h", 
		"slot_rect_v", 
		"small_icon_absolute", 
		"small_icon_active", 
		"small_icon_artnet", 
		"small_icon_at_preset", 
		"small_icon_backwards", 
		"small_icon_button", 
		"small_icon_cli", 
		"small_icon_clicking_hand", 
		"small_icon_clock", 
		"small_icon_cooking_template", 
		"small_icon_cooking", 
		"small_icon_countdown", 
		"small_icon_default", 
		"small_icon_dynamic_filter", 
		"small_icon_encoder_bar_resolution_coarse", 
		"small_icon_encoder_bar_resolution_fine", 
		"small_icon_encoder_bar_resolution_increment", 
		"small_icon_encoder_bar_resolution_native", 
		"small_icon_error", 
		"small_icon_execute_at", 
		"small_icon_execute_call", 
		"small_icon_execute_flash", 
		"small_icon_execute_select", 
		"small_icon_execute_temp", 
		"small_icon_execute_toggle", 
		"small_icon_fader", 
		"small_icon_filter", 
		"small_icon_generator", 
		"small_icon_global", 
		"small_icon_h", 
		"small_icon_highlight", 
		"small_icon_hint", 
		"small_icon_infinity", 
		"small_icon_input_filter", 
		"small_icon_input_output_filter", 
		"small_icon_integrated", 
		"small_icon_l", 
		"small_icon_locked", 
		"small_icon_lowlight", 
		"small_icon_magic", 
		"small_icon_master_additive", 
		"small_icon_master_negative", 
		"small_icon_master_positive", 
		"small_icon_master_scaling", 
		"small_icon_matricks", 
		"small_icon_midi", 
		"small_icon_multi_events", 
		"small_icon_multi_step", 
		"small_icon_ndi", 
		"small_icon_note", 
		"small_icon_output_filter", 
		"small_icon_p", 
		"small_icon_parked", 
		"small_icon_pause", 
		"small_icon_play", 
		"small_icon_pool_limited", 
		"small_icon_record", 
		"small_icon_referenced_integrated", 
		"small_icon_referenced", 
		"small_icon_relative", 
		"small_icon_sacn", 
		"small_icon_selective", 
		"small_icon_selfix_at", 
		"small_icon_selfix_extract", 
		"small_icon_selfix", 
		"small_icon_shared_data", 
		"small_icon_star", 
		"small_icon_stopwatch", 
		"small_icon_tag", 
		"small_icon_tester", 
		"small_icon_time", 
		"small_icon_timecode", 
		"small_icon_timer", 
		"small_icon_universal", 
		"small_icon_warning", 
		"small_icon_world", 
		"small_icon_xlr", 
		"SmallCircle", 
		"SmallCross", 
		"SmallRing", 
		"Snap", 
		"sort_asc", 
		"sort_desc", 
		"sound_mute", 
		"Spdif", 
		"special_master", 
		"spot", 
		"star", 
		"status_blind", 
		"status_dmx_tester_output", 
		"status_filter", 
		"status_highlight", 
		"status_lowlight", 
		"status_not_enough_parameters", 
		"status_parameter_overload", 
		"status_parked", 
		"status_preview", 
		"status_solo", 
		"status_timecode_record", 
		"status_world_filter", 
		"SubD", 
		"suspension", 
		"SwipeButtonIcon", 
		"tc_diamond", 
		"test", 
		"text_cursor", 
		"time", 
		"TimeRangesIcon", 
		"tiny_cross", 
		"ToggleButtonIcon", 
		"tools", 
		"TopToBottom", 
		"transp", 
		"trash", 
		"treeview_corner_last", 
		"treeview_corner_more", 
		"treeview_horizontal", 
		"treeview_vertical", 
		"triangle_down", 
		"triangle_left", 
		"triangle_right", 
		"triangle_up", 
		"ts_greater_zero", 
		"ts_rising_from_zero", 
		"undo", 
		"update_add_simple", 
		"update_add", 
		"update_simple", 
		"update_small", 
		"update", 
		--"UpDown", 
		"UrlBack", 
		"UrlFwd", 
		"UrlRel", 
		"UrlZoomIn", 
		"UrlZoomOut", 
		"Usb2", 
		"Usb3", 
		"user", 
		"view_at_0000001", 
		"view_at_0000010", 
		"view_at_0000011", 
		"view_at_0000100", 
		"view_at_0000101", 
		"view_at_0000110", 
		"view_at_0000111", 
		"view_at_0001000", 
		"view_at_0001001", 
		"view_at_0001010", 
		"view_at_0001011", 
		"view_at_0001100", 
		"view_at_0001101", 
		"view_at_0001110", 
		"view_at_0001111", 
		"view_at_0010000", 
		"view_at_0010001", 
		"view_at_0010010", 
		"view_at_0010011", 
		"view_at_0010100", 
		"view_at_0010101", 
		"view_at_0010110", 
		"view_at_0010111", 
		"view_at_0011000", 
		"view_at_0011001", 
		"view_at_0011010", 
		"view_at_0011011", 
		"view_at_0011100", 
		"view_at_0011101", 
		"view_at_0011110", 
		"view_at_0011111", 
		"view_at_0100000", 
		"view_at_0100001", 
		"view_at_0100010", 
		"view_at_0100011", 
		"view_at_0100100", 
		"view_at_0100101", 
		"view_at_0100110", 
		"view_at_0100111", 
		"view_at_0101000", 
		"view_at_0101001", 
		"view_at_0101010", 
		"view_at_0101011", 
		"view_at_0101100", 
		"view_at_0101101", 
		"view_at_0101110", 
		"view_at_0101111", 
		"view_at_0110000", 
		"view_at_0110001", 
		"view_at_0110010", 
		"view_at_0110011", 
		"view_at_0110100", 
		"view_at_0110101", 
		"view_at_0110110", 
		"view_at_0110111", 
		"view_at_0111000", 
		"view_at_0111001", 
		"view_at_0111010", 
		"view_at_0111011", 
		"view_at_0111100", 
		"view_at_0111101", 
		"view_at_0111110", 
		"view_at_0111111", 
		"view_at_1000000", 
		"view_at_1000001", 
		"view_at_1000010", 
		"view_at_1000011", 
		"view_at_1000100", 
		"view_at_1000101", 
		"view_at_1000110", 
		"view_at_1000111", 
		"view_at_1001000", 
		"view_at_1001001", 
		"view_at_1001010", 
		"view_at_1001011", 
		"view_at_1001100", 
		"view_at_1001101", 
		"view_at_1001110", 
		"view_at_1001111", 
		"view_at_1010000", 
		"view_at_1010001", 
		"view_at_1010010", 
		"view_at_1010011", 
		"view_at_1010100", 
		"view_at_1010101", 
		"view_at_1010110", 
		"view_at_1010111", 
		"view_at_1011000", 
		"view_at_1011001", 
		"view_at_1011010", 
		"view_at_1011011", 
		"view_at_1011100", 
		"view_at_1011101", 
		"view_at_1011110", 
		"view_at_1011111", 
		"view_at_1100000", 
		"view_at_1100001", 
		"view_at_1100010", 
		"view_at_1100011", 
		"view_at_1100100", 
		"view_at_1100101", 
		"view_at_1100110", 
		"view_at_1100111", 
		"view_at_1101000", 
		"view_at_1101001", 
		"view_at_1101010", 
		"view_at_1101011", 
		"view_at_1101100", 
		"view_at_1101101", 
		"view_at_1101110", 
		"view_at_1101111", 
		"view_at_1110000", 
		"view_at_1110001", 
		"view_at_1110010", 
		"view_at_1110011", 
		"view_at_1110100", 
		"view_at_1110101", 
		"view_at_1110110", 
		"view_at_1110111", 
		"view_at_1111000", 
		"view_at_1111001", 
		"view_at_1111010", 
		"view_at_1111011", 
		"view_at_1111100", 
		"view_at_1111101", 
		"view_at_1111110", 
		"view_at_1111111", 
		"view_locked", 
		"VolumeIcon", 
		"warning_triangle_big", 
		"warning_triangle", 
		"wash", 
		"wheel_sym", 
		"white", 
		"windows", 
		"wizard", 
		"Xlr3pF", 
		"Xlr4pF", 
		"Xlr5pF", 
		"Xlr5pM", 
		"XYZColorsChecker", 
		"XYZColorsClear", 
		"XYZColorsCovered", 
		"zoom" 
		}
	


  --[[ Items that are commented out in the iconSearch 
		  table were found in my search of the UIXML files, but gave 
		  an error when I ran this plugin refernecing them. 

      Used Grep on Mac in Terminal Utility.
      Grep|sed|sort command below:
    
     grep -Eorh "Icon=\"([^\"]+)\"" /Users/(Your User Folder)/MALightingTechnology/gma3_2.3.2/shared | sed 's/^.*=//' | sort -u
    
     ]]

	local iconSearch = {
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
		"cancel",
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
		"exec_button_100_24px",
		"exec_button_100_64px",
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
		--"No",
		"object_3d",
		"object_agenda",
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
		"object_layout",
		"object_macro",
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
		"object_timecodeslots",
		"object_trackp",
		"object_universe",
		"object_user",
		"object_video",
		"object_view",
		"object_world_server",
		"object_world1",
		"object_xkeys",
		"ok",
		"PhaserAddAbsolute",
		"PhaserAddRelative",
		"PhaserCopy",
		"PhaserCut",
		"PhaserFlip",
		"PhaserFormRect",
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
		"PhaserRotatingClockwise",
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
		"PlaybackTrippleBackward",
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
	

  --Merging the two lists  
	iconList = iconSearch
	
	for i, v in ipairs(textureSearch) do
		local foundIt = false

		for j=0, #iconList do
			if v == iconList[j] then
				foundIt = true
				break
			end
		end

		if foundIt == false then
			table.insert(iconList, v)
		end
	end

	Printf("# of Entries in iconList= " .. #iconList)

    








  local baseLayer = GetFocusDisplay().ScreenOverlay:Append('BaseInput')
    	baseLayer.H = 800
    	baseLayer.W = 600
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
    	titleBarIcon.Text = 'UI Icon List Reference'
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


  local loopCount = 0
  local spread = math.ceil(#iconList/dialogPages)

  for j = 1, dialogPages do

    local iButtonLimiter = spread * j
    iButton[j] = {}

    --Titlebars Galore to hold Icons
	  for k = 1, spread do
      loopCount = loopCount + 1

		  local iButSize = 140	
		  local iButYAdj = (k - 1) * iButSize 
		  local iButtText = string.format("'%s'", iconList[loopCount])

		  iButton[j][k] = scrollbox[j]:Append('Button')
  		  iButton[j][k].Anchors = '0.1,0'
			  iButton[j][k].H = iButSize
			  iButton[j][k].W = '100%'
			  iButton[j][k].Y = iButYAdj
  		  iButton[j][k].Textshadow = 1
  		  iButton[j][k].HasHover = 'Yes'
  		  iButton[j][k].Text = iButtText
        iButton[j][k].Tooltip = iButtText
  		  iButton[j][k].Font = 'Medium20'
			  iButton[j][k].TextColor = 'Global.Text'
			  iButton[j][k].TextalignmentV = 'Centre'
			  iButton[j][k].Icon = iconList[loopCount]
			  iButton[j][k].IconalignmentV = 'Top'
  		  iButton[j][k].PluginComponent = myHandle
  		  iButton[j][k].Clicked = 'ButtonClicked'

		  if loopCount >= iButtonLimiter then
        break
      end
	  end
  end
	  --End of Icon Button Display
  
Printf(iButton[1][1]:Dump())

  for i=1, dialogPages do 

    --Bottom Buttons (Next & Cancel)
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
