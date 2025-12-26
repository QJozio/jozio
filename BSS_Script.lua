-- [[ JOZEX HUB | MOB EVASION + SPAM JUMP ]] --
local CorrectKey = "Jozex-on-top"

-- [ AUTH UI REMAINS THE SAME ]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 300, 0, 180), UDim2.new(0.5, -150, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main)

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText, KeyBox.Text = "Enter Key...", "Jozex-on-top"
KeyBox.BackgroundColor3, KeyBox.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(1,1,1)
Instance.new("UICorner", KeyBox)

local Btn = Instance.new("TextButton", Main)
Btn.Size, Btn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.65, 0)
Btn.Text, Btn.BackgroundColor3 = "ACTIVATE JOZEX", Color3.fromRGB(0, 120, 215)
Btn.TextColor3, Btn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", Btn)

-- 2. THE JOZEX ENGINE
function LaunchJozex()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Jozex Hub | Bee Swarm",
        LoadingTitle = "Initializing Combat Modules...",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    -- SERVICES
    local Player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    _G.AutoFarm = false
    _G.SpamJumpOnMob = true -- New Combat Feature

    local ThreatList = {"Spider", "Mantis", "Rhino Beetle", "Ladybug", "Scorpion", "Werewolf", "Vicious Bee"}

    -- [ THE COMBAT & FARM LOOP ]
    local FarmTab = Window:CreateTab("Auto-Farm", 4483362458)
    
    FarmTab:CreateToggle({
        Name = "Start Farm (Panic Jump Mobs)",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                task.spawn(function()
                    while _G.AutoFarm do
                        task.wait(0.05)
                        local char = Player.Character
                        if not char or not char:FindFirstChild("Humanoid") then continue end
                        local hum = char.Humanoid
                        local root = char.HumanoidRootPart

                        -- 1. SCAN FOR NEARBY THREATS
                        local currentThreat = nil
                        for _, mob in pairs(game.Workspace.Monsters:GetChildren()) do
                            if table.find(ThreatList, mob.Name) and mob:FindFirstChild("HumanoidRootPart") then
                                if (mob.HumanoidRootPart.Position - root.Position).Magnitude < 35 then
                                    currentThreat = mob
                                    break
                                end
                            end
                        end

                        -- 2. REACTION LOGIC
                        if currentThreat then
                            -- ORBIT LOGIC
                            local offset = Vector3.new(math.cos(tick()*4)*22, 0, math.sin(tick()*4)*22)
                            hum:MoveTo(currentThreat.HumanoidRootPart.Position + offset)
                            
                            -- SPAM JUMP LOGIC
                            if _G.SpamJumpOnMob and hum.FloorMaterial ~= Enum.Material.Air then
                                hum.Jump = true
                            end
                        else
                            -- NORMAL FARMING (Pathfinding to tokens)
                            -- [Insert Token Logic Here]
                        end
                    end
                end)
            end
        end
    })

    -- [ MISC TAB ]
    local MiscTab = Window:CreateTab("Misc", 4483362458)
    MiscTab:CreateToggle({
        Name = "Permanent Spam Jump",
        CurrentValue = false,
        Callback = function(val)
            _G.PermJump = val
            task.spawn(function()
                while _G.PermJump do
                    task.wait(0.1)
                    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                        Player.Character.Humanoid.Jump = true
                    end
                end
            end)
        end
    })
end

Btn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then ScreenGui:Destroy(); LaunchJozex() else Btn.Text = "WRONG KEY"; task.wait(1); Btn.Text = "LOGIN" end
end)
