-- SIMPLE AUTO FISH (MACRO STYLE)
-- Toggle with F

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local enabled = false

-- TOGGLE KEY
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        enabled = not enabled
        print("🎣 Auto Fish:", enabled and "ON" or "OFF")
    end
end)

-- MAIN LOOP
task.spawn(function()
    while true do
        task.wait(1)

        if enabled then
            -- CAST
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.2)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

            -- WAIT FOR BITE
            task.wait(3) -- adjust if needed

            -- REEL
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.3)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)

            task.wait(1.5)
        end
    end
end)