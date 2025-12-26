-- [[ JOZEX HUB | FINAL FIXED BUILD ]] --
local CorrectKey = "Jozex-on-top"
local KeyLink = "Https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. AUTHENTICATION UI (Login Screen)
local LoginScreen = Instance.new("ScreenGui", game.CoreGui)
LoginScreen.Name = "JozexLogin"
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

local GetKeyBtn = Instance.new("TextButton", Main)
GetKeyBtn.Size, GetKeyBtn.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.75, 0)
GetKeyBtn.Text, GetKeyBtn.BackgroundColor3 = "GET KEY", Color3.fromRGB(40, 40, 40)
GetKeyBtn.TextColor3, GetKeyBtn.Font = Color3.new(0.8, 0.8, 0.8), Enum.Font.GothamBold
Instance.new("UICorner", GetKeyBtn)

-- 2. THE MASTER ENGINE
function LaunchJozex()
    -- Create a NEW ScreenGui for the Overlay features (Auto Clicker)
    local JozexOverlay = Instance.new("ScreenGui", game.CoreGui)
    JozexOverlay.Name = "JozexOverlay"
    
    -- [ FLOATING CLICKER WIDGET ]
    local ClickerFrame = Instance.new("Frame", JozexOverlay)
    ClickerFrame.Size = UDim2.new(0, 160, 0, 90)
    ClickerFrame.Position = UDim2.new(0.1, 0, 0.2, 0) -- Top Left area
    ClickerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ClickerFrame.Active, ClickerFrame.Draggable = true, true
    ClickerFrame.Visible = false -- Hidden by default until enabled in Misc
    ClickerFrame.BorderSizePixel = 0
    Instance.new("UICorner", ClickerFrame)

    local ClickTitle = Instance.new("TextLabel", ClickerFrame)
    ClickTitle.Size, ClickTitle.Position = UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 0)
    ClickTitle.Text = "AUTO CLICKER"
    ClickTitle.Font = Enum.Font.GothamBold
    ClickTitle.TextColor3, ClickTitle.BackgroundTransparency = Color3.new(1,1,1), 1

    local ClickBtn = Instance.new("TextButton", ClickerFrame)
    ClickBtn.Size, ClickBtn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.4, 0)
    ClickBtn.Text, ClickBtn.BackgroundColor3 = "OFF", Color3.fromRGB(200, 50, 50)
    ClickBtn.TextColor3, ClickBtn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
    Instance.new("UICorner", ClickBtn)

    -- [ RAYFIELD UI ]
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
        Name = "Jozex Hub | BSS",
        LoadingTitle = "Engine Loaded",
        ConfigurationSaving = {Enabled = true, FolderName = "Jozex_BSS"}
    })

    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm = false
    _G.SelectedField = "Clover Field"
    _G.WS_Value = 16
    _G.InternalClicker = false

    -- CLICKER LOGIC
    ClickBtn.MouseButton1Click:Connect(function()
        _G.InternalClicker = not _G.InternalClicker
        ClickBtn.Text = _G.InternalClicker and "ON" or "OFF"
        ClickBtn.BackgroundColor3 = _G.InternalClicker and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    
    task.spawn(function()
        while true do 
            task.wait(0.1) -- Slower loop to prevent crashing, fast enough for tools
            if _G.InternalClicker and Player.Character then
                local tool = Player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end 
        end
    end)

    -- [ SMART RAYCAST MOVE ]
    local function SmartMove(targetPos)
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local origin = char.HumanoidRootPart.Position
        local direction = targetPos - origin
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {char, game.Workspace.Collectibles, game.Workspace.Monsters}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        
        -- Raycast to check for walls
        local hit = game.Workspace:Raycast(origin, direction.Unit * math.min(direction.Magnitude, 15), rayParams)

        if hit and hit.Instance.CanCollide then
            -- Wall detected! Pathfind AROUND it.
            local path = PathfindingService:CreatePath({
                AgentRadius = 4, AgentHeight = 5, AgentCanJump = true, AgentCanClimb = true, Costs = { Jump = 50 }
            })
            local success = pcall(function() path:ComputeAsync(origin, targetPos) end)
            if success and path.Status == Enum.PathStatus.Success then
                local waypoints = path:GetWaypoints()
                if waypoints[2] then
                    char
                    
