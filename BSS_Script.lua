-- [[ JOZEX HUB | STABLE MASTER BUILD ]] --
local CorrectKey = "Jozex-on-top"
local KeyLink = "Https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. SECURE AUTHENTICATION UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 300, 0, 220), UDim2.new(0.5, -150, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.3, 0)
KeyBox.PlaceholderText, KeyBox.Text = "Enter Access Key...", ""
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
        Name = "Jozex Hub | Bee Swarm Simulator",
        LoadingTitle = "Stability Optimized...",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm = false
    _G.SelectedField = "Clover Field"
    _G.WS_Value = 16
    _G.NoClip = false

    local ThreatList = {"Spider", "Mantis", "Rhino Beetle", "Ladybug", "Scorpion", "Werewolf", "Vicious Bee"}
    local AllFields = {"Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field", "Pineapple Patch", "Stump Field", "Cactus Field", "Pumpkin Patch", "Pine Tree Forest", "Rose Field", "Mountain Top Field", "Coconut Field", "Pepper Patch"}

    -- [ STABLE CONVERSION LOGIC ]
    local function ConvertAtHive()
        local char = Player.Character
        local stats = Player:FindFirstChild("CoreStats")
        if not char or not stats or not Player.SpawnPos.Value then return end
        
        char.Humanoid.WalkSpeed = 16
        local hivePos = Player.SpawnPos.Value.Position + Vector3.new(0, 0, 5)
        
        local path = PathfindingService:CreatePath({AgentCanJump = false, AgentRadius = 3})
        path:ComputeAsync(char.HumanoidRootPart.Position, hivePos)
        
        if path.Status == Enum.PathStatus.Success then
            for _, wp in pairs(path:GetWaypoints()) do
                if not _G.AutoFarm or stats.Pollen.Value == 0 then break end
                char.Humanoid:MoveTo(wp.Position)
                char.Humanoid.MoveToFinished:Wait(1.2)
            end
        end

        -- Ensure Honey Making starts
        local lastPollen = stats.Pollen.Value
        repeat 
            game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
            task.wait(2) -- Wait to see if pollen drops
        until stats.Pollen.Value < lastPollen or stats.Pollen.Value <= 0 or not _G.AutoFarm
        
        -- Wait for complete empty
        repeat task.wait(0.5) until stats.Pollen.Value <= 0 or not _G.AutoFarm
        char.Humanoid.WalkSpeed = _G.WS_Value
    end

    local FarmTab = Window:CreateTab("Auto-Farm", 4483362458)
    FarmTab:CreateDropdown({
        Name = "Select Field", Options = AllFields, CurrentOption = {"Clover Field"},
        Callback = function(Option) _G.SelectedField = Option[1] end,
    })

    FarmTab:CreateToggle({
        Name = "No Mercy Strict Farm",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                task.spawn(function()
                    while _G.AutoFarm do
                        RunService.Heartbeat:Wait()
                        local char = Player.Character
                        local stats = Player:FindFirstChild("CoreStats")
                        if char and char:FindFirstChild("HumanoidRootPart") and stats then
                            local hum = char.Humanoid
                            local root = char.HumanoidRootPart
                            local field = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)

                            -- TOOL AUTO-CLICK
                            if char:FindFirstChildOfClass("Tool") then char:FindFirstChildOfClass("Tool"):Activate() end

                            -- 1. COMBAT JUMP
                            local threat = nil
                            for _, m in pairs(game.Workspace.Monsters:GetChildren()) do
                                if table.find(ThreatList, m.Name) and m:FindFirstChild("HumanoidRootPart") then
                                    if (m.HumanoidRootPart.Position - root.Position).Magnitude < 30 then
                                        threat = m; break
                                    end
                                end
                            end

                            if threat then
                                hum:MoveTo(threat.HumanoidRootPart.Position + Vector3.new(math.cos(tick()*4)*20, 0, math.sin(tick()*4)*20))
                                if hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
                            
                            -- 2. HIVE RETURN
                            elseif (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                                ConvertAtHive()
                            
                            -- 3. AGGRESSIVE TOKEN CHASE
                            elseif field then
                                local nearestToken = nil
                                local lastDist = math.huge
                                for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                                    if t:IsA("BasePart") and (t.Position - field.Position).Magnitude < 65 then
                                        local d = (t.Position - root.Position).Magnitude
                                        if d < lastDist then nearestToken = t; lastDist = d end
                                    end
                                end
                                if nearestToken then 
                                    hum:MoveTo(nearestToken.Position)
                                elseif (root.Position - field.Position).Magnitude > 60 then 
                                    hum:MoveTo(field.Position) 
                                end
                            end
                        end
                    end
                end)
            end
        end
    })

    -- MISC TAB
    local MiscTab = Window:CreateTab("Misc", 4483362458)
    MiscTab:CreateSlider({
        Name = "WalkSpeed", Range = {16, 60}, Increment = 1, CurrentValue = 16,
        Callback = function(v) _G.WS_Value = v; if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end
    })
    MiscTab:CreateToggle({
        Name = "Noclip", CurrentValue = false,
        Callback = function(val) _G.NoClip = val end
    })
    
    -- Optimized Noclip Loop
    RunService.Stepped:Connect(function()
        if _G.NoClip and Player.Character then
            for _, v in pairs(Player.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end

-- BUTTONS
GetKeyBtn.MouseButton1Click:Connect(function() setclipboard(KeyLink); GetKeyBtn.Text = "COPIED!" task.wait(2) GetKeyBtn.Text = "GET KEY" end)
LoginBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then ScreenGui:Destroy(); LaunchJozex() else LoginBtn.Text = "WRONG KEY"; task.wait(1); LoginBtn.Text = "LOGIN" end
end)
