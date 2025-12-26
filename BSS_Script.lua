-- [[ QJOZIO HUB: ULTRA-STABLE LOAD ]] --
print("QJozio Hub is attempting to load...")

repeat task.wait() until game:IsLoaded()
local LP = game.Players.LocalPlayer

-- 1. INTERNAL UI LIBRARY (Fixed for Mobile)
local QJozioLib = {}
function QJozioLib:CreateWindow(Name)
    local sg = Instance.new("ScreenGui", game.CoreGui)
    sg.Name = "QJozioGui"
    
    local Main = Instance.new("Frame", sg)
    Main.Size = UDim2.new(0, 380, 0, 220)
    Main.Position = UDim2.new(0.5, -190, 0.5, -110)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.Active = true
    Main.Draggable = true -- Simple drag for mobile
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
        
        -- Default visibility fix
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

-- 2. INITIALIZE
local MyHub = QJozioLib:CreateWindow("QJozio Hub")
local Farm = MyHub:CreateTab("Farm")
local farmOn = false

Farm:AddToggle("Auto Farm", function(v) farmOn = v end)

-- 3. SIMPLE LOOP
task.spawn(function()
    while task.wait(0.1) do
        if farmOn and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

print("QJozio Hub Loaded Successfully!")
