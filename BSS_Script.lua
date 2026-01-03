local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Jozex Hub | 2026",
   LoadingTitle = "Jozex Hub Loading...",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = { Enabled = false },
   Theme = "Default"
})

-- [[ GLOBAL VARIABLES ]] --
getgenv().DesyncEnabled = false
local LocalPlayer = game.Players.LocalPlayer

-- [[ TABS ]] --
local MainTab = Window:CreateTab("Main", 4483362458)

-- [[ DESYNC LOGIC ]] --
-- This runs in the background and waits for the toggle
task.spawn(function()
    while true do
        if getgenv().DesyncEnabled then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- This creates the "Ghost" effect by flicking velocity
                local oldV = hrp.AssemblyLinearVelocity
                hrp.AssemblyLinearVelocity = Vector3.new(0, 500, 0) -- Flick up
                game:GetService("RunService").RenderStepped:Wait()
                hrp.AssemblyLinearVelocity = oldV
            end
        end
        task.wait() -- Prevents crashing
    end
end)

-- [[ UI ELEMENTS ]] --
MainTab:CreateSection("Exploits")

MainTab:CreateToggle({
   Name = "Safe Desync",
   CurrentValue = false,
   Flag = "DesyncToggle", 
   Callback = function(Value)
      getgenv().DesyncEnabled = Value
      if Value then
          Rayfield:Notify({
              Title = "Jozex Hub",
              Content = "Desync is now ACTIVE",
              Duration = 2,
              Image = 4483362458,
          })
      else
          Rayfield:Notify({
              Title = "Jozex Hub",
              Content = "Desync is now DISABLED",
              Duration = 2,
              Image = 4483362458,
          })
      end
   end,
})

MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
       game:GetService("UserInputService").JumpRequest:Connect(function()
           LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
       end)
   end,
})

Rayfield:Notify({Title = "Loaded!", Content = "Jozex Hub is ready for use.", Duration = 3})