-- [[ JOZEX HUB | AIMBOT ASSISTANT 2025 ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JOZEX HUB | BETA",
   LoadingTitle = "Aimbot Assistant",
   LoadingSubtitle = "by QJozio",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "JozexConfigs",
      FileName = "Universal"
   },
   KeySystem = false
})

-- [[ SETTINGS & VARIABLES ]] --
local Settings = {
    Aimbot = false,
    TeamCheck = true,
    Smoothing = 0.5,
    FOV = 150,
    WalkSpeed = 16,
    JumpPower = 50
}

-- Movement Loop (WalkSpeed & JumpPower)
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

-- Aimbot Logic
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

game:GetService("RunService").RenderStepped:Connect(function()
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
   Name = "Team Check",
   CurrentValue = true,
   Callback = function(v) Settings.TeamCheck = v end,
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
MainTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) Settings.JumpPower = v end,
})

-- SUCCESS NOTIFICATION
Rayfield:Notify({
   Title = "Success!",
   Content = "Jozex Hub has loaded all features.",
   Duration = 5
})
