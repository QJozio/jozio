-- FULL FEATURED AI CHAT GUI
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local API_KEY = "PUT_YOUR_API_KEY_HERE"

-- Conversation memory
local conversation = {
    {role = "system", content = "You are a helpful AI assistant."}
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 400)
Frame.Position = UDim2.new(0.5, -200, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

-- Make GUI draggable
Frame.Active = true
Frame.Draggable = true

-- Chat history TextLabel
local Output = Instance.new("TextLabel", Frame)
Output.Size = UDim2.new(1, -20, 1, -100)
Output.Position = UDim2.new(0, 10, 0, 10)
Output.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Output.TextColor3 = Color3.fromRGB(255, 255, 255)
Output.TextWrapped = true
Output.TextYAlignment = Enum.TextYAlignment.Top
Output.TextXAlignment = Enum.TextXAlignment.Left
Output.Text = "AI ready."
Output.Font = Enum.Font.SourceSans
Output.TextSize = 16
Output.RichText = true

-- Input box
local Input = Instance.new("TextBox", Frame)
Input.Size = UDim2.new(1, -100, 0, 40)
Input.Position = UDim2.new(0, 10, 1, -80)
Input.PlaceholderText = "Type your message..."
Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.SourceSans
Input.TextSize = 16

-- Send button
local Send = Instance.new("TextButton", Frame)
Send.Size = UDim2.new(0, 80, 0, 40)
Send.Position = UDim2.new(1, -90, 1, -80)
Send.Text = "Send"
Send.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Send.TextColor3 = Color3.fromRGB(255, 255, 255)
Send.Font = Enum.Font.SourceSansBold
Send.TextSize = 18

-- Function to update chat history
local function updateOutput()
    local text = ""
    for i, msg in ipairs(conversation) do
        if msg.role == "user" then
            text = text .. "<b>You:</b> " .. msg.content .. "\n"
        elseif msg.role == "assistant" then
            text = text .. "<b>AI:</b> " .. msg.content .. "\n"
        end
    end
    Output.Text = text
end

-- AI Request Function
local function askAI(prompt)
    table.insert(conversation, {role = "user", content = prompt})
    updateOutput()

    local body = {
        model = "gpt-4o-mini",
        messages = conversation
    }

    local response = request({
        Url = "https://api.openai.com/v1/chat/completions",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. API_KEY
        },
        Body = HttpService:JSONEncode(body)
    })

    local data = HttpService:JSONDecode(response.Body)
    local reply = data.choices[1].message.content

    table.insert(conversation, {role = "assistant", content = reply})
    updateOutput()
end

-- Function to send input
local function sendInput()
    local text = Input.Text
    if text ~= "" then
        Input.Text = ""
        task.spawn(function()
            askAI(text)
        end)
    end
end

-- Connect send button
Send.MouseButton1Click:Connect(sendInput)

-- Enter-to-send
Input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        sendInput()
    end
end)