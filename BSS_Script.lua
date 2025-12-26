-- [[ JOZEX HUB | ZERO-LATENCY OMNI-DETECTOR ]] --
local CorrectKey = "Jozex-on-top"
local KeyLink = "Https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. AUTH UI
local LoginScreen = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", LoginScreen)
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

-- 2. THE MASTER ENGINE
function LaunchJozex()
    local JozexOverlay = Instance.new("ScreenGui", game.CoreGui)
    
    -- [ FLOATING CLICKER ]
    local ClickerFrame = Instance.new("Frame", JozexOverlay)
    ClickerFrame.Size, ClickerFrame.Position = UDim2.new(0, 140, 0, 80), UDim2.new(0.1, 0, 0.2, 0)
    ClickerFrame.BackgroundColor3, ClickerFrame.Active, ClickerFrame.Draggable = Color3.fromRGB(20, 20, 20), true, true
    ClickerFrame.Visible = false
    Instance.new("UICorner", ClickerFrame)

    local ClickBtn = Instance.new("TextButton", ClickerFrame)
    ClickBtn.Size, ClickBtn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.3, 0)
    ClickBtn.Text, ClickBtn.BackgroundColor3 = "CLICKER: OFF", Color3.fromRGB(200, 50, 50)
    ClickBtn.TextColor3, ClickBtn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
    Instance.new("UICorner", ClickBtn)

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({Name = "Jozex Hub | Omni-Nav", LoadingTitle = "Calibrating Instant Sensors..."})

    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm, _G.WS_Value, _G.InternalClicker = false, 16, false
    _G.SelectedField = "Clover Field"

    -- [ THE OMNI-DETECTOR (NO DELAY VERSION) ]
    local function GetSmartPath(targetPos)
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        
        -- Spatial Query Box Check
        local overlapParams = OverlapParams.new()
        overlapParams.FilterDescendantsInstances = {char, game.Workspace.Collectibles, game.Workspace.FlowerZones, game.Workspace.Monsters}
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude

        local sensorCFrame = root.CFrame * CFrame.new(0, 0, -3) -- Detects 3 studs ahead
        local objectsInWay = game.Workspace:GetPartBoundsInBox(sensorCFrame, Vector3.new(3, 5, 3), overlapParams)

        if #objectsInWay > 0 then
            -- Pathfind instantly around wall
            local path = PathfindingService:CreatePath({AgentRadius = 3, AgentCanJump = true})
            path:ComputeAsync(root.Position, targetPos)
            if path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                if waypoints[2] then
                    char.Humanoid:MoveTo(waypoints[2].Position)
                    if waypoints[2].Action == Enum.PathWaypointAction.Jump then char.Humanoid.Jump = true end
                end
            end
        else
            -- Straight line (Zero delay)
            char.Humanoid:MoveTo(targetPos)
        end
    end

    -- CLICKER LOGIC
    ClickBtn.MouseButton1Click:Connect(function()
        _G.InternalClicker = not _G.InternalClicker
        ClickBtn.Text = _G.InternalClicker and "CLICKER: ON" or "CLICKER: OFF"
        ClickBtn.BackgroundColor3 = _G.InternalClicker and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    task.spawn(function()
        while true do task.wait(0.05) if _G.InternalClicker and Player.Character then 
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end 
        end end
    end)

    -- TABS
    local FarmTab = Window:CreateTab("Main", 4483362458)
    FarmTab:CreateDropdown({
        Name = "Field", Options = {"Sunflower Field", "Clover Field", "Mushroom Field", "Spider Field", "Bamboo Field", "Pine Tree Forest", "Rose Field", "Mountain Top Field"},
        CurrentOption = {"Clover Field"}, Callback = function(Option) _G.SelectedField = Option[1] end,
    })

    FarmTab:CreateToggle({
        Name = "No-Stop Omni-Farm", CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                -- RUN ON HEARTBEAT FOR INSTANT MOVEMENT
                task.spawn(function()
                    while _G.AutoFarm do
                        RunService.Heartbeat:Wait()
                        local char = Player.Character
                        local stats = Player:FindFirstChild("CoreStats")
                        if char and stats and char:FindFirstChild("HumanoidRootPart") then
                            local field = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)
                            
                            -- 1. HIVE LOGIC
                            if (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                                GetSmartPath(Player.SpawnPos.Value.Position)
                                if (char.HumanoidRootPart.Position - Player.SpawnPos.Value.Position).Magnitude < 10 then
                                    game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                                    repeat task.wait(0.5) until stats.Pollen.Value == 0 or not _G.AutoFarm
                                end
                            -- 2. INSTANT TOKEN CHASE
                            elseif field then
                                local nt = nil; local ld = math.huge
                                for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                                    if t:IsA("BasePart") and (t.Position - field.Position).Magnitude < 60 then
                                        local d = (t.Position - char.HumanoidRootPart.Position).Magnitude
                                        if d < ld then nt = t; ld = d end
                                    end
                                end
                                if nt then 
                                    GetSmartPath(nt.Position) 
                                else 
                                    GetSmartPath(field.Position) 
                                end
                            end
                        end
                    end
                end)
            end
        end
    })

    local MiscTab = Window:CreateTab("Misc", 4483362458)
    MiscTab:CreateToggle({Name = "Auto-Clicker Widget", Callback = function(v) ClickerFrame.Visible = v end})
    MiscTab:CreateSlider({Name = "Speed", Range = {16, 60}, Increment = 1, CurrentValue = 16, Callback = function(v) if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end})
end

LoginBtn.MouseButton1Click:Connect(function() if KeyBox.Text == CorrectKey then LoginScreen:Destroy(); LaunchJozex() end end)
