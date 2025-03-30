local Player = game.Players
local player = Player.LocalPlayer
local char = player.Character

local objval1 = Instance.new("ObjectValue")
objval1.Name = "npc val"
objval1.Parent = char
objval1.Value = workspace.QuestNPCs:WaitForChild("Decimating Flames")

local rpfarmgui = Instance.new("ScreenGui")

rpfarmgui.Parent = player:WaitForChild("PlayerGui")

local enemy_folder = workspace:FindFirstChild("Enemies")

local him_location = enemy_folder:FindFirstChild("Eternal Halls Him").Enemy.EnemyLocation
local oni_location = enemy_folder:FindFirstChild("Samurai Island Oni").Enemy.EnemyLocation
local cheart_location = enemy_folder.Chaos.Enemy.EnemyLocation
local crystal_mobs = enemy_folder:FindFirstChild("Crystal Mobs")

local farmButton = Instance.new("TextButton")
farmButton.Name = "ToggleRP"
farmButton.Text = "Start RP"
farmButton.Size = UDim2.new(0, 150, 0, 50)  -- Width: 150 pixels, Height: 50 pixels
farmButton.Position = UDim2.new(0.5, -975, 0.9, -75)  -- Centered at the bottom of the screen
farmButton.Parent = rpfarmgui

local remotebutton = Instance.new("TextButton")
remotebutton.Name = "remotebutton"
remotebutton.Text = "autoclick this"
remotebutton.Size = UDim2.new(0, 150, 0, 50)  -- Width: 150 pixels, Height: 50 pixels
remotebutton.Position = UDim2.new(0.5, -975, 0.9, -25)  -- Centered at the bottom of the screen
remotebutton.Parent = rpfarmgui

local function rpfarm()

for _, enemy in pairs(crystal_mobs:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == "Enemy" then
            local modelValue = enemy:FindFirstChild("Model")
            local fire_location = enemy:FindFirstChild("EnemyLocation")
            if modelValue.Value.Name == "Flame Incarnate" then
			char.HumanoidRootPart.CFrame = fire_location.CFrame
			task.wait(2.5)
			char.HumanoidRootPart.CFrame = him_location.CFrame
			task.wait(2.5)
			char.HumanoidRootPart.CFrame = oni_location.CFrame
			task.wait(2.5)
			char.HumanoidRootPart.CFrame = cheart_location.CFrame
            end
        end
    end
end

local function remotes()
local questremote = workspace.QuestNPCs.Main.onClick
local level_points = player.leaderstats.Level.Value *2
local bonus_points = player.leaderstats.BonusSkillPoints.Value
local points = level_points + bonus_points
game.ReplicatedStorage.Server:FireServer("Invest", "Shield", points)
game.ReplicatedStorage.Server:FireServer("ResetPoints")
game.ReplicatedStorage.Server:FireServer("UseItem", 1)
workspace.QuestNPCs.Main.onClick:FireServer("MainAction", objval1.Value)
end


local function toggleFarm()
    isFarming = not isFarming
    farmButton.Text = isFarming and "Stop RP" or "Start RP" 
end

farmButton.MouseButton1Click:Connect(toggleFarm) 
remotebutton.MouseButton1Click:Connect(remotes) 

while true do
    if isFarming then
        rpfarm() 
    end
    wait(0.5)
end
