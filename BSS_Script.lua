-- CONFIG
local MONEY_STAT_NAME = "Coins" -- change if needed
local UPDATE_INTERVAL = 1 -- seconds

-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- WAIT FOR STATS
local leaderstats = player:WaitForChild("leaderstats")
local moneyStat = leaderstats:WaitForChild(MONEY_STAT_NAME)

-- VARIABLES
local startTime = os.clock()
local startingMoney = moneyStat.Value

print("💰 Money/hour tracker started")
print("Starting money:", startingMoney)

while true do
    task.wait(UPDATE_INTERVAL)

    local elapsedSeconds = os.clock() - startTime
    local elapsedHours = elapsedSeconds / 3600

    local currentMoney = moneyStat.Value
    local earned = currentMoney - startingMoney

    local perHour = 0
    if elapsedHours > 0 then
        perHour = math.floor(earned / elapsedHours)
    end

    print(
        "⏱ Time:",
        string.format("%.2f", elapsedHours), "hrs |",
        "➕ Earned:", earned, "|",
        "📈 Per Hour:", perHour
    )
end