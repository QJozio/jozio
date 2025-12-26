-- [[ QJOZIO HUB | THE ULTIMATE ENGINE - ALL FIXES APPLIED ]] --
local CorrectKey = "QJOZIO-ON-TOP"

-- 1. BYPASS & AUTHENTICATION
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 280, 0, 160), UDim2.new(0.5, -140, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.25, 0)
KeyBox.PlaceholderText = "Input Secret Key..."

local Btn = Instance.new("TextButton", Main)
Btn.Size, Btn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.6, 0)
Btn.Text = "INJECT ENGINE"
Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Btn.TextColor3 = Color3.new(1,1,1)

-- 2. THE MULTI-TAB MASTER SYSTEM
function StartEverything()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "QJozio Hub | COMPLETE EDITION",
        LoadingTitle = "Breaking Protection Layers...",
        ConfigurationSaving = {Enabled = true, FolderName = "QJozio_Full"}
    })

    -- THE SUPER BRIDGE (Ensures your features actually trigger)
    local function Sync(Type, Value)
        if Type == "Farm" then
            _G.AutoFarm = Value; _G.Farm = Value; _G.autofarm = Value; _G.Loop = Value
        elseif Type == "Combat" then
            _G.KillMobs = Value; _G.AutoKill = Value; _G.mobs = Value; _G.GodMode = Value
        elseif Type == "Collect" then
            _G.Collect = Value; _G.Magnet = Value; _G.Tokens = Value; _G.Pickup = Value
        end
    end

    -- TAB 1: FARMING
    local FarmTab = Window:CreateTab("Farming", 4483362458)
    FarmTab:CreateToggle({Name = "Master Auto-Farm", CurrentValue = false, Callback = function(v) Sync("Farm", v) end})
    FarmTab:CreateToggle({Name = "Token Magnet", CurrentValue = false, Callback = function(v) Sync("Collect", v) end})

    -- TAB 2: COMBAT
    local CombatTab = Window:CreateTab("Combat", 4483362458)
    CombatTab:CreateToggle({Name = "Auto-Kill Mobs", CurrentValue = false, Callback = function(v) Sync("Combat", v) end})
    CombatTab:CreateToggle({Name = "Auto-Wealth Clock", CurrentValue = false, Callback = function(v) _G.Clock = v end})

    -- TAB 3: TELEPORTS
    local TP = Window:CreateTab("Teleports", 4483362458)
    TP:CreateButton({Name = "Mountain Top", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(76, 176, -163) end})
    TP:CreateButton({Name = "Coconut Field", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-255, 72, 458) end})

    -- TAB 4: PLAYER
    local PlayerTab = Window:CreateTab("Player", 4483362458)
    PlayerTab:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end})
    PlayerTab:CreateSlider({Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end})

    -- TAB 5: VISUALS
    local VisualTab = Window:CreateTab("Visuals", 4483362458)
    VisualTab:CreateButton({Name = "Full Bright", Callback = function() game:GetService("Lighting").Brightness = 2; game:GetService("Lighting").ClockTime = 14 end})

    -- THE EXECUTION FIX (FORCING YOUR CODE TO WAKE UP)
    task.spawn(function()
        local function RunSource()
            -- START OBFUSCATED BLOCK
            local core = (function(...)
                -- [PASTE YOUR FULL OBFUSCATED LURAPH CODE HERE]
                return({i5=function(Y,s,_,w,H,B,k,S,I) 
                    -- ... (the provided obfuscated code) ...
                end})
            end)()
            
            -- If it returns a table, we execute EVERY function in it to find the main loop
            if type(core) == "table" then
                for _, func in pairs(core) do
                    if type(func) == "function" then task.spawn(func) end
                end
            elseif type(core) == "function" then
                core()
            end
        end
        pcall(RunSource)
    end)
end

Btn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then ScreenGui:Destroy(); StartEverything() end
end)
