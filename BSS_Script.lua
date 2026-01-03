-- [[ JOZEX HUB: SAFE DESYNC ]] --
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

getgenv().DesyncEnabled = true

-- Optimized Loop
task.spawn(function()
    while getgenv().DesyncEnabled do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Store original velocity
            local oldVelocity = hrp.AssemblyLinearVelocity
            
            -- Apply a "Fake" velocity to desync the client-server position
            -- We use math.sin to make it move slightly so it's harder for anti-cheats to flag
            hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * (math.sin(tick() * 10) * 15)
            
            -- Wait for a frame render
            RunService.RenderStepped:Wait()
            
            -- Restore velocity so you don't actually fly away on your screen
            hrp.AssemblyLinearVelocity = oldVelocity
        else
            task.wait(1)
        end
    end
end)

print("🛡️ Jozex Desync: Active. You are now oscillating on the server's view.")
