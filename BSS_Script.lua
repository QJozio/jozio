-- [[ QJOZIO HUB: ATLAS SOURCE + STABLE TOGGLE SYSTEM ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- KEY CONFIGURATION
local CorrectKey = "QJOZIO-ON-TOP"
local KeyLink = "https://direct-link.net/2552546/CxGwpvRqOVJH"
local TypedKey = ""

-- 1. CREATE THE MAIN WINDOW FIRST (BUT KEEP IT HIDDEN)
local Window = Rayfield:CreateWindow({
   Name = "QJozio Hub | THE TOTAL ATLAS",
   LoadingTitle = "Engine Loading...",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = {Enabled = true, FolderName = "QJozioBSS"}
})

-- Force the window to be invisible at start
Window.Enabled = false 

-- 2. CREATE A SEPARATE VERIFICATION UI
local KeyWindow = Rayfield:CreateWindow({
   Name = "QJozio Hub | Verification",
   LoadingTitle = "Auth Required",
   LoadingSubtitle = "Enter Key to Unlock",
   ConfigurationSaving = {Enabled = false}
})

local KeyTab = KeyWindow:CreateTab("Key System", 4483362458)

-- ENGINE VARIABLES
local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local _G = {Farm = false, Magnet = false, Mobs = false}
local selectedField = "Dandelion"
local Fields = {
    ["Dandelion"] = Vector3.new(-30, 5, 225), ["Sunflower"] = Vector3.new(-210, 5, 185),
    ["Mushroom"] = Vector3.new(-95, 5, 115), ["Blue Flower"] = Vector3.new(115, 5, 100),
    ["Clover"] = Vector3.new(175, 34, 190), ["Spider"] = Vector3.new(-50, 20, -5),
    ["Bamboo"] = Vector3.new(95, 20, -25), ["Pine Tree"] = Vector3.new(-315, 70, -215),
    ["Mountain Top"] = Vector3.new(75, 176, -140), ["Coconut"] = Vector3.new(-255, 72, 460)
}

-- 3. SETUP KEY TAB
KeyTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Paste Key Here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       TypedKey = Text
   end,
})

KeyTab:CreateButton({
   Name = "Submit Key",
   Callback = function()
       if TypedKey == CorrectKey then
           Rayfield:Notify({Title = "SUCCESS", Content = "Access Granted!", Duration = 3})
           task.wait(0.5)
           KeyWindow.Enabled = false -- Hide Key Window
           Window.Enabled = true -- Show Main Window
       else
           Rayfield:Notify({Title = "ERROR", Content = "Invalid Key!", Duration = 3})
       end
   end,
})

KeyTab:CreateButton({
   Name = "Copy Key Link",
   Callback = function()
       setclipboard(KeyLink)
       Rayfield:Notify({Title = "Copied", Content = "Link copied to clipboard!", Duration = 3})
   end,
})

-- 4. SETUP MAIN TABS (Hidden until key is correct)
local Tab1 = Window:CreateTab("Auto Farm", 4483362458)
local Tab2 = Window:CreateTab("Combat", 4483362458)

Tab1:CreateToggle({Name = "Atlass Auto-Farm", CurrentValue = false, Callback = function(v) _G.Farm = v end})
Tab1:CreateToggle({Name = "Instant CFrame Magnet", CurrentValue = false, Callback = function(v) _G.Magnet = v end})
Tab1:CreateDropdown({Name = "Field", Options = {"Dandelion","Sunflower","Mushroom","Blue Flower","Clover","Spider","Bamboo","Pine Tree","Mountain Top","Coconut"}, CurrentOption = "Dandelion", Callback = function(v) selectedField = v end})

Tab2:CreateToggle({Name = "Mob God-Mode", CurrentValue = false, Callback = function(v) _G.Mobs = v end})

-- ENGINE LOOP
task.spawn(function()
    local angle = 0
    while task.wait(0.01) do
        if _G.Farm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local root = LP.Character.HumanoidRootPart
            local stats = LP:WaitForChild("CoreStats")
            if stats.Pollen.Value >= stats.Capacity.Value * 0.99 then
                root.CFrame = LP.SpawnPos.Value * CFrame.new(0, 2, 0)
                RS.Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
            else
                local token = nil
                if _G.Magnet then
                    for _, v in pairs(workspace.Collectibles:GetChildren()) do
                        if (v.Position - root.Position).Magnitude < 150 then token = v break end
                    end
                end
                if token then root.CFrame = CFrame.new(token.Position)
                else
                    angle = angle + 0.9
                    LP.Character.Humanoid:MoveTo(Fields[selectedField] + Vector3.new(math.sin(angle)*35, 0, math.cos(angle)*35))
                end
                if LP.Character:FindFirstChildOfClass("Tool") then LP.Character:FindFirstChildOfClass("Tool"):Activate() end
            end
        end
        if _G.Mobs and LP.Character:FindFirstChild("HumanoidRootPart") then
            for _, mob in pairs(workspace.Monsters:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and (mob.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 80 then
                    LP.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 22, 0)
                end
            end
        end
    end
end)
