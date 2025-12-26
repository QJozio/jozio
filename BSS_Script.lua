-- [[ JOZEX HUB | STABLE SAFE-LOAD BUILD ]] --
repeat task.wait() until game:IsLoaded()

local CorrectKey = "Jozex-on-top"
local KeyLink = "Https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. STABLE DRAGGABLE AUTH UI
local LoginScreen = Instance.new("ScreenGui", game.CoreGui)
LoginScreen.Name = "Jozex_SafeAuth"

local Main = Instance.new("Frame", LoginScreen)
Main.Size, Main.Position = UDim2.new(0, 300, 0, 220), UDim2.new(0.5, -150, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true 
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "JOZEX HUB | LOGIN"
Title.TextColor3, Title.BackgroundTransparency = Color3.new(1,1,1), 1
Title.Font = Enum.Font.GothamBold

local KeyBox = Instance.new("TextBox", Main)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 35), UDim2.new(0.1, 0, 0.35, 0)
KeyBox.PlaceholderText = "Paste Key Here..."
KeyBox.Text = ""
KeyBox.BackgroundColor3, KeyBox.TextColor3 = Color3.fromRGB(30, 30, 30), Color3.new(1,1,1)
Instance.new("UICorner", KeyBox)

local LoginBtn = Instance.new("TextButton", Main)
LoginBtn.Size, LoginBtn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.58, 0)
LoginBtn.Text, LoginBtn.BackgroundColor3 = "LOGIN", Color3.fromRGB(0, 120, 215)
LoginBtn.TextColor3, LoginBtn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
Instance.new("UICorner", LoginBtn)

local GetKeyBtn = Instance.new("TextButton", Main)
GetKeyBtn.Size, GetKeyBtn.Position = UDim2.new(0.8, 0, 0, 30), UDim2.new(0.1, 0, 0.8, 0)
GetKeyBtn.Text, GetKeyBtn.BackgroundColor3 = "GET KEY LINK", Color3.fromRGB(45, 45, 45)
GetKeyBtn.TextColor3, GetKeyBtn.Font = Color3.new(0.8, 0.8, 0.8), Enum.Font.Gotham
Instance.new("UICorner", GetKeyBtn)

-- 2. MAIN ENGINE LAUNCHER
function LaunchJozex()
    -- Load Rayfield with Error Handling
    local success, Rayfield = pcall(function()
        return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    end)
    
    if not success or not Rayfield then 
        warn("Jozex Hub: Failed to load Rayfield Library. Check Internet Connection.")
        return 
    end

    local JozexOverlay = Instance.new("ScreenGui", game.CoreGui)
    
    -- DRAGGABLE CLICKER WIDGET
    local ClickerFrame = Instance.new("Frame", JozexOverlay)
    ClickerFrame.Size, ClickerFrame.Position = UDim2.new(0, 140, 0, 80), UDim2.new(0.1, 0, 0.2, 0)
    ClickerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ClickerFrame.Active, ClickerFrame.Draggable, ClickerFrame.Visible = true, true, false
    Instance.new("UICorner", ClickerFrame)

    local ClickBtn = Instance.new("TextButton", ClickerFrame)
    ClickBtn.Size, ClickBtn.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0.3, 0)
    ClickBtn.Text, ClickBtn.BackgroundColor3 = "CLICKER: OFF", Color3.fromRGB(200, 50, 50)
    ClickBtn.TextColor3, ClickBtn.Font = Color3.new(1,1,1), Enum.Font.GothamBold
    Instance.new("UICorner", ClickBtn)

    local Window = Rayfield:CreateWindow({
        Name = "Jozex Hub | BSS",
        LoadingTitle = "Omni-Nav Systems Online",
        ConfigurationSaving = {Enabled = false}
    })

    local Player = game.Players.LocalPlayer
    local PathfindingService = game:GetService("PathfindingService")
    local RunService = game:GetService("RunService")
    _G.AutoFarm, _G.WS_Value, _G.InternalClicker
    
