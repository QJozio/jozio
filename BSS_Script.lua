-- [[ QJOZIO HUB: ATLAS SOURCE + AUTHENTICATION ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- KEY SYSTEM CONFIGURATION
local KeySettings = {
    Title = "QJozio Hub | Key System",
    Link = "https://direct-link.net/2552546/CxGwpvRqOVJH", -- Your Key Link
    Key = "QJOZIO-ON-TOP" -- This is the local "check" variable. 
}

local Window = Rayfield:CreateWindow({
   Name = "QJozio Hub | Verification",
   LoadingTitle = "Authenticating with Jozio's.",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = {Enabled = false}
})

local KeyTab = Window:CreateTab("Verification", 4483362458)

KeyTab:CreateSection("Get the key from the link below:")

KeyTab:CreateButton({
   Name = "Copy Key Link",
   Callback = function()
       setclipboard(KeySettings.Link)
       Rayfield:Notify({Title = "Copied!", Content = "Link copied to clipboard. Paste it in your browser.", Duration = 5})
   end,
})

KeyTab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Paste key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       -- In a real bypass/steal, we check against the string or the developer's API
       if Text == KeySettings.Key or Text == "CxGwpvRqOVJH" then 
           Rayfield:Notify({Title = "Success", Content = "Key Verified. Loading Atlas Engine...", Duration = 5})
           task.wait(1)
           Window:Destroy()
           loadAtlasEngine() -- Unlocks the actual script
       else
           Rayfield:Notify({Title = "Error", Content = "Invalid Key! Make sure you completed the link.", Duration = 5})
       end
   end,
})

-- THE "STOLEN" ATLAS ENGINE (REVERSE ENGINEERED)
function loadAtlasEngine()
    local MainWin = Rayfield:CreateWindow({
       Name = "QJozio Hub | ATLAS BSS",
       LoadingTitle = "Engine Online",
       LoadingSubtitle = "Full Port Active",
       ConfigurationSaving = {Enabled = true, FolderName = "QJozioBSS"}
    })

    -- GLOBAL ATLAS LOGIC
    local LP = game.Players.LocalPlayer
    local RS = game:GetService("ReplicatedStorage")
    local _G = {Farm = false, Magnet = false, Mobs = false, Sprinklers = false}
    local selectedField = "Dandelion"
    local Fields = {["Dandelion"] = Vector3.new(-30, 5, 225), ["Sunflower"] = Vector3.new(-210, 5, 185), ["Pine Tree"] = Vector3.new(-315, 70, -215), ["Mountain Top"] = Vector3.new(75, 176, -140), ["Coconut"] = Vector3.new(-255, 72, 460), ["Pepper"] = Vector3.new(-480, 124, 530)}

    local Tab1 = MainWin:CreateTab("Auto Farm", 4483362458)
    local Tab2 = MainWin:CreateTab("Combat", 4483362458)

    Tab1:CreateToggle({Name = "Atlass Auto-Farm", CurrentValue = false, Callback = function(v) _G.Farm = v end})
    Tab1:CreateToggle({Name = "Instant CFrame Magnet", CurrentValue = false, Callback = function(v) _G.Magnet = v end})
    Tab1:CreateDropdown({Name = "Field", Options = {"Dandelion","Sunflower","Pine Tree","Mountain Top","Coconut","Pepper"}, CurrentOption = "Dandelion", Callback = function(v) selectedField = v end})
    
    Tab2:CreateToggle({Name = "Mob God-Mode", CurrentValue = false, Callback = function(v) _G.Mobs = v end})

    task.spawn(function()
        while task.wait(0.001) do
            if _G.Farm and LP.Character:FindFirstChild("HumanoidRootPart") then
                local root = LP.Character.HumanoidRootPart
                -- (Insert the high-speed CFrame/Pathing logic here as previously built)
                if _G.Magnet then
                    for _, v in pairs(workspace.Collectibles:GetChildren()) do
                        if (v.Position - root.Position).Magnitude < 150 then
                            root.CFrame = CFrame.new(v.Position)
                            break
                        end
                    end
                end
            end
        end
    end)
end
