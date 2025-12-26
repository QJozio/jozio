-- [[ JOZEX HUB | GROUNDED PRECISION NAV ]] --
local CorrectKey = "Jozex-on-top"
local KeyLink = "Https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. AUTH UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 300, 0, 220), UDim2.new(0.5, -150, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.3, 0)
KeyBox.PlaceholderText = "Enter Access Key..."
KeyBox.BackgroundColor3, KeyBox.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(1,1,1)
Instance.new("UICorner", KeyBox)

local LoginBtn = Instance.new("TextButton", Main)
LoginBtn.Size, LoginBtn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.52, 0)
LoginBtn.Text, LoginBtn.BackgroundColor3 = "LOGIN", Color3.fromRGB(0, 120, 215)
LoginBtn.TextColor3, LoginBtn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", LoginBtn)

local GetKeyBtn = Instance.new("TextButton", Main)
GetKeyBtn.Size, GetKeyBtn.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.75, 0)
GetKeyBtn.Text, GetKeyBtn.BackgroundColor3 = "GET KEY", Color3.fromRGB(40, 40, 40)
GetKeyBtn.TextColor3, GetKeyBtn.Font = Color3.new(0.8, 0.8, 0.8), Enum.Font.GothamBold
Instance.new("UICorner", GetKeyBtn)

-- 2. THE MASTER ENGINE
function LaunchJozex()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Jozex Hub | BSS",
        LoadingTitle = "Applying Grounded Pathing...",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm = false
    _G.SelectedField = "Clover Field"
    _G.WS_Value = 16
    _G.InternalClicker = false

    -- [ FLOATING CLICKER UI ]
    local ClickerGui = Instance.new("Frame", ScreenGui)
    ClickerGui.Size = UDim2.new(0, 150, 0, 80)
    ClickerGui.Position = UDim2.new(0.1, 0, 0.1, 0)
    ClickerGui.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ClickerGui.Active, ClickerGui.Draggable, ClickerGui.Visible = true, true, false
    Instance.new("UICorner", ClickerGui)

    local ClickBtn = Instance.new("TextButton", ClickerGui)
    ClickBtn.Size, ClickBtn.Position = UDim2.new(0.8, 0, 0, 30), UDim2.new(0.1, 0, 0.45, 0)
    ClickBtn.Text, ClickBtn.BackgroundColor3 = "OFF", Color3.fromRGB(200, 50, 50)
    ClickBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", ClickBtn)

    ClickBtn.MouseButton1Click:Connect(function()
        _G.InternalClicker = not _G.InternalClicker
        ClickBtn.Text = _G.InternalClicker and "ON" or "OFF"
        ClickBtn.BackgroundColor3 = _G.InternalClicker and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    task.spawn(function()
        while true do
            task.wait(0.01)
            if _G.InternalClicker and Player.Character and Player.Character:FindFirstChildOfClass("Tool") then
                Player.Character:FindFirstChildOfClass("Tool"):Activate()
            end
        end
    end)

    -- [ GROUNDED NAVIGATION ]
    local function TapToMove(targetPos)
        local char = Player.Character
        if not char or not char:FindFirstChild("Humanoid") then return end
        
        local path = PathfindingService:CreatePath({
            AgentRadius = 3,
            AgentHeight = 5,
            AgentCanJump = true, -- Jump for obstacles
            AgentCanClimb = true,
            AgentMaxSlope = 40,
            -- Cost logic: Makes "jumping over gaps" extremely expensive so it prefers walking
            Costs = { Jump = 100 } 
        })
        
        path:ComputeAsync(char.HumanoidRootPart.Position, targetPos)
        
        if path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            if waypoints[2] then
                char.Humanoid:MoveTo(waypoints[2].Position)
                -- Only jump if the pathfinder explicitly says it's required to clear a step
                if waypoints[2].Action == Enum.PathWaypointAction.Jump then
                    char.Humanoid.Jump = true
                end
            end
        else
            char.Humanoid:MoveTo(targetPos)
        end
    end

    -- TABS
    local FarmTab = Window:CreateTab("Auto-Farm", 4483362458)
    FarmTab:CreateDropdown({
        Name = "Select Field", 
        Options = {"Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field", "Pineapple Patch", "Stump Field", "Cactus Field", "Pumpkin Patch", "Pine Tree Forest", "Rose Field", "Mountain Top Field", "Coconut Field", "Pepper Patch"},
        CurrentOption = {"Clover Field"},
        Callback = function(Option) _G.SelectedField = Option[1] end,
    })

    FarmTab:CreateToggle({
        Name = "Grounded Precision Farm",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                task.spawn(function()
                    while _G.AutoFarm do
                        RunService.Heartbeat:Wait()
                        local char = Player.Character
                        local stats = Player:FindFirstChild("CoreStats")
                        if char and stats and char:FindFirstChild("HumanoidRootPart") then
                            local field = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)
                            
                            -- COMBAT
                            local threat = nil
                            for _, m in pairs(game.Workspace.Monsters:GetChildren()) do
                                if m:FindFirstChild("HumanoidRootPart") and (m.Name == "Spider" or m.Name == "Mantis") then
                                    if (m.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude < 30 then threat = m; break end
                                end
                            end
                            if threat then
                                char.Humanoid:MoveTo(threat.HumanoidRootPart.Position + Vector3.new(math.cos(tick()*4)*20, 0, math.sin(tick()*4)*20))
                                if char.Humanoid.FloorMaterial ~= Enum.Material.Air then char.Humanoid.Jump = true end
                            -- HIVE RETURN
                            elseif (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                                char.Humanoid.WalkSpeed = 16
                                local hivePos = Player.SpawnPos.Value.Position + Vector3.new(0,0,5)
                                TapToMove(hivePos)
                                if (char.HumanoidRootPart.Position - hivePos).Magnitude < 8 then
                                    game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                                    repeat task.wait(1) until stats.Pollen.Value <= 0 or not _G.AutoFarm
                                    char.Humanoid.WalkSpeed = _G.WS_Value
                                end
                            -- TOKEN CHASE
                            elseif field then
                                local nt = nil; local ld = math.huge
                                for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                                    if t:IsA("BasePart") and (t.Position - field.Position).Magnitude < 65 then
                                        local d = (t.Position - char.HumanoidRootPart.Position).Magnitude
                                        if d < ld then nt = t; ld = d end
                                    end
                                end
                                if nt then TapToMove(nt.Position) elseif (char.HumanoidRootPart.Position - field.Position).Magnitude > 60 then TapToMove(field.Position) end
                            end
                        end
                    end
                end)
            end
        end
    })

    local MiscTab = Window:CreateTab("Misc", 4483362458)
    MiscTab:CreateToggle({Name = "Show Clicker Widget", CurrentValue = false, Callback = function(v) ClickerGui.Visible = v end})
    MiscTab:CreateSlider({
        Name = "WalkSpeed", Range = {16, 60}, Increment = 1, CurrentValue = 16,
        Callback = function(v) _G.WS_Value = v; if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end
    })
    MiscTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(v) _G.NoClip = v end})
    
    RunService.Stepped:Connect(function()
        if _G.NoClip and Player.Character then
            for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end

-- LOGIN
GetKeyBtn.MouseButton1Click:Connect(function() setclipboard(KeyLink); GetKeyBtn.Text = "COPIED!" task.wait(2) GetKeyBtn.Text = "GET KEY" end)
LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then ScreenGui:Destroy(); LaunchJozex() else LoginBtn.Text = "WRONG KEY"; task.wait(1); LoginBtn.Text = "LOGIN" end
end)
