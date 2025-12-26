-- [[ QJOZIO HUB: CUSTOM KEY UI + RAYFIELD EXPLOIT ]] --

local CorrectKey = "QJOZIO-ON-TOP"
local KeyLink = "https://direct-link.net/2552546/CxGwpvRqOVJH"

-- 1. CREATE CUSTOM KEY UI (Non-Rayfield)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local KeyInput = Instance.new("TextBox")
local SubmitBtn = Instance.new("TextButton")
local GetKeyBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "QJozioAuth"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- Allows user to move it

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "QJOZIO HUB AUTH"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

KeyInput.Parent = MainFrame
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham

SubmitBtn.Parent = MainFrame
SubmitBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35)
SubmitBtn.Text = "SUBMIT"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold

GetKeyBtn.Parent = MainFrame
GetKeyBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
GetKeyBtn.Size = UDim2.new(0.8, 0, 0, 30)
GetKeyBtn.Text = "GET KEY LINK"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Font = Enum.Font.Gotham

-- 2. LOGIC FOR CUSTOM UI
GetKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KeyLink)
    GetKeyBtn.Text = "LINK COPIED!"
    task.wait(2)
    GetKeyBtn.Text = "GET KEY LINK"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        SubmitBtn.Text = "SUCCESS!"
        task.wait(1)
        ScreenGui:Destroy() -- Completely remove the Key UI
        loadExploit() -- Run the real exploit
    else
        SubmitBtn.Text = "WRONG KEY!"
        task.wait(2)
        SubmitBtn.Text = "SUBMIT"
    end
end)

-- 3. THE REAL EXPLOIT (Rayfield)
function loadExploit()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Window = Rayfield:CreateWindow({
       Name = "QJozio Hub | THE TOTAL ATLAS",
       LoadingTitle = "Atlass Engine Online",
       LoadingSubtitle = "Authentication Verified",
       ConfigurationSaving = {Enabled = true, FolderName = "QJozioBSS"}
    })

    -- GLOBAL LOGIC
    local LP = game.Players.LocalPlayer
    local RS = game:GetService("ReplicatedStorage")
    local _G = {Farm = false, Magnet = false, Mobs = false}
    local selectedField = "Dandelion"
    local Fields = {
        ["Dandelion"] = Vector3.new(-30, 5, 225), ["Sunflower"] = Vector3.new(-210, 5, 185),
        ["Pine Tree"] = Vector3.new(-315, 70, -215), ["Mountain Top"] = Vector3.new(75, 176, -140)
    }

    local Tab = Window:CreateTab("Auto Farm", 4483362458)
    Tab:CreateToggle({Name = "Atlass Auto-Farm", CurrentValue = false, Callback = function(v) _G.Farm = v end})
    Tab:CreateToggle({Name = "Instant CFrame Magnet", CurrentValue = false, Callback = function(v) _G.Magnet = v end})
    Tab:CreateDropdown({Name = "Field", Options = {"Dandelion","Sunflower","Pine Tree","Mountain Top"}, CurrentOption = "Dandelion", Callback = function(v) selectedField = v end})

    -- THE ENGINE
    task.spawn(function()
        local angle = 0
        while task.wait(0.01) do
            if _G.Farm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local root = LP.Character.HumanoidRootPart
                if LP.CoreStats.Pollen.Value >= LP.CoreStats.Capacity.Value * 0.99 then
                    root.CFrame = LP.SpawnPos.Value * CFrame.new(0, 2, 0)
                    RS.Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
                else
                    if _G.Magnet then
                        for _, v in pairs(workspace.Collectibles:GetChildren()) do
                            if (v.Position - root.Position).Magnitude < 150 then
                                root.CFrame = CFrame.new(v.Position) break
                            end
                        end
                    end
                    angle = angle + 0.9
                    LP.Character.Humanoid:MoveTo(Fields[selectedField] + Vector3.new(math.sin(angle)*35, 0, math.cos(angle)*35))
                    if LP.Character:FindFirstChildOfClass("Tool") then LP.Character:FindFirstChildOfClass("Tool"):Activate() end
                end
            end
        end
    end)
end

