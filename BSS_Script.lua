local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Jozex Hub | Fisch Edition",
   LoadingTitle = "Jozex Hub",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = { Enabled = false },
   Theme = "Default" -- We will customize colors via the Teal style
})

-- [[ VARIABLES ]] --
getgenv().AutoFarm = false
getgenv().AutoSell = false
local FishCaught = 0

-- [[ TABS ]] --
local MainTab = Window:CreateTab("AutoFarm", 4483362458)
local StatsTab = Window:CreateTab("Stats", 4483362458)

-- [[ AUTOFARM TAB ]] --
MainTab:CreateSection("Fishing Controls")

MainTab:CreateToggle({
   Name = "Full Auto Fish",
   CurrentValue = false,
   Flag = "AutoFish",
   Callback = function(Value)
      getgenv().AutoFarm = Value
      if Value then
          Rayfield:Notify({Title = "Jozex Hub", Content = "Auto-Fishing Started!", Duration = 2})
      end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Sell (When Full)",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(Value)
      getgenv().AutoSell = Value
   end,
})

MainTab:CreateSection("Settings")
MainTab:CreateSlider({
   Name = "Cast Strength",
   Min = 50,
   Max = 100,
   Default = 100,
   Color = Color3.fromRGB(0, 128, 128),
   Callback = function(Value)
      getgenv().CastStrength = Value
   end,
})

-- [[ STATS TAB ]] --
StatsTab:CreateSection("Session Info")
local FishLabel = StatsTab:CreateLabel("Fish Caught: 0")

-- [[ LOGIC: AUTO-FISHING ]] --
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().AutoFarm then
            local char = game.Players.LocalPlayer.Character
            local rod = char and char:FindFirstChildOfClass("Tool")
            
            -- 1. Auto Cast
            if rod and not char:FindFirstChild("FishingLine") then
                task.wait(1)
                rod:Activate()
            end
            
            -- 2. Auto Shake
            local shakeUI = PlayerGui:FindFirstChild("shakeui", true)
            if shakeUI and shakeUI.Enabled then
                local button = shakeUI:FindFirstChild("safezone", true):FindFirstChild("button", true)
                if button and button.Visible then
                    VirtualInputManager:SendMouseButtonEvent(
                        button.AbsolutePosition.X + (button.AbsoluteSize.X/2),
                        button.AbsolutePosition.Y + (button.AbsoluteSize.Y/2),
                        0, true, game, 1
                    )
                    VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X, button.AbsolutePosition.Y, 0, false, game, 1)
                end
            end
            
            -- 3. Auto Reel (Instant)
            local reelUI = PlayerGui:FindFirstChild("reelui", true)
            if reelUI and reelUI.Enabled then
                local reelEvent = ReplicatedStorage:FindFirstChild("events"):FindFirstChild("reelfinished")
                if reelEvent then
                    reelEvent:FireServer(100, true)
                    FishCaught = FishCaught + 1
                    FishLabel:Set("Fish Caught: " .. FishCaught)
                end
            end
        end
    end
end)

-- [[ LOGIC: AUTO SELL ]] --
task.spawn(function()
    while task.wait(5) do
        if getgenv().AutoSell then
            local hud = PlayerGui:FindFirstChild("hud")
            local backpack = hud and hud:FindFirstChild("safezone", true):FindFirstChild("backpack", true)
            if backpack then
                local text = backpack.Amount.Text
                local current, max = text:match("(%d+)/(%d+)")
                if current == max then
                    local sellEvent = ReplicatedStorage:FindFirstChild("events"):FindFirstChild("sellall")
                    if sellEvent then sellEvent:FireServer() end
                end
            end
        end
    end
end)
