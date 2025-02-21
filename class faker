local rep = game:GetService("ReplicatedStorage")
local class_f = rep:FindFirstChild("StyleWeapons")

local wanted_class = "CheeseSOLO"
local eq_or_uneq = "WeaponEquipped" -- Change to "WeaponEquipped" or "WeaponUnequip" if needed
local wanted_classfolder = class_f and class_f:FindFirstChild(wanted_class) and class_f[wanted_class]:FindFirstChild(eq_or_uneq)

-- Body Parts (Full Name for Normal, Abbreviations for GoodOne)
local bodyPartsGood = {
    H = "Head",
    HRP = "HumanoidRootPart",
    LA = "Left Arm",
    RA = "Right Arm",
	LArm = "Left Arm",
    RArm = "Right Arm",
    T = "Torso",
    M = "Torso",
    LL = "Left Leg",
    RL = "Right Leg"
}

local bodyPartsNormal = {
    ["Head"] = "Head",
    ["HumanoidRootPart"] = "HumanoidRootPart",
    ["Left Arm"] = "Left Arm",
    ["Right Arm"] = "Right Arm",
    ["Torso"] = "Torso",
    ["Left Leg"] = "Left Leg",
    ["Right Leg"] = "Right Leg"
}

local function findoutwhatone()
    local rightone = nil

    if not wanted_classfolder then
        warn("wanted_classfolder not found!")
        return nil
    end

    -- Check if "Middle" exists first
    if wanted_classfolder:FindFirstChild("Middle") then
        rightone = "normal"
        return rightone
    end

    local foundGood = false
    local foundModel = false

    -- Loop through children to check for GoodOne using abbreviations
    for _, child in ipairs(wanted_classfolder:GetChildren()) do
        if child:IsA("Model") then
            foundModel = true -- If we find any model, mark it
        end

        for key, _ in pairs(bodyPartsGood) do
            if child.Name:sub(1, #key) == key then -- Check if it starts with a body part abbreviation
                foundGood = true
                break
            end
        end

        if foundGood then break end -- Stop checking once a "goodone" is found
    end

    if foundGood then
        rightone = "goodone"
    elseif foundModel then
        rightone = "badone"
    end

    return rightone
end

local function anchorAllParts(folder)
    for _, part in ipairs(folder:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = true
        end
    end
end

local function cleanUpOldWeapons(character)
    -- Remove old weapon folders before adding a new one
    if character:FindFirstChild("WeaponUnequip") then
        character:FindFirstChild("WeaponUnequip"):Destroy()
    end
    if character:FindFirstChild("WeaponEquipped") then
        character:FindFirstChild("WeaponEquipped"):Destroy()
    end
end

local function copyAndWeldPartsToBody()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return end

    cleanUpOldWeapons(character) -- Remove any previous weapon folders

    if not wanted_classfolder then
        warn("No valid class folder found in ReplicatedStorage!")
        return
    end

    local copiedFolder = wanted_classfolder:Clone()
    copiedFolder.Parent = character
    copiedFolder.Name = eq_or_uneq -- Ensure the name is consistent

    local weaponFolder = character:FindFirstChild(eq_or_uneq)

    if not weaponFolder then
        warn("Failed to copy weapon folder into the character!")
        return
    end

    -- Iterate through each folder inside the weapon
    for folderName, bodyPartName in pairs(bodyPartsGood) do
        local bodyPart = character:FindFirstChild(bodyPartName)
        local weaponSection = weaponFolder:FindFirstChild(folderName)

        if bodyPart and weaponSection then
            local middle = weaponSection:FindFirstChild("Middle")
            if not middle then
                warn("Middle part missing in:", folderName)
                continue
            end

            -- 🔹 Weld All Parts in This Section to "Middle"
            for _, part in pairs(weaponSection:GetChildren()) do
                if part:IsA("BasePart") then
							for _, part2 in pairs(part:GetChildren()) do
				if part2:IsA("BasePart") then
					part2.Anchored = false
				end
			end
                    local weld = Instance.new("Weld")
                    weld.Part0 = middle
                    weld.Part1 = part
                    weld.C0 = middle.CFrame:inverse() * part.CFrame
                    weld.Parent = middle
                    part.Anchored = false -- Allow movement
					
                end
            end
		            -- 🔥 Weld Middle to the Correct Body Part
            local mainWeld = Instance.new("Weld")
            mainWeld.Part0 = bodyPart
            mainWeld.Part1 = middle
            mainWeld.Parent = bodyPart
            middle.Anchored = false -- Allow physics
        end
    end
end

local function weldPartsToMiddle()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return end

    cleanUpOldWeapons(character) -- Remove old weapon folders

    -- Find the Info folder for the class
    local infoFolder = class_f:FindFirstChild(wanted_class) and class_f[wanted_class]:FindFirstChild("Info")
    if not infoFolder then
        warn("Info folder not found for", wanted_class)
        return
    end

    -- Find the correct body part from the Info folder using full names
    local bodyPartName = nil

    -- If it's not WeaponUnequip, check Info for correct body part
    if eq_or_uneq ~= "WeaponUnequip" then
        local infoFolder = class_f:FindFirstChild(wanted_class) and class_f[wanted_class]:FindFirstChild("Info")
        if infoFolder then
            for _, bodyPart in pairs(infoFolder:GetChildren()) do
                if bodyPartsNormal[bodyPart.Name] then
                    bodyPartName = bodyPartsNormal[bodyPart.Name]
                    break
                end
            end
        else
            warn("Info folder not found for", wanted_class)
        end
    end

	if not bodyPartName then
    warn("No valid body part found in Info folder! Defaulting to Right Arm.")
    bodyPartName = "Right Arm"
	end

	if eq_or_uneq == "WeaponUnequip" then
		bodyPartName = "Torso"
	end

    -- Clone the normal version into the character
    local copiedFolder = wanted_classfolder:Clone()
    copiedFolder.Parent = character
    copiedFolder.Name = eq_or_uneq -- Ensure it's named properly

    local weaponFolder = character:FindFirstChild(eq_or_uneq)

    if not weaponFolder then
        warn("Failed to copy weapon folder into the character!")
        return
    end

    -- Get the middle part
    local middle = weaponFolder:FindFirstChild("Middle")
    if not middle then
        warn("Middle part not found!")
        return
    end

    -- Find the body part in the character
    local bodyPart = character:FindFirstChild(bodyPartName)
    if not bodyPart then
        warn("Target body part not found in character:", bodyPartName)
        return
    end

    -- 🔹 Weld All Parts in This Section to "Middle"
    for _, part in pairs(weaponFolder:GetChildren()) do
        if part:IsA("BasePart") and part ~= middle then
			for _, part2 in pairs(part:GetChildren()) do
				if part2:IsA("BasePart") then
					part2.Anchored = false
				end
			end
            local weld = Instance.new("Weld")
            weld.Part0 = middle
            weld.Part1 = part
            weld.C0 = middle.CFrame:inverse() * part.CFrame
            weld.Parent = middle
            part.Anchored = false -- Allow movement
        end
    end

    -- 🔥 Weld Middle to the Correct Body Part
    local mainWeld = Instance.new("Weld")
    mainWeld.Part0 = bodyPart
    mainWeld.Part1 = middle
    mainWeld.Parent = bodyPart
    middle.Anchored = false -- Allow physics

end

-- Run logic
local result = findoutwhatone()
if result then
    print("Result:", result)
    
    if result == "goodone" then
        copyAndWeldPartsToBody() -- Copy and weld if it's a good one
    elseif result == "normal" then
		anchorAllParts(wanted_classfolder) 
        weldPartsToMiddle() -- Weld normal version to specified body part
    end
end
