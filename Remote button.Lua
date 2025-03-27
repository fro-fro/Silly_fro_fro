local Player = game.Players
local player = Player.LocalPlayer
local char = player.Character
local hrp = char.HumanoidRootPart
local objval1 = workspace.QuestNPCs:WaitForChild("Decimating Flames")
local objval2 = workspace.QuestNPCs["Voidborn Drills"]
local objval3 = workspace.QuestNPCs["Hate and Eternity"] --this prolly wont work ngl
local objval4 = workspace.QuestNPCs["Get down here!"]
local objval5 = workspace.QuestNPCs.Rageblade
local buyR = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Effected")
local questR = workspace.QuestNPCs.Main.onClick
local rpfarmgui = Instance.new("ScreenGui")

rpfarmgui.Parent = player:WaitForChild("PlayerGui")

local remotebutton = Instance.new("TextButton")
remotebutton.Name = "remotebutton"
remotebutton.Text = "autoclick this"
remotebutton.Size = UDim2.new(0, 150, 0, 50) 
remotebutton.Position = UDim2.new(0.5, -975, 0.9, -25)  
remotebutton.Parent = rpfarmgui

local function remotes()
local questremote = workspace.QuestNPCs.Main.onClick
local points = game:GetService("Players").LocalPlayer.PlayerData.Stats.LevelUpPoints.Value
game.ReplicatedStorage.Server:FireServer("Invest", "Shield", points - 1)
game.ReplicatedStorage.Server:FireServer("Invest", "Mana", 1)
game.ReplicatedStorage.Server:FireServer("ResetPoints")
game.ReplicatedStorage.Server:FireServer("UseItem", 1)
if not game:GetService("Players").LocalPlayer.PlayerData.Quests:FindFirstChild("Decimating Flames") then
	questR:FireServer("MainAction", objval1)
end
if not game:GetService("Players").LocalPlayer.PlayerData.Quests:FindFirstChild("Drilling Mission") then
	questR:FireServer("MainAction", objval2)
end
if not game:GetService("Players").LocalPlayer.PlayerData.Quests:FindFirstChild("Hate and Eternity") then
	questR:FireServer("MainAction", objval3)
end
if not game:GetService("Players").LocalPlayer.PlayerData.Quests:FindFirstChild("Get down here!") then
	questR:FireServer("MainAction", objval4)
end
if not game:GetService("Players").LocalPlayer.PlayerData.Quests:FindFirstChild("Anger Issues") then
	questR:FireServer("MainAction", objval5)
end
if game:GetService("Players").LocalPlayer.leaderstats.Gold.Value > 900000000000 then
	for i = 1, 5 do
		buyR:FireServer("Buy5", workspace:WaitForChild("Stalls"):WaitForChild("Initus Bay"):WaitForChild("Item Shop"):WaitForChild("Shop"):WaitForChild("Blubb Pizza"))
	end
end
task.wait(0.5)
for _, main in pairs(workspace:GetChildren()) do
	local hitboxName = "Hitbox"

    if main:IsA("BasePart") and main.Name == hitboxName then
        firetouchinterest(hrp, main, 0) 
        firetouchinterest(hrp, main, 1)
    end

	if main.Name == "Text" or main.Name == "HitEffect" or main.Name == "DefeatedEffect" or main.Name == "Number" or main.Name == "BigShot" then
		main:Destroy()
	end
		if main.Name == char.Name then
			for _, thing in pairs(main:GetChildren()) do
    			if thing and thing.Name == "AttackBuff_Blood" or thing.Name == "AttackBuff_BigShot" then
					thing:Destroy()
   				end
				if thing.Name == "Torso" then
					for _, thing2 in pairs(thing:GetChildren()) do
						if thing2 and thing2.Name == "Particle" or thing2.Name == "Light" or thing2.Name == "RestoreEffect" or thing2.Name == "ShieldBreakEffect" then
							thing2:Destroy()
						end
					end
				end
			end
		end
	end
end
remotebutton.MouseButton1Click:Connect(remotes)
