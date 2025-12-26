-- [[ QJOZIO HUB | STABLE MODULAR VERSION ]] --
local CorrectKey = "QJOZIO-ON-TOP"

-- 1. AUTHENTICATION
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 280, 0, 160), UDim2.new(0.5, -140, 0.5, -80)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.25, 0)
KeyBox.PlaceholderText = "Input Key..."

local Btn = Instance.new("TextButton", Main)
Btn.Size, Btn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.6, 0)
Btn.Text = "ACTIVATE ALL FEATURES"
Btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- 2. THE ENGINE
function StartEngine()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "QJozio Hub | BSS FIXED",
        LoadingTitle = "Initializing Logic Bridge...",
        ConfigurationSaving = {Enabled = true, FolderName = "QJozio_Final"}
    })

    -- MAPS UI TO YOUR CODE'S INTERNAL GLOBALS
    local function Sync(Cat, Val)
        if Cat == "Farm" then _G.AutoFarm = Val; _G.Farm = Val; _G.autofarm = Val
        elseif Cat == "Collect" then _G.Collect = Val; _G.Magnet = Val; _G.TokenCollect = Val
        elseif Cat == "Combat" then _G.KillMobs = Val; _G.AutoKill = Val; _G.Combat = Val end
    end

    -- CREATE TABS
    local Tab1 = Window:CreateTab("Farming", 4483362458)
    Tab1:CreateToggle({Name = "Master Farm", CurrentValue = false, Callback = function(v) Sync("Farm", v) end})
    Tab1:CreateToggle({Name = "Token Magnet", CurrentValue = false, Callback = function(v) Sync("Collect", v) end})

    local Tab2 = Window:CreateTab("Combat", 4483362458)
    Tab2:CreateToggle({Name = "Kill Mobs", CurrentValue = false, Callback = function(v) Sync("Combat", v) end})

    local Tab3 = Window:CreateTab("Player", 4483362458)
    Tab3:CreateSlider({Name = "WalkSpeed", Range = {16, 500}, Increment = 1, CurrentValue = 16, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end})

    -- 3. THE "NO MERCY" LOGIC EXECUTION
    task.spawn(function()
        local function RunHeavyLogic()
            -- THIS IS THE WRAPPER FOR YOUR ENTIRE LURAPH CODE
            local Execute = (function(...)
                -- [PASTE YOUR FULL OBFUSCATED CODE BLOCK STARTING WITH 'return' HERE]
                return({i5=function(Y,s,_,w,H,B,k,S,I) 
                    -- ... (all your i5, Y5, v functions here) ...
                end})
            end)()

            -- AUTO-START ALL INTERNAL FUNCTIONS
            if type(Execute) == "table" then
                for _, f in pairs(Execute) do if type(f) == "function" then task.spawn(f) end end
            elseif type(Execute) == "function" then
                Execute()
            end
        end
        
        local success, err = pcall(RunHeavyLogic)
        if not success then warn("LOGIC ERROR: " .. err) end
    end)
end

Btn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then ScreenGui:Destroy(); StartEngine() end
end)
