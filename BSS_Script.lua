            -- [[ JOZEX HUB | CUSTOM TABBED UI ]] --
repeat task.wait() until game:IsLoaded()

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

-- Global Variables
_G.AutoFarm = false
_G.AutoClicker = false
_G.SelectedField = "Clover Field"
_G.WS_Value = 16

-- 1. MAIN UI STRUCTURE
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "JozexTabbedUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 

local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 2

-- Sidebar (Tabs)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 100, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", SideBar)

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -110, 1, -40)
TabContainer.Position = UDim2.new(0, 105, 0, 35)
TabContainer.BackgroundTransparency = 1

-- 2. TAB LOGIC
local Tabs = {}
local function CreateTab(name, isDefault)
    local TabFrame = Instance.new("ScrollingFrame", TabContainer)
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = isDefault or false
    TabFrame.ScrollBarThickness = 2
    TabFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    
    local List = Instance.new("UIListLayout", TabFrame)
    List.Padding = UDim.new(0, 8)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local TabBtn = Instance.new("TextButton", SideBar)
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.Position = UDim2.new(0, 0, 0, #Tabs * 45)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(35, 35, 35)
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do 
            t.Frame.Visible = false 
            t.Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end
        TabFrame.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)
    
    table.insert(Tabs, {Frame = TabFrame, Btn = TabBtn})
    return TabFrame
end

local FarmTab = CreateTab("Farming", true)
local MiscTab = CreateTab("Misc", false)

-- 3. UI ELEMENT HELPERS
local function CreateToggle(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.Text = text .. " : OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", Btn)
    
    local enabled = false
    Btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        Btn.Text = text .. (enabled and " : ON" or " : OFF")
        Btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(35, 35, 35)
        callback(enabled)
    end)
end

local function CreateLabel(parent, text)
    local Label = Instance.new("TextLabel", parent)
    Label.Size = UDim2.new(0.9, 0, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
end

-- 4. SMART NAVIGATION LOGIC
local function SmartMove(targetPos)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local overlapParams = OverlapParams.new()
    overlapParams.FilterDescendantsInstances = {char, game.Workspace.Collectibles, game.Workspace.FlowerZones}
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude

    local sensorCFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4) 
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

-- 5. POPULATE TABS
CreateLabel(FarmTab, "FIELD SELECTION")
local FieldInput = Instance.new("TextBox", FarmTab)
FieldInput.Size = UDim2.new(0.9, 0, 0, 35)
FieldInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FieldInput.Text = "Clover Field"
FieldInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FieldInput)
FieldInput.FocusLost:Connect(function() _G.SelectedField = FieldInput.Text end)

CreateToggle(FarmTab, "Omni-Auto Farm", function(v)
    _G.AutoFarm = v
    task.spawn(function()
        while _G.AutoFarm do
            RunService.Heartbeat:Wait()
            local char = Player.Character
            local stats = Player:FindFirstChild("CoreStats")
            if char and stats and char:FindFirstChild("HumanoidRootPart") then
                local field = game.Workspace.FlowerZones:FindFirstChild(_G.SelectedField)
                if (stats.Pollen.Value / stats.Capacity.Value) >= 0.95 then
                    SmartMove(Player.SpawnPos.Value.Position)
                    if (char.HumanoidRootPart.Position - Player.SpawnPos.Value.Position).Magnitude < 10 then
                        game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleMakeHoney")
                        repeat task.wait(0.5) until stats.Pollen.Value == 0 or not _G.AutoFarm
                    end
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
end)

CreateToggle(MiscTab, "Auto Clicker", function(v)
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

CreateToggle(MiscTab, "Fast Walkspeed", function(v)
    if Player.Character then
        Player.Character.Humanoid.WalkSpeed = v and 50 or 16
    end
end)

print("Jozex Hub: Custom Tabbed UI Loaded.")
