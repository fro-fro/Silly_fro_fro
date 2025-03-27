local screenGui = Instance.new("ScreenGui")
screenGui.Name = "setupgui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local resetButton = Instance.new("TextButton")
resetButton.Name = "Setup"
resetButton.Text = "Setup"
resetButton.Size = UDim2.new(0, 150, 0, 50)  -- Width: 150 pixels, Height: 50 pixels
resetButton.Position = UDim2.new(0.5, -75, 0.9, -25)  -- Centered at the bottom of the screen
resetButton.Parent = screenGui

local Stats = screenGui.Parent.Adventure.Main.Stats
local Active_3 = Stats:FindFirstChild("Active")
local Passive = Stats:FindFirstChild("Passive")

local tbl_2_upvr = {
    active = {Active_3.First, Active_3.Second, Active_3.Third};
    passive = {Passive.First, Passive.Second, Passive.Third};
}


local first3 = {
	"Legendary Orange Tree Sapling",
	"Spectral Shield",
	"Snowman Heart",
}

local second3 = {
	"Mining Pickaxe",
	"Santa Hat",
	"Dealmaker",
	}

local final3 = {
	"Force Shield",
	"Black Hole",
	"Caribbean Pirate's Cutlass",
}

local remoteEvent = game.ReplicatedStorage:FindFirstChild("Server")
if not remoteEvent or not remoteEvent:IsA("RemoteEvent") then
	warn("RemoteEvent 'Server' not found in ReplicatedStorage!")
	return
end


local function fireResetEvent()
    local arg1 = "passive"
    
    for arg2 = 1, 3 do
        if tbl_2_upvr[arg1] and tbl_2_upvr[arg1][arg2] then
            local var64 = tbl_2_upvr[arg1][arg2]
            var64.Count.Text = "nil"
            var64.Holder.Icon.Image = ""
            var64.Holder.Empty.Visible = false
            game.ReplicatedStorage.Server:FireServer("RequestRemoval", arg1 .. arg2)
			task.wait(0.5)
        else
            warn(arg1 .. " and " .. arg2 .. " not in tbl2")
        end
    end
end

local function Main()
	remoteEvent:FireServer("Invest", "Shield", 1)
	for _, item in ipairs(first3) do
	task.wait(0.5)
		remoteEvent:FireServer("SetupItem", item)
	end
	task.wait(0.5)
	fireResetEvent()
	task.wait(0.5)
	for _, item in ipairs(second3) do
	task.wait(0.5)
		remoteEvent:FireServer("SetupItem", item)
	end
	task.wait(0.5)
	fireResetEvent()
	task.wait(0.5)
	for _, item in ipairs(final3) do
	task.wait(0.5)
		remoteEvent:FireServer("SetupItem", item)
	end
	remoteEvent:FireServer("ResetPoints")
	task.wait(1)
	screenGui:Destroy()
end

resetButton.MouseButton1Click:Connect(Main)
