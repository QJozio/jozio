-- [[ JOZEX HUB | AIMBOT ASSISTANT + FOV ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JOZEX HUB | BETA",
   LoadingTitle = "Aimbot Assistant",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = {Enabled = true, FolderName = "JozexConfigs", FileName = "Universal"}
})

-- [[ SETTINGS & VISUALS ]] --
local Settings = {
    Aimbot = false,
    TeamCheck = true,
    Smoothing = 0.5,
    FOV = 150,
    WalkSpeed = 16,
    JumpPower = 50,
    FOVVisible = true
}

-- Create the Drawing Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Filled = false

-- Movement Loop
task.spawn(function()
    while task.wait() do
        pcall(function()
            local Hum = game.Players.LocalPlayer.Character.Humanoid
            Hum.WalkSpeed = Settings.WalkSpeed
            Hum.UseJumpPower = true
            Hum.JumpPower = Settings.JumpPower
        end)
    end
end)

-- Aimbot Target Logic
local function GetTarget()
    local target = nil
    local dist = Settings.FOV
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if Settings.TeamCheck and v.Team == game.Players.LocalPlayer.Team then continue end
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                if mag < dist then target = v; dist = mag end
            end
        end
    end
    return target
end

-- Update Loop (FOV Position & Aimbot)
game:GetService("RunService").RenderStepped:Connect(function()
    -- Update Circle Visuals
    FOVCircle.Visible = Settings.FOVVisible
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Position = game:GetService("UserInputService"):GetMouseLocation()

    -- Aimbot Execution
    if Settings.Aimbot and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetTarget()
        if t then
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, t.Character.Head.Position), Settings.Smoothing)
        end
    end
end)

-- [[ UI TAB: AIMBOT ASSISTANT ]] --
local MainTab = Window:CreateTab("Aimbot Assistant", 4483362458)

MainTab:CreateSection("Combat Controls")
MainTab:CreateToggle({
   Name = "Master Aimbot",
   CurrentValue = false,
   Callback = function(v) Settings.Aimbot = v end,
})
MainTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = true,
   Callback = function(v) Settings.FOVVisible = v end,
})
MainTab:CreateSlider({
   Name = "FOV Size",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) Settings.FOV = v end,
})
MainTab:CreateSlider({
   Name = "Smoothness",
   Range = {0.1, 1},
   Increment = 0.1,
   CurrentValue = 0.5,
   Callback = function(v) Settings.Smoothing = v end,
})

MainTab:CreateSection("Movement Controls")
MainTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) Settings.WalkSpeed = v end,
})

Rayfield:Notify({Title = "Success!", Content = "Aimbot Assistant Loaded", Duration = 5})
