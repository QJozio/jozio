-- [[ JOZEX INSTANT STAT ENGINE ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Initialize
local StartTime = tick() -- High precision timer
local Stats = LocalPlayer:WaitForChild("CoreStats")
local StartHoney = Stats.Honey.Value
local StartPollen = Stats.Pollen.Value

-- Number Formatting (k, M, B, T)
local function Format(n)
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

-- Calculation Function
local function Recalculate()
    local Elapsed = tick() - StartTime
    if Elapsed < 1 then return end -- Prevent division by zero at start

    local GainedH = Stats.Honey.Value - StartHoney
    local GainedP = Stats.Pollen.Value - StartPollen
    
    local HPH = (GainedH / Elapsed) * 3600
    local PPH = (GainedP / Elapsed) * 3600

    -- Instant Output to Console
    print(string.format("[UPDATE] Session: %s Honey | Rate: %s/HR", Format(GainedH), Format(HPH)))
end

-- [[ INSTANT TRIGGERS ]] --
-- This fires the second your Honey or Pollen changes in the game folder
Stats.Honey.Changed:Connect(Recalculate)
Stats.Pollen.Changed:Connect(Recalculate)

print("--- INSTANT TRACKER LOADED: STATS WILL LOG ON CHANGE ---")
