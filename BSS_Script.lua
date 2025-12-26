-- [[ QJOZIO HUB | PROFESSIONAL MULTI-TAB ENGINE ]] --
local CorrectKey = "QJOZIO-ON-TOP"
local KeyLink = "https://direct-link.net/2552546/CxGwpvRqOVJH"

-- SECTION 1: SECURE AUTHENTICATION
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KeyInput = Instance.new("TextBox")
local SubmitBtn = Instance.new("TextButton")

ScreenGui.Name = "QJozioAuth"
ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

KeyInput.Parent = MainFrame
KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""

SubmitBtn.Parent = MainFrame
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
SubmitBtn.Text = "ACCESS ENGINE"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SubmitBtn.TextColor3 = Color3.new(1,1,1)

-- SECTION 2: THE MULTI-TAB ENGINE
function StartEngine()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "QJozio Hub | BSS Ultimate",
        LoadingTitle = "Syncing Obfuscated Modules...",
        ConfigurationSaving = {Enabled = true, FolderName = "QJozioConfig"}
    })

    -- EXECUTE YOUR PROTECTED SOURCE IN THE BACKGROUND
    task.spawn(function()
        local success, err = pcall(function()
            -- YOUR FULL OBFUSCATED CODE START
            local protected_code = (function(...)
                -- [Your return functions i5, Y5, etc. are handled here]
                return (function() 
                    -- THE FULL OBFUSCATED SCRIPT YOU PROVIDED GOES HERE
                end)
            end)()
            protected_code()
            -- YOUR FULL OBFUSCATED CODE END
        end)
        if not success then warn("Logic Bridge Failed: " .. err) end
    end)

    -- TAB 1: AUTOMATED FARMING
    local FarmTab = Window:CreateTab("Farming", 4483362458)
    FarmTab:CreateSection("Pollen Collection")

    FarmTab:CreateToggle({
        Name = "Auto Farm (Selected Field)",
        CurrentValue = false,
        Callback = function(v) _G.AutoFarm = v end
    })

    FarmTab:CreateToggle({
        Name = "Instant Token Magnet",
        CurrentValue = false,
        Callback = function(v) _G.Magnet = v end
    })

    -- TAB 2: COMBAT & MOBS
    local CombatTab = Window:CreateTab("Combat", 4483362458)
    CombatTab:CreateSection("Protection")

    CombatTab:CreateToggle({
        Name = "Auto-Kill Mobs",
        CurrentValue = false,
        Callback = function(v) _G.KillMobs = v end
    })

    CombatTab:CreateToggle({
        Name = "God Mode (Safe Altitude)",
        CurrentValue = false,
        Callback = function(v) _G.GodMode = v end
    })

    -- TAB 3: WORLD & MISC
    local WorldTab = Window:CreateTab("World", 4483362458)
    
    WorldTab:CreateButton({
        Name = "Infinite Oxygen",
        Callback = function() _G.InfOxygen = true end
    })

    WorldTab:CreateSlider({
        Name = "Walkspeed",
        Range = {16, 200},
        Increment = 1,
        Suffix = "Speed",
        CurrentValue = 16,
        Callback = function(Value) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end
    })

    Rayfield:Notify({Title = "Authorized", Content = "Welcome back, QJozio.", Duration = 5})
end

-- KEY VALIDATION TRIGGER
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        ScreenGui:Destroy()
        StartEngine()
    else
        SubmitBtn.Text = "INVALID KEY"
        task.wait(1)
        SubmitBtn.Text = "ACCESS ENGINE"
    end
end)
