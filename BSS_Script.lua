-- [[ QJOZIO HUB: PURE ATLAS SOURCE ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "QJozio Hub | Atlass v4",
   LoadingTitle = "Loading Atlass Source...",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = {Enabled = true, FolderName = "QJozioBSS"}
})

-- ATLAS INTERNAL VARIABLES
local LP = game.Players.LocalPlayer
local _G = {Farm = false, Tokens = false, Mobs = false, Sprinklers = false}
local selectedField = "Dandelion"

local Fields = {
    ["Dandelion"] = Vector3.new(-30, 5, 225), ["Sunflower"] = Vector3.new(-210, 5, 185),
    ["Mushroom"] = Vector3.new(-95, 5, 115), ["Blue Flower"] = Vector3.new(115, 5, 100),
    ["Clover"] = Vector3.new(175, 34, 190), ["Spider"] = Vector3.new(-50, 20, -5),
    ["Bamboo"] = Vector3.new(95, 20, -25), ["Pine Tree"] = Vector3.new(-315, 70, -215),
    ["Mountain Top"] = Vector3.new(75, 176, -140), ["Coconut"] = Vector3.new(-255, 72, 460),
    ["Pepper"] = Vector3.new(-480, 124, 530), ["Stump"] = Vector3.new(420, 35, -175)
}

-- TABS
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- ELEMENTS
FarmTab:CreateToggle({
   Name = "Atlass Auto-Farm",
   CurrentValue = false,
   Callback = function(v) _G.Farm = v end,
})

FarmTab:CreateToggle({
   Name = "Instant CFrame Magnet",
   CurrentValue = false,
   Callback = function(v) _G.Tokens = v end,
})

FarmTab:CreateToggle({
   Name = "Atlass Sprinklers",
   CurrentValue = false,
   Callback = function(v) _G.Sprinklers = v end,
})

FarmTab:CreateDropdown({
   Name = "Field",
   Options = {"Dandelion","Sunflower","Mushroom","Blue Flower","Clover","Spider","Bamboo","Pine Tree","Mountain Top","Coconut","Pepper","Stump"},
   CurrentOption = "Dandelion",
   Callback = function(v) selectedField = v end,
})

CombatTab:CreateToggle({
   Name = "Monster Kill-Aura",
   CurrentValue = false,
   Callback = function(v) _G.Mobs = v end,
})

-- PURE ATLAS ENGINE
task.spawn(function()
    local angle = 0
    while task.wait(0.001) do
        if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then continue end
        local root = LP.Character.HumanoidRootPart
        local hum = LP.Character.Humanoid

        if _G.Farm then
            local stats = LP:WaitForChild("CoreStats")
            if stats.Pollen.Value >= stats.Capacity.Value * 0.99 then
                hum:MoveTo(LP.SpawnPos.Value.Position)
            else
                -- Atlass Instant Token Logic
                local targetToken = nil
                if _G.Tokens then
                    for _, v in pairs(workspace.Collectibles:GetChildren()) do
                        if (v.Position - root.Position).Magnitude < 100 then
                            targetToken = v
                            break 
                        end
                    end
                end

                if targetToken then
                    root.CFrame = CFrame.new(targetToken.Position)
                else
                    angle = angle + 0.8
                    local goal = Fields[selectedField] + Vector3.new(math.sin(angle)*35, 0, math.cos(angle)*35)
                    hum:MoveTo(goal)
                end
                
                -- Tools & Remote Events
                if LP.Character:FindFirstChildOfClass("Tool") then LP.Character:FindFirstChildOfClass("Tool"):Activate() end
                if _G.Sprinklers then
                    game.ReplicatedStorage.Events.PlayerGiveEvent:FireServer("Sprinkler")
                end
            end
        end

        -- Atlass Altitude Combat
        if _G.Mobs then
            for _, mob in pairs(workspace.Monsters:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and (mob.HumanoidRootPart.Position - root.Position).Magnitude < 70 then
                    root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                end
            end
        end
    end
end)
