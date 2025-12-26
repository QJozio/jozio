-- [[ JOZEX HUB | BETA SAFE-LOAD ]] --
local success, err = pcall(function()
    repeat task.wait() until game:IsLoaded()

    local CoreGui = game:GetService("CoreGui")
    local Player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local PathfindingService = game:GetService("PathfindingService")
    local UserInputService = game:GetService("UserInputService")

    if CoreGui:FindFirstChild("JozexBeta") then CoreGui.JozexBeta:Destroy() end

    _G.AutoFarm = false
    _G.AutoClick = false
    _G.Field = "Clover Field"

    -- 1. UI ROOT
    local Jozex = Instance.new("ScreenGui")
    Jozex.Name = "JozexBeta"
    Jozex.Parent = CoreGui
    Jozex.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [[ SMOOTH DRAG FUNCTION ]] --
    local function MakeDraggable(frame, handle)
        local dragging, dragInput, dragStart, startPos
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- 2. MINI-WINDOW
    local Mini = Instance.new("TextButton", Jozex)
    Mini.Size = UDim2.new(0, 60, 0, 60)
    Mini.Position = UDim2.new(0.1, 0, 0.1, 0)
    Mini.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Mini.Text = "BETA"
    Mini.TextColor3 = Color3.new(1,1,1)
    Mini.Font = Enum.Font.GothamBold
    Mini.Visible = false
    Instance.new("UICorner", Mini)
    MakeDraggable(Mini, Mini)

    -- 3. MAIN HUB
    local Main = Instance.new("Frame", Jozex)
    Main.Size = UDim2.new(0, 420, 0, 300)
    Main.Position = UDim2.new(0.5, -210, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main)
    local Glow = Instance.new("UIStroke", Main)
    Glow.Color = Color3.fromRGB(0, 150, 255)
    Glow.Thickness = 2

    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundTransparency = 1
    MakeDraggable(Main, Header) -- Drag by holding the top bar

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "JOZEX HUB | BETA"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -40, 0.5, -15)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MinBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", MinBtn)

    MinBtn.MouseButton1Click:Connect(function() Main.Visible = false; Mini.Visible = true end)
    Mini.MouseButton1Click:Connect(function() Main.Visible = true; Mini.Visible = false end)

    -- 4. TABS
    local SideBar = Instance.new("Frame", Main)
    SideBar.Size = UDim2.new(0, 100, 1, -60)
    SideBar.Position = UDim2.new(0, 10, 0, 50)
    SideBar.BackgroundTransparency = 1

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -130, 1, -60)
    Container.Position = UDim2.new(0, 120, 0, 50)
    Container.BackgroundTransparency = 1

    local Tabs = {}
    local function CreateTab(name, active)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = active
        Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local Btn = Instance.new("TextButton", SideBar)
        Btn.Size = UDim2.new(1, 0, 0, 40)
        Btn.Text = name
        Btn.BackgroundColor3 = active and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(25, 25, 25)
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", Btn)

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.P.Visible = false; t.B.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end
            Page.Visible = true
            Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        end)
        table.insert(Tabs, {P = Page, B = Btn})
        return Page
    end

    local FarmPage = CreateTab("FARMING", true)
    local MiscPage = CreateTab("MISC", false)

    -- 5. ENGINE LOGIC
    local function SmartMove(targetPos)
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        char.Humanoid:MoveTo(targetPos)
    end

    local function AddToggle(parent, text, callback)
        local t = Instance.new("TextButton", parent)
        t.Size = UDim2.new(0.95, 0, 0, 40)
        t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        t.Text = text .. " : OFF"
        t.TextColor3 = Color3.new(1,1,1)
        t.Font = Enum.Font.GothamBold
        Instance.new("UICorner", t)
        local s = false
        t.MouseButton1Click:Connect(function()
            s = not s
            t.Text = text .. (s and " : ON" or " : OFF")
            t.BackgroundColor3 = s and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(30, 30, 30)
            callback(s)
        end)
    end

    local FieldInput = Instance.new("TextBox", FarmPage)
    FieldInput.Size = UDim2.new(0.95, 0, 0, 40)
    FieldInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    FieldInput.Text = "Clover Field"
    FieldInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", FieldInput)
    FieldInput.FocusLost:Connect(function() _G.Field = FieldInput.Text end)

    AddToggle(FarmPage, "Omni-Auto Farm", function(v)
        _G.AutoFarm = v
        task.spawn(function()
            while _G.AutoFarm do
                RunService.Heartbeat:Wait()
                local stats = Player:FindFirstChild("CoreStats")
                local char = Player.Character
                if char and stats and char:FindFirstChild("HumanoidRootPart") then
                    local field = game.Workspace.FlowerZones:FindFirstChild(_G.Field)
                    if (stats.Pollen.Value / stats.Capacity.Value) >= 0.9 then
                        SmartMove(Player.SpawnPos.Value.Position)
                    elseif field then
                        local nt = nil; local ld = math.huge
                        for _, t in pairs(game.Workspace.Collectibles:GetChildren()) do
                            if (t.Position - field.Position).Magnitude < 65 then
                                local d = (t.Position - char.HumanoidRootPart.Position).Magnitude
                                if d < ld then nt = t; ld = d end
                            end
                        end
                        SmartMove(nt and nt.Position or field.Position)
                    end
                end
            end
        end)
    end)

    AddToggle(MiscPage, "Auto Clicker", function(v)
        _G.AutoClick = v
        task.spawn(function()
            while _G.AutoClick do
                task.wait(0.05)
                local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end)
    end)

    print("Jozex Hub: BETA Loaded.")
end)

if not success then warn("Jozex Load Error: " .. err) end
