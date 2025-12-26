-- [[ JOZEX CUSTOM CAMERA LOCK - DRAGGABLE & RAINBOW ]] --

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local Locked = false
local Target = nil

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- Border Frame (The Draggable Rainbow Frame)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 48)
MainFrame.Position = UDim2.new(0.5, -80, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
MainFrame.BorderSizePixel = 0
local BorderCorner = Instance.new("UICorner", MainFrame)
BorderCorner.CornerRadius = UDim.new(0, 12)

-- Inner Button
local Button = Instance.new("TextButton", MainFrame)
Button.Size = UDim2.new(1, -6, 1, -6)
Button.Position = UDim2.new(0, 3, 0, 3)
Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Button.Text = "CAMERA LOCK: OFF"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 12
Button.BorderSizePixel = 0
local ButtonCorner = Instance.new("UICorner", Button)
ButtonCorner.Corner
