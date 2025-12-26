-- [[ QJOZIO HUB: FINAL INTEGRATED MASTER ]] --
repeat task.wait() until game:IsLoaded()
local LP = game.Players.LocalPlayer

-- Notification Function
local function Notify(text)
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", frame)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    game:GetService("Debris"):AddItem(sg, 3)
end

Notify("QJozio Hub Loading...")

-- 1. INTERNAL UI LIBRARY
local QJozioLib = {}
function QJozioLib:CreateWindow(Name)
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 380, 0, 220)
    Main.Position = UDim2.new(0.5, -190, 0.5, -110)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main)

    local TabSide = Instance.new("Frame", Main)
    TabSide.Size = UDim2.new(0, 90, 1, -10)
    TabSide.Position = UDim2.new(0, 5, 0, 5)
    TabSide.BackgroundTransparency = 0.8
    Instance.new("UIListLayout", TabSide).Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -105, 1, -10)
    Pages.Position = UDim2.new(0, 100, 0, 5)
    Pages.BackgroundTransparency = 1

    local Hub = {}
    function Hub:CreateTab(TabName)
        local P = Instance.new("ScrollingFrame", Pages)
        P.Size = UDim2.new(1, 0, 1, 0)
        P.Visible = false
        P.BackgroundTransparency = 1
        P.CanvasSize = UDim2.new(0, 0, 2, 0)
        P.ScrollBarThickness = 2
        Instance.new("UIListLayout", P).Padding = UDim.new(0, 5)

        local B = Instance.new("TextButton", TabSide)
        B.Size = UDim2.new(1, 0, 0, 30)
        B.Text = TabName
        B.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        B.TextColor3 = Color3.new(1, 1, 1)
        B.MouseButton1Click:Connect(function()
            for _, v in pairs(Pages:GetChildren()) do v.Visible = false end
            P.Visible = true
        end)
        
        if #TabSide:GetChildren() == 2 then P.Visible = true end

        local Elm = {}
        function Elm:AddToggle(Txt, cb)
            local T = Instance.new("TextButton", P)
            T.Size = UDim2.new(1, -10, 0, 35)
            T.Text = Txt .. ": OFF"
            T.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            T.TextColor3 = Color3.new(1, 1, 1)
            Instance.new("UICorner", T)
            local s = false
            T.MouseButton1Click:Connect(function()
                s = not s
                T.Text = Txt .. (s and ": ON" or ": OFF")
                T.BackgroundColor3 = s and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
                cb(s)
            end)
        end
        return Elm
    end
    return Hub
end

-- 2. DATA & ENGINE
local farmOn, tokensOn = false, true
local Fields = {
    ["Dandelion"] = Vector3.new(-30, 5, 225),
    ["Sunflower"] = Vector3.new(-210, 5, 185),
    ["Pine Tree"] = Vector3.new(-315, 70, -215)
}

-- 3. INITIALIZE
local MyHub = QJozioLib:CreateWindow("QJozio Hub")
local Farm = MyHub:CreateTab("Farm")
local Combat = MyHub:CreateTab("Combat")

Farm:AddToggle("Master Farm", function(v) farmOn = v end)
Farm:AddToggle("Collect Tokens", function(v) tokensOn = v end)
Combat:AddToggle("Auto-Kill Mobs", function(v) _G.KillMobs = v end)

-- 4. THE LOOP
task.spawn(function()
    local angle = 0
    while task.wait(0.05) do
        if farmOn and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            local hum = LP.Character.Humanoid
            local stats = LP:WaitForChild("CoreStats")
            
            if stats.Pollen.Value >= stats.Capacity.Value * 0.95 then
                hum:MoveTo(LP.SpawnPos.Value.Position)
            else
                local target = nil
                if tokensOn then
                    for _, v in pairs(workspace.Collectibles:GetChildren()) do
                        if (v.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 50 then target = v break end
                    end
                end
                
                if target then
                    hum:MoveTo(target.Position)
                else
                    angle = angle + 0.3
                    hum:MoveTo(Fields["Dandelion"] + Vector3.new(math.sin(angle)*30, 0, math.cos(angle)*30))
                end
                if LP.Character:FindFirstChildOfClass("Tool") then LP.Character:FindFirstChildOfClass("Tool"):Activate() end
            end
        end
    end
end)

Notify("QJozio Hub: SUCCESS!")
