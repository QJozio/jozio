-- [[ JOZEX HUB | SMART PATHFINDING + MISC TAB ]] --
local CorrectKey = "Jozex-on-top"

-- 1. JOZEX AUTHENTICATION
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size, Main.Position = UDim2.new(0, 300, 0, 180), UDim2.new(0.5, -150, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active, Main.Draggable = true, true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size, Title.Position = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 5)
Title.Text = "JOZEX ENGINE | AUTH"
Title.TextColor3, Title.BackgroundTransparency = Color3.fromRGB(0, 120, 215), 1
Title.Font, Title.TextSize = Enum.Font.GothamBold, 16

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText, KeyBox.Text = "Input Key...", ""
KeyBox.BackgroundColor3, KeyBox.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(1,1,1)
Instance.new("UICorner", KeyBox)

local Btn = Instance.new("TextButton", Main)
Btn.Size, Btn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.65, 0)
Btn.Text, Btn.BackgroundColor3 = "LOGIN", Color3.fromRGB(0, 120, 215)
Btn.TextColor3, Btn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", Btn)

-- 2. THE MAIN ENGINE
function LaunchJozex()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Jozex Hub | Bee Swarm Simulator",
        LoadingTitle = "Initializing Jozex Systems...",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    -- SERVICES
    local Player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local PathfindingService = game:GetService("PathfindingService")
    
    -- VARIABLES
    _G.AutoFarm = false
    _G.NoClip = false
    local noclipConnection

    -- [ SMART MOVE FUNCTION ]
    local function SmartMove(target)
        local Character = Player.Character
        if not Character then return end
        local Humanoid = Character:FindFirstChild("Humanoid")
        local path = PathfindingService:CreatePath({AgentCanJump = false, AgentRadius = 2})
        path:ComputeAsync(Character.HumanoidRootPart.Position, target)
        if path.Status == Enum.PathStatus.Success then
            for _, waypoint in pairs(path:GetWaypoints()) do
                if not _G.AutoFarm then break end
                Humanoid:MoveTo(waypoint.Position)
                Humanoid.MoveToFinished:Wait(1.5)
            end
        end
    end

    -- [ TABS ]
    local MainTab = Window:CreateTab("Auto-Farm", 4483362458)
    MainTab:CreateToggle({
        Name = "Smart Path-Farm",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                task.spawn(function()
                    while _G.AutoFarm do
                        task.wait(0.1)
                        local stats = Player:FindFirstChild("CoreStats")
                        if stats and (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                            SmartMove(Player.SpawnPos.Value.Position + Vector3.new(0,0,5))
                            game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                            repeat task.wait(1) until stats.Pollen.Value == 0 or not _G.AutoFarm
                        else
                            local token = game.Workspace.Collectibles:FindFirstChildOfClass("BasePart")
                            if token then SmartMove(token.Position) end
                        end
                    end
                end)
            end
        end
    })

    -- [ MISC TAB ]
    local MiscTab = Window:CreateTab("Misc", 4483362458)

    MiscTab:CreateSection("Character Modifiers")

    MiscTab:CreateSlider({
        Name = "WalkSpeed",
        Range = {16, 300},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(v)
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = v
            end
        end
    })

    MiscTab:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(Value)
            _G.NoClip = Value
            if _G.NoClip then
                -- Start Noclip
                noclipConnection = RunService.Stepped:Connect(function()
                    if _G.NoClip and Player.Character then
                        for _, v in pairs(Player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end)
            else
                -- Stop Noclip
                if noclipConnection then 
                    noclipConnection:Disconnect() 
                end
                -- Reset collisions
                if Player.Character then
                    for _, v in pairs(Player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = true
                        end
                    end
                end
            end
        end
    })

    Rayfield:Notify({Title = "Jozex Loaded", Content = "Welcome back. Misc tab added.", Duration = 5})
end

-- 3. LOGIN LOGIC
Btn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        ScreenGui:Destroy()
        LaunchJozex()
    else
        Btn.Text = "WRONG KEY"
        task.wait(1)
        Btn.Text = "LOGIN"
    end
end)
