-- [[ JOZEX INSTANT STAT ENGINE - FIXED ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait for the character and stats folder to exist
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Stats = LocalPlayer:WaitForChild("CoreStats", 10) -- Safely waits up to 10 seconds

if not Stats then
    warn("JOZEX: CoreStats folder not found! Make sure you are in Bee Swarm Simulator.")
    return
end

-- Initialize starting values
local StartTime = tick()
local StartHoney = Stats:WaitForChild("Honey").Value
local StartPollen = Stats:WaitForChild("Pollen").Value

-- Number Formatting (k, M, B, T)
local function Format(n)
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

-- The Calculation Function
local function Recalculate()
    local Elapsed = tick() - StartTime
    if Elapsed < 1 then return end 

    local CurrentHoney = Stats.Honey.Value
    local CurrentPollen = Stats.Pollen.Value
    
    local GainedH = CurrentHoney - StartHoney
    local GainedP = CurrentPollen - StartPollen
    
    -- Formula: (Gained / Seconds) * 3600
    local HPH = (GainedH / Elapsed) * 3600
    local PPH = (GainedP / Elapsed) * 3600

    print("-------------------------------")
    print("INSTANT UPDATE:")
    print("Honey/HR:  " .. Format(HPH))
    print("Pollen/HR: " .. Format(PPH))
    print("Session:   " .. Format(GainedH) .. " Honey")
end

-- Connect to changes so it updates the moment stats move
Stats.Honey.Changed:Connect(Recalculate)
Stats.Pollen.Changed:Connect(Recalculate)

print("--- JOZEX TRACKER: ACTIVE & WAITING FOR CHANGES ---")
