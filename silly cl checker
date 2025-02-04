local Players = game.Players
local you = Players.LocalPlayer

local function gradient(owner)
	local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(202, 202, 202)),
        ColorSequenceKeypoint.new(0.56406, Color3.fromRGB(205, 205, 205)),
        ColorSequenceKeypoint.new(0.575707, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    gradient.Rotation = -75
    gradient.Parent = owner
end

local function textbutton(name,text, par, texttype)
    local textbutton = Instance.new(texttype)
    textbutton.Name = name
    textbutton.Text = text
    textbutton.Size = UDim2.new(0, 75, 0, 75)
    textbutton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    textbutton.TextColor3 = Color3.fromRGB(255, 255, 255)
	textbutton.TextWrapped = true
	textbutton.BorderSizePixel = 0
    textbutton.Parent = par
	gradient(textbutton)
end

local Playerchecker = Instance.new("ScreenGui")
Playerchecker.Name = "Playerchecker"
Playerchecker.Parent = you:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = Playerchecker

local Playerinfoframe = Instance.new("ScrollingFrame")
Playerinfoframe.Name = "Playerinfoframe"
Playerinfoframe.Size = UDim2.new(1,1, 1,1)
Playerinfoframe.Position = UDim2.new(0.5, -150, 0.5, -150)
Playerinfoframe.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Playerinfoframe.BorderSizePixel = 0
Playerinfoframe.ScrollBarThickness = 0
Playerinfoframe.ZIndex = 0
Playerinfoframe.AutomaticCanvasSize = "XY"
Playerinfoframe.Parent = MainFrame

textbutton("BackButton" ,"X", MainFrame, "TextButton")
local back_button = MainFrame.BackButton

back_button.Position = UDim2.new(1, -55, 0, 5)
back_button.BackgroundTransparency = 1
back_button.TextColor3 = Color3.fromRGB(255, 255, 255)

local grid = Instance.new("UIGridLayout")
grid.Parent = Playerinfoframe
grid.CellSize = UDim2.new(0, 75, 0, 75)
grid.CellPadding = UDim2.new(0, 5, 0, 5)

local UIS = game:GetService("UserInputService") 
local dragging, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local currentView = "players"

local function destroyNonPlayerButtons()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        playerNames[player.Name] = true
    end

    for _, obj in pairs(Playerinfoframe:GetChildren()) do
        if obj:IsA("TextButton") or obj:IsA("TextLabel") and obj ~= back_button then
            if not playerNames[obj.Name] then
                obj:Destroy()
            elseif playerNames[obj.Name] and currentView == "players" then
                obj.Visible = true
            else
                obj.Visible = false
            end
        end
    end
end

local searchBar = Instance.new("TextBox")
    searchBar.Name = "searchbar"
    searchBar.Size = UDim2.new(0, 300, 0, 30)
	searchBar.Position = UDim2.new(0, 0, 0.9, 0)
    searchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
	searchBar.TextWrapped = true
	searchBar.BorderSizePixel = 0
	searchBar.Text = ""
	searchBar.PlaceholderText = "Search..."
    searchBar.Parent = MainFrame
gradient(searchBar)

local resultsFrame = Playerinfoframe

local function filterResults()
    local query = searchBar.Text:lower()

    for _, item in pairs(Playerinfoframe:GetChildren()) do
        if item:IsA("TextLabel") then
            if query == "" or item.Text:lower():find(query) then
                item.Visible = true
            else
                item.Visible = false 
            end
        end
    end
end

searchBar:GetPropertyChangedSignal("Text"):Connect(filterResults)


local function showPlayerButtons()
	currentView = "players"
    for _, obj in pairs(Playerinfoframe:GetChildren()) do
	destroyNonPlayerButtons()
    end
end


local function loadplayerequips(selected)
	currentView = "equiped"
	destroyNonPlayerButtons()

    if selected:FindFirstChild("PlayerData") and selected.PlayerData:FindFirstChild("Equipped") then
        local equips = selected.PlayerData.Equipped
        for _, equip in pairs(equips:GetChildren()) do
			textbutton(equip.Name,equip.Value, Playerinfoframe, "TextLabel")
        end
    else
        warn("PlayerData or Equipped items not found for " .. selected.Name)
    end
end

local function LoadStats(selected)
    currentView = "Stats"
    destroyNonPlayerButtons()

    if selected:FindFirstChild("PlayerData") and selected.PlayerData:FindFirstChild("Stats") then

        local char = selected.Character
        local stats2 = char.Stats

        local minDmg, maxDmg, curmana, maxmana, curshield, maxshield

        for _, Stats2 in pairs(stats2:GetChildren()) do
            if Stats2:IsA("NumberValue") then
                if Stats2.Name == "MinDamage" then
                    minDmg = Stats2.Value
                elseif Stats2.Name == "MaxDamage" then
                    maxDmg = Stats2.Value
				elseif Stats2.Name == "CurrentMana" then
                    curmana = Stats2.Value
				elseif Stats2.Name == "Mana" then
                    maxmana = Stats2.Value
				elseif Stats2.Name == "CurrentShield" then
                    curshield = Stats2.Value
				elseif Stats2.Name == "Shield" then
                    maxshield = Stats2.Value
                else
                    textbutton(Stats2.Name, Stats2.Name .. ": " .. Stats2.Value, Playerinfoframe, "TextLabel")
                end
            end
        end

        if curmana and maxmana then
            textbutton("Mana", "Mana: " .. curmana .. "/" .. maxmana, Playerinfoframe, "TextLabel")
        end
        if curshield and maxshield then
            textbutton("Shield", "Shield: " .. curshield .. "/" .. maxshield, Playerinfoframe, "TextLabel")
        end
		if minDmg and maxDmg then
            textbutton("Damage", "Damage: " .. minDmg .. "-" .. maxDmg, Playerinfoframe, "TextLabel")
        end
    else
        warn("PlayerData or Stats not found for " .. selected.Name)
    end
end
local function LoadMisc(selected)
    currentView = "Misc"
    destroyNonPlayerButtons()

    if selected:FindFirstChild("PlayerData") and selected.PlayerData:FindFirstChild("Misc") then    
        local Misc = selected.PlayerData.Misc
        for _, misc in pairs(Misc:GetChildren()) do
            textbutton(misc.Name, misc.Name .. ": " .. misc.Value, Playerinfoframe, "TextLabel")
        end

        local Others = selected.leaderstats
        local validNames = {
            Gold = true,
            EXP = true,
            Honor = true,
            Level = true,
            RP = true,
            BonusSkillPoints = true,
            LevelUpPoints = true,
            SubStyle = true,  
            RelicSkin = true 
        }

        local skins = {
            [0] = "None",
            [1] = "Lovestruck",
            [2] = "Soul Agony",
            [3] = "Crown of the Shadows",
            [4] = "Turquoise Moon",
            [5] = "Midas Gold(?)"
        }

        local relics = {
            [0] = "None",
            [1] = "Blood Wipe",
            [2] = "Portal",
            [3] = "Burning Head",
            [4] = "Ocean Glider",
            [5] = "Cursed",
            [6] = "Holy",
            [7] = "Time Grinders",
            [8] = "Gravity Boots",
            [9] = "Pull",
            [10] = "Ghoul",
            [11] = "Hunter (Furry)",
            [12] = "Torch",
            [13] = "Bounty Hunter",
            [14] = "Crystallized",
            [15] = "Berserk",
            [16] = "Hyper"
        }

        for _, otherMisc in pairs(Others:GetChildren()) do
            if validNames[otherMisc.Name] then
                local displayValue = otherMisc.Value

                if otherMisc.Name == "SubStyle" then
                    displayValue = skins[displayValue] or "Unknown"
                end

                if otherMisc.Name == "RelicSkin" then
                    displayValue = relics[displayValue] or "Unknown"
                end

                textbutton(otherMisc.Name, otherMisc.Name .. ": " .. displayValue, Playerinfoframe, "TextLabel")
            end
        end
    end
end

local function LoadInv(selected)
	currentView = "Inv"
	destroyNonPlayerButtons()
	if selected:FindFirstChild("PlayerData") and selected.PlayerData:FindFirstChild("Inventory") then
	local Inventory = selected.PlayerData.Inventory
        for _, inv in pairs(Inventory:GetChildren()) do
            textbutton(inv.Name, inv.Name .. ": " .. inv.Value, Playerinfoframe, "TextLabel")
		end
	end
end

local function LoadSettings(chosen)
	currentView = "Settings"
	destroyNonPlayerButtons()
	textbutton("equiped", "Equipments", Playerinfoframe, "TextButton")
	textbutton("Stats", "Stats", Playerinfoframe, "TextButton")
	textbutton("Misc", "Misc", Playerinfoframe, "TextButton")
	textbutton("Inventory", "Inventory", Playerinfoframe, "TextButton")
	local misc_button = Playerinfoframe.Misc
	local stat_button = Playerinfoframe.Stats
	local item_button = Playerinfoframe.equiped
	local inv_button = Playerinfoframe.Inventory
	misc_button.MouseButton1Click:Connect(function()
        LoadMisc(chosen)
    end)
	item_button.MouseButton1Click:Connect(function()
        loadplayerequips(chosen)
    end)
	stat_button.MouseButton1Click:Connect(function()
        LoadStats(chosen)
    end)
	inv_button.MouseButton1Click:Connect(function()
        LoadInv(chosen)
    end)
end

for _, otherplayer in pairs(Players:GetPlayers()) do
	local button_name = otherplayer.Name
	textbutton(otherplayer.Name, otherplayer.Name, Playerinfoframe, "TextButton")
	Playerbutton = Playerinfoframe:FindFirstChild(button_name)
    Playerbutton.MouseButton1Click:Connect(function()
        LoadSettings(otherplayer)
    end)
end

back_button.MouseButton1Click:Connect(function()
    if currentView == "players" then
		Playerchecker:Destroy()
	else
        showPlayerButtons()
		destroyNonPlayerButtons()
    end
end)
