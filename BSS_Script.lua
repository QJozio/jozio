-- [[ JOZEX UNIVERSAL FIX ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 1. CREATE VISUAL DEBUGGER (So you know it's working)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 100)
Main.Position = UDim2.new(0, 10, 0, 10) -- Top Left
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red initially (Not Ready)

local Label = Instance.new("TextLabel", Main)
Label.Size = UDim2.new(1, -10, 1, -10)
Label.Position = UDim2.new(0, 5, 0, 5)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.new(1, 1, 1)
Label.TextWrapped = true
Label.Font = Enum.Font.Code
Label.TextSize = 14
Label.Text = "STATUS: Initializing..."

-- 2. WAIT FOR GAME LOAD
if not game:IsLoaded() then
    Label.Text = "STATUS: Waiting for Game Load..."
    game.Loaded:Wait()
end

-- 3. ROBUST STAT FINDER
Label.Text = "STATUS: Searching for Stats..."
local StatsFolder = nil
local HoneyVal = nil
local PollenVal = nil

-- Try loop to find stats (Max 30 seconds)
for i = 1, 30 do
    StatsFolder = LocalPlayer:FindFirstChild("CoreStats") or LocalPlayer:FindFirstChild("leaderstats")
    
    if StatsFolder then
        HoneyVal = StatsFolder:FindFirstChild("Honey")
        PollenVal = StatsFolder:FindFirstChild("Pollen")
        
        if HoneyVal and PollenVal then
            break -- Found everything!
        end
    end
    
    Label.Text = "STATUS: Searching... (" .. i .. ")"
    task.wait(1)
end

if not HoneyVal then
    Label.Text = "ERROR: Could not find 'Honey'. Check F9 Console."
    Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
    warn("DEBUG: Found Folder:", StatsFolder)
    return -- Stop script safely
end

-- 4. SUCCESS - START TRACKING
Main.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Green (Ready)
Label.Text = "TRACKER ACTIVE"

local StartTime = tick()
local StartHoney = HoneyVal.Value
local StartPollen = PollenVal.Value

local function Format(n)
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

local function Update()
    local Elapsed = tick() - StartTime
    if Elapsed < 1 then return end

    local GainedH = HoneyVal.Value - StartHoney
    local GainedP = PollenVal.Value - StartPollen
    
    local HPH = (GainedH / Elapsed) * 3600
    local PPH = (GainedP / Elapsed) * 3600
    
    Label.Text = string.format(
        "TIME: %ds\n\nHONEY: %s (%s/HR)\nPOLLEN: %s (%s/HR)",
        math.floor(Elapsed),
        Format(GainedH), Format(HPH),
        Format(GainedP), Format(PPH)
    )
end

-- 5. CONNECT INSTANT EVENTS
HoneyVal.Changed:Connect(Update)
PollenVal.Changed:Connect(Update)
Update() -- Run once immediately
