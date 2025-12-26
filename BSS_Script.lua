-- [[ QJOZIO HUB: ATLAS SOURCE + KEY SYSTEM FIXED ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- KEY CONFIGURATION
local CorrectKey = "QJOZIO-ON-TOP"
local KeyLink = "https://direct-link.net/2552546/CxGwpvRqOVJH"

local Window = Rayfield:CreateWindow({
   Name = "QJozio Hub | Verification",
   LoadingTitle = "Authenticating...",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = {Enabled = false}
})

local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateSection("Get the key here:")

KeyTab:CreateButton({
   Name = "Copy Key Link (Direct-Link)",
   Callback = function()
       setclipboard(KeyLink)
       Rayfield:Notify({Title = "Copied!", Content = "Link copied to clipboard!", Duration = 5})
   end,
})

KeyTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Input Key...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       if Text == CorrectKey then
           Rayfield:Notify({Title = "Success!", Content = "Key Accepted. Loading Atlas Engine...", Duration = 5})
           task.wait(1)
           Window:Destroy() -- Closes Key Window
           loadAtlasEngine() -- Unlocks the actual Atlas script logic
       else
           Rayfield:Notify({Title = "Incorrect Key", Content = "The key you entered is invalid.", Duration = 5})
       end
   end,
})

-- THE "STOLEN" ATLAS ENGINE MODULE
function loadAtlasEngine()
    local MainWin = Rayfield:CreateWindow({
       Name = "QJozio Hub | THE TOTAL ATLAS",
       LoadingTitle = "Engine Online",
       LoadingSubtitle = "Full 1:1 Port Active",
       ConfigurationSaving = {Enabled = true, FolderName = "QJozioBSS"}
    })

    local LP = game.Players.LocalPlayer
    local RS = game:GetService("ReplicatedStorage")
    local _G = {Farm = false, Magnet = false, Mobs = false, Sprinklers = false}
    local selectedField = "Dandelion"
    local Fields = {
        ["Dandelion"] = Vector3.new(-30, 5, 225), ["Sunflower"] = Vector3.new(-210, 5, 185),
        ["Mushroom"] = Vector3.new(-95, 5, 115), ["Blue Flower"] = Vector3.new(115, 5, 100),
        ["Clover"] = Vector3.new(175, 34, 190), ["Spider"] = Vector3.new(-50, 20, -5),
        ["Bamboo"] = Vector3.new(95, 20, -25), ["Pine Tree"] = Vector3.new(-315, 70, -215),
        ["Mountain Top"] = Vector3.new(75, 176, -140), ["Coconut"] = Vector3.new(-255, 72, 460)
    }

    local Tab1 = MainWin:CreateTab("Auto Farm", 4483362458)
    local Tab2 = MainWin:CreateTab("Combat", 4483362458)

    Tab1:CreateToggle({Name = "Atlass Auto-Farm", CurrentValue = false, Callback = function(v) _G.Farm = v end})
    Tab1:CreateToggle({Name = "Instant CFrame Magnet", CurrentValue = false, Callback = function(v) _G.Magnet = v end})
    Tab1:CreateDropdown({Name = "Field", Options = {"Dandelion","Sunflower","Mushroom","Blue Flower","Clover","Spider","Bamboo","Pine Tree","Mountain Top","Coconut"}, CurrentOption = "Dandelion", Callback = function(v) selectedField = v end})
    
    Tab2:CreateToggle({Name = "Mob God-Mode", CurrentValue = false, Callback = function(v) _G.Mobs = v end})

    task.spawn(function()
        local angle = 0
        while task.wait(0.001) do
            if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then continue end
            local root = LP.Character.HumanoidRootPart
            
            if _G.Farm then
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
                    if token then
                        root.CFrame = CFrame.new(token.Position)
                    else
                        angle = angle + 0.9
                        LP.Character.Humanoid:MoveTo(Fields[selectedField] + Vector3.new(math.sin(angle)*35, 0, math.cos(angle)*35))
                    end
                    if LP.Character:FindFirstChildOfClass("Tool") then LP.Character:FindFirstChildOfClass("Tool"):Activate() end
                end
            end

            if _G.Mobs then
                for _, mob in pairs(workspace.Monsters:GetChildren()) do
                    if mob:FindFirstChild("HumanoidRootPart") and (mob.HumanoidRootPart.Position - root.Position).Magnitude < 80 then
                        root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 22, 0)
                    end
                end
            end
        end
    end)
end
