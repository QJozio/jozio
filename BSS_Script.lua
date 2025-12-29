-- [[ JOZEX BSS ULTIMATE TRACKER ]] --

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ INITIAL DATA ]] --
local StartTime = os.time()
local Stats = LocalPlayer.CoreStats
local StartHoney = Stats.Honey.Value
local StartPollen = Stats.Pollen.Value

local Locked = false
local Target = nil

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- Main Draggable Container
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 160)
MainFrame.Position = UDim2.new(0.5, -90, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", MainFrame)

-- Rainbow Border for the Camera Lock Button
local RGBBorder = Instance.new("Frame", MainFrame)
RGBBorder.Size = UDim2.new(1, -10, 0, 40)
RGBBorder.Position = UDim2.new(0, 5, 0, 5)
RGBBorder.BackgroundColor3 = Color3.new(1, 1, 1)
local BCorn = Instance.new("UICorner", RGBBorder)

local LockBtn = Instance.new("TextButton", RGBBorder)
LockBtn.Size = UDim2.new(1, -4, 1, -4)
LockBtn.Position = UDim2.new(0, 2, 0, 2)
LockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LockBtn.Text = "CAMERA LOCK: OFF"
LockBtn.TextColor3 = Color3.new(1, 1, 1)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 11
local Lcorn = Instance.new("UICorner", LockBtn)

-- Stats Section
local function CreateStatLabel(pos, color)
    local lbl = Instance.new("TextLabel", MainFrame)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local hSessionLbl = CreateStatLabel(UDim2.new(0, 10, 0, 55), Color3.fromRGB(255, 200, 0))
local hRateLbl = CreateStatLabel(UDim2.new(0, 10, 0, 75), Color3.fromRGB(200, 160, 0))
local pSessionLbl = CreateStatLabel(UDim2.new(0, 10, 0, 105), Color3.fromRGB(255, 255, 255))
local pRateLbl = CreateStatLabel(UDim2.new(0, 10, 0, 125), Color3.fromRGB(200, 200, 200))

-- [[ LOGIC & UTILITY ]] --

-- Rainbow Animation
task.spawn(function()
    local h = 0
    while task.wait() do h = h + 0.005; RGBBorder.BackgroundColor3 = Color3.fromHSV(h, 1, 1) end
end)

-- Formatting (1M, 1B, 1T)
local function Format(n)
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Calculation Loop
task.spawn(function()
    while task.wait(2) do
        local elapsed = os.time() - StartTime
        local gHoney = Stats.Honey.Value - StartHoney
        local gPollen = Stats.Pollen.Value - StartPollen
        
        hSessionLbl.Text = "HONEY: " .. Format(gHoney)
        hRateLbl.Text = "H/HR:  " .. Format((gHoney / elapsed) * 3600)
        
        pSessionLbl.Text = "POLLEN: " .. Format(gPollen)
        pRateLbl.Text = "P/HR:  " .. Format((gPollen / elapsed) * 3600)
    end
end --- Aimbot Logic omitted here for brevity, keep your existing RenderStepped lock logic below
)
