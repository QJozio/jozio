-- RAYFIELD LOAD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Fisch Auto Farm",
    LoadingTitle = "Fisch",
    LoadingSubtitle = "Auto Fish",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local Tab = Window:CreateTab("Auto Farm", 4483362458)

getgenv().AutoFish = false

Tab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoFish = Value
        print("🎣 AutoFish:", Value)
    end
})

-- MAIN LOOP
task.spawn(function()
    while true do
        task.wait(0.2)

        if getgenv().AutoFish then
            -- CAST
            mouse1click()
            task.wait(3.5) -- wait for bite

            -- REEL
            mouse1click()
            task.wait(1.5)
        end
    end
end)

print("✅ Rayfield Fisch Auto Farm Loaded")