--[[
@title: [ Gobos.lua ]
@author: [ BakaCowpoke ]
@date: [ 1/3/2026 ]
@description: [  Tracks down FixtureTypes that have Gobo Wheels & gets 
    the number of Slots in each.
    Stores Pallettes for each via Command Line commands.

    Useful for GDTF Profiles that do not play well with the GrandMA3 Show Creator.

    Note: Multiple approaches to this do not work for Numerous reasons. 
    mostly incompatibility bertween GrandMA & the way Manufacturers create GDTFs for their 
    fixtures. (Zeroes in PhysFrom & PhysTo values for one)  I stumbled across the appropriate 
    command line syntax to make this work with how far I had already gotten after about two weeks. ]
--]]



--[[ alfredPlease Shared Plugin Table (Namespace) Definition
for sharing functions across Plugin Components without making 
them Global ]]
local alfredPlease = select(3, ...)



local function buildTheGoboPresets()

    --Begin the Sleuthing!

    --ObjectList of all Fixtures
    local fixtureTypesList = ObjectList("FixtureType *")

    --Table for details of found Gobos and Wheels
    local hasGobos = {}

    --Running through all the FixtureTypes
    for k, fixtureType in pairs(fixtureTypesList) do
    
        --Wheel Parent
        local wheels = fixtureType.Wheels


        if wheels and wheels:Count() > 0 then

            -- Iterate through each specific wheel
            for j, wheel in ipairs(wheels:Children()) do

                local currentWheelName = wheel.Name

                --table to act as a Boolean to find the wheels we want.
                local validWheelNames = {
                    ['G1'] = true,
                    ['g1'] = true,
                    ['Gobo1'] = true,
                    ['gobo1'] = true,
                    ['GOBO1'] = true,
                    ['G2'] = true,
                    ['g2'] = true,
                    ['Gobo2'] = true,
                    ['gobo2'] = true,
                    ['GOBO2'] = true,
                    ['G3'] = true,
                    ['g3'] = true,
                    ['Gobo3'] = true,
                    ['gobo3'] = true,
                    ['GOBO3'] = true
                }
                --Eureka!  Found one of the wheels!
                if  validWheelNames[currentWheelName] then

                    --Making a name Pallateable to the Command Line
                    local cWNameEnd = string.sub(currentWheelName, -1)

                    --Constructing the Results Table (hasGobos)
                    local numSlots1 = wheel:Count()

                    local tableToInsert = {['wCmdName'] = tostring("Gobo" .. cWNameEnd), ['Wheel'] = wheel.Name, ['Slots'] = numSlots1}

                    --[[if the FixtureType hasn't been iterated through yet, 
                        create the empty table to target.]]
                    if not hasGobos[fixtureType.Name] then
                        
                        hasGobos[fixtureType.Name] = {}
                       
                    end  
                    
                    --Note thre important bits!
                    table.insert( hasGobos[fixtureType.Name], tableToInsert )
                       
                    --Printf("Wheel Name: %s (contains %i slots)", wheel.Name, numSlots1 )
                end
                
            end

        else
            --Printf("  No wheels found for this fixture type.")
        end

    end

    Printf("")

    alfredPlease.storeGoboPresets(hasGobos)
end

--[[Making function accessible to other components in this Plugin 
via the alfredPlease Shared Table]]
alfredPlease.buildTheGoboPresets = buildTheGoboPresets



local function storeGoboPresets(tableArg1)

    local goboWheels = tableArg1

    --Sorting the wheels by FixtureType Alphabetically
    local gWSortOrder = {}

    for key, value in pairs(goboWheels) do

        table.insert(gWSortOrder, key)
        
    end

    --[[ A Count variable to Specify which Preset Number to Overwrite
            So we don't flood the Gobo Preset Pool by running 
            the Plugin Over and Over again. ]]
    local gPPresetNumber = 1

    table.sort(gWSortOrder)

    for i, gWKey in ipairs(gWSortOrder) do

        
        for j,key in ipairs(goboWheels[gWKey]) do
            

            --Clear & Select by FixtureType Commands
            local gClearCmd1 = "Clear"
            local gSelectCmd2 = 'FixtureType \"' .. tostring(gWKey) .. '\"'

            CmdIndirectWait(gClearCmd1)
            CmdIndirectWait(gSelectCmd2)

            --Generating a seperate Attribute Set command for each Gobo Slot.
            for l = 1, key.Slots do

                --Attribte Set Command
                local gSetCmd3 = "Attribute " .. key.wCmdName .. " At ChannelSet " .. l
                local gStoreCmd4 = ""

                if l == 1 then
                    --Assuming the fist slot in each wheel is an "Open" slot.
                    gStoreCmd4 = 'Store Preset \"Gobo\".'.. gPPresetNumber .. ' \"Open\" Property \"Appearance\" \"'.. tostring(gWKey) .. '\" /Overwrite'
            
                else
                    
                    gStoreCmd4 = 'Store Preset \"Gobo\".'.. gPPresetNumber .. ' Property \"Appearance\" \"'.. tostring(gWKey) .. '\" /Overwrite'
                
                end

                gPPresetNumber = gPPresetNumber + 1
            
                --Set and Store Commands.
                CmdIndirectWait(gSetCmd3)
                CmdIndirectWait(gStoreCmd4)

            end
        end
    end
    
    --[[clearing the Programmer and Selecting all the fixtures 
        for building Subsquent Presets]]
    CmdIndirectWait('Clear')
    CmdIndirectWait('Fixture Thru')

end 

--[[Making function accessible to other components in this Plugin 
via the alfredPlease Shared Table]]
alfredPlease.storeGoboPresets = storeGoboPresets



local function main()
		
alfredPlease.buildTheGoboPresets()

end

return main