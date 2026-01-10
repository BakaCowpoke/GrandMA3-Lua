--[[
@title: [ CueHop.lua ]
@author: [ BakaCowpoke ]
@date: [ 12/1/2025 ]
@description: [  First Attempt at a Plugin.  
	Please excuse any faults in the code.

	Randomly "Hops" to another Cue in a Sequence
	Works Best as Custum Command on Executor Handle
	Assuming you've named the Plugin "CueHop" and that 
	the Sequence on the handle is Sequence 3 
	use the below command.

	Plugin 'CueHop' 'Sequence 3'  ]
]]


--First Argument is not used.  Left it as a placeholder.
local function main(handleArg1, arg2)
  

	if arg2 == nil then

        ErrPrintf('Plugin \"Cue Hop\"\'s submitted argument does not exist.')
		ErrPrintf('Please check your Plugin Command!')
        return

    end

	local userSeq2 = arg2

    local userSeq2List = ObjectList(string.format("Sequence \"%s\"", userSeq2))

    if #userSeq2List > 0 then

        --Printf(string.format("Sequence '%s' exists.", userSeq2))

    else

        ErrPrintf('\tPlugin \"Cue Hop\"\'s submitted Sequence')
		ErrPrintf('\tdoes not exist.')
		ErrPrintf('\tPlease check your Plugin Command!')
        return

    end

	--Changing the selected sequence because it's messy trying to identify a sequence other ways
	CmdIndirectWait('Select ' .. userSeq2)	
	
	--Currently Selected Sequence handle.
	local sequ1 = SelectedSequence()

	
    local userSeq2Class = sequ1:GetClass()

    if userSeq2Class ~= "Sequence" then

        ErrPrintf('Plugin \"Cue Hop\"\'s submitted argument is not a Sequence.')
		ErrPrintf('Please check your Plugin Command!')
		return

    end

	--Object List of Cues
	local sequ1ObjList = ObjectList(sequ1 .. " Cue Thru")

	--building a table to recall Cue Numbers from.
  	local cueNumbers = {}
	local cueNumbersTally = 0

    	for i, sequ1ObjList in ipairs(sequ1ObjList) do

        	local cueNoRaw = sequ1ObjList.no

			--Divide by 1000 to give a usable Cue Number.
        	local cueNumber = cueNoRaw / 1000

			table.insert(cueNumbers,cueNumber)
			cueNumbersTally = cueNumbersTally + 1

   		end

	--Current Cue of the submitted Sequence
	local sequ1CurCue = sequ1:CurrentChild()

	-- Minus 2 to account for the OnCue and OffCue.
	local numCues = sequ1:Count() - 2


    local randomCue = 0
	local curCueNumber = 0	

	if sequ1CurCue then
		--Divide by 1000 to give a usable Cue Number.
    	curCueNumber = sequ1CurCue.No/1000
  
	    Printf("Original Cue: " .. curCueNumber .. ' in '..sequ1)

  	else

    	Printf("No active cue in selected sequence.")

  	end


	--[[ elow while loop to test for and handle Null & Empty Sequences & to 
		randomly select a different cue than the Current one. ]]
 	local randCueNotFound = true

	while randCueNotFound == true do

		-- Generate a random integer between 1 and the total number of cues.
  		randomCue = math.random(1, cueNumbersTally)

		--Recall the cue number from the table for below 'if' statement comparisons 
		local test = cueNumbers[randomCue]

		if test == nil then

			ErrPrintf('The Table cueNumbers index: ' ..randomCue.. ' has a nil Value.')
	    	randCueNotFound = false
			break

		elseif test == 0 then

			Echo('Cue Zero...picking another Cue...')
			Echo('')
			Echo('\t\"If at first you don\'t Succeed,')
			Echo('\t\tkeep on Suckin\'...\"')
			Echo('')
			Echo('\t\t\t-Curly Howard')
			Echo('')

		elseif numCues == 0 then

	    	ErrPrintf("The selected sequence has no cues.")
	    	randCueNotFound = false
			break
			
		elseif numCues == 1 then 

			ErrPrintf("\t" ..sequ1.. " has but a single lonesome Cue.") 
			Printf("\tThe Cue Hop Plugin would really like more")
			Printf("\tcues so it might Cavort freely.")

			randCueNotFound = false
			randomCue = curCueNumber
			break

		elseif test == curCueNumber then

			--Keep looping, we want a different cue!  Not the same one.
			Echo('Same Cue we started with...')
			Echo('')
			Echo('\t\"If at first you don\'t Succeed,')
			Echo('\t\tkeep on Suckin\'...\"')
			Echo('')		
			Echo('\t\t\t-Curly Howard')
			Echo('')

		else

			Echo('Success!')
			randomCue = test
			randCueNotFound = false

		end

	end
	

    Cmd('Goto ' .. sequ1 .. ' Cue ' .. tostring(randomCue))

    -- Command Line/System Nonitor Feeback
	Printf("Going to random cue: " ..randomCue.. " in " ..sequ1)	

end

return main
