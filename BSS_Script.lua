-- [[ JOZEX HUB | THE ULTIMATE INTEGRATED VERSION ]] --
local CorrectKey = "Jozex-on-top"

-- 1. SECURE AUTHENTICATION UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 300, 0, 180), UDim2.new(0.5, -150, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText, KeyBox.Text = "Enter Key...", ""
KeyBox.BackgroundColor3, KeyBox.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(1,1,1)
Instance.new("UICorner", KeyBox)

local Btn = Instance.new("TextButton", Main)
Btn.Size, Btn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.65, 0)
Btn.Text, Btn.BackgroundColor3 = "LOGIN TO JOZEX", Color3.fromRGB(0, 120, 215)
Btn.TextColor3, Btn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", Btn)

-- 2. THE MASTER ENGINE
function LaunchJozex()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Jozex Hub | Bee Swarm Simulator",
        LoadingTitle = "Mapping All Systems...",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    -- GLOBAL SETTINGS & SERVICES
    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm = false
    _G.NoClip = false
    _G.SelectedField = "Clover Field"
    
    local ThreatList = {"Spider", "Mantis", "Rhino Beetle", "Ladybug", "Scorpion", "Werewolf", "Vicious Bee", "Mondo Chick"}
    local AllFields = {"Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field", "Pineapple Patch", "Stump Field", "Cactus Field", "Pumpkin Patch", "Pine Tree Forest", "Rose Field", "Mountain Top Field", "Coconut Field", "Pepper Patch"}

    -- [ SMART MOVE FUNCTION ]
    local function JozexMove(target)
        if not Player.Character or not _G.AutoFarm then return end
        local hum = Player.Character:FindFirstChild("Humanoid")
        local path = PathfindingService:CreatePath({AgentCanJump = false, AgentRadius = 3})
        path:ComputeAsync(Player.Character.HumanoidRootPart.Position, target)
        if path.Status == Enum.PathStatus.Success then
            for _, wp in pairs(path:GetWaypoints()) do
                if not _G.AutoFarm then break end
                hum:MoveTo(wp.Position)
                hum.MoveToFinished:Wait(1.2)
            end
        end
    end

    -- [ AUTO-FARM TAB ]
    local FarmTab = Window:CreateTab("Auto-Farm", 4483362458)
    
    FarmTab:CreateDropdown({
        Name = "Select Field",
        Options = AllFields,
        CurrentOption = {"Clover Field"},
        Callback = function(Option) _G.SelectedField = Option[1] end,
    })

    FarmTab:CreateToggle({
        Name = "Start Smart Farm (With Combat)",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                task.spawn(function()
                    while _G.AutoFarm do
                        task.wait(0.05)
                        local char = Player.Character
                        local stats = Player:FindFirstChild("CoreStats")
                        if char and stats then
                            local hum = char.Humanoid
                            local root = char.HumanoidRootPart

                            -- 1. COMBAT CHECK (Spider, Mantis, etc.)
                            local threat = nil
                            for _, m in pairs(game.Workspace.Monsters:GetChildren()) do
                                if table.find(ThreatList, m.Name) and m:FindFirstChild("HumanoidRootPart") then
                                    if (m.HumanoidRootPart.Position - root.Position).Magnitude < 35 then
                                        threat = m; break
                                    end
                                end
                            end

                            if threat then
                                -- ORBIT + PANIC JUMP
                                local offset = Vector3.new(math.cos(tick()*4)*22, 0, math.sin(tick()*4)*22)
                                hum:MoveTo(threat.HumanoidRootPart.Position + offset)
                                if hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
                            
                            -- 2. AUTO-CONVERT CHECK (95% Full)
                            elseif (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                                JozexMove(Player.SpawnPos.Value.Position + Vector3.new(0,0,5))
                                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                                repeat task.wait(1) until stats.Pollen.Value == 0 or not _G.AutoFarm
                            
                            -- 3. FIELD FARMING
                            else
                                local field = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)
                                if field then
                                    local token = nil
                                    for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                                        if t:IsA("BasePart") and (t.Position - field.Position).Magnitude < 60 then
                                            token = t; break
                                        end
                                    end
                                    if token then hum:MoveTo(token.Position) else JozexMove(field.Position) end
                                end
                            end
                        end
                    end
                end)
            end
        end
    })

    -- [ MISC TAB ]
    local MiscTab = Window:CreateTab("Misc", 4483362458)
    
    MiscTab:CreateSlider({
        Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16,
        Callback = function(v) if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end
    })

    MiscTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(Value)
            _G.NoClip = Value
            RunService.Stepped:Connect(function()
                if _G.NoClip and Player.Character then
                    for _, v in pairs(Player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        end
    })
end

-- LOGIN LOGIC
Btn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then ScreenGui:Destroy(); LaunchJozex() else Btn.Text = "INVALID KEY"; task.wait(1); Btn.Text = "LOGIN TO JOZEX" end
end)
