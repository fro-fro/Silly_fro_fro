local Players = game:GetService("Players")
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")

screenGui.Parent = player:WaitForChild("PlayerGui")

local objval1 = Instance.new("ObjectValue")
objval1.Name = "npc val"
objval1.Parent = char
objval1.Value = workspace.QuestNPCs:WaitForChild("Honey Collector")


local enemy_folder = workspace:FindFirstChild("Enemies"):FindFirstChild("Flora Field")

local resetButton = Instance.new("TextButton")
resetButton.Name = "ToggleHonor"
resetButton.Text = "Toggle Honor"
resetButton.Size = UDim2.new(0, 150, 0, 50)  -- Width: 150 pixels, Height: 50 pixels
resetButton.Position = UDim2.new(0.5, -75, 0.9, -25)  -- Centered at the bottom of the screen
resetButton.Parent = screenGui


local remotebutton = Instance.new("TextButton")
remotebutton.Name = "remotebutton"
remotebutton.Text = "autoclick this"
remotebutton.Size = UDim2.new(0, 150, 0, 50)  -- Width: 150 pixels, Height: 50 pixels
remotebutton.Position = UDim2.new(0.5, -975, 0.9, -25)  -- Centered at the bottom of the screen
remotebutton.Parent = screenGui

local isFarming = false  -- Variable to track the farming state

local function teleportToBees()
    local character = player.Character or player.CharacterAdded:Wait()  -- Get the player's character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return  -- Exit if the character or HumanoidRootPart doesn't exist
    end

    for _, enemy in pairs(enemy_folder:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == "Enemy" then
            local modelValue = enemy:FindFirstChild("Model")
            local beePosition = enemy:FindFirstChild("EnemyLocation")
            if modelValue and beePosition and modelValue:IsA("ObjectValue") and modelValue.Value and modelValue.Value.Name == "Bee" then
                character.HumanoidRootPart.CFrame = beePosition.CFrame  -- Teleport the player's character
                wait(1.5) -- Wait between teleports
            end
        end
    end
end

local function remotes()
workspace.QuestNPCs.Main.onClick:FireServer("MainAction", objval1.Value)
end
local function toggleFarm()
    isFarming = not isFarming
    resetButton.Text = isFarming and "Stop Honor" or "Toggle Honor" 
end

resetButton.MouseButton1Click:Connect(toggleFarm)
remotebutton.MouseButton1Click:Connect(remotes) 


while true do
    if isFarming then
        teleportToBees() 
    end
    wait(0.5)
end
