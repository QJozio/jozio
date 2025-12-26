-- [[ JOZEX HUB | BETA BUILD ]] --
repeat task.wait() until game:IsLoaded()

local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")

-- Cleanup
if CoreGui:FindFirstChild("JozexBeta") then CoreGui.JozexBeta:Destroy() end

-- Settings
_G.AutoFarm = false
_G.AutoClick = false
_G.Field = "Clover Field"

-- 1. ROOT UI
local Jozex = Instance.new("ScreenGui", CoreGui)
Jozex.Name = "JozexBeta"

-- 2. MINI-WINDOW (Floating Button)
local Mini = Instance.new("TextButton", Jozex)
Mini.Name = "MiniWindow"
Mini.Size = UDim2.new(0, 60, 0, 60)
Mini.Position = UDim2.new(0.1, 0, 0.1, 0)
Mini.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Mini.Text = "BETA"
Mini.TextColor3 = Color3.new(1,1,1)
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.Draggable = true
Instance.new("UICorner", Mini)
local MiniStroke = Instance.new("UIStroke", Mini)
MiniStroke.Color = Color3.new(1,1,1)
MiniStroke.Thickness = 2

-- 3. MAIN HUB
local Main = Instance.new("Frame", Jozex)
Main.Name = "Main"
Main.Size = UDim2.new(0, 420, 0, 300)
Main.Position = UDim2.new(0.5, -210, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true 
Instance.new("UICorner", Main)
local Glow = Instance.new("UIStroke", Main)
Glow.Color = Color3.fromRGB(0, 150, 255)
Glow.Thickness = 2

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JOZEX HUB | BETA"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1,
    
