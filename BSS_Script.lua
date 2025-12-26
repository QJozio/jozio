-- [[ QJOZIO HUB: MASTER INTEGRATED ]] --
if not game:IsLoaded() then game.Loaded:Wait() end

local LP = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- 1. INTERNAL UI LIBRARY (Loads Instantly)
local QJozioLib = {}
function QJozioLib:CreateWindow(Name)
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 400, 0, 250)
    Main.Position = UDim2.new(0.5, -200, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Main)

    local TabSide = Instance.new("Frame", Main)
    TabSide.Size = UDim2.new(0, 100, 1, -10)
    TabSide.Position = UDim2.new(0, 5, 0, 5)
    TabSide.BackgroundTransparency = 0.9
    Instance.new("UIListLayout", TabSide).Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -115, 1, -10)
    Pages.Position = UDim2.new(0, 110, 0, 5)
    Pages.BackgroundTransparency = 1

    local Hub = {}
    function Hub:CreateTab(TabName)
        local P = Instance.new("ScrollingFrame", Pages)
        P.Size = UDim2.new(1, 0, 1, 0)
        P.Visible = false
        P.BackgroundTransparency = 1
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
            T.Size = UDim2.new(1, -5, 0, 35)
            T.Text = Txt .. ": OFF"
            T.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            T.TextColor3 = Color3.new(1, 1, 1)
            local s = false
            T.MouseButton1Click:Connect(function()
                s = not s
                T.Text = Txt .. (s and ": ON" or ": OFF")
                T.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(35, 35, 35)
                cb(s)
            end)
        end
        return Elm
    end
    return Hub
end

-- 2. ENGINE SETUP
local farmOn, tokensOn = false, true
local Fields = {
    ["Dandelion"] = Vector3.new(-30, 5, 225),
    ["Sunflower"] = Vector3.new(-210, 5, 185),
    ["Pine Tree"] = Vector3.new(-315, 70, -215)
}

-- 3. CREATE INTERFACE
local MyHub = QJozioLib:CreateWindow("QJozio Hub")
local Main = MyHub:CreateTab("Farm")
Main:AddToggle("Auto Farm & Honey", function(v) farmOn = v end)
Main:AddToggle("Collect Tokens", function(v) tokensOn = v end)

-- 4. THE LOOP (Walk & Token Logic)
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
