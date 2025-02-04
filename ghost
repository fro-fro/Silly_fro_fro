-- Create a ScreenGui to hold the button
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Stats = screenGui.Parent.Adventure.Main.Stats
local Active_3 = Stats:FindFirstChild("Active")
local Passive = Stats:FindFirstChild("Passive")

local tbl_2_upvr = {
    active = {Active_3.First, Active_3.Second, Active_3.Third};
    passive = {Passive.First, Passive.Second, Passive.Third};
}
-- Create the TextButton
local resetButton = Instance.new("TextButton")
resetButton.Name = "GHOSTbutton"
resetButton.Text = "GHOST"
resetButton.Size = UDim2.new(0, 150, 0, 50)  -- Width: 150 pixels, Height: 50 pixels
resetButton.Position = UDim2.new(0.5, -75, 0.9, -25)  -- Centered at the bottom of the screen
resetButton.Parent = screenGui

-- Style the button (optional)
resetButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red background
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
resetButton.FontSize = Enum.FontSize.Size18

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
-- Connect the function to the button's MouseButton1Click event
resetButton.MouseButton1Click:Connect(fireResetEvent)
