--[[
@title: [ Groups.lua ]
@author: [ BakaCowpoke ]
@date: [ 12/23/2025 ]
@description: [ Constructs Group Presets by FixtureType, 
	as well as by non-recursive Patch "Groupings".
	I didn't want to dance with nested Grouping Logic.
	One level was enough for me.  ]
]]



--[[ alfredPlease Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global ]]
local alfredPlease = select(3, ...)



local function buildGroups()

	-- Handles for all Patched Fixtures
	local allFixtures = ObjectList("Fixture Thru")

	--a table to store the FixtureTypes as I pin them down.
	local uniqueFixtureTypes = {}

    -- Check if the list is not empty
    if allFixtures and #allFixtures > 0 then

        -- Loop through the ObjectList
        for i, fixtureHandle in ipairs(allFixtures) do

			local currentFixtureType = fixtureHandle.fixturetype
			local currentFixtureTypeName = fixtureHandle.fixturetype.name

			local foundCFTName = false

			if currentFixtureTypeName == "Grouping" then
				
				--Collecting a table of the FixtureTypes in the patch Groupings
				local kidsFT = alfredPlease.listKidsFixtureTypes(fixtureHandle)
		
				--and storing them where I can find them.
				uniqueFixtureTypes[fixtureHandle.name] = kidsFT

			else

				for i, uFTNames in ipairs(uniqueFixtureTypes) do
					
					if currentFixtureTypeName == uFTNames then

						foundCFTName = true

					end

				end
				
				--adds FixtureTypes to the List if they're not listed already.
				if foundCFTName == false then

					table.insert(uniqueFixtureTypes, currentFixtureType.name)
				
				end

			end

        end

		alfredPlease.storeTheGroups(uniqueFixtureTypes)

    else

        Echo("* Alfred: I Have Not Found any Fixrtures that need to be Organized into Groupa.")
		return
    end

end

--[[Making function accessible to other components in this Plugin 
via the alfredPlease Shared Table]]
alfredPlease.buildGroups = buildGroups



local function listKidsFixtureTypes(argHandle)
--Generating the table of FixtureTypes in the patch "Grouping"

	--[[yeah, I was getting short on Variable names by the 
	second time I built this logic.]]
 	local youthfulWard = argHandle:Children()
	local returnList = {}


    if youthfulWard and #youthfulWard > 0 then

        for i, kidHandle in ipairs(youthfulWard) do
        	local foundMatch = false

            local kidsFTName = kidHandle.fixturetype.name
			
			for key, value in pairs(returnList) do
				if kidsFTName == value then
					foundMatch = true
				end
			end

			if foundMatch == false then
				table.insert(returnList, kidsFTName)
			end
			
        end

	return returnList
    end

end

--[[Making function accessible to other components in this Plugin 
via the alfredPlease Shared Table]]
alfredPlease.listKidsFixtureTypes = listKidsFixtureTypes



local function storeTheGroups(argTable)
	--building the commands to Set & Store the Groups

	--validation
	if type(argTable) == "table" then
		

		for key, argValue in pairs(argTable) do

			local groupCmdSet = ""
			local groupCmdStore = ""

			CmdIndirectWait("Clear")

			--tables here are patch "Groupings"
			if type(argValue) == "table" then
				
				local gAppStoreCmd = 'Store Appearance \"'..tostring(key)..'\" Property \"Color\" \"0,0,0,0.0\"' 
				
				CmdIndirectWait(gAppStoreCmd)
				CmdIndirectWait("Clear")

				--[[ Loop to come up with the Set commands for each 
					Child FixtureType in the patch Grouping ]]
				for key, value in pairs(argValue) do

					groupCmdSet = 'FixtureType \"' .. value .. '\" /All'
					--Printf(groupCmdSet)

					CmdIndirectWait(groupCmdSet)

				end

				groupCmdStore = 'Store Group \"' .. key .. '\" Property \"Appearance\" \"'.. key .. '\" /Universal /Overwrite'

			else
				--values here are plain single FixtureTypes

				local gAppStoreCmd = 'Store Appearance \"'..tostring(argValue)..'\" Property \"Color\" \"0,0,0,0.0\"' 
				CmdIndirectWait(gAppStoreCmd)
				CmdIndirectWait("Clear")

				groupCmdSet = 'FixtureType \"' .. argValue .. '\" /All'
				groupCmdStore = 'Store Group \"' .. argValue .. '\" Property \"Appearance\" \"'.. argValue .. '\" /Universal /Overwrite'

				CmdIndirectWait(groupCmdSet)

			end

			CmdIndirectWait(groupCmdStore)
			CmdIndirectWait("Clear")

		end

	else
	
		ErrPrintf("Alfred: Having Problems Storing the Groups.")
		ErrPrintf("We did Not recieve the expected Table of")
		ErrPrintf("FixtureTypes and Groupings.")

	end

end

--[[Making function accessible to other components in this Plugin 
via the alfredPlease Shared Table]]
alfredPlease.storeTheGroups = storeTheGroups



local function main()
		
alfredPlease.buildGroups()

end

return main