-- [[ JOZEX HUB | FIELD SELECTION + SMART PATHFINDING ]] --
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
Title.Text, Title.TextColor3 = "JOZEX ENGINE | AUTH", Color3.fromRGB(0, 120, 215)
Title.BackgroundTransparency, Title.Font, Title.TextSize = 1, Enum.Font.GothamBold, 16

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
        LoadingTitle = "Mapping Field Coordinates...",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    -- SERVICES & GLOBALS
    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    _G.AutoFarm = false
    _G.SelectedField = "Clover Field" -- Default

    -- FIELD LIST
    local BSS_Fields = {
        "Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", 
        "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field", 
        "Pineapple Patch", "Pumpkin Patch", "Cactus Field", "Rose Field", 
        "Pine Tree Forest", "Stump Field", "Coconut Field", "Pepper Patch"
    }

    -- [ SMART MOVE FUNCTION ]
    local function SmartMove(target)
        if not Player.Character then return end
        local path = PathfindingService:CreatePath({AgentCanJump = false, AgentRadius = 2.5})
        path:ComputeAsync(Player.Character.HumanoidRootPart.Position, target)
        if path.Status == Enum.PathStatus.Success then
            for _, wp in pairs(path:GetWaypoints()) do
                if not _G.AutoFarm then break end
                Player.Character.Humanoid:MoveTo(wp.Position)
                Player.Character.Humanoid.MoveToFinished:Wait(1.5)
            end
        end
    end

    -- [ AUTO-FARM TAB ]
    local FarmTab = Window:CreateTab("Auto-Farm", 4483362458)

    FarmTab:CreateDropdown({
        Name = "Select Field",
        Options = BSS_Fields,
        CurrentOption = "Clover Field",
        Callback = function(Option)
            _G.SelectedField = Option
        end,
    })

    FarmTab:CreateToggle({
        Name = "Start Smart Farm",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoFarm = Value
            if Value then
                task.spawn(function()
                    while _G.AutoFarm do
                        task.wait(0.1)
                        local stats = Player:FindFirstChild("CoreStats")
                        if stats and (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                            -- Bag Full: Path to Hive
                            SmartMove(Player.SpawnPos.Value.Position + Vector3.new(0,0,5))
                            game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                            repeat task.wait(1) until stats.Pollen.Value == 0 or not _G.AutoFarm
                        else
                            -- Farm Logic: Stay in Selected Field
                            local fieldPart = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)
                            if fieldPart then
                                -- Logic: Find token inside that specific field
                                local targetToken = nil
                                for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                                    -- Checks if token is within field bounds
                                    if t:IsA("BasePart") and (t.Position - fieldPart.Position).Magnitude < 50 then
                                        targetToken = t
                                        break
                                    end
                                end
                                
                                if targetToken then
                                    SmartMove(targetToken.Position)
                                else
                                    -- If no tokens, walk to center of field
                                    SmartMove(fieldPart.Position)
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
        Callback = function(v) Player.Character.Humanoid.WalkSpeed = v end
    })

    Rayfield:Notify({Title = "Jozex Active", Content = "Field modules loaded.", Duration = 5})
end

-- 3. LOGIN LOGIC
Btn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CorrectKey then
        ScreenGui:Destroy()
        LaunchJozex()
    else
        Btn.Text = "WRONG KEY"; task.wait(1); Btn.Text = "LOGIN"
    end
end)
