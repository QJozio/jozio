-- [[ JOZEX HUB: FISCH FULL AUTO + AUTO-SELL ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- CONFIG
getgenv().AutoFarm = true
getgenv().AutoSell = true

-- // 1. AUTO CAST //
local function getRod()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
end

task.spawn(function()
    while getgenv().AutoFarm do
        task.wait(1.5)
        local rod = getRod()
        if rod and not LocalPlayer.Character:FindFirstChild("FishingLine") then
            rod:Activate()
        end
    end
end)

-- // 2. AUTO SHAKE //
task.spawn(function()
    while getgenv().AutoFarm do
        task.wait(0.01)
        local shakeUI = PlayerGui:FindFirstChild("shakeui", true)
        if shakeUI and shakeUI.Enabled then
            local button = shakeUI:FindFirstChild("safezone", true):FindFirstChild("button", true)
            if button and button.Visible then
                VirtualInputManager:SendMouseButtonEvent(
                    button.AbsolutePosition.X + (button.AbsoluteSize.X / 2),
                    button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2),
                    0, true, game, 1
                )
                VirtualInputManager:SendMouseButtonEvent(
                    button.AbsolutePosition.X + (button.AbsoluteSize.X / 2),
                    button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2),
                    0, false, game, 1
                )
            end
        end
    end
end)

-- // 3. AUTO REEL (INSTANT CATCH) //
task.spawn(function()
    while getgenv().AutoFarm do
        task.wait(0.01)
        local reelUI = PlayerGui:FindFirstChild("reelui", true)
        if reelUI and reelUI.Enabled then
            -- Firing the reelfinished event for instant catch
            local reelEvent = ReplicatedStorage:FindFirstChild("events"):FindFirstChild("reelfinished")
            if reelEvent then
                reelEvent:FireServer(100, true)
            end
        end
    end
end)

-- // 4. AUTO SELL //
-- This checks your backpack capacity and sells when full.
task.spawn(function()
    while getgenv().AutoSell do
        task.wait(2)
        local backpack = LocalPlayer.PlayerGui:FindFirstChild("hud"):FindFirstChild("safezone"):FindFirstChild("backpack")
        if backpack then
            local text = backpack.Amount.Text -- Example: "10/10"
            local current, max = text:match("(%d+)/(%d+)")
            
            if current == max then
                print("🎒 Bag Full! Selling...")
                -- Remote for selling to Merchant
                local sellEvent = ReplicatedStorage:FindFirstChild("events"):FindFirstChild("sellall")
                if sellEvent then
                    sellEvent:FireServer()
                end
            end
        end
    end
end)
