-- [[ JOZEX HUB | DIRECT-LOAD UNIVERSAL ]] --
repeat task.wait() until game:IsLoaded()

local CorrectKey = "Jozex-on-top"
local KeyLink = "Https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. AUTHENTICATION UI
local LoginScreen = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", LoginScreen)
Main.Size, Main.Position = UDim2.new(0, 280, 0, 180), UDim2.new(0.5, -140, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Text = UDim2.new(1, 0, 0, 40), "JOZEX HUB LOGIN"
Title.TextColor3, Title.BackgroundTransparency = Color3.new(1,1,1), 1
Title.Font = Enum.Font.GothamBold

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText, KeyBox.Text = "Paste Key...", ""
KeyBox.BackgroundColor3, KeyBox.TextColor3 = Color3.fromRGB(35, 35, 35), Color3.new(1,1,1)
Instance.new("UICorner", KeyBox)

local LoginBtn = Instance.new("TextButton", Main)
LoginBtn.Size, LoginBtn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.65, 0)
LoginBtn.Text, LoginBtn.BackgroundColor3 = "LOGIN", Color3.fromRGB(0, 150, 255)
LoginBtn.TextColor3, LoginBtn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", LoginBtn)

-- 2. MAIN ENGINE
function LaunchJozex()
    -- Switch to Kavo Library (Highly stable, fast loading)
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Jozex Hub | BSS", "DarkTheme")

    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm, _G.SelectedField, _G.WS_Value = false, "Clover Field", 16

    -- [ SMART BOX DETECTOR ]
    local function SmartMove(targetPos)
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local overlapParams = OverlapParams.new()
        overlapParams.FilterDescendantsInstances = {char, game.Workspace.Collectibles, game.Workspace.FlowerZones}
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude

        -- Detector Box: 3 studs in front, 4x6x4 dimensions
        local sensorCFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3) 
        local hits = game.Workspace:GetPartBoundsInBox(sensorCFrame, Vector3.new(4, 6, 4), overlapParams)

        if #hits > 0 then
            local path = PathfindingService:CreatePath({AgentRadius = 3, AgentCanJump = true})
            path:ComputeAsync(char.HumanoidRootPart.Position, targetPos)
            if path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                if waypoints[2] then
                    char.Humanoid:MoveTo(waypoints[2].Position)
                    if waypoints[2].Action == Enum.PathWaypointAction.Jump then char.Humanoid.Jump = true end
                end
            end
        else
            char.Humanoid:MoveTo(targetPos)
        end
    end

    -- TABS
    local FarmTab = Window:NewTab("Auto-Farm")
    local FarmSection = FarmTab:NewSection("Field Farming")

    FarmSection:NewDropdown("Select Field", "Choose a field to farm", {"Sunflower Field", "Clover Field", "Mushroom Field", "Spider Field", "Bamboo Field", "Pineapple Patch", "Pumpkin Patch", "Rose Field", "Pine Tree Forest", "Mountain Top Field"}, function(s)
        _G.SelectedField = s
    end)

    FarmSection:NewToggle("Omni-Farm (No Stop)", "Farms tokens instantly", function(v)
        _G.AutoFarm = v
        if v then
            task.spawn(function()
                while _G.AutoFarm do
                    RunService.Heartbeat:Wait()
                    local char = Player.Character
                    local stats = Player:FindFirstChild("CoreStats")
                    if char and stats and char:FindFirstChild("HumanoidRootPart") then
                        local field = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)
                        
                        -- Pollen Check
                        if (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                            SmartMove(Player.SpawnPos.Value.Position)
                            if (char.HumanoidRootPart.Position - Player.SpawnPos.Value.Position).Magnitude < 10 then
                                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                                repeat task.wait(0.5) until stats.Pollen.Value == 0 or not _G.AutoFarm
                            end
                        -- Token Grab
                        elseif field then
                            local nt = nil; local ld = math.huge
                            for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                                if t:IsA("BasePart") and (t.Position - field.Position).Magnitude < 65 then
                                    local d = (t.Position - char.HumanoidRootPart.Position).Magnitude
                                    if d < ld then nt = t; ld = d end
                                end
                            end
                            if nt then SmartMove(nt.Position) else SmartMove(field.Position) end
                        end
                    end
                end
            end)
        end
    end)

    local MiscTab = Window:NewTab("Misc")
    local MiscSection = MiscTab:NewSection("Player")
    
    MiscSection:NewSlider("WalkSpeed", "Default is 16", 60, 16, function(s)
        _G.WS_Value = s
        if Player.Character then Player.Character.Humanoid.WalkSpeed = s end
    end)

    -- AUTO CLICKER (Integrated)
    MiscSection:NewToggle("Internal Auto-Clicker", "Clicks your tool automatically", function(v)
        _G.AutoClicker = v
        task.spawn(function()
            while _G.AutoClicker do
                task.wait(0.05)
                if Player.Character then
                    local tool = Player.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end)
    end)
end

-- BUTTONS
LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        LoginScreen:Destroy()
        LaunchJozex()
    else
        LoginBtn.Text = "WRONG KEY"
        task.wait(1)
        LoginBtn.Text = "LOGIN"
    end
end)
