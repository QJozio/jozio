-- [[ JOZEX HUB | CUSTOM UI + MINI-WINDOW ]] --
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

if CoreGui:FindFirstChild("JozexCustom") then CoreGui.JozexCustom:Destroy() end

_G.AutoFarm = false
_G.AutoClick = false
_G.Field = "Clover Field"

-- 1. MAIN UI SETUP
local Jozex = Instance.new("ScreenGui", CoreGui)
Jozex.Name = "JozexCustom"

local Main = Instance.new("Frame", Jozex)
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 280)
Main.Position = UDim2.new(0.5, -200, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true 
local Corner = Instance.new("UICorner", Main)
local Glow = Instance.new("UIStroke", Main)
Glow.Color = Color3.fromRGB(0, 120, 215)
Glow.Thickness = 2

-- 2. MINI-WINDOW TOGGLE
local Mini = Instance.new("TextButton", Jozex)
Mini.Name = "MiniWindow"
Mini.Size = UDim2.new(0, 50, 0, 50)
Mini.Position = UDim2.new(0.5, -25, 0.1, 0)
Mini.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Mini.Text = "JOZEX"
Mini.TextColor3 = Color3.new(1,1,1)
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.Draggable = true
Instance.new("UICorner", Mini)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinBtn)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

-- 3. SIDEBAR & CONTENT
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0, 100, 1, -50)
TabBar.Position = UDim2.new(0, 5, 0, 45)
TabBar.BackgroundTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -120, 1, -55)
Content.Position = UDim2.new(0, 110, 0, 45)
Content.BackgroundTransparency = 1

local function CreateTab(name, active)
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = active
    Page.ScrollBarThickness = 0
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 5)

    local TabBtn = Instance.new("TextButton", TabBar)
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundColor3 = active and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(30, 30, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do v.Visible = false end
        for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end end
        Page.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end)
    return Page
end

local FarmPage = CreateTab("Farming", true)
local MiscPage = CreateTab("Misc", false)

-- 4. SMART NAVIGATION & DETECTION
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

-- 5. FEATURES
local function AddToggle(parent, text, callback)
    local t = Instance.new("TextButton", parent)
    t.Size = UDim2.new(1, 0, 0, 35)
    t.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    t.Text = text .. " [OFF]"
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.Gotham
    Instance.new("UICorner", t)
    local state = false
    t.MouseButton1Click:Connect(function()
        state = not state
        t.Text = text .. (state and " [ON]" or " [OFF]")
        t.BackgroundColor3 = state and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(35, 35, 35)
        callback(state)
    end)
end

-- Farming UI
local FieldInp = Instance.new("TextBox", FarmPage)
FieldInp.Size = UDim2.new(1, 0, 0, 35)
FieldInp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FieldInp.PlaceholderText = "Enter Field..."
FieldInp
